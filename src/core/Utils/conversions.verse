ASCIITable <internal> : string = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz\{|\}~"
Base64Table <internal> : string = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
ToInt <internal> : [char]int = map:
    '0' => 0x0
    '1' => 0x1
    '2' => 0x2
    '3' => 0x3
    '4' => 0x4
    '5' => 0x5
    '6' => 0x6
    '7' => 0x7
    '8' => 0x8
    '9' => 0x9
    'A' => 0xA
    'a' => 0xa
    'B' => 0xB
    'b' => 0xb
    'C' => 0xC
    'c' => 0xc
    'D' => 0xD
    'd' => 0xd
    'E' => 0xE
    'e' => 0xe
    'F' => 0xF
    'f' => 0xf

EncodeBytes<public>(InBytes:[]int)<computes>:[]int=
    EncodeInt(InBytes.Length) + for (Byte : InBytes) do BitAnd(Byte, 0xFF)

EncodeInt<public>(Value:int)<computes>:[]int=
    Biased:int = Value + 0x80000000
    array:
        Mod[Biased, 0x100] or 0
        Mod[Quotient[Biased, 0x100] or 0, 0x100] or 0
        Mod[Quotient[Biased, 0x10000] or 0, 0x100] or 0
        Mod[Quotient[Biased, 0x1000000] or 0, 0x100] or 0

EncodeInts<public>(Values:[]int)<computes>:[]int=
    EncodeInt(Values.Length) + for (Value : Values, Part : EncodeInt(Value)) do Part

GetByte<public>(Hex:string, Index:int)<computes><decides>:int=
    HighNibble:int = ToInt[Hex[Index * 2]]
    LowNibble:int = ToInt[Hex[Index * 2 + 1]]
    (HighNibble * 16) + LowNibble

ToASCII<public>(Byte:int)<decides><reads>:char=
    Byte >= 0x20 and Byte <= 0x7E
    ASCIITable[Byte - 0x20]

ToBase64<public>(Value:int)<computes>:[]char=
    if:
        Array := array:
            Base64Table[BitAnd(ShiftRight(Value, 0x12), 0x3F)]
            Base64Table[BitAnd(ShiftRight(Value, 0xC), 0x3F)]
            Base64Table[BitAnd(ShiftRight(Value, 0x6), 0x3F)]
            Base64Table[BitAnd(Value, 0x3F)]
    then:
        Array
    else:
        ()

ToByte<public>(Component:float)<decides><reads>:int=
    Max(0, Min(255, Round[Component * 255]))