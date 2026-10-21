register <internal> := class<final>:
    Hi <final><internal> : reference(int) = reference(int){Value := 0}
    Lo <final><internal> : reference(int) = reference(int){Value := 0}

    GetReg<internal>()<reads>:int=
        return Hi.Value * 0x100 + Lo.Value

    SetReg<internal>(Value:int)<transacts>:void=
        Word:int = BitAnd(Value, 0xFFFF)
        set Hi.Value = Quotient[Word, 0x100] or 0
        set Lo.Value = BitAnd(Word, 0xFF)