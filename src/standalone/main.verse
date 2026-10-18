BootROMs:[]string = ("[BIOS] Nintendo Game Boy Boot ROM (World).gb", "boot.gb", "bootstrap.gb", "dmg_boot.bin", "dmg0_boot.bin", "gb_bios.bin", "mgb_boot.bin")

Main<internal>(Args:[]string, Env:[string]string)<suspends>:void=
    BootResult:result(string, io_error) = LoadTextFile("boot.gb")
    Gameboy:standalone_gameboy = standalone_gameboy{}
    Gameboy.Initialize()
    Print("Usage: verse verseboy.verse | py verseboy.py")
    loop:
        for (File : BootROMs):
            Result:result(string, io_error) = LoadTextFile(File)
            if (String := Result.GetSuccess[]):
                BootROM:[]int = for:
                    Char : String
                    ByteMap[Char]
                Gameboy.LoadROM(BootROM)
                Print("Loaded {File}!")
                break
        break
    Gameboy.StartEmulation()