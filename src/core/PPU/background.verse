using { Utils }

(InPPU:ppu).RenderBackground<internal>(LCDC:int):void=
    # Let's draw the background (however it does need to be enabled)
    if (Emulator := InPPU.MaybeEmulator?, Scanline := Emulator.Memory[0xFF44], Scanline <= 143):
        if (BitAnd(LCDC, 0x1) <> 0):
            if:
                ScrollX := Emulator.Memory[0xFF43]
                ScrollY := Emulator.Memory[0xFF42]
                WindowX := Emulator.Memory[0xFF4B] - 7
                WindowY := Emulator.Memory[0xFF4A]
                BackgroundY := BitAnd(ScrollY + Scanline, 0xFF)
                BackgroundLine := Mod[BackgroundY, 8] * 2
                BackgroundRow := Quotient[BackgroundY, 8] * 32
                WindowRow := Quotient[InPPU.WindowLine, 8] * 32
                WindowTileLine := Mod[InPPU.WindowLine, 8] * 2
            then:
                if (BitAnd(LCDC, 0x20) <> 0 and Scanline = WindowY):
                    set InPPU.WindowTriggered = true
                if (BitAnd(LCDC, 0x20) <> 0 and InPPU.WindowTriggered? and WindowX <= 159):
                    SplitX:int = Max(WindowX, 0)
                    WindowOffset:int = if (WindowX = -7):
                        7 + (Mod[ScrollX, 8] or 0)
                    else:
                        -WindowX
                    InPPU.RenderBackgroundSpan(0, SplitX - 1, Scanline, BackgroundLine, BackgroundRow, ScrollX, false)
                    InPPU.RenderBackgroundSpan(SplitX, 159, Scanline, WindowTileLine, WindowRow, WindowOffset, true)
                    set InPPU.WindowLine += 1
                else:
                    InPPU.RenderBackgroundSpan(0, 159, Scanline, BackgroundLine, BackgroundRow, ScrollX, false)
        else if (Blank := InPPU.BackgroundPalette[0]):
            for:
                Pixel := 0..159
                set InPPU.ScreenData[Scanline * 160 + Pixel] = Blank

(InPPU:ppu).RenderBackgroundPixels<internal>(Data:int, FirstPixel:int, LastPixel:int, Palette:[]int, Scanline:int, TileData:int, TileLine:int, TileRow:int, Unsigned:logic, XOffset:int):void=
    LineStart:int = Scanline * 160
    Needed:logic = InPPU.BackgroundColorNumsNeeded
    var Pixel:int = FirstPixel
    loop:
        if (Pixel > LastPixel):
            break
        XPos:int = BitAnd(Pixel + XOffset, 0xFF)
        Column:int = Quotient[XPos, 8] or 0
        Lane:int = XPos - Column * 8
        Total:int = Min(8 - Lane, LastPixel - Pixel + 1)
        if:
            Emulator := InPPU.MaybeEmulator?
            TileNum := Emulator.Memory[Column + Data + TileRow]
            TileLocation := TileData + if (Unsigned?):
                TileNum * 16
            else:
                SignedTileNum:int = TileNum > 0x7F and TileNum - 0x100 or TileNum
                (SignedTileNum + 128) * 16
            Data1 := Emulator.Memory[TileLocation + TileLine + 1]
            Data2 := Emulator.Memory[TileLocation + TileLine]
            High := InPPU.Spread[Data1]
            Low := InPPU.Spread[Data2]
            Packed := Quotient[Low + 2 * High, Pow4[Lane]]
        then:
            var Rest:int = Packed
            for (I := 0..Total - 1):
                ColorNum:int = Mod[Rest, 4] or 0
                if:
                    Color := Palette[ColorNum]
                    InPPU.ScreenData[LineStart + Pixel + I] <> Color
                    set InPPU.ScreenData[LineStart + Pixel + I] = Color
                if:
                    Needed?
                    set InPPU.BackgroundColorNums[Pixel + I] = ColorNum
                set Rest = Quotient[Rest, 4] or 0
        set Pixel += Total

(InPPU:ppu).RenderBackgroundSegment<internal>(FirstPixel:int, LastPixel:int, LCDC:int, Scanline:int, TileLine:int, TileRow:int, XOffset:int, Window:logic):void=
    Data:int = if (BitAnd(LCDC, Window? and 0x40 or 0x8) <> 0):
        0x9C00
    else:
        0x9800
    Unsigned:logic = logic{BitAnd(LCDC, 0x10) <> 0}
    TileData:int = Unsigned? and 0x8000 or 0x8800
    if (var Palette:[]int = InPPU.LinePalettes[palette_register.Background]):
        var Start:int = FirstPixel
        for (PaletteUpdate : InPPU.PaletteUpdates, PaletteUpdate.Register = palette_register.Background):
            End:int = Min(PaletteUpdate.X - 1, LastPixel)
            if (End >= Start):
                InPPU.RenderBackgroundPixels(Data, Start, End, Palette, Scanline, TileData, TileLine, TileRow, Unsigned, XOffset)
                set Start = End + 1
            set Palette = PaletteUpdate.Palette
        if (Start <= LastPixel):
            InPPU.RenderBackgroundPixels(Data, Start, LastPixel, Palette, Scanline, TileData, TileLine, TileRow, Unsigned, XOffset)

(InPPU:ppu).RenderBackgroundSpan<internal>(FirstPixel:int, LastPixel:int, Scanline:int, TileLine:int, TileRow:int, XOffset:int, Window:logic):void=
    var LCDC:int = InPPU.LineLCDControl
    var Start:int = FirstPixel
    for (LCDCUpdate : InPPU.LCDControlUpdates):
        Reach:int = LCDCUpdate.X + 6
        UpdateBoundary:int = Reach + (Mod[8 - Mod[Reach + XOffset, 8], 8] or 0)
        UpdateEnd:int = Min(UpdateBoundary - 1, LastPixel)
        if (UpdateEnd >= Start):
            InPPU.RenderBackgroundSegment(Start, UpdateEnd, LCDC, Scanline, TileLine, TileRow, XOffset, Window)
            set Start = UpdateEnd + 1
        set LCDC = LCDCUpdate.Value
    if (Start <= LastPixel):
        InPPU.RenderBackgroundSegment(Start, LastPixel, LCDC, Scanline, TileLine, TileRow, XOffset, Window)