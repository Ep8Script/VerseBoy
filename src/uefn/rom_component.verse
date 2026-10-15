using { Utils }
using { /Verse.org/SceneGraph }
using { /Verse.org/Simulation }

rom_component <public> := class<final><final_super>(component):
    @editable
    Data <private> : string = ""

    @editable
    Save <private> : string = ""

    GetByte<private>(Address:int)<computes><decides>:int=
        GetByte[Data, Address]

    GetROM<public>()<suspends>:?[]int=
        ToBytes(Data)

    GetSave<public>()<suspends>:?[]int=
        ToBytes(Save)

    GetTitle<public>()<decides><transacts>:string=
        var Failed:logic = false
        var Title:string = ""
        TitleEnd:int = if (Flag := GetByte[0x143], Flag = 0x80 or Flag = 0xC0):
            if:
                for (Address := 0x13F..0x142):
                    Byte:int = GetByte[Address]
                    Byte >= 48 and Byte <= 57 or Byte >= 65 and Byte <= 90
            then:
                0x13E
            else:
                0x142
        else:
            0x143
        loop:
            for (Address := 0x134..TitleEnd):
                if (Byte := GetByte[Address]):
                    if (Char := ToASCII[Byte], Char <> ' ' or Title.Length > 0):
                        set Title += array{Char}
                    else:
                        break
                else:
                    set Failed = true
                    break
            break
        not Failed?
        Title.Length > 0
        Title