mbc <internal> := class:
    var <protected> CachedOffset <final><internal> : int = 0
    var <protected> CurrentRamBank <final><protected> : int = 0
    var <private> CurrentRomBank <final><protected> : int = 1
    var <private> EnableRamBank <final><internal> : logic = false
    GameBankMask <internal> : int = 1
    var <protected> LowOffset <final><internal> : int = 0
    RamBankMask <internal> : int = 0
    var <protected> RTCRegisterSelected <final><internal> : logic = false

    FilterRead<internal>(Value:int)<reads>:int=
        Value

    FilterWrite<internal>(Value:int):int=
        Value

    GetAddress<internal>(Address:int)<reads>:int=
        BitAnd(CurrentRamBank, RamBankMask) * 0x2000 + Address - 0xA000

    LoadState<internal>(Data:[]int):void=
        LoadStateInternal(Data)

    LoadStateInternal<final><protected>(Data:[]int):void=
        if:
            Data.Length >= 6
            Offset := Data[0]
            RamBank := Data[1]
            RomBank := Data[2]
            Low := Data[4]
        then:
            set CachedOffset = Offset
            set CurrentRamBank = RamBank
            set CurrentRomBank = RomBank
            set EnableRamBank = logic{Data[3] = 1}
            set LowOffset = Low
            set RTCRegisterSelected = logic{Data[5] = 1}

    SaveState<internal>()<reads>:[]int=
        SaveStateInternal()

    SaveStateInternal<final><protected>()<reads>:[]int=
        array:
            CachedOffset
            CurrentRamBank
            CurrentRomBank
            EnableRamBank? and 1 or 0
            LowOffset
            RTCRegisterSelected? and 1 or 0

    SetRamEnabled<final><protected>(Data:int):void=
        set EnableRamBank = logic{BitAnd(Data, 0xF) = 0xA}

    SetRomBank<final><protected>(Bank:int):void=
        set CurrentRomBank = Bank
        set CachedOffset = (BitAnd(Bank, GameBankMask) - 1) * 0x4000

    Write<internal>(Address:int, Data:int):void=
        {}