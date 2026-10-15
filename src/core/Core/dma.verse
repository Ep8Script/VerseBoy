using { Utils }

dma <internal> := class<final>:
    var Cycles <private> : int = 0
    var Restarted <private> : logic = false
    var <private> Source <final><internal> : int = 0

    Advance<internal>(TotalCycles:int):logic=
        if (Cycles > 0):
            Before:int = Cycles
            set Cycles = Max(0, Cycles - TotalCycles)
            if (Before > 640 and Cycles <= 640):
                set Restarted = false
                return true
        return false

    IsActive<internal>(Offset:int, PendingCycles:int)<decides><reads>:void=
        Left:int = Cycles - PendingCycles - Offset
        Left > 0
        Left <= 640 or Restarted?

    LoadState<internal>(Data:[]int):void=
        if (Data.Length = 3, LoadedCycles := Data[0], LoadedSource := Data[2]):
            set Cycles = LoadedCycles
            set Restarted = logic{Data[1] = 1}
            set Source = LoadedSource

    SaveState<internal>()<reads>:[]int=
        array:
            Cycles
            Restarted? and 1 or 0
            Source

    Reset<internal>():void=
        set Cycles = 0

    Start<internal>(Data:int, Offset:int):void=
        NewData:int = Data >= 0xE0 and Data - 0x20 or Data
        set Restarted = logic{Cycles - Offset > 0 and Cycles - Offset <= 640}
        set Cycles = Offset + 648
        set Source = ShiftLeftWord(NewData, 8)