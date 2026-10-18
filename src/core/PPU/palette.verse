using { Core }
using { Utils }

DefaultPalette1 <public> : []color = (color{R := 1.0, G := 1.0, B := 1.0}, color{R := 204.0 / 255.0, G := 204.0 / 255.0, B := 204.0 / 255.0}, color{R := 119.0 / 255.0, G := 119.0 / 255.0, B := 119.0 / 255.0}, color{})
DefaultPalette2 <public> : []color = (color{R := 154.0 / 255.0, G := 158.0 / 255.0, B := 63.0 / 255.0}, color{R := 73.0 / 255.0, G := 107.0 / 255.0, B := 34.0 / 255.0}, color{R := 14.0 / 255.0, G := 69.0 / 255.0, B := 11.0 / 255.0}, color{R := 27.0 / 255.0, G := 42.0 / 255.0, B := 9.0 / 255.0})

palette_register <internal> := enum:
    Background
    Object0
    Object1

palette_update <internal> := struct<computes>:
    Palette <public> : []int
    Register <public> : palette_register
    X <public> : int

DecodePalette<internal>(Palette:int)<computes>:[]int=
    for (ColorNum := 0..3):
        BitAnd(ShiftRightByte(Palette, ColorNum * 2), 0x3)

(InPPU:ppu).GetColor<internal>(ColorNum:int, Register:palette_register, X:int)<decides><transacts>:int=
    var Palette:[]int = InPPU.LinePalettes[Register]
    for (PaletteUpdate : InPPU.PaletteUpdates, PaletteUpdate.Register = Register and PaletteUpdate.X <= X):
        set Palette = PaletteUpdate.Palette
    Palette[ColorNum]

(InPPU:ppu).UpdatePalette<internal>(Offset:int, Palette:[]int, Register:palette_register):void=
    if (Emulator := InPPU.MaybeEmulator?, BitAnd(Emulator.Memory[0xFF40], 0x80) <> 0):
        Dot:int = RetraceStart - (InPPU.RetraceLY - Emulator.PendingCycles - Offset)
        set InPPU.PaletteUpdates += array:
            palette_update:
                Palette := Palette
                Register := Register
                X := InPPU.GetPixel(Dot)
    else if:
        set InPPU.LinePalettes[Register] = Palette