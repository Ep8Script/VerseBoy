using { Utils }
using { /Verse.org/Simulation }

ToBytes<public>(Hex:string)<suspends>:?[]int=
    if (Mod[Hex.Length, 2] = 0):
        var MaybeBytes:?[]int = false
        loop:
            Output:[]int = for (I := 0..Quotient[Hex.Length, 2] - 1):
                if (I > 0 and Mod[I, 0x40000] = 0):
                    Sleep(0.0)
                if (Byte := GetByte[Hex, I]):
                    Byte
                else:
                    break
            set MaybeBytes = option{Output}
            break
        MaybeBytes
    else:
        false