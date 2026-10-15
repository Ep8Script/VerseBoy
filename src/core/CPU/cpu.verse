using { Core }
using { Utils }

cpu <public> := class<final><scoped{Core}>:
    AF <final><public> : register = register{}
    BC <final><public> : register = register{}
    var CurrentOpcode <private> : int = 0
    var CyclesThisUpdate <final><public> : int = 0
    DE <final><public> : register = register{}
    var EnableInterrupts <final><public> : logic = false
    var HaltBug <final><internal> : logic = false
    var <internal> Halted <final><public> : logic = false
    HL <final><public> : register = register{}
    var MaybeEmulator <final><scoped{Core}> : ?emulator = false
    var <internal> PendingInterruptEnabled <final><scoped{Core}> : logic = false
    var <internal> ProgramCounter <final><scoped{Core}> : int = 0
    StackPointer <final><public> : register = register{}

    ExecuteExtendedOpcode<internal>(Emulator:emulator, Opcode:int):void=
        set ProgramCounter = BitAnd(ProgramCounter + 1, 0xFFFF)
        if (Function := ExtendedOpcodes[Opcode]):
            Function(Emulator)
        else:
            Err("Unhandled extended opcode: {Opcode}")

    GetReadOffset<scoped{Core}>()<reads>:int=
        case (CurrentOpcode):
            0xF0 => 8
            0xFA => 12
            0xCB => 8
            _ => 4

    GetWriteOffset<scoped{Core}>()<reads>:int=
        case (CurrentOpcode):
            0x36 => 8
            0xE0 => 8
            0x34 => 8
            0x35 => 8
            0xEA => 12
            0xCB => 12
            _ => 4

    LoadState<scoped{Core}>(Data:[]int):void=
        if:
            Data.Length = 12
            AFValue := Data[0]
            BCValue := Data[1]
            Opcode := Data[2]
            Cycles := Data[3]
            DEValue := Data[4]
            HLValue := Data[8]
            PC := Data[10]
            SPValue := Data[11]
        then:
            AF.SetReg(AFValue)
            BC.SetReg(BCValue)
            DE.SetReg(DEValue)
            HL.SetReg(HLValue)
            set CurrentOpcode = Opcode
            set CyclesThisUpdate = Cycles
            set EnableInterrupts = logic{Data[5] = 1}
            set HaltBug = logic{Data[6] = 1}
            set Halted = logic{Data[7] = 1}
            set PendingInterruptEnabled = logic{Data[9] = 1}
            set ProgramCounter = PC
            StackPointer.SetReg(SPValue)

    PopWordOffStack<internal>(?Offset:int = 4)<decides><transacts>:int=
        Emulator:emulator = MaybeEmulator?
        Reg:int = StackPointer.GetReg()
        Word:int = Emulator.ReadMemory[Reg + 1, ?Offset := Offset + 4] * 0x100 + Emulator.ReadMemory[Reg, ?Offset := Offset]
        StackPointer.SetReg(Reg + 2)
        Word

    PushWordOntoStack<internal>(Word:int, ?Offset:int = 8):void=
        if (Emulator := MaybeEmulator?):
            Reg:int = StackPointer.GetReg()
            Emulator.WriteByte(BitAnd(Reg - 1, 0xFFFF), Quotient[BitAnd(Word, 0xFFFF), 0x100] or 0, ?Offset := Offset)
            Emulator.WriteByte(BitAnd(Reg - 2, 0xFFFF), BitAnd(Word, 0xFF), ?Offset := Offset + 4)
            StackPointer.SetReg(Reg - 2)

    ReadWord<internal>()<decides><reads>:int=
        Emulator:emulator = MaybeEmulator?
        High:int = Emulator.ReadMemory[ProgramCounter + 1, ?Offset := 8]
        High * 0x100 + Emulator.ReadMemory[ProgramCounter, ?Offset := 4]

    Reset<public>():void=
        if (MaybeEmulator?.HasBootROM[]):
            BC.SetReg(0x0)
            DE.SetReg(0x0)
            HL.SetReg(0x0)
            StackPointer.SetReg(0x0)
            set AF.Hi.Value = 0x0
            set AF.Lo.Value = 0x0
            set ProgramCounter = 0x0
        else:
            BC.SetReg(0x13)
            DE.SetReg(0xD8)
            HL.SetReg(0x14D)
            StackPointer.SetReg(0xFFFE)
            set AF.Hi.Value = 0x01
            set AF.Lo.Value = 0xB0
            set ProgramCounter = 0x100
        set CurrentOpcode = 0x0
        set CyclesThisUpdate = 0
        set EnableInterrupts = false
        set HaltBug = false
        set Halted = false
        set PendingInterruptEnabled = false

    SaveState<scoped{Core}>()<reads>:[]int=
        array:
            AF.GetReg()
            BC.GetReg()
            CurrentOpcode
            CyclesThisUpdate
            DE.GetReg()
            EnableInterrupts? and 1 or 0
            HaltBug? and 1 or 0
            Halted? and 1 or 0
            HL.GetReg()
            PendingInterruptEnabled? and 1 or 0
            ProgramCounter
            StackPointer.GetReg()

    Update<scoped{Core}>(Emulator:emulator):void=
        Opcode:int = if (ProgramCounter < 0x4000):
            Emulator.Memory[ProgramCounter] or 0xFF
        else if (ProgramCounter <= 0x7FFF):
            Emulator.ReadMemory[ProgramCounter, ?Offset := 0] or Emulator.Memory[ProgramCounter] or 0xFF
        else if (ProgramCounter >= 0xFEA0 or ProgramCounter >= 0xC000 and ProgramCounter < 0xFE00 or ProgramCounter < 0xA000):
            Emulator.Memory[ProgramCounter] or 0xFF
        else:
            Emulator.ReadMemory[ProgramCounter, ?Offset := 0] or Emulator.Memory[ProgramCounter] or 0xFF
        WasPendingInterruptEnabled:logic = PendingInterruptEnabled
        set CurrentOpcode = Opcode
        if (Halted?):
            set CyclesThisUpdate += 4
        else:
            if (HaltBug?):
                set HaltBug = false
            else:
                set ProgramCounter = BitAnd(ProgramCounter + 1, 0xFFFF)
            if (Function := Opcodes[Opcode]):
                Function(Emulator)
            else:
                Err("Unhandled opcode: {Opcode}")
        if (PendingInterruptEnabled? and WasPendingInterruptEnabled?):
            set EnableInterrupts = true
            set PendingInterruptEnabled = false