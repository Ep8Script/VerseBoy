mbc1 <internal> := class<final>(mbc):
    var Bank1 <private> : int = 1
    var Bank2 <private> : int = 0
    Multicart <internal> : logic
    var UsingMemoryModel16_8 <private> : logic = true

    LoadState<override>(Data:[]int):void=
        LoadStateInternal(Data)
        if (Data.Length >= 9, Lower := Data[6], Upper := Data[7]):
            set Bank1 = Lower
            set Bank2 = Upper
            set UsingMemoryModel16_8 = logic{Data[8] = 1}

    SaveState<override>()<reads>:[]int=
        SaveStateInternal() + array{Bank1, Bank2, UsingMemoryModel16_8? and 1 or 0}

    Update<private>():void=
        Lower:int = BitAnd(Bank1, Multicart? and 0xF or 0x1F)
        Upper:int = Bank2 * (Multicart? and 16 or 32)
        SetRomBank(Lower + Upper)
        set CurrentRamBank = UsingMemoryModel16_8? and 0 or Bank2
        set LowOffset = UsingMemoryModel16_8? and 0 or BitAnd(Upper, GameBankMask) * 0x4000

    Write<override>(Address:int, Data:int):void=
        if (Address <= 0x1FFF):
            SetRamEnabled(Data)
        else if (Address <= 0x3FFF):
            set Bank1 = if (BitAnd(Data, 0x1F) = 0):
                1
            else:
                BitAnd(Data, 0x1F)
            Update()
        else if (Address <= 0x5FFF):
            set Bank2 = BitAnd(Data, 0x3)
            Update()
        else:
            set UsingMemoryModel16_8 = logic{BitAnd(Data, 0x1) = 0}
            Update()