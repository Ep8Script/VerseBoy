using { Core }
using { Utils }

# Opcode functions to avoid case()

# No-op
Opcode0x0<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    set CyclesThisUpdate += 4

# 8-bit loads
Opcode0x06<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_LOAD(BC.Hi)

Opcode0x0E<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_LOAD(BC.Lo)

Opcode0x16<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_LOAD(DE.Hi)

Opcode0x1E<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_LOAD(DE.Lo)

Opcode0x26<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_LOAD(HL.Hi)

Opcode0x2E<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_LOAD(HL.Lo)

# Load reg
Opcode0x7F<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(AF.Hi, AF.Hi.Value, 4)

Opcode0x78<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(AF.Hi, BC.Hi.Value, 4)

Opcode0x79<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(AF.Hi, BC.Lo.Value, 4)

Opcode0x7A<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(AF.Hi, DE.Hi.Value, 4)

Opcode0x7B<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(AF.Hi, DE.Lo.Value, 4)

Opcode0x7C<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(AF.Hi, HL.Hi.Value, 4)

Opcode0x7D<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(AF.Hi, HL.Lo.Value, 4)

Opcode0x40<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(BC.Hi, BC.Hi.Value, 4)

Opcode0x41<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(BC.Hi, BC.Lo.Value, 4)

Opcode0x42<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(BC.Hi, DE.Hi.Value, 4)

Opcode0x43<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(BC.Hi, DE.Lo.Value, 4)

Opcode0x44<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(BC.Hi, HL.Hi.Value, 4)

Opcode0x45<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(BC.Hi, HL.Lo.Value, 4)

Opcode0x48<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(BC.Lo, BC.Hi.Value, 4)

Opcode0x49<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(BC.Lo, BC.Lo.Value, 4)

Opcode0x4A<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(BC.Lo, DE.Hi.Value, 4)

Opcode0x4B<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(BC.Lo, DE.Lo.Value, 4)

Opcode0x4C<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(BC.Lo, HL.Hi.Value, 4)

Opcode0x4D<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(BC.Lo, HL.Lo.Value, 4)

Opcode0x50<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(DE.Hi, BC.Hi.Value, 4)

Opcode0x51<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(DE.Hi, BC.Lo.Value, 4)

Opcode0x52<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(DE.Hi, DE.Hi.Value, 4)

Opcode0x53<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(DE.Hi, DE.Lo.Value, 4)

Opcode0x54<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(DE.Hi, HL.Hi.Value, 4)

Opcode0x55<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(DE.Hi, HL.Lo.Value, 4)

Opcode0x58<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(DE.Lo, BC.Hi.Value, 4)

Opcode0x59<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(DE.Lo, BC.Lo.Value, 4)

Opcode0x5A<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(DE.Lo, DE.Hi.Value, 4)

Opcode0x5B<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(DE.Lo, DE.Lo.Value, 4)

Opcode0x5C<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(DE.Lo, HL.Hi.Value, 4)

Opcode0x5D<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(DE.Lo, HL.Lo.Value, 4)

Opcode0x60<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(HL.Hi, BC.Hi.Value, 4)

Opcode0x61<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(HL.Hi, BC.Lo.Value, 4)

Opcode0x62<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(HL.Hi, DE.Hi.Value, 4)

Opcode0x63<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(HL.Hi, DE.Lo.Value, 4)

Opcode0x64<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(HL.Hi, HL.Hi.Value, 4)

Opcode0x65<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(HL.Hi, HL.Lo.Value, 4)

Opcode0x68<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(HL.Lo, BC.Hi.Value, 4)

Opcode0x69<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(HL.Lo, BC.Lo.Value, 4)

Opcode0x6A<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(HL.Lo, DE.Hi.Value, 4)

Opcode0x6B<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(HL.Lo, DE.Lo.Value, 4)

Opcode0x6C<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(HL.Lo, HL.Hi.Value, 4)

Opcode0x6D<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(HL.Lo, HL.Lo.Value, 4)

# Write reg to memory
Opcode0x70<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.WriteByte(HL.GetReg(), BC.Hi.Value)
    set CyclesThisUpdate += 8

Opcode0x71<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.WriteByte(HL.GetReg(), BC.Lo.Value)
    set CyclesThisUpdate += 8

Opcode0x72<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.WriteByte(HL.GetReg(), DE.Hi.Value)
    set CyclesThisUpdate += 8

Opcode0x73<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.WriteByte(HL.GetReg(), DE.Lo.Value)
    set CyclesThisUpdate += 8

Opcode0x74<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.WriteByte(HL.GetReg(), HL.Hi.Value)
    set CyclesThisUpdate += 8

Opcode0x75<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.WriteByte(HL.GetReg(), HL.Lo.Value)
    set CyclesThisUpdate += 8

# Write memory to reg
Opcode0x7E<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD_ROM(AF.Hi, HL.GetReg())

Opcode0x46<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD_ROM(BC.Hi, HL.GetReg())

Opcode0x4E<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD_ROM(BC.Lo, HL.GetReg())

Opcode0x56<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD_ROM(DE.Hi, HL.GetReg())

Opcode0x5E<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD_ROM(DE.Lo, HL.GetReg())

Opcode0x66<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD_ROM(HL.Hi, HL.GetReg())

Opcode0x6E<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD_ROM(HL.Lo, HL.GetReg())

Opcode0x0A<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD_ROM(AF.Hi, BC.GetReg())

Opcode0x1A<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD_ROM(AF.Hi, DE.GetReg())

Opcode0xF2<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD_ROM(AF.Hi, BC.Lo.Value + 0xFF00)

# Put a into register
Opcode0x47<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(BC.Hi, AF.Hi.Value, 4)

Opcode0x4F<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(BC.Lo, AF.Hi.Value, 4)

Opcode0x57<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(DE.Hi, AF.Hi.Value, 4)

Opcode0x5F<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(DE.Lo, AF.Hi.Value, 4)

Opcode0x67<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(HL.Hi, AF.Hi.Value, 4)

Opcode0x6F<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD(HL.Lo, AF.Hi.Value, 4)

# Put a into memory address
Opcode0x02<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.WriteByte(BC.GetReg(), AF.Hi.Value)
    set CyclesThisUpdate += 8

Opcode0x12<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.WriteByte(DE.GetReg(), AF.Hi.Value)
    set CyclesThisUpdate += 8

Opcode0x77<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.WriteByte(HL.GetReg(), AF.Hi.Value)
    set CyclesThisUpdate += 8

Opcode0xE2<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.WriteByte(BC.Lo.Value + 0xFF00, AF.Hi.Value)
    set CyclesThisUpdate += 8

# Put memory into a, decrement/increment memory
Opcode0x3A<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD_ROM(AF.Hi, HL.GetReg())
    Emulator.CPU_16BIT_DEC(HL, 0)

Opcode0x2A<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_REG_LOAD_ROM(AF.Hi, HL.GetReg())
    Emulator.CPU_16BIT_INC(HL, 0)

# Put a into memory, decrement/increment reg
Opcode0x32<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.WriteByte(HL.GetReg(), AF.Hi.Value)
    Emulator.CPU_16BIT_DEC(HL, 0)
    set CyclesThisUpdate += 8

Opcode0x22<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.WriteByte(HL.GetReg(), AF.Hi.Value)
    Emulator.CPU_16BIT_INC(HL, 0)
    set CyclesThisUpdate += 8

# 16 bit loads
Opcode0x01<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_16BIT_LOAD(BC)

Opcode0x11<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_16BIT_LOAD(DE)

Opcode0x21<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_16BIT_LOAD(HL)

Opcode0x31<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_16BIT_LOAD(StackPointer)

Opcode0xF9<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    set CyclesThisUpdate += 8
    StackPointer.SetReg(HL.GetReg())

# Push word onto stack
Opcode0xF5<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    PushWordOntoStack(AF.GetReg())
    set CyclesThisUpdate += 16

Opcode0xC5<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    PushWordOntoStack(BC.GetReg())
    set CyclesThisUpdate += 16

Opcode0xD5<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    PushWordOntoStack(DE.GetReg())
    set CyclesThisUpdate += 16

Opcode0xE5<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    PushWordOntoStack(HL.GetReg())
    set CyclesThisUpdate += 16

# Pop word from stack into reg
Opcode0xF1<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    if (Word := PopWordOffStack[]):
        set CyclesThisUpdate += 12
        AF.SetReg(BitAnd(Word, 0xFFF0))

Opcode0xC1<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    if (Word := PopWordOffStack[]):
        set CyclesThisUpdate += 12
        BC.SetReg(Word)

Opcode0xD1<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    if (Word := PopWordOffStack[]):
        set CyclesThisUpdate += 12
        DE.SetReg(Word)

Opcode0xE1<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    if (Word := PopWordOffStack[]):
        set CyclesThisUpdate += 12
        HL.SetReg(Word)

# 8-bit add
Opcode0x87<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_ADD(AF.Hi, AF.Hi.Value, 4, false, false)

Opcode0x80<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_ADD(AF.Hi, BC.Hi.Value, 4, false, false)

Opcode0x81<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_ADD(AF.Hi, BC.Lo.Value, 4, false, false)

Opcode0x82<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_ADD(AF.Hi, DE.Hi.Value, 4, false, false)

Opcode0x83<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_ADD(AF.Hi, DE.Lo.Value, 4, false, false)

Opcode0x84<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_ADD(AF.Hi, HL.Hi.Value, 4, false, false)

Opcode0x85<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_ADD(AF.Hi, HL.Lo.Value, 4, false, false)

Opcode0x86<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    if (Byte := Emulator.ReadMemory[HL.GetReg()]):
        Emulator.CPU_8BIT_ADD(AF.Hi, Byte, 8, false, false)

Opcode0xC6<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_ADD(AF.Hi, 0, 8, true, false)

# 8-bit add + carry
Opcode0x8F<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_ADD(AF.Hi, AF.Hi.Value, 4, false, true)

Opcode0x88<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_ADD(AF.Hi, BC.Hi.Value, 4, false, true)

Opcode0x89<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_ADD(AF.Hi, BC.Lo.Value, 4, false, true)

Opcode0x8A<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_ADD(AF.Hi, DE.Hi.Value, 4, false, true)

Opcode0x8B<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_ADD(AF.Hi, DE.Lo.Value, 4, false, true)

Opcode0x8C<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_ADD(AF.Hi, HL.Hi.Value, 4, false, true)

Opcode0x8D<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_ADD(AF.Hi, HL.Lo.Value, 4, false, true)

Opcode0x8E<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    if (Byte := Emulator.ReadMemory[HL.GetReg()]):
        Emulator.CPU_8BIT_ADD(AF.Hi, Byte, 8, false, true)

Opcode0xCE<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_ADD(AF.Hi, 0, 8, true, true)

# 8-bit subtract
Opcode0x97<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_SUB(AF.Hi, AF.Hi.Value, 4, false, false)

Opcode0x90<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_SUB(AF.Hi, BC.Hi.Value, 4, false, false)

Opcode0x91<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_SUB(AF.Hi, BC.Lo.Value, 4, false, false)

Opcode0x92<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_SUB(AF.Hi, DE.Hi.Value, 4, false, false)

Opcode0x93<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_SUB(AF.Hi, DE.Lo.Value, 4, false, false)

Opcode0x94<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_SUB(AF.Hi, HL.Hi.Value, 4, false, false)

Opcode0x95<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_SUB(AF.Hi, HL.Lo.Value, 4, false, false)

Opcode0x96<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    if (Byte := Emulator.ReadMemory[HL.GetReg()]):
        Emulator.CPU_8BIT_SUB(AF.Hi, Byte, 8, false, false)

Opcode0xD6<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_SUB(AF.Hi, 0, 8, true, false)

# 8-bit subtract + carry
Opcode0x9F<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_SUB(AF.Hi, AF.Hi.Value, 4, false, true)

Opcode0x98<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_SUB(AF.Hi, BC.Hi.Value, 4, false, true)

Opcode0x99<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_SUB(AF.Hi, BC.Lo.Value, 4, false, true)

Opcode0x9A<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_SUB(AF.Hi, DE.Hi.Value, 4, false, true)

Opcode0x9B<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_SUB(AF.Hi, DE.Lo.Value, 4, false, true)

Opcode0x9C<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_SUB(AF.Hi, HL.Hi.Value, 4, false, true)

Opcode0x9D<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_SUB(AF.Hi, HL.Lo.Value, 4, false, true)

Opcode0x9E<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    if (Byte := Emulator.ReadMemory[HL.GetReg()]):
        Emulator.CPU_8BIT_SUB(AF.Hi, Byte, 8, false, true)

Opcode0xDE<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_SUB(AF.Hi, 0, 8, true, true)

# 8-bit AND reg with reg
Opcode0xA7<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_AND(AF.Hi, AF.Hi.Value, 4, false)

Opcode0xA0<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_AND(AF.Hi, BC.Hi.Value, 4, false)

Opcode0xA1<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_AND(AF.Hi, BC.Lo.Value, 4, false)

Opcode0xA2<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_AND(AF.Hi, DE.Hi.Value, 4, false)

Opcode0xA3<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_AND(AF.Hi, DE.Lo.Value, 4, false)

Opcode0xA4<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_AND(AF.Hi, HL.Hi.Value, 4, false)

Opcode0xA5<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_AND(AF.Hi, HL.Lo.Value, 4, false)

Opcode0xA6<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    if (Byte := Emulator.ReadMemory[HL.GetReg()]):
        Emulator.CPU_8BIT_AND(AF.Hi, Byte, 8, false)

Opcode0xE6<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_AND(AF.Hi, 0, 8, true)

# 8-bit OR reg with reg
Opcode0xB7<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_OR(AF.Hi, AF.Hi.Value, 4, false)

Opcode0xB0<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_OR(AF.Hi, BC.Hi.Value, 4, false)

Opcode0xB1<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_OR(AF.Hi, BC.Lo.Value, 4, false)

Opcode0xB2<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_OR(AF.Hi, DE.Hi.Value, 4, false)

Opcode0xB3<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_OR(AF.Hi, DE.Lo.Value, 4, false)

Opcode0xB4<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_OR(AF.Hi, HL.Hi.Value, 4, false)

Opcode0xB5<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_OR(AF.Hi, HL.Lo.Value, 4, false)

Opcode0xB6<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    if (Byte := Emulator.ReadMemory[HL.GetReg()]):
        Emulator.CPU_8BIT_OR(AF.Hi, Byte, 8, false)

Opcode0xF6<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_OR(AF.Hi, 0, 8, true)

# 8-bit XOR reg with reg
Opcode0xAF<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_XOR(AF.Hi, AF.Hi.Value, 4, false)

Opcode0xA8<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_XOR(AF.Hi, BC.Hi.Value, 4, false)

Opcode0xA9<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_XOR(AF.Hi, BC.Lo.Value, 4, false)

Opcode0xAA<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_XOR(AF.Hi, DE.Hi.Value, 4, false)

Opcode0xAB<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_XOR(AF.Hi, DE.Lo.Value, 4, false)

Opcode0xAC<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_XOR(AF.Hi, HL.Hi.Value, 4, false)

Opcode0xAD<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_XOR(AF.Hi, HL.Lo.Value, 4, false)

Opcode0xAE<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    if (Byte := Emulator.ReadMemory[HL.GetReg()]):
        Emulator.CPU_8BIT_XOR(AF.Hi, Byte, 8, false)

Opcode0xEE<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_XOR(AF.Hi, 0, 8, true)

# 8-Bit compare
Opcode0xBF<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_COMPARE(AF.Hi.Value, AF.Hi.Value, 4, false)

Opcode0xB8<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_COMPARE(AF.Hi.Value, BC.Hi.Value, 4, false)

Opcode0xB9<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_COMPARE(AF.Hi.Value, BC.Lo.Value, 4, false)

Opcode0xBA<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_COMPARE(AF.Hi.Value, DE.Hi.Value, 4, false)

Opcode0xBB<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_COMPARE(AF.Hi.Value, DE.Lo.Value, 4, false)

Opcode0xBC<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_COMPARE(AF.Hi.Value, HL.Hi.Value, 4, false)

Opcode0xBD<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_COMPARE(AF.Hi.Value, HL.Lo.Value, 4, false)

Opcode0xBE<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    if (Byte := Emulator.ReadMemory[HL.GetReg()]):
        Emulator.CPU_8BIT_COMPARE(AF.Hi.Value, Byte, 8, false)

Opcode0xFE<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_COMPARE(AF.Hi.Value, 0, 8, true)

# 8-bit inc
Opcode0x3C<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_INC(AF.Hi, 4)

Opcode0x04<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_INC(BC.Hi, 4)

Opcode0x0C<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_INC(BC.Lo, 4)

Opcode0x14<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_INC(DE.Hi, 4)

Opcode0x1C<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_INC(DE.Lo, 4)

Opcode0x24<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_INC(HL.Hi, 4)

Opcode0x2C<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_INC(HL.Lo, 4)

Opcode0x34<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_MEMORY_INC(HL.GetReg(), 12)

# 8-bit dec
Opcode0x3D<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_DEC(AF.Hi, 4)

Opcode0x05<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_DEC(BC.Hi, 4)

Opcode0x0D<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_DEC(BC.Lo, 4)

Opcode0x15<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_DEC(DE.Hi, 4)

Opcode0x1D<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_DEC(DE.Lo, 4)

Opcode0x25<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_DEC(HL.Hi, 4)

Opcode0x2D<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_DEC(HL.Lo, 4)

Opcode0x35<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_8BIT_MEMORY_DEC(HL.GetReg(), 12)

# 16-bit add
Opcode0x09<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_16BIT_ADD(HL, BC.GetReg(), 8)

Opcode0x19<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_16BIT_ADD(HL, DE.GetReg(), 8)

Opcode0x29<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_16BIT_ADD(HL, HL.GetReg(), 8)

Opcode0x39<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_16BIT_ADD(HL, StackPointer.GetReg(), 8)

# Inc 16-bit register
Opcode0x03<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_16BIT_INC(BC, 8)

Opcode0x13<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_16BIT_INC(DE, 8)

Opcode0x23<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_16BIT_INC(HL, 8)

Opcode0x33<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_16BIT_INC(StackPointer, 8)

# Dec 16-bit register
Opcode0x0B<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_16BIT_DEC(BC, 8)

Opcode0x1B<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_16BIT_DEC(DE, 8)

Opcode0x2B<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_16BIT_DEC(HL, 8)

Opcode0x3B<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_16BIT_DEC(StackPointer, 8)

# Jumps
Opcode0xE9<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    set CyclesThisUpdate += 4
    set ProgramCounter = HL.GetReg()

Opcode0xC3<internal>(Emulator:emulator):void=
    Emulator.CPU_JUMP(false, 0, false)

Opcode0xC2<internal>(Emulator:emulator):void=
    Emulator.CPU_JUMP(true, FLAG_MASK_Z, false)

Opcode0xCA<internal>(Emulator:emulator):void=
    Emulator.CPU_JUMP(true, FLAG_MASK_Z, true)

Opcode0xD2<internal>(Emulator:emulator):void=
    Emulator.CPU_JUMP(true, FLAG_MASK_C, false)

Opcode0xDA<internal>(Emulator:emulator):void=
    Emulator.CPU_JUMP(true, FLAG_MASK_C, true)

# Jump with immediate data
Opcode0x18<internal>(Emulator:emulator):void=
    Emulator.CPU_JUMP_IMMEDIATE(false, 0, false)

Opcode0x20<internal>(Emulator:emulator):void=
    Emulator.CPU_JUMP_IMMEDIATE(true, FLAG_MASK_Z, false)

Opcode0x28<internal>(Emulator:emulator):void=
    Emulator.CPU_JUMP_IMMEDIATE(true, FLAG_MASK_Z, true)

Opcode0x30<internal>(Emulator:emulator):void=
    Emulator.CPU_JUMP_IMMEDIATE(true, FLAG_MASK_C, false)

Opcode0x38<internal>(Emulator:emulator):void=
    Emulator.CPU_JUMP_IMMEDIATE(true, FLAG_MASK_C, true)

# Calls
Opcode0xCD<internal>(Emulator:emulator):void=
    Emulator.CPU_CALL(false, 0, false)

Opcode0xC4<internal>(Emulator:emulator):void=
    Emulator.CPU_CALL(true, FLAG_MASK_Z, false)

Opcode0xCC<internal>(Emulator:emulator):void=
    Emulator.CPU_CALL(true, FLAG_MASK_Z, true)

Opcode0xD4<internal>(Emulator:emulator):void=
    Emulator.CPU_CALL(true, FLAG_MASK_C, false)

Opcode0xDC<internal>(Emulator:emulator):void=
    Emulator.CPU_CALL(true, FLAG_MASK_C, true)

# Returns
Opcode0xC9<internal>(Emulator:emulator):void=
    Emulator.CPU_RETURN(false, 0, false)

Opcode0xC0<internal>(Emulator:emulator):void=
    Emulator.CPU_RETURN(true, FLAG_MASK_Z, false)

Opcode0xC8<internal>(Emulator:emulator):void=
    Emulator.CPU_RETURN(true, FLAG_MASK_Z, true)

Opcode0xD0<internal>(Emulator:emulator):void=
    Emulator.CPU_RETURN(true, FLAG_MASK_C, false)

Opcode0xD8<internal>(Emulator:emulator):void=
    Emulator.CPU_RETURN(true, FLAG_MASK_C, true)

# Restarts
Opcode0xC7<internal>(Emulator:emulator):void=
    Emulator.CPU_RESTARTS(0x0)

Opcode0xCF<internal>(Emulator:emulator):void=
    Emulator.CPU_RESTARTS(0x8)

Opcode0xD7<internal>(Emulator:emulator):void=
    Emulator.CPU_RESTARTS(0x10)

Opcode0xDF<internal>(Emulator:emulator):void=
    Emulator.CPU_RESTARTS(0x18)

Opcode0xE7<internal>(Emulator:emulator):void=
    Emulator.CPU_RESTARTS(0x20)

Opcode0xEF<internal>(Emulator:emulator):void=
    Emulator.CPU_RESTARTS(0x28)

Opcode0xF7<internal>(Emulator:emulator):void=
    Emulator.CPU_RESTARTS(0x30)

Opcode0xFF<internal>(Emulator:emulator):void=
    Emulator.CPU_RESTARTS(0x38)

Opcode0x27<internal>(Emulator:emulator):void=
    Emulator.CPU_DAA()

# Handle the extended opcodes
Opcode0xCB<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { Emulator }
    using { EmulatorCPU }
    if:
        Opcode := if (ProgramCounter >= 0x4000 and ProgramCounter <= 0x7FFF or ProgramCounter >= 0xA000 and ProgramCounter <= 0xBFFF):
            ReadMemory[ProgramCounter]
        else:
            Memory[ProgramCounter]
    then:
        ExecuteExtendedOpcode(Emulator, Opcode)

# Unique instructions
Opcode0x07<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RLC(AF.Hi)
    set AF.Lo.Value = BitAnd(AF.Lo.Value, 0x7F)
    set CyclesThisUpdate -= 4

Opcode0x0F<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RRC(AF.Hi)
    set AF.Lo.Value = BitAnd(AF.Lo.Value, 0x7F)
    set CyclesThisUpdate -= 4

Opcode0x17<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RL(AF.Hi)
    set AF.Lo.Value = BitAnd(AF.Lo.Value, 0x7F)
    set CyclesThisUpdate -= 4

Opcode0x1F<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RR(AF.Hi)
    set AF.Lo.Value = BitAnd(AF.Lo.Value, 0x7F)
    set CyclesThisUpdate -= 4

Opcode0xD9<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    if (Word := PopWordOffStack[]):
        set CyclesThisUpdate += 16
        set EnableInterrupts = true
        set ProgramCounter = Word

Opcode0x08<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { Emulator }
    using { EmulatorCPU }
    if (NN := ReadWord[]):
        set ProgramCounter = BitAnd(ProgramCounter + 2, 0xFFFF)
        WriteByte(NN, StackPointer.Lo.Value)
        WriteByte(BitAnd(NN + 1, 0xFFFF), StackPointer.Hi.Value)
        set CyclesThisUpdate += 20

Opcode0x36<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { Emulator }
    using { EmulatorCPU }
    set CyclesThisUpdate += 12
    if (N := ReadMemory[ProgramCounter]):
        set ProgramCounter = BitAnd(ProgramCounter + 1, 0xFFFF)
        WriteByte(HL.GetReg(), N)

Opcode0xFA<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { Emulator }
    using { EmulatorCPU }
    set CyclesThisUpdate += 16
    if (NN := ReadWord[]):
        set ProgramCounter = BitAnd(ProgramCounter + 2, 0xFFFF)
        if (N := ReadMemory[NN]):
            set AF.Hi.Value = N

Opcode0x3E<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    set CyclesThisUpdate += 8
    if (N := Emulator.ReadMemory[ProgramCounter]):
        set AF.Hi.Value = N
        set ProgramCounter = BitAnd(ProgramCounter + 1, 0xFFFF)

Opcode0xEA<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { Emulator }
    using { EmulatorCPU }
    set CyclesThisUpdate += 16
    if (NN := ReadWord[]):
        set ProgramCounter = BitAnd(ProgramCounter + 2, 0xFFFF)
        WriteByte(NN, AF.Hi.Value)

Opcode0xF3<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    set CyclesThisUpdate += 4
    set EnableInterrupts = false
    set PendingInterruptEnabled = false

Opcode0xFB<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    set CyclesThisUpdate += 4
    set PendingInterruptEnabled = true

Opcode0xE0<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { Emulator }
    using { EmulatorCPU }
    if (N := ReadMemory[ProgramCounter]):
        Address:int = 0xFF00 + N
        set ProgramCounter = BitAnd(ProgramCounter + 1, 0xFFFF)
        WriteByte(Address, AF.Hi.Value)
        set CyclesThisUpdate += 12

Opcode0xF0<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { Emulator }
    using { EmulatorCPU }
    if (N := ReadMemory[ProgramCounter]):
        Address:int = 0xFF00 + N
        set ProgramCounter = BitAnd(ProgramCounter + 1, 0xFFFF)
        if (Byte := ReadMemory[Address]):
            set AF.Hi.Value = Byte
            set CyclesThisUpdate += 12

Opcode0x2F<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    set AF.Hi.Value = BitXor(AF.Hi.Value, 0xFF)
    set AF.Lo.Value = BitSet(BitSet(AF.Lo.Value, FLAG_N), FLAG_H)
    set CyclesThisUpdate += 4

Opcode0x76<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { Emulator }
    using { EmulatorCPU }
    set CyclesThisUpdate += 4
    if (not EnableInterrupts?, BitAnd(BitAnd(Memory[0xFF0F], Memory[0xFFFF]), 0x1F) <> 0):
        set HaltBug = true
    else:
        set Halted = true

Opcode0x3F<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    set AF.Lo.Value = if (TestBit[AF.Lo.Value, FLAG_C]):
        BitReset(AF.Lo.Value, FLAG_C)
    else:
        BitSet(AF.Lo.Value, FLAG_C)
    set AF.Lo.Value = BitReset(BitReset(AF.Lo.Value, FLAG_H), FLAG_N)
    set CyclesThisUpdate += 4

Opcode0x37<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    set AF.Lo.Value = BitReset(BitReset(BitSet(AF.Lo.Value, FLAG_C), FLAG_H), FLAG_N)
    set CyclesThisUpdate += 4

Opcode0xF8<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    if (N := Emulator.ReadMemory[ProgramCounter]):
        SignedN:int = N > 127 and N - 256 or N
        Value:int = StackPointer.GetReg() + SignedN
        HL.SetReg(Value)
        set AF.Lo.Value = BitReset(BitReset(AF.Lo.Value, FLAG_Z), FLAG_N)
        set AF.Lo.Value = if (BitAnd(StackPointer.GetReg(), 0xFF) + N > 0xFF):
            BitSet(AF.Lo.Value, FLAG_C)
        else:
            BitReset(AF.Lo.Value, FLAG_C)
        set AF.Lo.Value = if (BitAnd(StackPointer.GetReg(), 0xF) + BitAnd(N, 0xF) > 0xF):
            BitSet(AF.Lo.Value, FLAG_H)
        else:
            BitReset(AF.Lo.Value, FLAG_H)
        set CyclesThisUpdate += 12
        set ProgramCounter = BitAnd(ProgramCounter + 1, 0xFFFF)

Opcode0x10<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    set CyclesThisUpdate += 4
    set ProgramCounter = BitAnd(ProgramCounter + 1, 0xFFFF)

Opcode0xE8<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    if (N := Emulator.ReadMemory[ProgramCounter]):
        Before:int = StackPointer.GetReg()
        SignedN:int = N > 127 and N - 256 or N
        StackPointer.SetReg(Before + SignedN)
        set AF.Lo.Value = BitReset(BitReset(AF.Lo.Value, FLAG_Z), FLAG_N)
        set AF.Lo.Value = if (BitAnd(Before, 0xFF) + N > 0xFF):
            BitSet(AF.Lo.Value, FLAG_C)
        else:
            BitReset(AF.Lo.Value, FLAG_C)
        set AF.Lo.Value = if (BitAnd(Before, 0xF) + BitAnd(N, 0xF) > 0xF):
            BitSet(AF.Lo.Value, FLAG_H)
        else:
            BitReset(AF.Lo.Value, FLAG_H)
        set CyclesThisUpdate += 16
        set ProgramCounter = BitAnd(ProgramCounter + 1, 0xFFFF)