using { Cartridge }
using { CPU }
using { Joypad }
using { PPU }
using { Timer }
using { Utils }

emulator <scoped{CPU, Joypad, PPU, Timer}> := class<final>:
    var BootROM <private> : []int = ()
    (emulator:)Cartridge <final><public> : cartridge = cartridge{}
    (emulator:)CPU <final><public> : cpu = cpu{}
    var CycleBudget <private> : int = -1
    DMA <private> : dma = dma{}
    (emulator:)Joypad <final><public> : joypad = joypad{}
    var <scoped{CPU, PPU, Timer}> Memory <final><public> : []int = ()
    var <private> PendingCycles <final><scoped{PPU,Timer}> : int = 0
    (emulator:)PPU <final><public> : ppu = ppu{}
    Serial <final><public> : serial = serial{}
    var StopAtVerticalBlank <private> : logic = false
    var StoppedAtVerticalBlank <private> : logic = false
    (emulator:)Timer <final><public> : emulator_timer = emulator_timer{}
    var UnusedBits <private> : []int = ()

    AdvanceDMA<scoped{CPU}>(Cycles:int):void=
        Copy:logic = DMA.Advance(Cycles)
        if (Copy?):
            for:
                I := 0..0x9F
                Byte := ReadMemory[DMA.Source + I]
                set Memory[0xFE00 + I] = Byte

    CanLoadState<private>(State:emulator_state)<decides><reads>:void=
        Self.Cartridge.HasROM[]
        State.Cartridge.Length = Self.Cartridge.SaveState().Length
        State.CPU.Length = Self.CPU.SaveState().Length
        State.DMA.Length = DMA.SaveState().Length
        State.Header = Self.Cartridge.GetHeader()
        State.Joypad.Length = Self.Joypad.SaveState().Length
        State.Memory.Length = 0x10000
        State.PPU.Length = Self.PPU.SaveState().Length
        State.RAM.Length = Self.Cartridge.GetRAM().Length
        State.Screen.Length = 23040
        State.Serial.Length = Serial.SaveState().Length
        State.Timer.Length = Self.Timer.SaveState().Length
        State.Version = StateVersion

    FlushForRegisterWrite<scoped{PPU,Timer}>():void=
        FlushPendingCycles()
        set CycleBudget = -1

    FlushPendingCycles<scoped{Core}>():void=
        if (PendingCycles > 0):
            Skip(PendingCycles)
            set CycleBudget -= PendingCycles
            set PendingCycles = 0

    HasBootROM<public>()<decides><reads>:void=
        BootROM.Length > 0

    HasROM<public>()<decides><reads>:void=
        Self.Cartridge.HasROM[]

    Initialize<final><internal>()<transacts>:void=
        set Self.CPU.MaybeEmulator = option{Self}
        set Self.Joypad.MaybeEmulator = option{Self}
        set Self.PPU.MaybeEmulator = option{Self}
        set Self.Timer.MaybeEmulator = option{Self}
        set Serial.MaybeEmulator = option{Self}
        set UnusedBits = for (Address := 0..0x7F):
            case (Address):
                0x02 => 0x7E
                0x07 => 0xF8
                0x0F => 0xE0
                0x10 => 0x80
                0x1A => 0x7F
                0x1C => 0x9F
                0x20 => 0xC0
                0x23 => 0x3F
                0x26 => 0x70
                0x41 => 0x80
                _ => if (Address = 0x03 or Address >= 0x08 and Address <= 0x0E or Address = 0x13 or Address = 0x15 or Address = 0x18 or Address = 0x1D or Address = 0x1F or Address >= 0x27 and Address <= 0x2F or Address >= 0x4C):
                    0xFF
                else:
                    0

    LoadROM<internal>(InROM:[]int):logic=
        if (InROM.Length = 256):
            set BootROM = InROM
            return true

        if (InROM.Length < 336):
            return false

        Self.Cartridge.LoadROM(InROM)
        WasReset:logic = Reset()
        if (not WasReset?):
            Self.Cartridge.Unload()
        return WasReset

    LoadState<public>(State:emulator_state):logic=
        if (not CanLoadState[State]):
            return false
        set Memory = State.Memory
        DMA.LoadState(State.DMA)
        Self.Cartridge.LoadState(State.Cartridge, State.RAM)
        Self.CPU.LoadState(State.CPU)
        Self.Joypad.LoadState(State.Joypad)
        Self.PPU.LoadState(State.PPU, State.Screen)
        Self.Timer.LoadState(State.Timer)
        Serial.LoadState(State.Serial)
        set CycleBudget = -1
        set PendingCycles = 0
        set StopAtVerticalBlank = false
        set StoppedAtVerticalBlank = false
        return true

    ReadIF<public>(Offset:int)<decides><reads>:int=
        Flags:int = BitOr(Memory[0xFF0F], 0xE0)
        if (Self.Timer.IsOverflowPending[Offset]):
            BitOr(Flags, 0x4)
        else:
            Flags

    ReadMemory<public>(Address:int, ?Offset:int = Self.CPU.GetReadOffset())<decides><reads>:int=
        FixedAddress:int = BitAnd(Address, 0xFFFF)
        if (FixedAddress <= 0x3FFF):
            if (Self.Cartridge.GetLowOffset() > 0):
                Self.Cartridge.Read[FixedAddress] or 0xFF
            else:
                Memory[FixedAddress]
        else if (FixedAddress <= 0x7FFF):
            Self.Cartridge.Read[FixedAddress] or 0xFF
        else if (FixedAddress >= 0xC000 and FixedAddress <= 0xDFFF or FixedAddress >= 0xFF80):
            Memory[FixedAddress]
        else if (FixedAddress >= 0x8000 and FixedAddress <= 0x9FFF):
            if (BitAnd(Memory[0xFF40], 0x80) <> 0, State := Self.PPU.GetLCDState[Offset], State.BlockedVRAM?):
                0xFF
            else:
                Memory[FixedAddress]
        else if (FixedAddress >= 0xA000 and FixedAddress <= 0xBFFF):
            Self.Cartridge.Read[FixedAddress] or 0xFF
        else if (FixedAddress >= 0xE000 and FixedAddress <= 0xFDFF):
            Memory[FixedAddress - 0x2000]
        else if (FixedAddress >= 0xFE00 and FixedAddress <= 0xFE9F):
            if (DMA.IsActive[Offset, PendingCycles]):
                0xFF
            else if (BitAnd(Memory[0xFF40], 0x80) <> 0, State := Self.PPU.GetLCDState[Offset], State.BlockedOAM?):
                0xFF
            else:
                Memory[FixedAddress]
        else if (FixedAddress = 0xFF00):
            Self.Joypad.GetState[]
        else if (FixedAddress > 0xFF00 and FixedAddress <= 0xFF7F):
            if (FixedAddress = 0xFF04):
                Self.Timer.ReadDIV[Offset]
            else if (FixedAddress = 0xFF05):
                Self.Timer.ReadTIMA[Offset]
            else if (FixedAddress = 0xFF0F):
                ReadIF[Offset]
            else if (FixedAddress = 0xFF41):
                Self.PPU.ReadStatus[Offset]
            else if (FixedAddress = 0xFF44):
                if (BitAnd(Memory[0xFF40], 0x80) <> 0, State := Self.PPU.GetLCDState[Offset]):
                    State.Line
                else:
                    Memory[FixedAddress]
            else:
                BitOr(Memory[FixedAddress], UnusedBits[FixedAddress - 0xFF00])
        else:
            Memory[FixedAddress]

    ReadyToSave<public>()<decides><reads>:void=
        BitAnd(Memory[0xFF40], 0x80) = 0 or StoppedAtVerticalBlank?

    RequestInterrupt<public>(Interrupt:interrupt):void=
        Bit:int = case (Interrupt):
            interrupt.VBlank => 0
            interrupt.LCDStat => 1
            interrupt.Timer => 2
            interrupt.Serial => 3
            interrupt.Joypad => 4
        if:
            RequestFlag := Memory[0xFF0F]
            set Memory[0xFF0F] = BitSet(RequestFlag, Bit)

    Reset<public>():logic=
        CartridgeReset:logic = Self.Cartridge.Reset()
        if (not CartridgeReset?):
            return false
        set Memory = for (I := 0..0xFFFF) do I < 0x8000 and (Self.Cartridge.Read[I] or 0xFF) or 0x0
        if (BootROM.Length > 0, set Memory[0xFF00] = 0xFF):
            for:
                I->Byte : BootROM
                set Memory[I] = Byte
        else if:
            set Memory[0xFF00] = 0xCF
            set Memory[0xFF04] = 0xAB
            set Memory[0xFF0F] = 0x1
            set Memory[0xFF10] = 0x80
            set Memory[0xFF11] = 0xBF
            set Memory[0xFF12] = 0xF3
            set Memory[0xFF14] = 0xBF
            set Memory[0xFF16] = 0x3F
            set Memory[0xFF19] = 0xBF
            set Memory[0xFF1A] = 0x7F
            set Memory[0xFF1B] = 0xFF
            set Memory[0xFF1C] = 0x9F
            set Memory[0xFF1E] = 0xBF
            set Memory[0xFF20] = 0xFF
            set Memory[0xFF23] = 0xBF
            set Memory[0xFF24] = 0x77
            set Memory[0xFF25] = 0xF3
            set Memory[0xFF26] = 0xF1
            set Memory[0xFF40] = 0x91
            set Memory[0xFF47] = 0xFC
            set Memory[0xFF48] = 0xFF
            set Memory[0xFF49] = 0xFF
        DMA.Reset()
        Self.CPU.Reset()
        Self.Joypad.Reset()
        Self.PPU.Reset()
        Self.Timer.Reset()
        Serial.Reset()
        set CycleBudget = -1
        set PendingCycles = 0
        return true

    SaveState<public>():emulator_state=
        FlushPendingCycles()
        set StopAtVerticalBlank = false
        set StoppedAtVerticalBlank = false
        emulator_state:
            Cartridge := Self.Cartridge.SaveState()
            CPU := Self.CPU.SaveState()
            DMA := DMA.SaveState()
            Header := Self.Cartridge.GetHeader()
            Joypad := Self.Joypad.SaveState()
            Memory := Memory
            PPU := Self.PPU.SaveState()
            RAM := Self.Cartridge.GetRAM()
            Screen := Self.PPU.ScreenData
            Serial := Serial.SaveState()
            Timer := Self.Timer.SaveState()
            Version := StateVersion

    Skip<private>(Cycles:int):void=
        AdvanceDMA(Cycles)
        Self.PPU.Skip(Cycles)
        Self.Timer.Skip(Cycles)
        Serial.Skip(Cycles)

    SkipHaltedCycles<public>():void=
        if:
            not Self.CPU.PendingInterruptEnabled?
            BitAnd(BitAnd(Memory[0xFFFF], Memory[0xFF0F]), 0x1F) = 0
        then:
            FlushPendingCycles()
            UpdateCycleBudget()
            if:
                FrameSteps := Quotient[CyclesPerFrame - Self.CPU.CyclesThisUpdate + 3, 4]
                Steps := Min(FrameSteps, Quotient[CycleBudget, 4])
                Steps >= 1
            then:
                Cycles:int = Steps * 4
                Skip(Cycles)
                set Self.CPU.CyclesThisUpdate += Cycles
                UpdateCycleBudget()

    StopAtNextVerticalBlank<public>():void=
        set StopAtVerticalBlank = true

    Update<public>():void=
        if (not HasROM[]):
            return
        loop:
            if (Self.CPU.CyclesThisUpdate >= CyclesPerFrame):
                break

            if (Self.CPU.Halted?):
                SkipHaltedCycles()
                if (Self.CPU.CyclesThisUpdate >= CyclesPerFrame):
                    break

            CurrentCycle:int = Self.CPU.CyclesThisUpdate
            Self.CPU.Update(Self)
            Cycles:int = Self.CPU.CyclesThisUpdate - CurrentCycle
            Update(Cycles)
            if (Memory[0xFF0F] > 0):
                BeforeInterrupts:int = Self.CPU.CyclesThisUpdate
                Self.CPU.DoInterrupts()
                InterruptCycles:int = Self.CPU.CyclesThisUpdate - BeforeInterrupts
                if (InterruptCycles > 0):
                    Update(InterruptCycles)
            if (Self.PPU.GetVerticalBlank[]):
                if (StopAtVerticalBlank?):
                    set StopAtVerticalBlank = false
                    set StoppedAtVerticalBlank = true
                    return
        Self.Cartridge.Update()
        Self.PPU.Update()
        set Self.CPU.CyclesThisUpdate -= CyclesPerFrame

    Update<private>(Cycles:int):void=
        if (PendingCycles + Cycles <= CycleBudget):
            set PendingCycles += Cycles
        else:
            FlushPendingCycles()
            AdvanceDMA(Cycles)
            Serial.Update(Cycles)
            Self.Timer.Update(Cycles)
            Self.PPU.Update(Cycles)
            UpdateCycleBudget()

    UpdateCycleBudget<scoped{Core}>():void=
        set CycleBudget = -1
        if:
            PPUBudget := Self.PPU.GetBudget[]
            TimerBudget := Self.Timer.GetBudget[]
            TotalBudget := Min(Min(Serial.GetBudget(), PPUBudget), TimerBudget)
            TotalBudget >= 0
        then:
            set CycleBudget = TotalBudget

    # Writes a byte to memory. Remember that address 0 - 07FFF is ROM so we can't write to this address
    WriteByte<public>(Address:int, Data:int, ?Offset:int = Self.CPU.GetWriteOffset()):void=
        if (Address >= 0xC000 and Address <= 0xDFFF or Address >= 0xFF80, set Memory[Address] = Data):
            return
        if (Address <= 0x7FFF):
            Self.Cartridge.Write(Address, Data)
        else if (Address >= 0x8000 and Address <= 0x9FFF):
            if:
                BitAnd(Memory[0xFF40], 0x80) = 0 or not Self.PPU.GetLCDState[Offset].BlockedWriteVRAM?
                set Memory[Address] = Data
        # From now on we're writing to RAM
        else if (Address >= 0xA000 and Address <= 0xBFFF):
            Self.Cartridge.Write(Address, Data)
        # Echo memory. Writes here into the internal RAM. Same as above
        else if (Address >= 0xE000 and Address <= 0xFDFF):
            if:
                set Memory[Address] = Data
                set Memory[Address - 0x2000] = Data # Echo data into RAM address
        else if (Address >= 0xFE00 and Address <= 0xFE9F):
            if:
                not Self.DMA.IsActive[Offset, PendingCycles]
                BitAnd(Memory[0xFF40], 0x80) = 0 or not Self.PPU.GetLCDState[Offset].BlockedWriteOAM?
                set Memory[Address] = Data
        # This area is restricted
        else if:
            Address >= 0xFEA0
            Address <= 0xFEFF
        else if (Address = 0xFF02):
            Serial.Write(Data, Offset)
        else if (Address = 0xFF04 or Address = 0xFF05 or Address = 0xFF07):
            Self.Timer.Write(Address, Data, Offset)
        else if (Address = 0xFF40 or Address = 0xFF41 or Address = 0xFF44 or Address = 0xFF45 or Address >= 0xFF47 and Address <= 0xFF49):
            Self.PPU.Write(Address, Data, Offset)
        else if (Address = 0xFF50):
            if (Data <> 0):
                for:
                    I := 0..255
                    Byte := Self.Cartridge.Read[I]
                    set Memory[I] = Byte
        # DMA transfer
        else if (Address = 0xFF46, set Memory[0xFF46] = Data):
            Self.FlushForRegisterWrite()
            DMA.Start(Data, Offset)
        # This area is restricted
        else if (Address >= 0xFF4C and Address <= 0xFF7F):
        # I guess we're ok to write to memory... gulp
        else if:
            set Memory[Address] = Data