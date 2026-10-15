Main<internal>(Args:[]string, Env:[string]string)<suspends>:void=
    BootResult:result(string, io_error) = LoadTextFile("boot.gb")
    Gameboy:standalone_gameboy = standalone_gameboy{}
    Gameboy.Initialize()
    Print("Usage: verse verseboy.verse | py verseboy.py")
    if (Boot := BootResult.GetSuccess[]):
        BootROM := for:
            Char : Boot
            ByteMap[Char]
        Gameboy.LoadROM(BootROM)
        Print("Loaded boot.gb!")
    else:
        BootstrapResult:result(string, io_error) = LoadTextFile("bootstrap.gb")
        if (Bootstrap := BootstrapResult.GetSuccess[]):
            BootstrapROM := for:
                Char : Bootstrap
                ByteMap[Char]
            Gameboy.LoadROM(BootstrapROM)
            Print("Loaded bootstrap.gb!")
        else:
            BinResult:result(string, io_error) = LoadTextFile("dmg_boot.bin")
            if (Bin := BinResult.GetSuccess[]):
                BinROM := for:
                    Char : Bin
                    ByteMap[Char]
                Gameboy.LoadROM(BinROM)
                Print("Loaded dmg_boot.bin!")
    Gameboy.StartEmulation()