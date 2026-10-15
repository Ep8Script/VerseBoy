using { Core }

# Extended opcode functions to avoid case()

# Rotate left through carry
ExtendedOpcode0x0<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RLC(BC.Hi)

ExtendedOpcode0x1<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RLC(BC.Lo)

ExtendedOpcode0x2<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RLC(DE.Hi)

ExtendedOpcode0x3<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RLC(DE.Lo)

ExtendedOpcode0x4<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RLC(HL.Hi)

ExtendedOpcode0x5<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RLC(HL.Lo)

ExtendedOpcode0x6<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RLC_MEMORY(HL.GetReg())

ExtendedOpcode0x7<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RLC(AF.Hi)

# Rotate right through carry
ExtendedOpcode0x8<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RRC(BC.Hi)

ExtendedOpcode0x9<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RRC(BC.Lo)

ExtendedOpcode0xA<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RRC(DE.Hi)

ExtendedOpcode0xB<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RRC(DE.Lo)

ExtendedOpcode0xC<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RRC(HL.Hi)

ExtendedOpcode0xD<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RRC(HL.Lo)

ExtendedOpcode0xE<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RRC_MEMORY(HL.GetReg())

ExtendedOpcode0xF<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RRC(AF.Hi)

# Rotate left
ExtendedOpcode0x10<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RL(BC.Hi)

ExtendedOpcode0x11<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RL(BC.Lo)

ExtendedOpcode0x12<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RL(DE.Hi)

ExtendedOpcode0x13<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RL(DE.Lo)

ExtendedOpcode0x14<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RL(HL.Hi)

ExtendedOpcode0x15<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RL(HL.Lo)

ExtendedOpcode0x16<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RL_MEMORY(HL.GetReg())

ExtendedOpcode0x17<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RL(AF.Hi)

# Rotate right
ExtendedOpcode0x18<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RR(BC.Hi)

ExtendedOpcode0x19<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RR(BC.Lo)

ExtendedOpcode0x1A<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RR(DE.Hi)

ExtendedOpcode0x1B<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RR(DE.Lo)

ExtendedOpcode0x1C<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RR(HL.Hi)

ExtendedOpcode0x1D<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RR(HL.Lo)

ExtendedOpcode0x1E<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RR_MEMORY(HL.GetReg())

ExtendedOpcode0x1F<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RR(AF.Hi)

ExtendedOpcode0x20<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SLA(BC.Hi)

ExtendedOpcode0x21<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SLA(BC.Lo)

ExtendedOpcode0x22<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SLA(DE.Hi)

ExtendedOpcode0x23<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SLA(DE.Lo)

ExtendedOpcode0x24<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SLA(HL.Hi)

ExtendedOpcode0x25<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SLA(HL.Lo)

ExtendedOpcode0x26<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SLA_MEMORY(HL.GetReg())

ExtendedOpcode0x27<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SLA(AF.Hi)

ExtendedOpcode0x28<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SRA(BC.Hi)

ExtendedOpcode0x29<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SRA(BC.Lo)

ExtendedOpcode0x2A<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SRA(DE.Hi)

ExtendedOpcode0x2B<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SRA(DE.Lo)

ExtendedOpcode0x2C<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SRA(HL.Hi)

ExtendedOpcode0x2D<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SRA(HL.Lo)

ExtendedOpcode0x2E<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SRA_MEMORY(HL.GetReg())

ExtendedOpcode0x2F<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SRA(AF.Hi)

ExtendedOpcode0x38<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SRL(BC.Hi)

ExtendedOpcode0x39<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SRL(BC.Lo)

ExtendedOpcode0x3A<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SRL(DE.Hi)

ExtendedOpcode0x3B<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SRL(DE.Lo)

ExtendedOpcode0x3C<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SRL(HL.Hi)

ExtendedOpcode0x3D<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SRL(HL.Lo)

ExtendedOpcode0x3E<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SRL_MEMORY(HL.GetReg())

ExtendedOpcode0x3F<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SRL(AF.Hi)

# Swap nibbles
ExtendedOpcode0x37<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SWAP_NIBBLES(AF.Hi)

ExtendedOpcode0x30<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SWAP_NIBBLES(BC.Hi)

ExtendedOpcode0x31<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SWAP_NIBBLES(BC.Lo)

ExtendedOpcode0x32<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SWAP_NIBBLES(DE.Hi)

ExtendedOpcode0x33<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SWAP_NIBBLES(DE.Lo)

ExtendedOpcode0x34<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SWAP_NIBBLES(HL.Hi)

ExtendedOpcode0x35<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SWAP_NIBBLES(HL.Lo)

ExtendedOpcode0x36<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SWAP_NIB_MEM(HL.GetReg())

# Test bit
ExtendedOpcode0x40<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(BC.Hi.Value, 0, 8)

ExtendedOpcode0x41<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(BC.Lo.Value, 0, 8)

ExtendedOpcode0x42<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(DE.Hi.Value, 0, 8)

ExtendedOpcode0x43<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(DE.Lo.Value, 0, 8)

ExtendedOpcode0x44<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(HL.Hi.Value, 0, 8)

ExtendedOpcode0x45<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(HL.Lo.Value, 0, 8)

ExtendedOpcode0x46<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    if (Byte := Emulator.ReadMemory[HL.GetReg()]):
        Emulator.CPU_TEST_BIT(Byte, 0, 12)

ExtendedOpcode0x47<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(AF.Hi.Value, 0, 8)

ExtendedOpcode0x48<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(BC.Hi.Value, 1, 8)

ExtendedOpcode0x49<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(BC.Lo.Value, 1, 8)

ExtendedOpcode0x4A<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(DE.Hi.Value, 1, 8)

ExtendedOpcode0x4B<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(DE.Lo.Value, 1, 8)

ExtendedOpcode0x4C<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(HL.Hi.Value, 1, 8)

ExtendedOpcode0x4D<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(HL.Lo.Value, 1, 8)

ExtendedOpcode0x4E<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    if (Byte := Emulator.ReadMemory[HL.GetReg()]):
        Emulator.CPU_TEST_BIT(Byte, 1, 12)

ExtendedOpcode0x4F<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(AF.Hi.Value, 1, 8)

ExtendedOpcode0x50<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(BC.Hi.Value, 2, 8)

ExtendedOpcode0x51<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(BC.Lo.Value, 2, 8)

ExtendedOpcode0x52<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(DE.Hi.Value, 2, 8)

ExtendedOpcode0x53<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(DE.Lo.Value, 2, 8)

ExtendedOpcode0x54<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(HL.Hi.Value, 2, 8)

ExtendedOpcode0x55<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(HL.Lo.Value, 2, 8)

ExtendedOpcode0x56<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    if (Byte := Emulator.ReadMemory[HL.GetReg()]):
        Emulator.CPU_TEST_BIT(Byte, 2, 12)

ExtendedOpcode0x57<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(AF.Hi.Value, 2, 8)

ExtendedOpcode0x58<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(BC.Hi.Value, 3, 8)

ExtendedOpcode0x59<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(BC.Lo.Value, 3, 8)

ExtendedOpcode0x5A<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(DE.Hi.Value, 3, 8)

ExtendedOpcode0x5B<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(DE.Lo.Value, 3, 8)

ExtendedOpcode0x5C<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(HL.Hi.Value, 3, 8)

ExtendedOpcode0x5D<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(HL.Lo.Value, 3, 8)

ExtendedOpcode0x5E<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    if (Byte := Emulator.ReadMemory[HL.GetReg()]):
        Emulator.CPU_TEST_BIT(Byte, 3, 12)

ExtendedOpcode0x5F<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(AF.Hi.Value, 3, 8)

ExtendedOpcode0x60<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(BC.Hi.Value, 4, 8)

ExtendedOpcode0x61<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(BC.Lo.Value, 4, 8)

ExtendedOpcode0x62<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(DE.Hi.Value, 4, 8)

ExtendedOpcode0x63<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(DE.Lo.Value, 4, 8)

ExtendedOpcode0x64<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(HL.Hi.Value, 4, 8)

ExtendedOpcode0x65<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(HL.Lo.Value, 4, 8)

ExtendedOpcode0x66<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    if (Byte := Emulator.ReadMemory[HL.GetReg()]):
        Emulator.CPU_TEST_BIT(Byte, 4, 12)

ExtendedOpcode0x67<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(AF.Hi.Value, 4, 8)

ExtendedOpcode0x68<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(BC.Hi.Value, 5, 8)

ExtendedOpcode0x69<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(BC.Lo.Value, 5, 8)

ExtendedOpcode0x6A<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(DE.Hi.Value, 5, 8)

ExtendedOpcode0x6B<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(DE.Lo.Value, 5, 8)

ExtendedOpcode0x6C<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(HL.Hi.Value, 5, 8)

ExtendedOpcode0x6D<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(HL.Lo.Value, 5, 8)

ExtendedOpcode0x6E<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    if (Byte := Emulator.ReadMemory[HL.GetReg()]):
        Emulator.CPU_TEST_BIT(Byte, 5, 12)

ExtendedOpcode0x6F<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(AF.Hi.Value, 5, 8)

ExtendedOpcode0x70<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(BC.Hi.Value, 6, 8)

ExtendedOpcode0x71<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(BC.Lo.Value, 6, 8)

ExtendedOpcode0x72<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(DE.Hi.Value, 6, 8)

ExtendedOpcode0x73<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(DE.Lo.Value, 6, 8)

ExtendedOpcode0x74<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(HL.Hi.Value, 6, 8)

ExtendedOpcode0x75<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(HL.Lo.Value, 6, 8)

ExtendedOpcode0x76<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    if (Byte := Emulator.ReadMemory[HL.GetReg()]):
        Emulator.CPU_TEST_BIT(Byte, 6, 12)

ExtendedOpcode0x77<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(AF.Hi.Value, 6, 8)

ExtendedOpcode0x78<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(BC.Hi.Value, 7, 8)

ExtendedOpcode0x79<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(BC.Lo.Value, 7, 8)

ExtendedOpcode0x7A<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(DE.Hi.Value, 7, 8)

ExtendedOpcode0x7B<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(DE.Lo.Value, 7, 8)

ExtendedOpcode0x7C<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(HL.Hi.Value, 7, 8)

ExtendedOpcode0x7D<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(HL.Lo.Value, 7, 8)

ExtendedOpcode0x7E<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    if (Byte := Emulator.ReadMemory[HL.GetReg()]):
        Emulator.CPU_TEST_BIT(Byte, 7, 12)

ExtendedOpcode0x7F<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_TEST_BIT(AF.Hi.Value, 7, 8)

# Reset bit
ExtendedOpcode0x80<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(BC.Hi, 0)

ExtendedOpcode0x81<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(BC.Lo, 0)

ExtendedOpcode0x82<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(DE.Hi, 0)

ExtendedOpcode0x83<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(DE.Lo, 0)

ExtendedOpcode0x84<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(HL.Hi, 0)

ExtendedOpcode0x85<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(HL.Lo, 0)

ExtendedOpcode0x86<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT_MEMORY(HL.GetReg(), 0)

ExtendedOpcode0x87<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(AF.Hi, 0)

ExtendedOpcode0x88<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(BC.Hi, 1)

ExtendedOpcode0x89<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(BC.Lo, 1)

ExtendedOpcode0x8A<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(DE.Hi, 1)

ExtendedOpcode0x8B<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(DE.Lo, 1)

ExtendedOpcode0x8C<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(HL.Hi, 1)

ExtendedOpcode0x8D<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(HL.Lo, 1)

ExtendedOpcode0x8E<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT_MEMORY(HL.GetReg(), 1)

ExtendedOpcode0x8F<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(AF.Hi, 1)

ExtendedOpcode0x90<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(BC.Hi, 2)

ExtendedOpcode0x91<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(BC.Lo, 2)

ExtendedOpcode0x92<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(DE.Hi, 2)

ExtendedOpcode0x93<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(DE.Lo, 2)

ExtendedOpcode0x94<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(HL.Hi, 2)

ExtendedOpcode0x95<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(HL.Lo, 2)

ExtendedOpcode0x96<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT_MEMORY(HL.GetReg(), 2)

ExtendedOpcode0x97<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(AF.Hi, 2)

ExtendedOpcode0x98<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(BC.Hi, 3)

ExtendedOpcode0x99<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(BC.Lo, 3)

ExtendedOpcode0x9A<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(DE.Hi, 3)

ExtendedOpcode0x9B<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(DE.Lo, 3)

ExtendedOpcode0x9C<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(HL.Hi, 3)

ExtendedOpcode0x9D<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(HL.Lo, 3)

ExtendedOpcode0x9E<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT_MEMORY(HL.GetReg(), 3)

ExtendedOpcode0x9F<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(AF.Hi, 3)

ExtendedOpcode0xA0<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(BC.Hi, 4)

ExtendedOpcode0xA1<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(BC.Lo, 4)

ExtendedOpcode0xA2<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(DE.Hi, 4)

ExtendedOpcode0xA3<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(DE.Lo, 4)

ExtendedOpcode0xA4<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(HL.Hi, 4)

ExtendedOpcode0xA5<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(HL.Lo, 4)

ExtendedOpcode0xA6<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT_MEMORY(HL.GetReg(), 4)

ExtendedOpcode0xA7<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(AF.Hi, 4)

ExtendedOpcode0xA8<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(BC.Hi, 5)

ExtendedOpcode0xA9<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(BC.Lo, 5)

ExtendedOpcode0xAA<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(DE.Hi, 5)

ExtendedOpcode0xAB<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(DE.Lo, 5)

ExtendedOpcode0xAC<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(HL.Hi, 5)

ExtendedOpcode0xAD<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(HL.Lo, 5)

ExtendedOpcode0xAE<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT_MEMORY(HL.GetReg(), 5)

ExtendedOpcode0xAF<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(AF.Hi, 5)

ExtendedOpcode0xB0<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(BC.Hi, 6)

ExtendedOpcode0xB1<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(BC.Lo, 6)

ExtendedOpcode0xB2<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(DE.Hi, 6)

ExtendedOpcode0xB3<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(DE.Lo, 6)

ExtendedOpcode0xB4<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(HL.Hi, 6)

ExtendedOpcode0xB5<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(HL.Lo, 6)

ExtendedOpcode0xB6<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT_MEMORY(HL.GetReg(), 6)

ExtendedOpcode0xB7<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(AF.Hi, 6)

ExtendedOpcode0xB8<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(BC.Hi, 7)

ExtendedOpcode0xB9<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(BC.Lo, 7)

ExtendedOpcode0xBA<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(DE.Hi, 7)

ExtendedOpcode0xBB<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(DE.Lo, 7)

ExtendedOpcode0xBC<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(HL.Hi, 7)

ExtendedOpcode0xBD<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(HL.Lo, 7)

ExtendedOpcode0xBE<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT_MEMORY(HL.GetReg(), 7)

ExtendedOpcode0xBF<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_RESET_BIT(AF.Hi, 7)

# Set bit
ExtendedOpcode0xC0<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(BC.Hi, 0)

ExtendedOpcode0xC1<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(BC.Lo, 0)

ExtendedOpcode0xC2<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(DE.Hi, 0)

ExtendedOpcode0xC3<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(DE.Lo, 0)

ExtendedOpcode0xC4<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(HL.Hi, 0)

ExtendedOpcode0xC5<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(HL.Lo, 0)

ExtendedOpcode0xC6<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT_MEMORY(HL.GetReg(), 0)

ExtendedOpcode0xC7<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(AF.Hi, 0)

ExtendedOpcode0xC8<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(BC.Hi, 1)

ExtendedOpcode0xC9<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(BC.Lo, 1)

ExtendedOpcode0xCA<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(DE.Hi, 1)

ExtendedOpcode0xCB<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(DE.Lo, 1)

ExtendedOpcode0xCC<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(HL.Hi, 1)

ExtendedOpcode0xCD<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(HL.Lo, 1)

ExtendedOpcode0xCE<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT_MEMORY(HL.GetReg(), 1)

ExtendedOpcode0xCF<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(AF.Hi, 1)

ExtendedOpcode0xD0<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(BC.Hi, 2)

ExtendedOpcode0xD1<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(BC.Lo, 2)

ExtendedOpcode0xD2<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(DE.Hi, 2)

ExtendedOpcode0xD3<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(DE.Lo, 2)

ExtendedOpcode0xD4<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(HL.Hi, 2)

ExtendedOpcode0xD5<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(HL.Lo, 2)

ExtendedOpcode0xD6<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT_MEMORY(HL.GetReg(), 2)

ExtendedOpcode0xD7<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(AF.Hi, 2)

ExtendedOpcode0xD8<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(BC.Hi, 3)

ExtendedOpcode0xD9<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(BC.Lo, 3)

ExtendedOpcode0xDA<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(DE.Hi, 3)

ExtendedOpcode0xDB<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(DE.Lo, 3)

ExtendedOpcode0xDC<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(HL.Hi, 3)

ExtendedOpcode0xDD<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(HL.Lo, 3)

ExtendedOpcode0xDE<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT_MEMORY(HL.GetReg(), 3)

ExtendedOpcode0xDF<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(AF.Hi, 3)

ExtendedOpcode0xE0<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(BC.Hi, 4)

ExtendedOpcode0xE1<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(BC.Lo, 4)

ExtendedOpcode0xE2<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(DE.Hi, 4)

ExtendedOpcode0xE3<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(DE.Lo, 4)

ExtendedOpcode0xE4<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(HL.Hi, 4)

ExtendedOpcode0xE5<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(HL.Lo, 4)

ExtendedOpcode0xE6<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT_MEMORY(HL.GetReg(), 4)

ExtendedOpcode0xE7<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(AF.Hi, 4)

ExtendedOpcode0xE8<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(BC.Hi, 5)

ExtendedOpcode0xE9<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(BC.Lo, 5)

ExtendedOpcode0xEA<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(DE.Hi, 5)

ExtendedOpcode0xEB<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(DE.Lo, 5)

ExtendedOpcode0xEC<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(HL.Hi, 5)

ExtendedOpcode0xED<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(HL.Lo, 5)

ExtendedOpcode0xEE<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT_MEMORY(HL.GetReg(), 5)

ExtendedOpcode0xEF<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(AF.Hi, 5)

ExtendedOpcode0xF0<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(BC.Hi, 6)

ExtendedOpcode0xF1<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(BC.Lo, 6)

ExtendedOpcode0xF2<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(DE.Hi, 6)

ExtendedOpcode0xF3<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(DE.Lo, 6)

ExtendedOpcode0xF4<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(HL.Hi, 6)

ExtendedOpcode0xF5<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(HL.Lo, 6)

ExtendedOpcode0xF6<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT_MEMORY(HL.GetReg(), 6)

ExtendedOpcode0xF7<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(AF.Hi, 6)

ExtendedOpcode0xF8<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(BC.Hi, 7)

ExtendedOpcode0xF9<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(BC.Lo, 7)

ExtendedOpcode0xFA<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(DE.Hi, 7)

ExtendedOpcode0xFB<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(DE.Lo, 7)

ExtendedOpcode0xFC<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(HL.Hi, 7)

ExtendedOpcode0xFD<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(HL.Lo, 7)

ExtendedOpcode0xFE<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT_MEMORY(HL.GetReg(), 7)

ExtendedOpcode0xFF<internal>(Emulator:emulator):void=
    EmulatorCPU:cpu = Emulator.CPU
    using { EmulatorCPU }
    Emulator.CPU_SET_BIT(AF.Hi, 7)