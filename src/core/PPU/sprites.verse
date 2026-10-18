using { Core }
using { Utils }

(InPPU:ppu).RenderSprites<internal>(LCDC:int):void=
    # Let's draw the sprites (however it does need to be enabled)
    if:
        BitAnd(LCDC, 0x2) <> 0
        Emulator := InPPU.MaybeEmulator?
        Scanline := Emulator.Memory[0xFF44]
    then:
        Use8x16:logic = logic{BitAnd(LCDC, 0x4) <> 0}
        YSize:int = Use8x16? and 16 or 8
        if (InPPU.LineSprites.Length > 0):
            var Claimed:[]int = BlankRow
            for (Key : InPPU.LineSprites):
                if:
                    Sprite := Mod[Key, 64]
                    Base:int = 0xFE00 + Sprite * 4
                    Attributes := Emulator.Memory[Base + 3]
                    TileNumber := Emulator.Memory[Base + 2]
                    X := Emulator.Memory[Base + 1]
                    Y := Emulator.Memory[Base]
                then:
                    BehindBackground:logic = logic{BitAnd(Attributes, 0x80) <> 0}
                    FlipX:logic = logic{BitAnd(Attributes, 0x20) <> 0}
                    FlipY:logic = logic{BitAnd(Attributes, 0x40) <> 0}
                    var Line:int = Scanline - (Y - 16)
                    Register:palette_register = BitAnd(Attributes, 0x10) <> 0 and palette_register.Object1 or palette_register.Object0
                    Tile:int = Use8x16? and BitAnd(TileNumber, 0xFE) or TileNumber
                    XPos:int = X - 8
                    if (FlipY?):
                        set Line = YSize - 1 - Line
                    set Line *= 2
                    if:
                        HighPlane := Emulator.Memory[0x8000 + Tile * 16 + Line + 1]
                        LowPlane := Emulator.Memory[0x8000 + Tile * 16 + Line]
                        High := InPPU.Spread[HighPlane]
                        Low := InPPU.Spread[LowPlane]
                    then:
                        Packed:int = Low + 2 * High
                        for (I := 0..7):
                            Lane:int = if (FlipX?):
                                7 - I
                            else:
                                I
                            Pixel:int = XPos + I
                            if:
                                Pixel >= 0
                                Pixel <= 159
                                Claimed[Pixel] = 0
                                Divisor := Pow4[Lane]
                                ColorNum := Mod[Quotient[Packed, Divisor], 4]
                                ColorNum <> 0
                                Color := InPPU.GetColor[ColorNum, Register, Pixel]
                                set Claimed[Pixel] = 1
                            then if:
                                not BehindBackground? or InPPU.BackgroundColorNums[Pixel] = 0
                                InPPU.ScreenData[Scanline * 160 + Pixel] <> Color
                                set InPPU.ScreenData[Scanline * 160 + Pixel] = Color

(InPPU:ppu).UpdateLineSprites<internal>():void=
    var Keys:[]int = ()
    if:
        Emulator := InPPU.MaybeEmulator?
        LCDC := Emulator.Memory[0xFF40]
        BitAnd(LCDC, 0x2) <> 0
        Scanline := Emulator.Memory[0xFF44]
        Scanline < VerticalBlankScanLine
    then:
        YSize:int = BitAnd(LCDC, 0x4) <> 0 and 16 or 8
        for (Sprite := 0..39):
            Base:int = 0xFE00 + Sprite * 4
            if:
                Keys.Length < 10
                Y := Emulator.Memory[Base]
                Scanline >= Y - 16
                Scanline < Y - 16 + YSize
                X := Emulator.Memory[Base + 1]
            then:
                set Keys = Keys.InsertSorted(X * 64 + Sprite)
    set InPPU.LineSprites = Keys