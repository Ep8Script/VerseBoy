BitMasks <internal> : []int = (0x1, 0x2, 0x4, 0x8, 0x10, 0x20, 0x40, 0x80, 0x100, 0x200, 0x400, 0x800, 0x1000, 0x2000, 0x4000, 0x8000, 0x10000, 0x20000, 0x40000)
Pow4 <public> : []int = (0x1, 0x4, 0x10, 0x40, 0x100, 0x400, 0x1000, 0x4000, 0x10000, 0x40000, 0x100000, 0x400000)

BitReset<public>(Number:int, Position:int)<computes>:int=
    Mask:int = BitMasks[Position] or 0
    BitAnd(Number, BitNot(Mask))

BitSet<public>(Byte:int, Position:int)<computes>:int=
    Mask:int = BitMasks[Position] or 0
    Result:int = BitOr(Byte, Mask)
    BitAnd(Result, 0xFF)

ShiftLeft<public>(Number:int, Shift:int)<computes>:int=
    if (Shift <= 0):
        Number
    else:
        Number * BitMasks[Shift] or 0

ShiftLeftByte<public>(Byte:int, Shift:int)<computes>:int=
    if (Shift <= 0):
        Byte
    else:
        BitAnd(ShiftLeft(Byte, Shift), 0xFF)

ShiftLeftWord<public>(InWord:int, Shift:int)<computes>:int=
    if (Shift <= 0):
        InWord
    else:
        BitAnd(ShiftLeft(InWord, Shift), 0xFFFF)

ShiftRight<public>(Number:int, Shift:int)<computes>:int=
    if (Shift <= 0):
        Number
    else if (Shift >= BitMasks.Length):
        0
    else:
        Quotient[Number, BitMasks[Shift] or 1] or 0

ShiftRightByte<public>(Byte:int, Shift:int)<computes>:int=
    ShiftRight(BitAnd(Byte, 0xFF), Shift)

ShiftRightWord<public>(InWord:int, Shift:int)<computes>:int=
    ShiftRight(BitAnd(InWord, 0xFFFF), Shift)

SpreadBits<public>(Byte:int, Lane:int)<computes>:int=
    if (Lane > 7):
        0x0
    else:
        Bit:int = Mod[Quotient[Byte, BitMasks[7 - Lane] or 1], 2] or 0
        Bit * (Pow4[Lane] or 1) + SpreadBits(Byte, Lane + 1)

TestBit<public>(Data:int, Position:int)<computes><decides>:void=
    Mask:int = BitMasks[Position] or 0
    BitAnd(Data, Mask) <> 0