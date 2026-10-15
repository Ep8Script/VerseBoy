mbc3 <internal> := class<final>(mbc):
    Write<override>(Address:int, Data:int):void=
        if (Address <= 0x1FFF):
            SetRamEnabled(Data)
        else if (Address <= 0x3FFF):
            Bank:int = BitAnd(Data, 0x7F)
            if (Bank = 0):
                SetRomBank(1)
            else:
                SetRomBank(Bank)
            set CachedOffset = (CurrentRomBank - 1) * 0x4000
        else if (Address <= 0x5FFF):
            if (Data <= 0x3):
                set CurrentRamBank = Data
                set RTCRegisterSelected = false
            else if (Data >= 0x8 and Data <= 0xC):
                set RTCRegisterSelected = true