using { Core }
using { Utils }

ppu <public> := class<final><scoped{Core}>:
    var BackgroundColorNums <final><internal> : []int = BlankRow
    var <private> BackgroundColorNumsNeeded <final><internal> : logic = false
    var <private> BackgroundPalette <final><internal> : []int = (0x0, 0x1, 0x2, 0x3)
    var BlankPending <private> : logic = false
    var CurrentStatLine <final><internal> : logic = false
    var LCDControlUpdates <final><internal> : []lcdc_update = ()
    var LineLCDControl <final><internal> : int = 0x0
    var LinePalettes <final><internal> : [palette_register][]int = map{}
    var LineSprites <final><internal> : []int = ()
    var MaybeEmulator <final><scoped{Core}> : ?emulator = false
    var <private> ModeThreshold <final><internal> : int = RETRACE_START - 80 - 172
    var ObjectPalette0 <private> : []int = (0x0, 0x1, 0x2, 0x3)
    var ObjectPalette1 <private> : []int = (0x0, 0x1, 0x2, 0x3)
    var PaletteUpdates <final><internal> : []palette_update = ()
    var RetraceLY <final><internal> : int = RETRACE_START
    var <internal> ScreenData <final><public> : []int = BlankScreen
    var <private> SkipFrame <final><internal> : logic = false
    var <private> Spread <final><internal> : []int = ()
    var <private> Stalls <final><internal> : []int = ()
    var VerticalBlankReached <final><scoped{Core}> : logic = false
    VerticalBlankEvent <private> : event() = event(){}
    var WindowLine <final><internal> : int = 0
    var WindowTriggered <final><internal> : logic = false

    AdvanceLine<private>():void=
        if (Emulator := MaybeEmulator?):
            if (Byte := Emulator.Memory[0xFF40], BitAnd(Byte, 0x80) = 0):
                return

            if:
                Byte := Emulator.Memory[0xFF44]
                set Emulator.Memory[0xFF44] = BitAnd(Byte + 1, 0xFF)
            if (Value := Emulator.Memory[0xFF40]):
                set LineLCDControl = Value
            set LCDControlUpdates = ()
            set LinePalettes = map{palette_register.Background => BackgroundPalette, palette_register.Object0 => ObjectPalette0, palette_register.Object1 => ObjectPalette1}
            set PaletteUpdates = ()
            set RetraceLY += RETRACE_START

            if (Scanline := Emulator.Memory[0xFF44]):
                if (Scanline = VERTICAL_BLANK_SCAN_LINE):
                    IssueVerticalBlank()
                if:
                    Scanline > VERTICAL_BLANK_SCAN_LINE_MAX
                    set Emulator.Memory[0xFF44] = 0x0
                then:
                    set WindowLine = 0
                    set WindowTriggered = false
                UpdateLineSprites()
                set ModeThreshold = GetModeThreshold()
                UpdateStalls()

    AwaitVerticalBlank<public>()<suspends>:void=
        VerticalBlankEvent.Await()

    DrawScanline<private>():void=
        if (not SkipFrame?, Emulator := MaybeEmulator?, LCDC := Emulator.Memory[0xFF40]):
            # We can only draw of the LCD is enabled
            if (BitAnd(LCDC, 0x80) <> 0):
                set BackgroundColorNumsNeeded = logic:
                    BitAnd(LCDC, 0x2) <> 0
                    first:
                        Key : LineSprites
                        Attributes := Emulator.Memory[0xFE00 + Mod[Key, 64] * 4 + 3]
                        BitAnd(Attributes, 0x80) <> 0
                if (BackgroundColorNumsNeeded?):
                    set BackgroundColorNums = BlankRow
                RenderBackground(LCDC)
                RenderSprites(LCDC)

    GetBudget<scoped{Core}>()<decides><transacts>:int=
        Emulator:emulator = MaybeEmulator?
        LCDC:int = Emulator.Memory[0xFF40]
        LY:int = Emulator.Memory[0xFF44]
        STAT:int = Emulator.Memory[0xFF41]
        if (BitAnd(LCDC, 0x80) = 0):
            LY = 0
            RetraceLY = RETRACE_START
            BitAnd(STAT, 0x3) = 0
            0x100
        else:
            LY <= VERTICAL_BLANK_SCAN_LINE_MAX
            RetraceLY > 0
            Mode:int = GetMode(LY)
            BitAnd(STAT, 0x3) = Mode
            Coincidence:logic = logic{LY = Emulator.Memory[0xFF45]}
            StatCoincidence:logic = logic{BitAnd(STAT, 0x4) <> 0}
            Coincidence = StatCoincidence
            var Budget:int = RetraceLY - 1
            if (LY < VERTICAL_BLANK_SCAN_LINE):
                if (RetraceLY >= ModeThreshold):
                    set Budget = Min(Budget, RetraceLY - ModeThreshold)
                if (RetraceLY > RETRACE_START - 80):
                    set Budget = Min(Budget, RetraceLY - (RETRACE_START - 80) - 1)
                else if (Mode = 3):
                    set Budget = Min(Budget, RetraceLY - ModeThreshold - 1)
            if (LY = VERTICAL_BLANK_SCAN_LINE and RetraceLY > RETRACE_START - 24):
                set Budget = Min(Budget, RetraceLY - (RETRACE_START - 24) - 1)
            Budget

    GetMode<internal>(LY:int)<reads>:int=
        if (LY >= VERTICAL_BLANK_SCAN_LINE):
            1
        else if (RetraceLY > RETRACE_START - 80):
            if (LY = 0 and SkipFrame?):
                0
            else:
                2
        else if (RetraceLY > ModeThreshold):
            3
        else:
            0

    GetModeThreshold<private>():int=
        if (Emulator := MaybeEmulator?):
            var Penalty:int = 0
            TileOffset:int = if (ScrollX := Emulator.Memory[0xFF43], Offset := Mod[ScrollX, 8]):
                Offset
            else:
                0
            if:
                LCDC := Emulator.Memory[0xFF40]
                BitAnd(LCDC, 0x2) <> 0
                Scanline := Emulator.Memory[0xFF44]
                Scanline < VERTICAL_BLANK_SCAN_LINE
            then:
                var LastTile:int = -1
                for (Key : LineSprites, X := Quotient[Key, 64], X < 168, Tile := Quotient[X, 8], Offset := Mod[X, 8]):
                    if (Tile <> LastTile):
                        set LastTile = Tile
                        set Penalty += 5 - Min(5, Offset)
                    set Penalty += 6
            Remainder:int = Mod[Penalty, 4] or 0
            RETRACE_START - 80 - 172 - (Penalty - Remainder) - if (TileOffset = 0):
                0
            else if (TileOffset <= 4):
                4
            else:
                8
        else:
            0

    GetVerticalBlank<scoped{Core}>()<decides><transacts>:void=
        VerticalBlankReached?
        set VerticalBlankReached = false

    IssueVerticalBlank<private>():void=
        defer:
            set BlankPending = false
        if (Emulator := MaybeEmulator?):
            Emulator.RequestInterrupt(interrupt.VBlank)
        if (SkipFrame?):
            set SkipFrame = false
            if (not BlankPending?):
                return
            set ScreenData = BlankScreen
        set VerticalBlankReached = true
        VerticalBlankEvent.Signal()

    LoadState<scoped{Core}>(Data:[]int, Screen:[]int):void=
        if:
            Emulator := MaybeEmulator?
            Data.Length = 6
            Retrace := Data[2]
            Window := Data[4]
        then:
            set BackgroundColorNums = BlankRow
            set BackgroundColorNumsNeeded = false
            set BackgroundPalette = DecodePalette(Emulator.Memory[0xFF47] or 0)
            set BlankPending = logic{Data[0] = 1}
            set CurrentStatLine = logic{Data[1] = 1}
            set LCDControlUpdates = ()
            set LineLCDControl = Emulator.Memory[0xFF40] or 0
            set LinePalettes = map{palette_register.Background => DecodePalette(Emulator.Memory[0xFF47] or 0), palette_register.Object0 => DecodePalette(Emulator.Memory[0xFF48] or 0), palette_register.Object1 => DecodePalette(Emulator.Memory[0xFF49] or 0)}
            set ObjectPalette0 = DecodePalette(Emulator.Memory[0xFF48] or 0)
            set ObjectPalette1 = DecodePalette(Emulator.Memory[0xFF49] or 0)
            set PaletteUpdates = ()
            set RetraceLY = Retrace
            set ScreenData = Screen
            set SkipFrame = logic{Data[3] = 1}
            set VerticalBlankReached = false
            set WindowLine = Window
            set WindowTriggered = logic{Data[5] = 1}
            UpdateLineSprites()
            set ModeThreshold = GetModeThreshold()
            UpdateStalls()
            VerticalBlankEvent.Signal()

    ReadStatus<scoped{Core}>(Offset:int)<decides><reads>:int=
        Emulator:emulator = MaybeEmulator?
        Byte:int = Emulator.Memory[0xFF41]
        if (BitAnd(Emulator.Memory[0xFF40], 0x80) = 0):
            BitOr(Byte, 0x80)
        else:
            State:lcd_state = GetLCDState[Offset]
            BitOr(BitOr(BitOr(BitAnd(Byte, 0x78), State.Mode), State.Line = Emulator.Memory[0xFF45] and State.ValidCoincidence? and 4 or 0), 0x80)

    Reset<public>():void=
        if (MaybeEmulator?.HasBootROM[]):
            set BackgroundPalette = DecodePalette(0x0)
            set ObjectPalette0 = DecodePalette(0x0)
            set ObjectPalette1 = DecodePalette(0x0)
        else:
            set BackgroundPalette = DecodePalette(0xFC)
            set ObjectPalette0 = DecodePalette(0xFF)
            set ObjectPalette1 = DecodePalette(0xFF)
        if (Spread.Length = 0):
            set Spread = for (B := 0..255) do SpreadBits(B, 0)
        if (Value := MaybeEmulator?.Memory[0xFF40]):
            set LineLCDControl = Value
        set BlankPending = false
        set CurrentStatLine = false
        set LCDControlUpdates = ()
        set LinePalettes = map{palette_register.Background => BackgroundPalette, palette_register.Object0 => ObjectPalette0, palette_register.Object1 => ObjectPalette1}
        set LineSprites = ()
        set ModeThreshold = RETRACE_START - 80 - 172
        set PaletteUpdates = ()
        set RetraceLY = RETRACE_START
        set ScreenData = BlankScreen
        set SkipFrame = false
        set Stalls = ()
        set WindowLine = 0
        set WindowTriggered = false
        VerticalBlankEvent.Signal()

    SaveState<scoped{Core}>()<reads>:[]int=
        array:
            BlankPending? and 1 or 0
            CurrentStatLine? and 1 or 0
            RetraceLY
            SkipFrame? and 1 or 0
            WindowLine
            WindowTriggered? and 1 or 0

    Skip<scoped{Core}>(Cycles:int):void=
        if (Emulator := MaybeEmulator?, BitAnd(Emulator.Memory[0xFF40], 0x80) <> 0):
            set RetraceLY -= Cycles

    Update<scoped{Core}>():void=
        if (BlankPending?):
            set BlankPending = false
            set ScreenData = BlankScreen
            VerticalBlankEvent.Signal()

    Update<scoped{Core}>(Cycles:int):void=
        if (Emulator := MaybeEmulator?):
            # Count down the LY register which is the current line being drawn. When it reaches 144 (0x90), it's vertical blank time
            Before:int = RetraceLY
            LCDOn:logic = logic{BitAnd(Emulator.Memory[0xFF40], 0x80) <> 0}
            if (LCDOn?):
                set RetraceLY -= Cycles

            if:
                Emulator.Memory[0xFF44] > VERTICAL_BLANK_SCAN_LINE_MAX
                set Emulator.Memory[0xFF44] = 0
            then:
                set WindowLine = 0
                set WindowTriggered = false

            if:
                LCDOn?
                Emulator.Memory[0xFF44] < VERTICAL_BLANK_SCAN_LINE
                Before >= ModeThreshold
                RetraceLY < ModeThreshold
            then:
                DrawScanline()

            if (RetraceLY <= 0):
                AdvanceLine()
            SetLCDStatus()

    UpdateStalls<private>():void=
        var NewStalls:[]int = ()
        if:
            Emulator := MaybeEmulator?
            LCDC := Emulator.Memory[0xFF40]
            Scanline := Emulator.Memory[0xFF44]
            Scanline < VERTICAL_BLANK_SCAN_LINE
        then:
            if:
                BitAnd(LCDC, 0x20) <> 0
                WindowX := Emulator.Memory[0xFF4B] - 7
                WindowX <= 159, WindowTriggered? or Scanline = Emulator.Memory[0xFF4A]
            then:
                set NewStalls = NewStalls.InsertSorted(Max(WindowX, 0) * 32 + 6)
            if (BitAnd(LCDC, 0x2) <> 0):
                var LastTile:int = -1
                for:
                    Key : LineSprites
                    X := Quotient[Key, 64]
                    X < 168
                    Offset := Mod[X, 8]
                    Tile := Quotient[X, 8]
                do:
                    var Penalty:int = 6
                    if (Tile <> LastTile):
                        set LastTile = Tile
                        set Penalty += 5 - Min(5, Offset)
                    set NewStalls = NewStalls.InsertSorted(Max(X - 8, 0) * 32 + Penalty)
        set Stalls = NewStalls

    Write<public>(Address:int, Data:int, Offset:int):void=
        if (Emulator := MaybeEmulator?):
            if (Address = 0xFF40 or Address = 0xFF41 or Address = 0xFF45):
                if (Address = 0xFF40):
                    if (Old := Emulator.Memory[0xFF40]):
                        if (BitAnd(Old, 0xA6) = BitAnd(Data, 0xA6)):
                            UpdateLCDC(Offset, Data)
                            if {set Emulator.Memory[0xFF40] = Data}
                            return
                        if (BitAnd(Data, 0x80) = 0 and BitAnd(Old, 0x80) <> 0):
                            set BlankPending = true
                        else if (BitAnd(Data, 0x80) <> 0 and BitAnd(Old, 0x80) = 0):
                            set LCDControlUpdates = ()
                            set LinePalettes = map{palette_register.Background => BackgroundPalette, palette_register.Object0 => ObjectPalette0, palette_register.Object1 => ObjectPalette1}
                            set PaletteUpdates = ()
                            set RetraceLY = RETRACE_START + 8
                            set SkipFrame = true
                    set ModeThreshold = GetModeThreshold()
                    UpdateLCDC(Offset, Data)
                    UpdateStalls()
                Emulator.FlushForRegisterWrite()
                if {set Emulator.Memory[Address] = Data}
                if (Address = 0xFF40):
                    UpdateLineSprites()
            # FF44 shows which horizontal scanline is currently being drawn. Writing here resets it
            else if (Address = 0xFF44):
                Emulator.FlushForRegisterWrite()
                if {set Emulator.Memory[0xFF44] = 0}
            # Color palettes
            else if (Address = 0xFF47, set Emulator.Memory[Address] = Data):
                set BackgroundPalette = DecodePalette(Data)
                UpdatePalette(Offset, BackgroundPalette, palette_register.Background)
            else if (Address = 0xFF48, set Emulator.Memory[Address] = Data):
                set ObjectPalette0 = DecodePalette(Data)
                UpdatePalette(Offset, ObjectPalette0, palette_register.Object0)
            else if (Address = 0xFF49, set Emulator.Memory[Address] = Data):
                set ObjectPalette1 = DecodePalette(Data)
                UpdatePalette(Offset, ObjectPalette1, palette_register.Object1)