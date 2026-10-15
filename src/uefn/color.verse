using { /Verse.org }

color <internal> := Colors.color

PackColor<public>(Color:color):float=
    R:int = Round[Color.R * 255] or 0
    G:int = Round[Color.G * 255] or 0
    B:int = Round[Color.B * 255] or 0
    (R * 0x10000 + G * 0x100 + B) * 1.0

ToColor<public>(R:float, G:float, B:float):Colors.color=
    Colors.color{R := R, G := G, B := B}