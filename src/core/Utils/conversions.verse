ASCIITable <internal> : string = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz\{|\}~"
Base64Table <internal> : string = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
ToInt <internal> : [char]int = map:
    '0' => 0
    '1' => 1
    '2' => 2
    '3' => 3
    '4' => 4
    '5' => 5
    '6' => 6
    '7' => 7
    '8' => 8
    '9' => 9
    'A' => 10
    'B' => 11
    'C' => 12
    'D' => 13
    'E' => 14
    'F' => 15
    'a' => 10
    'b' => 11
    'c' => 12
    'd' => 13
    'e' => 14
    'f' => 15

EncodeBytes<public>(InBytes:[]int)<computes>:[]int=
    EncodeInt(InBytes.Length) + for (Byte : InBytes) do BitAnd(Byte, 0xFF)

EncodeInt<public>(Value:int)<computes>:[]int=
    Biased:int = Value + 0x80000000
    array:
        Mod[Biased, 0x100] or 0
        Mod[Quotient[Biased, 256] or 0, 0x100] or 0
        Mod[Quotient[Biased, 0x10000] or 0, 0x100] or 0
        Mod[Quotient[Biased, 0x1000000] or 0, 0x100] or 0

EncodeInts<public>(Values:[]int)<computes>:[]int=
    EncodeInt(Values.Length) + for (Value : Values, Part : EncodeInt(Value)) do Part

GetByte<public>(Hex:string, Index:int)<computes><decides>:int=
    HighNibble:int = ToInt[Hex[Index * 2]]
    LowNibble:int = ToInt[Hex[Index * 2 + 1]]
    (HighNibble * 16) + LowNibble

ToASCII<public>(Byte:int)<decides><reads>:char=
    Byte >= 32 and Byte <= 126
    ASCIITable[Byte - 32]

ToBase64<public>(Value:int)<computes>:[]char=
    if:
        Array := array:
            Base64Table[BitAnd(ShiftRight(Value, 18), 63)]
            Base64Table[BitAnd(ShiftRight(Value, 12), 63)]
            Base64Table[BitAnd(ShiftRight(Value, 6), 63)]
            Base64Table[BitAnd(Value, 63)]
    then:
        Array
    else:
        ()

ToByte<public>(Component:float)<decides><reads>:int=
    Max(0, Min(255, Round[Component * 255]))