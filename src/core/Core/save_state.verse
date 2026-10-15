using { Utils }

STATE_VERSION <public> : int = 1

DecodeState<public>(InBytes:[]int)<decides><transacts>:emulator_state=
    Reader := state_reader{Bytes := InBytes}
    Version := Reader.ReadInt[]
    Version = STATE_VERSION
    CartridgeValues := Reader.ReadInts[]
    CPUValues := Reader.ReadInts[]
    DMAValues := Reader.ReadInts[]
    HeaderValues := Reader.ReadInts[]
    JoypadValues := Reader.ReadInts[]
    MemoryValues := Reader.ReadBytes[]
    PPUValues := Reader.ReadInts[]
    RAMValues := Reader.ReadBytes[]
    ScreenValues := Reader.ReadBytes[]
    SerialValues := Reader.ReadInts[]
    TimerValues := Reader.ReadInts[]
    InBytes.Length = Reader.Position
    emulator_state:
        Cartridge := CartridgeValues
        CPU := CPUValues
        DMA := DMAValues
        Header := HeaderValues
        Joypad := JoypadValues
        Memory := MemoryValues
        PPU := PPUValues
        RAM := RAMValues
        Screen := ScreenValues
        Serial := SerialValues
        Timer := TimerValues
        Version := Version

emulator_state <public> := struct<computes>:
    (emulator_state:)Cartridge <public> : []int
    (emulator_state:)CPU <public> : []int
    DMA <public> : []int
    Header <public> : []int
    (emulator_state:)Joypad <public> : []int
    Memory <public> : []int
    (emulator_state:)PPU <public> : []int
    RAM <public> : []int
    Screen <public> : []int
    Serial <public> : []int
    (emulator_state:)Timer <public> : []int
    Version <public> : int

(State:emulator_state).Encode<public>()<computes>:[]int=
    EncodeInt(State.Version) + EncodeInts(State.Cartridge) + EncodeInts(State.CPU) + EncodeInts(State.DMA) + EncodeInts(State.Header) + EncodeInts(State.Joypad) + EncodeBytes(State.Memory) + EncodeInts(State.PPU) + EncodeBytes(State.RAM) + EncodeBytes(State.Screen) + EncodeInts(State.Serial) + EncodeInts(State.Timer)

state_reader <internal> := class:
    (state_reader:)Bytes <internal> : []int
    var <private> Position <final><internal> : int = 0

    ReadBytes<internal>()<decides><transacts>:[]int=
        Count:int = ReadInt[]
        Count >= 0
        Count <= Self.Bytes.Length - Position
        Sliced:[]int = Self.Bytes.Slice[Position, Position + Count]
        set Position += Count
        Sliced

    ReadInt<internal>()<decides><transacts>:int=
        Byte0:int = Self.Bytes[Position]
        Byte1:int = Self.Bytes[Position + 1]
        Byte2:int = Self.Bytes[Position + 2]
        Byte3:int = Self.Bytes[Position + 3]
        set Position += 4
        Byte0 + Byte1 * 0x100 + Byte2 * 0x10000 + Byte3 * 0x1000000 - 0x80000000

    ReadInts<internal>()<decides><transacts>:[]int=
        Count:int = ReadInt[]
        Count >= 0
        Count * 4 <= Self.Bytes.Length - Position
        for (I := 1..Count):
            ReadInt[]