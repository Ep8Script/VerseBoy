using { Core }
using { Utils }

joypad <public> := class<final><scoped{Core}>:
    var MaybeEmulator <final><scoped{Core}> : ?emulator = false
    var State <private> : int = 0x0

    ButtonPressed<public>(Button:int):void=
        # This function CANNOT call ReadMemory[0xFF00] it must access it directly from Memory[0xFF00]
        # Because ReadMemory traps this address
        Direction:logic = logic{Button < 4}
        WasSet:logic = logic{TestBit[State, Button]}
        set State = BitReset(State, Button)
        if (Emulator := MaybeEmulator?, KeyReq := Emulator.Memory[0xFF00]):
            ReqInterrupt:logic = if (BitAnd(KeyReq, 0x10) = 0 and not Direction?):
                # Player pressed directional and programmer interested
                true
            else if (BitAnd(KeyReq, 0x20) = 0 and Direction?):
                # Player pressed button and programmer interested in button
                true
            else:
                false
            if (ReqInterrupt? and WasSet?):
                Emulator.RequestInterrupt(interrupt.Joypad)

    ButtonReleased<public>(Button:int):void=
        # This function CANNOT call ReadMemory[0xFF00] it must access it directly from Memory[0xFF00]
        # Because ReadMemory traps this address
        set State = BitSet(State, Button)

    GetState<public>()<decides><reads>:int=
        # This function CANNOT call ReadMemory[0xFF00] it must access it directly from Memory[0xFF00]
        # Because ReadMemory traps this address
        JoypadSelection:int = MaybeEmulator?.Memory[0xFF00]
        Res:int = BitAnd(JoypadSelection, 0x20) <> 0 and 0xF or BitAnd(0xF, ShiftRightByte(State, 0x4))
        Result:int = BitAnd(JoypadSelection, 0x10) <> 0 and Res or BitAnd(Res, BitAnd(State, 0xF))
        BitOr(BitOr(0xC0, BitAnd(JoypadSelection, 0x30)), BitAnd(Result, 0xF))

    LoadState<scoped{Core}>(Data:[]int):void=
        if (Data.Length = 1, LoadedState := Data[0]):
            set State = LoadedState

    Reset<public>():void=
        set State = 0xFF

    SaveState<scoped{Core}>()<reads>:[]int=
        array:
            State