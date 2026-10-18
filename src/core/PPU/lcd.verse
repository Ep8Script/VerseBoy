using { Core }

BlankRow <internal> : []int = for (I := 1..160) do 0
BlankScreen <internal> : []int = for (I := 1..23040) do 0

lcdc_update <internal> := struct<computes>:
    Value <public> : int
    X <public> : int

lcd_state <public> := struct<computes><internal>:
    BlockedOAM <public> : logic
    BlockedWriteOAM <public> : logic
    BlockedVRAM <public> : logic
    BlockedWriteVRAM <public> : logic
    Line <public> : int
    Mode <public> : int
    ValidCoincidence <public> : logic

(InPPU:ppu).GetLCDState<scoped{Core}>(Offset:int)<decides><reads>:lcd_state=
    using { InPPU }
    ActiveLine:int = MaybeEmulator?.Memory[0xFF44]
    CurrentRemaining:int = RetraceLY - MaybeEmulator?.PendingCycles - Offset
    CurrentLine:int = if (CurrentRemaining <= 0):
        if (ActiveLine >= VerticalBlankScanLineMax):
            0
        else:
            ActiveLine + 1
    else:
        ActiveLine
    Line:int = if (CurrentRemaining <= 0):
        if (CurrentLine >= VerticalBlankScanLineMax):
            0
        else:
            CurrentLine + 1
    else:
        CurrentLine
    MaxVRAM:int = if (SkipFrame? and CurrentLine = 0 and CurrentRemaining >= 0):
        RetraceStart - 80
    else:
        RetraceStart - 76
    Remaining:int = if (CurrentRemaining <= 0):
        CurrentRemaining + RetraceStart
    else:
        CurrentRemaining
    lcd_state:
        BlockedOAM := logic:
            CurrentLine < VerticalBlankScanLine
            (Remaining <= 4 or Remaining > ModeThreshold and Remaining <= RetraceStart - 80 or (Remaining > RetraceStart - 80 and not (CurrentLine = 0 and CurrentRemaining > 0 and SkipFrame?)))
        BlockedWriteOAM := logic:
            CurrentLine < VerticalBlankScanLine
            (Remaining > ModeThreshold and Remaining <= RetraceStart - 80 or (Remaining > RetraceStart - 76 and not (CurrentLine = 0 and CurrentRemaining > 0 and SkipFrame?)))
        BlockedVRAM := logic:
            Remaining > 4
            CurrentLine < VerticalBlankScanLine
            Remaining > ModeThreshold
            Remaining <= MaxVRAM
        BlockedWriteVRAM := logic:
            CurrentLine < VerticalBlankScanLine
            Remaining > ModeThreshold
            Remaining <= RetraceStart - 80
        Line := if (Remaining <= 4 and CurrentLine < VerticalBlankScanLine):
            CurrentLine + 1
        else:
            CurrentLine
        Mode := if (Line >= VerticalBlankScanLine):
            1
        else if (Line < VerticalBlankScanLine and Remaining <= 4):
            0
        else if (Remaining > RetraceStart - 80):
            if (CurrentLine = 0 and CurrentRemaining > 0 and SkipFrame?):
                0
            else:
                2
        else if (Remaining > ModeThreshold):
            3
        else:
            0
        ValidCoincidence := logic{Remaining > 4 or CurrentLine >= VerticalBlankScanLine}

(InPPU:ppu).GetPixel<internal>(Dot:int):int=
    var Index:int = 0
    Scroll:int = Mod[InPPU.MaybeEmulator?.Memory[0xFF43], 8] or 0
    var Stalled:int = 0
    TotalDots:int = Dot - PixelStart - Scroll
    loop:
        if:
            Stall := InPPU.Stalls[Index]
            Trigger := Quotient[Stall, 32]
            TotalDots >= Trigger + Stalled
            Dots := Mod[Stall, 32]
        then:
            if (TotalDots < Dots + Stalled + Trigger):
                return Trigger
            set Index += 1
            set Stalled += Dots
        else:
            break
    TotalDots - Stalled

(InPPU:ppu).SetLCDStatus<internal>():void=
    if (Emulator := InPPU.MaybeEmulator?, OldStatus := Emulator.Memory[0xFF41]):
        if (BitAnd(Emulator.Memory[0xFF40], 0x80) = 0, set Emulator.Memory[0xFF44] = 0):
            LCDStatus:int = BitAnd(OldStatus, 0xFC)
            if:
                LCDStatus <> OldStatus
                set Emulator.Memory[0xFF41] = LCDStatus
            set InPPU.CurrentStatLine = logic{BitAnd(OldStatus, 0x4) <> 0 and BitAnd(OldStatus, 0x40) <> 0}
            set InPPU.RetraceLY = RetraceStart
            set InPPU.WindowLine = 0
            set InPPU.WindowTriggered = false
            return

        if (LY := Emulator.Memory[0xFF44]):
            # Set mode as vertical blank
            Coincidence:logic = logic{LY = Emulator.Memory[0xFF45]}
            CurrentMode:int = InPPU.GetMode(LY)
            var LCDStatus:int = BitOr(BitAnd(OldStatus, 0xF8), CurrentMode)
            StatLine:logic = logic{CurrentMode = 0 and BitAnd(OldStatus, 0x8) <> 0 or CurrentMode = 1 and BitAnd(OldStatus, 0x10) <> 0 or (CurrentMode = 2 or LY = VerticalBlankScanLine and InPPU.RetraceLY > RetraceStart - 24) and BitAnd(OldStatus, 0x20) <> 0 or Coincidence? and BitAnd(OldStatus, 0x40) <> 0}
            if (Coincidence?):
                set LCDStatus += 4
            if (StatLine? and not InPPU.CurrentStatLine?):
                Emulator.RequestInterrupt(interrupt.LCDStat)
            if:
                LCDStatus <> OldStatus
                set Emulator.Memory[0xFF41] = LCDStatus
            set InPPU.CurrentStatLine = StatLine

(InPPU:ppu).UpdateLCDC<internal>(Offset:int, Value:int):void=
    if (Emulator := InPPU.MaybeEmulator?, BitAnd(Emulator.Memory[0xFF40], 0x80) <> 0):
        Dot:int = RetraceStart - (InPPU.RetraceLY - Emulator.PendingCycles - Offset)
        set InPPU.LCDControlUpdates += array:
            lcdc_update:
                Value := Value
                X := InPPU.GetPixel(Dot)
    else:
        set InPPU.LineLCDControl = Value