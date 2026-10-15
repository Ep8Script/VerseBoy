using { Core }

emulator_timer <public> := class<final><scoped{Core}>:
    var CurrentClockSpeed <private> : int = 1024
    var DividerVariable <private> : int = 0
    var MaybeEmulator <final><scoped{Core}> : ?emulator = false
    var SkipDividerCycles <private> : int = 0
    var SkipTicks <private> : int = 0

    GetBit<private>(TAC:int)<computes>:int=
        case (BitAnd(TAC, 3)):
            0 => 0x200
            1 => 0x8
            2 => 0x20
            _ => 0x80

    GetBudget<scoped{Core}>()<decides><transacts>:int=
        DividerVariable < 0x100
        Emulator:emulator = MaybeEmulator?
        var TotalBudget:int = 0xFF - DividerVariable
        if (BitAnd(Emulator.Memory[0xFF07], 0x4) <> 0):
            Phase:int = Mod[Emulator.Memory[0xFF04] * 0x100 + DividerVariable, CurrentClockSpeed]
            set TotalBudget = Min(TotalBudget, CurrentClockSpeed - 1 - Phase)
        TotalBudget

    GetCounter<internal>()<decides><reads>:int=
        MaybeEmulator?.Memory[0xFF04] * 0x100 + DividerVariable

    IsOverflowPending<public>(Offset:int)<decides><reads>:void=
        Emulator:emulator = MaybeEmulator?
        BitAnd(Emulator.Memory[0xFF07], 0x4) <> 0
        Counter:int = GetCounter[]
        Position:int = Counter + Emulator.PendingCycles
        ReadEdges:int = Quotient[Position + Offset, CurrentClockSpeed] - Quotient[Position, CurrentClockSpeed]
        ReadEdges > 0
        Mod[Position + Offset, CurrentClockSpeed] >= 4
        Emulator.Memory[0xFF05] + ReadEdges > 0xFF

    LoadState<scoped{Core}>(Data:[]int):void=
        if (Data.Length = 4, Clock := Data[0], Divider := Data[1], SkipDivider := Data[2], Ticks := Data[3]):
            set CurrentClockSpeed = Clock
            set DividerVariable = Divider
            set SkipDividerCycles = SkipDivider
            set SkipTicks = Ticks

    ReadDIV<scoped{Core}>(Offset:int)<decides><reads>:int=
        Emulator:emulator = MaybeEmulator?
        Byte:int = Emulator.Memory[0xFF04]
        BitAnd(Quotient[Byte * 0x100 + DividerVariable + Offset + Emulator.PendingCycles, 0x100], 0xFF)

    ReadTIMA<scoped{Core}>(Offset:int)<decides><reads>:int=
        Emulator:emulator = MaybeEmulator?
        Byte:int = Emulator.Memory[0xFF05]
        if:
            BitAnd(Emulator.Memory[0xFF07], 0x4) <> 0
            Counter := GetCounter[]
            ReadEdges := Quotient[Counter + Emulator.PendingCycles + Offset, CurrentClockSpeed] - Quotient[Counter + Emulator.PendingCycles, CurrentClockSpeed]
            ReadEdges > 0
        then:
            if (Byte + ReadEdges > 0xFF):
                if (Mod[Counter + Emulator.PendingCycles + Offset, CurrentClockSpeed] < 4):
                    0
                else:
                    Emulator.Memory[0xFF06]
            else:
                Byte + ReadEdges
        else:
            Byte

    Reset<public>():void=
        if (MaybeEmulator?.HasBootROM[]):
            set DividerVariable = 0
        else:
            set DividerVariable = 0xCC
        set CurrentClockSpeed = 1024
        set SkipDividerCycles = 0
        set SkipTicks = 0

    SaveState<scoped{Core}>()<reads>:[]int=
        array:
            CurrentClockSpeed
            DividerVariable
            SkipDividerCycles
            SkipTicks

    Skip<scoped{Core}>(Cycles:int):void=
        set DividerVariable += Cycles

    Update<scoped{Core}>(Cycles:int):void=
        if (Emulator := MaybeEmulator?):
            Elapsed:int = Cycles - SkipDividerCycles
            if:
                Before := GetCounter[]
                Edges := Quotient[Before + Elapsed, CurrentClockSpeed] - Quotient[Before, CurrentClockSpeed]
                TimerAttributes := Emulator.Memory[0xFF07]
                BitAnd(TimerAttributes, 0x4) <> 0
            then:
                for (Edge := 1..Edges - SkipTicks):
                    UpdateTIMA()
            set DividerVariable += Elapsed
            set SkipDividerCycles = 0
            set SkipTicks = 0

            # Do divider register
            if (DividerVariable >= 0x100):
                if:
                    Byte := Emulator.Memory[0xFF04]
                    set Emulator.Memory[0xFF04] = BitAnd(Byte + 1, 0xFF)
                set DividerVariable -= 0x100

    UpdateTIMA<private>():void=
        if (Emulator := MaybeEmulator?):
            Overflow:logic = logic{Emulator.Memory[0xFF05] = 0xFF}
            if:
                Byte := Emulator.Memory[0xFF05]
                set Emulator.Memory[0xFF05] = BitAnd(Byte + 1, 0xFF)
            if (Overflow?):
                if:
                    Byte := Emulator.Memory[0xFF06]
                    set Emulator.Memory[0xFF05] = Byte
                Emulator.RequestInterrupt(interrupt.Timer)

    Write<public>(Address:int, Data:int, Offset:int):void=
        if (Emulator := MaybeEmulator?):
            # Reset the divider register
            if (Address = 0xFF04):
                Emulator.FlushForRegisterWrite()
                if (Counter := GetCounter[], TAC := Emulator.Memory[0xFF07], BitAnd(TAC, 0x4) <> 0):
                    if (Edges := Quotient[Counter + Offset, CurrentClockSpeed] - Quotient[Counter, CurrentClockSpeed]):
                        for (Edge := 1..Edges):
                            UpdateTIMA()
                    if (BitAnd(Counter + Offset, GetBit(TAC)) <> 0):
                        UpdateTIMA()
                if {set Emulator.Memory[0xFF04] = 0}
                set DividerVariable = 0
                set SkipDividerCycles = Offset
            else if (Address = 0xFF05):
                Emulator.FlushForRegisterWrite()
                if (BitAnd(Emulator.Memory[0xFF07], 0x4) <> 0, Counter := GetCounter[], NewSkipTicks := Quotient[Counter + Offset, CurrentClockSpeed] - Quotient[Counter, CurrentClockSpeed]):
                    set SkipTicks = NewSkipTicks
                    if (SkipTicks > 0, Emulator.Memory[0xFF05] = 0xFF, SinceEdge := Mod[Counter + Offset, CurrentClockSpeed], SinceEdge >= 4):
                        if:
                            TMA := Emulator.Memory[0xFF06]
                            set Emulator.Memory[0xFF05] = TMA
                        Emulator.RequestInterrupt(interrupt.Timer)
                        if (SinceEdge < 8):
                            return
                else:
                    set SkipTicks = 0
                if {set Emulator.Memory[Address] = Data}
            # Not sure if this is correct
            else if (Address = 0xFF07):
                ClockSpeed:int = case (BitAnd(Data, 0x3)):
                    0 => 1024
                    1 => 16
                    2 => 64
                    3 => 256
                    _ => Err()
                Emulator.FlushForRegisterWrite()
                if (Counter := GetCounter[], Old := Emulator.Memory[0xFF07]):
                    Position:int = Counter + Offset
                    if (BitAnd(Old, 0x4) <> 0, OldEdges := Quotient[Position, CurrentClockSpeed] - Quotient[Counter, CurrentClockSpeed]):
                        for (Edge := 1..OldEdges):
                            UpdateTIMA()
                    if (BitAnd(Old, 0x4) <> 0 and BitAnd(Position, GetBit(Old)) <> 0 and (BitAnd(Data, 0x4) = 0 or BitAnd(Position, GetBit(Data)) = 0)):
                        UpdateTIMA()
                    if (BitAnd(Data, 0x4) <> 0, NewSkipTicks := Quotient[Position, ClockSpeed] - Quotient[Counter, ClockSpeed]):
                        set SkipTicks = NewSkipTicks
                    else:
                        set SkipTicks = 0
                if {set Emulator.Memory[Address] = Data}
                set CurrentClockSpeed = ClockSpeed