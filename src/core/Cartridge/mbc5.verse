mbc5 <internal> := class<final>(mbc):
    Write<override>(Address:int, Data:int):void=
        if (Address <= 0x1FFF):
            SetRamEnabled(Data)
        else if (Address <= 0x3FFF):
            Bank:int = if (Address <= 0x2FFF):
                BitOr(BitAnd(CurrentRomBank, 0x100), BitAnd(Data, 0xFF))
            else:
                BitOr(BitAnd(CurrentRomBank, 0xFF), BitAnd(Data, 0x1) * 0x100)
            SetRomBank(Bank)
        else if (Address <= 0x5FFF):
            set CurrentRamBank = BitAnd(Data, 0xF)