using { Core }
using { Utils }

(InCPU:cpu).DoInterrupts<public>():void=
    using { InCPU }
    # Has anything requested an interrupt?
    if:
        Emulator := MaybeEmulator?
        BitAnd(BitAnd(Emulator.Memory[0xFF0F], Emulator.Memory[0xFFFF]), 0x1F) > 0
    then:
        set Halted = false
        if (EnableInterrupts?):
            InCPU.ServiceInterrupt()

(InCPU:cpu).ServiceInterrupt<internal>():void=
    using { InCPU }
    if (Emulator := MaybeEmulator?):
        Reg:int = StackPointer.GetReg()
        Emulator.WriteByte(BitAnd(Reg - 1, 0xFFFF), ShiftRightWord(ProgramCounter, 0x8))
        Pending:int = BitAnd(BitAnd(Emulator.Memory[0xFF0F], Emulator.Memory[0xFFFF]), 0x1F) or 0
        StackPointer.SetReg(Reg - 2)
        Emulator.WriteByte(BitAnd(Reg - 2, 0xFFFF), BitAnd(ProgramCounter, 0xFF))
        set CyclesThisUpdate += 20
        set EnableInterrupts = false
        set Halted = false
        if:
            Num := first:
                Bit := 0..4
                TestBit[Pending, Bit]
                Bit
        then:
            if:
                Byte := BitReset(Emulator.Memory[0xFF0F], Num)
                set Emulator.Memory[0xFF0F] = Byte
            set ProgramCounter = case (Num):
                0 => 0x40 # V-Blank
                1 => 0x48 # LCD-STAT
                2 => 0x50 # Timer
                3 => 0x58 # Serial
                _ => 0x60 # Joypad
        else:
            set ProgramCounter = 0x0