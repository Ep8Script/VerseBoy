using { Core }

serial <public> := class<final><scoped{Core}>:
    var Cycles <private> : int = 0
    var MaybeEmulator <final><scoped{Core}> : ?emulator = false
    var <private> Sent <final><public> : []int = ()

    GetBudget<scoped{Core}>()<reads>:int=
        if (Cycles > 0):
            Cycles - 1
        else:
            0x100

    LoadState<scoped{Core}>(Data:[]int):void=
        if (Data.Length = 1, LoadedCycles := Data[0]):
            set Cycles = LoadedCycles

    Reset<public>():void=
        set Cycles = 0
        set Sent = ()

    SaveState<scoped{Core}>()<reads>:[]int=
        array:
            Cycles

    Skip<scoped{Core}>(TotalCycles:int):void=
        if (Cycles > 0):
            set Cycles -= TotalCycles

    Update<scoped{Core}>(TotalCycles:int):void=
        if (Emulator := MaybeEmulator?):
            if (Cycles > 0):
                set Cycles -= TotalCycles
                if (Cycles <= 0):
                    if (Byte := Emulator.Memory[0xFF01]):
                        set Sent += array{Byte}
                    if {set Emulator.Memory[0xFF01] = 0xFF}
                    if:
                        Control := Emulator.Memory[0xFF02]
                        set Emulator.Memory[0xFF02] = BitAnd(Control, 0x7F)
                    set Cycles = 0
                    Emulator.RequestInterrupt(interrupt.Serial)

    Write<public>(Data:int, Offset:int):void=
        if (Emulator := MaybeEmulator?):
            Emulator.FlushForRegisterWrite()
            if {set Emulator.Memory[0xFF02] = Data}
            if (BitAnd(Data, 0x81) = 0x81, Counter := Emulator.Timer.GetCounter[]):
                FirstEdge:int = 512 - (Mod[Counter + Offset, 512] or 0)
                set Cycles = FirstEdge + Offset + 7 * 512
            else:
                set Cycles = 0