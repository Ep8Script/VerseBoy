using { Core }
using { Utils }

# Put 1 byte immediate data into reg
(Emulator:emulator).CPU_8BIT_LOAD<internal>(Reg:reference(int)):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    set CyclesThisUpdate += 8
    if (N := Emulator.ReadMemory[ProgramCounter]):
        set ProgramCounter = BitAnd(ProgramCounter + 1, 0xFFFF)
        set Reg.Value = N

# Put 2 byte immediate data into reg
(Emulator:emulator).CPU_16BIT_LOAD<internal>(Reg:register):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    set CyclesThisUpdate += 12
    if (N := ReadWord[]):
        Reg.SetReg(N)
        set ProgramCounter = BitAnd(ProgramCounter + 2, 0xFFFF)

(Emulator:emulator).CPU_REG_LOAD<internal>(Reg:reference(int), Load:int, Cycles:int):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    set CyclesThisUpdate += Cycles
    set Reg.Value = Load

(Emulator:emulator).CPU_REG_LOAD_ROM<internal>(Reg:reference(int), Address:int):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    set CyclesThisUpdate += 8
    if (Byte := Emulator.ReadMemory[Address]):
        set Reg.Value = Byte

# Apparently no flags affected
(Emulator:emulator).CPU_16BIT_DEC<internal>(Word:register, Cycles:int):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    set CyclesThisUpdate += Cycles
    Word.SetReg(Word.GetReg() - 1)

# Apparently no flags affected
(Emulator:emulator).CPU_16BIT_INC<internal>(Word:register, Cycles:int):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    set CyclesThisUpdate += Cycles
    Word.SetReg(BitAnd(Word.GetReg() + 1, 0xFFFF))

# Add to reg. Can be immediate data, and can also add the carry flag to the result
(Emulator:emulator).CPU_8BIT_ADD<internal>(Reg:reference(int), ToAdd:int, Cycles:int, UseImmediate:logic, AddCarry:logic):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    var Adding:int = 0
    var Before:int = Reg.Value
    var Flags:int = 0
    set CyclesThisUpdate += Cycles

    # Are we adding immediate data or the second param?
    if (UseImmediate?):
        if (N := Emulator.ReadMemory[ProgramCounter]):
            set Adding = N
            set ProgramCounter = BitAnd(ProgramCounter + 1, 0xFFFF)
    else:
        set Adding = ToAdd

    # Are we also adding the carry flag?
    CarryIn:int = if (AddCarry?, BitAnd(AF.Lo.Value, FLAG_MASK_C) <> 0):
        1
    else:
        0
    set Reg.Value = BitAnd(Adding + Before + CarryIn, 0xFF)
    if (Reg.Value = 0):
        set Flags += FLAG_MASK_Z
    if (BitAnd(Adding, 0xF) + BitAnd(Before, 0xF) + CarryIn > 0xF):
        set Flags += FLAG_MASK_H
    if (Adding + Before + CarryIn > 0xFF):
        set Flags += FLAG_MASK_C
    set AF.Lo.Value = Flags

# Subtracts away from reg, can also subtract the carry flag too
(Emulator:emulator).CPU_8BIT_SUB<internal>(Reg:reference(int), Subtracting:int, Cycles:int, UseImmediate:logic, SubCarry:logic):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    var Before:int = Reg.Value
    var Flags:int = FLAG_MASK_N
    var ToSubtract:int = 0
    set CyclesThisUpdate += Cycles

    if (UseImmediate?):
        if (N := Emulator.ReadMemory[ProgramCounter]):
            set ProgramCounter = BitAnd(ProgramCounter + 1, 0xFFFF)
            set ToSubtract = N
    else:
        set ToSubtract = Subtracting

    CarryIn:int = if (SubCarry?, BitAnd(AF.Lo.Value, FLAG_MASK_C) <> 0):
        1
    else:
        0

    set Reg.Value = BitAnd(Before - CarryIn - ToSubtract, 0xFF)
    if (Reg.Value = 0):
        set Flags += FLAG_MASK_Z
    if (Before < ToSubtract + CarryIn):
        set Flags += FLAG_MASK_C
    if (BitAnd(Before, 0xF) < BitAnd(ToSubtract, 0xF) + CarryIn):
        set Flags += FLAG_MASK_H
    set AF.Lo.Value = Flags

(Emulator:emulator).CPU_8BIT_AND<internal>(Reg:reference(int), ToAnd:int, Cycles:int, UseImmediate:logic):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    var MyAnd:int = 0
    set CyclesThisUpdate += Cycles

    if (UseImmediate?):
        if (N := Emulator.ReadMemory[ProgramCounter]):
            set MyAnd = N
            set ProgramCounter = BitAnd(ProgramCounter + 1, 0xFFFF)
    else:
        set MyAnd = ToAnd

    set Reg.Value = BitAnd(Reg.Value, MyAnd)
    set AF.Lo.Value = if (Reg.Value = 0):
        FLAG_MASK_Z + FLAG_MASK_H
    else:
        FLAG_MASK_H

(Emulator:emulator).CPU_8BIT_OR<internal>(Reg:reference(int), ToOr:int, Cycles:int, UseImmediate:logic):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    var MyOr:int = 0
    set CyclesThisUpdate += Cycles

    if (UseImmediate?):
        if (N := Emulator.ReadMemory[ProgramCounter]):
            set MyOr = N
            set ProgramCounter = BitAnd(ProgramCounter + 1, 0xFFFF)
    else:
        set MyOr = ToOr

    set Reg.Value = BitOr(Reg.Value, MyOr)
    set AF.Lo.Value = if (Reg.Value = 0):
        FLAG_MASK_Z
    else:
        0

(Emulator:emulator).CPU_8BIT_XOR<internal>(Reg:reference(int), ToXor:int, Cycles:int, UseImmediate:logic):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    var MyXor:int = 0
    set CyclesThisUpdate += Cycles

    if (UseImmediate?):
        if (N := Emulator.ReadMemory[ProgramCounter]):
            set MyXor = N
            set ProgramCounter = BitAnd(ProgramCounter + 1, 0xFFFF)
    else:
        set MyXor = ToXor

    set Reg.Value = BitXor(Reg.Value, MyXor)
    set AF.Lo.Value = if (Reg.Value = 0):
        FLAG_MASK_Z
    else:
        0

# This does not affect any registers, hence why I'm not passing a reference

(Emulator:emulator).CPU_8BIT_COMPARE<internal>(Reg:int, Subtracting:int, Cycles:int, UseImmediate:logic):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    var Before:int = Reg
    var Flags:int = FLAG_MASK_N
    var ToSubtract:int = 0
    set CyclesThisUpdate += Cycles

    if (UseImmediate?):
        if (N := Emulator.ReadMemory[ProgramCounter]):
            set ProgramCounter = BitAnd(ProgramCounter + 1, 0xFFFF)
            set ToSubtract = N
    else:
        set ToSubtract = Subtracting

    if (Before = ToSubtract):
        set Flags += FLAG_MASK_Z
    if (Before < ToSubtract):
        set Flags += FLAG_MASK_C
    if (BitAnd(Before, 0xF) < BitAnd(ToSubtract, 0xF)):
        set Flags += FLAG_MASK_H
    set AF.Lo.Value = Flags

(Emulator:emulator).CPU_8BIT_INC<internal>(Reg:reference(int), Cycles:int):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    # WHEN EDITING THIS FUNCTION DON'T FORGET TO MAKE THE SAME CHANGES TO CPU_8BIT_MEMORY_INC
    var Before:int = Reg.Value
    var Flags:int = BitAnd(AF.Lo.Value, 0x1F)
    Result:int = BitAnd(Before + 1, 0xFF)
    if (Result = 0):
        set Flags += FLAG_MASK_Z
    if (BitAnd(Before, 0xF) = 0xF):
        set Flags += FLAG_MASK_H
    set AF.Lo.Value = Flags
    set CyclesThisUpdate += Cycles
    set Reg.Value = Result

(Emulator:emulator).CPU_8BIT_MEMORY_INC<internal>(Address:int, Cycles:int):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { Emulator }
    using { EmulatorCPU }
    # WHEN EDITING THIS FUNCTION DON'T FORGET TO MAKE THE SAME CHANGES TO CPU_8BIT_INC
    set CyclesThisUpdate += Cycles
    if (Before := ReadMemory[Address]):
        var Flags:int = BitAnd(AF.Lo.Value, 0x1F)
        Now:int = BitAnd(Before + 1, 0xFF)
        WriteByte(Address, Now)
        if (Now = 0):
            set Flags += FLAG_MASK_Z
        if (BitAnd(Before, 0xF) = 0xF):
            set Flags += FLAG_MASK_H
        set AF.Lo.Value = Flags

(Emulator:emulator).CPU_8BIT_DEC<internal>(Reg:reference(int), Cycles:int):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    # WHEN EDITING THIS FUNCTION DON'T FORGET TO MAKE THE SAME CHANGES TO CPU_8BIT_MEMORY_DEC
    Before:int = Reg.Value
    var Flags:int = BitAnd(AF.Lo.Value, 0x1F) + FLAG_MASK_N
    Result:int = BitAnd(Before - 1, 0xFF)
    if (Result = 0):
        set Flags += FLAG_MASK_Z
    if (BitAnd(Before, 0xF) = 0):
        set Flags += FLAG_MASK_H
    set AF.Lo.Value = Flags
    set CyclesThisUpdate += Cycles
    set Reg.Value = Result

(Emulator:emulator).CPU_8BIT_MEMORY_DEC<internal>(Address:int, Cycles:int):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { Emulator }
    using { EmulatorCPU }
    # WHEN EDITING THIS FUNCTION DON'T FORGET TO MAKE THE SAME CHANGES TO CPU_8BIT_DEC
    set CyclesThisUpdate += Cycles
    if (Before := ReadMemory[Address]):
        var Flags:int = BitAnd(AF.Lo.Value, 0x1F) + FLAG_MASK_N
        Now:int = BitAnd(Before - 1, 0xFF)
        WriteByte(Address, Now)
        if (Now = 0):
            set Flags += FLAG_MASK_Z
        if (BitAnd(Before, 0xF) = 0):
            set Flags += FLAG_MASK_H
        set AF.Lo.Value = Flags

(Emulator:emulator).CPU_16BIT_ADD<internal>(Reg:register, ToAdd:int, Cycles:int):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Before:int = Reg.GetReg()
    var Flags:int = BitAnd(AF.Lo.Value, 0x8F)
    if (Before + ToAdd > 0xFFFF):
        set Flags += FLAG_MASK_C
    if (BitAnd(Before, 0xFFF) + BitAnd(ToAdd, 0xFFF) > 0xFFF):
        set Flags += FLAG_MASK_H
    Reg.SetReg(Before + ToAdd)
    set AF.Lo.Value = Flags
    set CyclesThisUpdate += Cycles

(Emulator:emulator).CPU_JUMP<internal>(UseCondition:logic, FlagMask:int, Condition:logic):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    set CyclesThisUpdate += 12
    if (NN := ReadWord[]):
        if (UseCondition?):
            if (logic{BitAnd(AF.Lo.Value, FlagMask) <> 0} = Condition):
                set CyclesThisUpdate += 4
                set ProgramCounter = NN
            else:
                set ProgramCounter = BitAnd(ProgramCounter + 2, 0xFFFF)
        else:
            set CyclesThisUpdate += 4
            set ProgramCounter = NN

(Emulator:emulator).CPU_JUMP_IMMEDIATE<internal>(UseCondition:logic, FlagMask:int, Condition:logic):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    set CyclesThisUpdate += 8
    if (N := Emulator.ReadMemory[ProgramCounter]):
        SignedN:int = N > 127 and N - 256 or N
        if (not UseCondition? or logic{BitAnd(AF.Lo.Value, FlagMask) <> 0} = Condition):
            set CyclesThisUpdate += 4
            set ProgramCounter += SignedN
        set ProgramCounter = BitAnd(ProgramCounter + 1, 0xFFFF)

(Emulator:emulator).CPU_CALL<internal>(UseCondition:logic, FlagMask:int, Condition:logic):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { Emulator }
    using { EmulatorCPU }
    set CyclesThisUpdate += 12
    if (NN := ReadWord[]):
        set ProgramCounter = BitAnd(ProgramCounter + 2, 0xFFFF)
        if (UseCondition?):
            if (logic{BitAnd(AF.Lo.Value, FlagMask) <> 0} = Condition):
                PushWordOntoStack(ProgramCounter, ?Offset := 16)
                set CyclesThisUpdate += 12
                set ProgramCounter = NN
        else:
            PushWordOntoStack(ProgramCounter, ?Offset := 16)
            set CyclesThisUpdate += 12
            set ProgramCounter = NN

(Emulator:emulator).CPU_RETURN<internal>(UseCondition:logic, FlagMask:int, Condition:logic):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { Emulator }
    using { EmulatorCPU }
    set CyclesThisUpdate += 8
    if (UseCondition?):
        if (logic{BitAnd(AF.Lo.Value, FlagMask) <> 0} = Condition):
            if (Word := PopWordOffStack[?Offset := 8]):
                set ProgramCounter = Word
            set CyclesThisUpdate += 12
    else:
        if (Word := PopWordOffStack[]):
            set ProgramCounter = Word
        set CyclesThisUpdate += 8

(Emulator:emulator).CPU_SWAP_NIBBLES<internal>(Reg:reference(int)):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    set CyclesThisUpdate += 8
    Result:int = BitOr(ShiftRightByte(Reg.Value, 0x4), ShiftLeftByte(Reg.Value, 0x4))
    set AF.Lo.Value = if (Result = 0):
        FLAG_MASK_Z
    else:
        0
    set Reg.Value = Result
    # WHEN EDITING THIS FUNCTION ALSO EDIT CPU_SWAP_NIB_MEM

(Emulator:emulator).CPU_SWAP_NIB_MEM<internal>(Address:int):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { Emulator }
    using { EmulatorCPU }
    set AF.Lo.Value = 0
    set CyclesThisUpdate += 16
    if (Mem := ReadMemory[Address]):
        Result:int = BitOr(ShiftRightByte(Mem, 0x4), ShiftLeftByte(Mem, 0x4))
        WriteByte(Address, Result)
        if (Result = 0):
            set AF.Lo.Value = FLAG_MASK_Z
    # WHEN EDITING THIS FUNCTION ALSO EDIT CPU_SWAP_NIBBLES

(Emulator:emulator).CPU_RESTARTS<internal>(N:int):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    PushWordOntoStack(ProgramCounter)
    set CyclesThisUpdate += 16
    set ProgramCounter = N

(Emulator:emulator).CPU_RESET_BIT<internal>(Reg:reference(int), Bit:int):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    # WHEN EDITING THIS ALSO EDIT CPU_RESET_BIT_MEMORY
    set CyclesThisUpdate += 8
    set Reg.Value = BitReset(Reg.Value, Bit)

(Emulator:emulator).CPU_RESET_BIT_MEMORY<internal>(Address:int, Bit:int):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { Emulator }
    using { EmulatorCPU }
    # WHEN EDITING THIS ALSO EDIT CPU_RESET_BIT
    if (Mem := BitReset(ReadMemory[Address], Bit)):
        WriteByte(Address, Mem)
        set CyclesThisUpdate += 16


(Emulator:emulator).CPU_TEST_BIT<internal>(Reg:int, Bit:int, Cycles:int):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    var Flags:int = BitAnd(AF.Lo.Value, 0x1F) + FLAG_MASK_H
    if (not TestBit[Reg, Bit]):
        set Flags += FLAG_MASK_Z
    set AF.Lo.Value = Flags
    set CyclesThisUpdate += Cycles

(Emulator:emulator).CPU_SET_BIT<internal>(Reg:reference(int), Bit:int):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    # WHEN EDITING THIS ALSO EDIT CPU_SET_BIT_MEMORY
    set CyclesThisUpdate += 8
    set Reg.Value = BitSet(Reg.Value, Bit)

(Emulator:emulator).CPU_SET_BIT_MEMORY<internal>(Address:int, Bit:int):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { Emulator }
    using { EmulatorCPU }
    # WHEN EDITING THIS ALSO EDIT CPU_SET_BIT
    if (Mem := BitSet(ReadMemory[Address], Bit)):
        WriteByte(Address, Mem)
        set CyclesThisUpdate += 16

(Emulator:emulator).CPU_DAA<internal>():void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    set CyclesThisUpdate += 4
    var A:int = AF.Hi.Value
    F:int = AF.Lo.Value
    var Carry:logic = logic{BitAnd(F, FLAG_MASK_C) <> 0}
    HalfCarry:logic = logic{BitAnd(F, FLAG_MASK_H) <> 0}
    var NewFlags:int = BitAnd(F, FLAG_MASK_N)
    if (BitAnd(F, FLAG_MASK_N) <> 0):
        if (Carry?):
            set A -= 0x60
        if (HalfCarry?):
            set A -= 0x6
    else:
        if (Carry? or A > 0x99):
            set A += 0x60
            set Carry = true
        if (HalfCarry? or BitAnd(A, 0xF) > 9):
            set A += 0x6
    set A = BitAnd(A, 0xFF)
    set AF.Hi.Value = A
    if (A = 0):
        set NewFlags += FLAG_MASK_Z
    if (Carry?):
        set NewFlags += FLAG_MASK_C
    set AF.Lo.Value = NewFlags

# Rotate right through carry
(Emulator:emulator).CPU_RR<internal>(Reg:reference(int)):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    # WHEN EDITING THIS ALSO EDIT CPU_RR_MEMORY
    var Flags:int = 0
    IsCarrySet:logic = logic{BitAnd(AF.Lo.Value, FLAG_MASK_C) <> 0}
    IsLSBSet:logic = logic{BitAnd(Reg.Value, 0x1) <> 0}
    var Result:int = ShiftRightByte(Reg.Value, 0x1)
    if (IsCarrySet?):
        set Result = BitOr(Result, 0x80)
    set CyclesThisUpdate += 8
    if (IsLSBSet?):
        set Flags += FLAG_MASK_C
    if (Result = 0):
        set Flags += FLAG_MASK_Z
    set AF.Lo.Value = Flags
    set Reg.Value = Result

# Rotate right through carry
(Emulator:emulator).CPU_RR_MEMORY<internal>(Address:int):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { Emulator }
    using { EmulatorCPU }
    # WHEN EDITING THIS ALSO EDIT CPU_RR
    set CyclesThisUpdate += 16
    if (Value := ReadMemory[Address]):
        var Flags:int = 0
        IsCarrySet:logic = logic{BitAnd(AF.Lo.Value, FLAG_MASK_C) <> 0}
        IsLSBSet:logic = logic{BitAnd(Value, 0x1) <> 0}
        var Result:int = ShiftRightByte(Value, 0x1)
        if (IsCarrySet?):
            set Result = BitOr(Result, 0x80)
        if (IsLSBSet?):
            set Flags += FLAG_MASK_C
        if (Result = 0):
            set Flags += FLAG_MASK_Z
        set AF.Lo.Value = Flags
        WriteByte(Address, Result)

# Rotate left
(Emulator:emulator).CPU_RLC<internal>(Reg:reference(int)):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    # WHEN EDITING THIS FUNCTION ALSO EDIT CPU_RLC_MEMORY
    var Flags:int = 0
    IsMSBSet:logic = logic{BitAnd(Reg.Value, 0x80) <> 0}
    var Result:int = ShiftLeftByte(Reg.Value, 0x1)
    set CyclesThisUpdate += 8
    if (IsMSBSet?):
        set Flags += FLAG_MASK_C
        set Result = BitOr(Result, 0x1)
    if (Result = 0):
        set Flags += FLAG_MASK_Z
    set AF.Lo.Value = Flags
    set Reg.Value = Result

# Rotate left
(Emulator:emulator).CPU_RLC_MEMORY<internal>(Address:int):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { Emulator }
    using { EmulatorCPU }
    # WHEN EDITING THIS FUNCTION ALSO EDIT CPU_RLC
    set CyclesThisUpdate += 16
    if (Value := ReadMemory[Address]):
        var Flags:int = 0
        IsMSBSet:logic = logic{BitAnd(Value, 0x80) <> 0}
        var Result:int = ShiftLeftByte(Value, 0x1)
        if (IsMSBSet?):
            set Flags += FLAG_MASK_C
            set Result = BitOr(Result, 0x1)
        if (Result = 0):
            set Flags += FLAG_MASK_Z
        set AF.Lo.Value = Flags
        WriteByte(Address, Result)

# Rotate right
(Emulator:emulator).CPU_RRC<internal>(Reg:reference(int)):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    # WHEN EDITING THIS FUNCTION ALSO EDIT CPU_RRC_MEMORY
    var Flags:int = 0
    IsLSBSet:logic = logic{BitAnd(Reg.Value, 0x1) <> 0}
    var Result:int = ShiftRightByte(Reg.Value, 0x1)
    set CyclesThisUpdate += 8
    if (IsLSBSet?):
        set Flags += FLAG_MASK_C
        set Result = BitOr(Result, 0x80)
    if (Result = 0):
        set Flags += FLAG_MASK_Z
    set AF.Lo.Value = Flags
    set Reg.Value = Result

# Rotate right
(Emulator:emulator).CPU_RRC_MEMORY<internal>(Address:int):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { Emulator }
    using { EmulatorCPU }
    # WHEN EDITING THIS FUNCTION ALSO EDIT CPU_RRC
    set CyclesThisUpdate += 16
    if (Value := ReadMemory[Address]):
        var Flags:int = 0
        IsLSBSet:logic = logic{BitAnd(Value, 0x1) <> 0}
        var Result:int = ShiftRightByte(Value, 0x1)
        if (IsLSBSet?):
            set Flags += FLAG_MASK_C
            set Result = BitOr(Result, 0x80)
        if (Result = 0):
            set Flags += FLAG_MASK_Z
        set AF.Lo.Value = Flags
        WriteByte(Address, Result)

# Shift left arithmetically (basically bit 0 gets set to 0) (bit 7 goes into carry)
(Emulator:emulator).CPU_SLA<internal>(Reg:reference(int)):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    # WHEN EDITING THIS ALSO EDIT CPU_SLA_MEMORY
    var Flags:int = 0
    IsMSBSet:logic = logic{BitAnd(Reg.Value, 0x80) <> 0}
    var Result:int = ShiftLeftByte(Reg.Value, 0x1)
    set CyclesThisUpdate += 8
    if (IsMSBSet?):
        set Flags += FLAG_MASK_C
    if (Result = 0):
        set Flags += FLAG_MASK_Z
    set AF.Lo.Value = Flags
    set Reg.Value = Result

(Emulator:emulator).CPU_SLA_MEMORY<internal>(Address:int):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { Emulator }
    using { EmulatorCPU }
    # WHEN EDITING THIS ALSO EDIT CPU_SLA_MEMORY
    set CyclesThisUpdate += 16
    if (Value := ReadMemory[Address]):
        var Flags:int = 0
        IsMSBSet:logic = logic{BitAnd(Value, 0x80) <> 0}
        var Result:int = ShiftLeftByte(Value, 0x1)
        if (IsMSBSet?):
            set Flags += FLAG_MASK_C
        if (Result = 0):
            set Flags += FLAG_MASK_Z
        set AF.Lo.Value = Flags
        WriteByte(Address, Result)

# Shift right. LSB into carry. bit 7 doesn't change
(Emulator:emulator).CPU_SRA<internal>(Reg:reference(int)):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    # WHEN EDITING THIS ALSO EDIT CPU_SRA_MEMORY
    var Flags:int = 0
    IsLSBSet:logic = logic{BitAnd(Reg.Value, 0x1) <> 0}
    IsMSBSet:logic = logic{BitAnd(Reg.Value, 0x80) <> 0}
    var Result:int = ShiftRightByte(Reg.Value, 0x1)
    set CyclesThisUpdate += 8
    if (IsLSBSet?):
        set Flags += FLAG_MASK_C
    if (IsMSBSet?):
        set Result = BitOr(Result, 0x80)
    if (Result = 0):
        set Flags += FLAG_MASK_Z
    set AF.Lo.Value = Flags
    set Reg.Value = Result

# Shift right. LSB into carry. bit 7 doesn't change
(Emulator:emulator).CPU_SRA_MEMORY<internal>(Address:int):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { Emulator }
    using { EmulatorCPU }
    # WHEN EDITING THIS ALSO EDIT CPU_SRA
    set CyclesThisUpdate += 16
    if (Value := ReadMemory[Address]):
        var Flags:int = 0
        IsLSBSet:logic = logic{BitAnd(Value, 0x1) <> 0}
        IsMSBSet:logic = logic{BitAnd(Value, 0x80) <> 0}
        var Result:int = ShiftRightByte(Value, 0x1)
        if (IsLSBSet?):
            set Flags += FLAG_MASK_C
        if (IsMSBSet?):
            set Result = BitOr(Result, 0x80)
        if (Result = 0):
            set Flags += FLAG_MASK_Z
        set AF.Lo.Value = Flags
        WriteByte(Address, Result)

# Shift right. bit 0 into carry
(Emulator:emulator).CPU_SRL<internal>(Reg:reference(int)):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    # WHEN EDITING THIS FUNCTION ALSO EDIT CPU_SRL_MEMORY
    var Flags:int = 0
    IsLSBSet:logic = logic{BitAnd(Reg.Value, 0x1) <> 0}
    var Result:int = ShiftRightByte(Reg.Value, 0x1)
    set CyclesThisUpdate += 8
    if (IsLSBSet?):
        set Flags += FLAG_MASK_C
    if (Result = 0):
        set Flags += FLAG_MASK_Z
    set AF.Lo.Value = Flags
    set Reg.Value = Result

# Shift right. bit 0 into carry
(Emulator:emulator).CPU_SRL_MEMORY<internal>(Address:int):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { Emulator }
    using { EmulatorCPU }
    # WHEN EDITING THIS FUNCTION ALSO EDIT CPU_SRL
    set CyclesThisUpdate += 16
    if (Value := ReadMemory[Address]):
        var Flags:int = 0
        IsLSBSet:logic = logic{BitAnd(Value, 0x1) <> 0}
        var Result:int = ShiftRightByte(Value, 0x1)
        if (IsLSBSet?):
            set Flags += FLAG_MASK_C
        if (Result = 0):
            set Flags += FLAG_MASK_Z
        set AF.Lo.Value = Flags
        WriteByte(Address, Result)

# Rotate left through carry flag
(Emulator:emulator).CPU_RL<internal>(Reg:reference(int)):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    # WHEN EDITING THIS FUNCTION ALSO EDIT CPU_RL_MEMORY
    var Flags:int = 0
    IsCarrySet:logic = logic{BitAnd(AF.Lo.Value, FLAG_MASK_C) <> 0}
    IsMSBSet:logic = logic{BitAnd(Reg.Value, 0x80) <> 0}
    var Result:int = ShiftLeftByte(Reg.Value, 0x1)
    set CyclesThisUpdate += 8
    if (IsCarrySet?):
        set Result = BitOr(Result, 0x1)
    if (IsMSBSet?):
        set Flags += FLAG_MASK_C
    if (Result = 0):
        set Flags += FLAG_MASK_Z
    set AF.Lo.Value = Flags
    set Reg.Value = Result

# Rotate left through carry flag
(Emulator:emulator).CPU_RL_MEMORY<internal>(Address:int):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { Emulator }
    using { EmulatorCPU }
    # WHEN EDITING THIS FUNCTION ALSO EDIT CPU_RL
    set CyclesThisUpdate += 16
    if (Value := ReadMemory[Address]):
        var Flags:int = 0
        IsCarrySet:logic = logic{BitAnd(AF.Lo.Value, FLAG_MASK_C) <> 0}
        IsMSBSet:logic = logic{BitAnd(Value, 0x80) <> 0}
        var Result:int = ShiftLeftByte(Value, 0x1)
        if (IsCarrySet?):
            set Result = BitOr(Result, 0x1)
        if (IsMSBSet?):
            set Flags += FLAG_MASK_C
        if (Result = 0):
            set Flags += FLAG_MASK_Z
        set AF.Lo.Value = Flags
        WriteByte(Address, Result)