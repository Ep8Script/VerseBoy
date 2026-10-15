mbc2 <internal> := class<final>(mbc):
    FilterRead<override>(Value:int)<reads>:int=
        BitOr(0xF0, BitAnd(Value, 0xF))

    FilterWrite<override>(Value:int):int=
        BitAnd(Value, 0xF)

    GetAddress<override>(Address:int)<reads>:int=
        BitAnd(Address, 0x1FF)

    Write<override>(Address:int, Data:int):void=
        if (Address <= 0x3FFF):
            if (BitAnd(Address, 0x100) <> 0):
                Bank:int = BitAnd(Data, 0xF)
                SetRomBank(Bank = 0 and 1 or Bank)
            else:
                SetRamEnabled(Data)