using { Utils }

cartridge <public> := class<final><scoped{Core}>:
    var Battery <private> : logic = false
    var DirtySave <private> : logic = false
    var MBC <private> : mbc = mbc{}
    var RamBank <private> : []int = ()
    var ROM <private> : []int = ()
    SaveEvent <private> : event() = event(){}
    var UpdatesSinceSave <private> : int = 0

    AwaitSave<public>()<suspends>:void=
        SaveEvent.Await()

    GetHeader<scoped{Core}>()<reads>:[]int=
        array{ROM.Length} + for (I := 0x134..0x14F) do ROM[I] or 0xFF

    GetLowOffset<public>()<reads>:int=
        MBC.LowOffset

    GetNumRamBanks<private>()<reads>:int=
        case (ROM[0x149] or 0x0):
            0x2 => 1
            0x3 => 4
            0x4 => 16
            0x5 => 8
            _ => 0

    GetRAM<scoped{Core}>()<reads>:[]int=
        RamBank

    GetSave<public>()<reads>:[]int=
        if (Battery?):
            RamBank
        else:
            ()

    GetTitle<public>()<decides><transacts>:string=
        var Failed:logic = false
        var Title:string = ""
        TitleEnd:int = if (Flag := ROM[0x143], Flag = 0x80 or Flag = 0xC0):
            if:
                for (Address := 0x13F..0x142):
                    Byte:int = ROM[Address]
                    Byte >= 0x30 and Byte <= 0x39 or Byte >= 0x41 and Byte <= 0x5A
            then:
                0x13E
            else:
                0x142
        else:
            0x143
        loop:
            for (Address := 0x134..TitleEnd):
                if (Byte := ROM[Address]):
                    if (Char := ToASCII[Byte]):
                        set Title += array{Char}
                    else:
                        break
                else:
                    set Failed = true
                    break
            break
        not Failed?
        Title.Length > 0
        Title

    HasROM<public>()<decides><reads>:void=
        ROM.Length > 0

    LoadROM<scoped{Core}>(InROM:[]int):void=
        if (InROM.Length < 0x150):
            return

        set ROM = InROM
        CartridgeType:int = InROM[0x147] or 0x0
        TotalRAM:int = if (CartridgeType = 0x5 or CartridgeType = 0x6):
            0x200
        else:
            GetNumRamBanks() * 0x2000
        set DirtySave = false
        set RamBank = for (I := 1..TotalRAM) do 0x0

    LoadSave<public>(Save:[]int):logic=
        if (RamBank.Length = 0 or Save.Length = 0):
            return false
        set DirtySave = false
        set RamBank = for (I := 0..RamBank.Length - 1) do Save[I] or 0x0
        return true

    LoadState<scoped{Core}>(InMBC:[]int, RAM:[]int):void=
        MBC.LoadState(InMBC)
        set DirtySave = Battery
        set RamBank = RAM
        set UpdatesSinceSave = 0

    Read<public>(Address:int)<decides><reads>:int=
        if (Address <= 0x3FFF):
            ROM[Address + GetLowOffset()]
        else if (Address <= 0x7FFF):
            ROM[Address + MBC.CachedOffset]
        else if (MBC.EnableRamBank?):
            if (MBC.RTCRegisterSelected?):
                0x0
            else:
                NewAddress:int = MBC.GetAddress(Address)
                MBC.FilterRead(RamBank[NewAddress] or 0xFF)
        else:
            0xFF

    Reset<public>():logic=
        var Banks:int = 2
        loop:
            if (Banks * 0x4000 >= ROM.Length):
                break
            set Banks *= 2
        BankMask:int = Banks - 1
        CartridgeType:int = ROM[0x147] or 0x0
        RamMask:int = Max(0, GetNumRamBanks() - 1)
        set Battery = logic{CartridgeType = 0x3 or CartridgeType = 0x6 or CartridgeType = 0x10 or CartridgeType = 0x13 or CartridgeType = 0x1B or CartridgeType = 0x1E}
        # What kinda ROM switching are we using, if any?
        set MBC = if (CartridgeType > 0x0):
            if (CartridgeType <= 0x3):
                mbc1:
                    GameBankMask := BankMask
                    Multicart := logic:
                        ROM.Length = 0x100000
                        for (Bank := 1..3, I := 0..47):
                            ROM[Bank * 0x40000 + 0x104 + I] = ROM[0x104 + I]
                    RamBankMask := RamMask
            else if (CartridgeType = 0x5 or CartridgeType = 0x6):
                mbc2{GameBankMask := BankMask, RamBankMask := RamMask}
            else if (CartridgeType >= 0xF and CartridgeType <= 0x13):
                mbc3{GameBankMask := BankMask, RamBankMask := RamMask}
            else if (CartridgeType >= 0x19 and CartridgeType <= 0x1E):
                mbc5{GameBankMask := BankMask, RamBankMask := RamMask}
            else if (ROM.Length > 0):
                return false
            else:
                mbc{}
        else:
            mbc{}
        return true

    SaveState<scoped{Core}>()<reads>:[]int=
        MBC.SaveState()

    Unload<public>():void=
        if (HasROM[]):
            set Battery = false
            set MBC = mbc{}
            set ROM = ()
            set RamBank = ()

    Update<scoped{Core}>():void=
        if (DirtySave?):
            set UpdatesSinceSave += 1
            if (UpdatesSinceSave >= 120):
                set DirtySave = false
                SaveEvent.Signal()

    Write<public>(Address:int, Data:int):void=
        if (Address <= 0x7FFF):
            Before:logic = MBC.EnableRamBank
            MBC.Write(Address, Data)
            if (Before? and DirtySave? and not MBC.EnableRamBank?):
                set DirtySave = false
                SaveEvent.Signal()
        else if (MBC.EnableRamBank?, not MBC.RTCRegisterSelected?):
            NewAddress:int = MBC.GetAddress(Address)
            NewData:int = MBC.FilterWrite(Data)
            if:
                Old := RamBank[NewAddress]
                Old <> NewData
                set RamBank[NewAddress] = NewData
            then if (Battery?):
                set DirtySave = true
                set UpdatesSinceSave = 0