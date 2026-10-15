using { Core }
using { PPU }
using { /UnrealEngine.com/JSON }

STATE_FILE <internal> : string = "state.json"

standalone_gameboy <internal> := class<final>(gameboy):
    var CurrentPalette <private> : int = 1
    var GameLoaded <private> : logic = false
    var HeldButtons <private> : []int = ()
    var Palette <final><override> : []color = DEFAULT_PALETTE_1
    var Paused <private> : logic = false
    var PendingROM <private> : ?string = false
    var SavePath <private> : string = ""
    var Stopped <private> : logic = false

    AwaitFilePath<private>()<suspends>:string=
        loop:
            HandleState()
            if (Path := PendingROM?):
                set PendingROM = false
                return Path

    AwaitSaveState<private>(Path:string)<suspends>:void=
        SaveStateBytes:[]int = SaveState()
        SaveStateString:string = for:
            Byte : SaveStateBytes
            Bytes[Byte]
        SaveTextFile(Path, SaveStateString)

    FlushSave<private>()<suspends>:void=
        SaveBytes:[]int = GetSave()
        if (SaveBytes.Length > 0, SavePath.Length > 0):
            Save:string = for:
                Byte : SaveBytes
                Bytes[Byte]
            SaveTextFile(SavePath, Save)

    GetSavePath<private>(Path:string)<transacts>:string =
        Extension:string = ".sav"
        if (Path.Length >= 4, Path.Slice[Path.Length - 4, Path.Length] = Extension):
            return Path + ".sav"

        var MaybeDotIndex:?int = false
        for (Index := 0..Path.Length - 1, Path[Index] = '.'):
            set MaybeDotIndex = option{Index}
        if (DotIndex := MaybeDotIndex?, NamePath := Path.Slice[0, DotIndex]):
            return NamePath + ".sav"
        return Path + ".sav"

    HandleState<private>()<suspends>:void=
        Result:result(string, io_error) = LoadTextFile(STATE_FILE)
        if (State := Parse[Result.GetSuccess[]].AsObject[]):
            if (Inputs := State["inputs"].AsArray[]):
                Buttons:[]int = for (Value : Inputs, Button := Value.AsInt[]) do Button
                for (Button : HeldButtons, not Buttons.Find[Button]):
                    SetButtonReleased(Button)
                for (Button : Buttons, not HeldButtons.Find[Button]):
                    SetButtonPressed(Button)
                set HeldButtons = Buttons
            if (NewPalette := State["palette"].AsInt[]):
                if (CurrentPalette <> NewPalette):
                    if (NewPalette = 1):
                        set CurrentPalette = 1
                        set Palette = DEFAULT_PALETTE_1
                        if (GameLoaded? and Paused?):
                            Screenshot()
                    else if (NewPalette = 2):
                        set CurrentPalette = 2
                        set Palette = DEFAULT_PALETTE_2
                        if (GameLoaded? and Paused?):
                            Screenshot()
            if (Action := State["action"].AsString[]):
                SaveTextFile(STATE_FILE, "\{\"inputs\": [{Join(for (Button : HeldButtons) do "{Button}", ",")}], \"palette\": {CurrentPalette}\}")
                case (Action):
                    "exit" =>
                        FlushSave()
                        Exit()
                    "load" => if (Path := State["file"].AsString[], GameLoaded?):
                        SaveStateResult:result(string, io_error) = LoadTextFile(Path)
                        if (SaveStateString := SaveStateResult.GetSuccess[]):
                            SaveStateBytes:[]int = for:
                                Char : SaveStateString
                                ByteMap[Char]
                            LoadState(SaveStateBytes)
                    "pause" => set Paused = true
                    "play" => set Paused = false
                    "reset" => if (GameLoaded?):
                        Reset()
                        set HeldButtons = ()
                        set Paused = false
                    "rom" => if (Path := State["file"].AsString[]):
                        set PendingROM = option{Path}
                    "save" => if (Path := State["file"].AsString[], GameLoaded?):
                        spawn {AwaitSaveState(Path)}
                    "screenshot" => if (GameLoaded?):
                        Print("Screenshot:")
                        Screenshot()
                    "stop" => if (GameLoaded?):
                        set Stopped = true
                    _ => {}

    LoadGame<private>(Path:string)<suspends>:logic=
        Result:result(string, io_error) = LoadTextFile(Path)
        if (File := Result.GetSuccess[]):
            ROM:[]int = for:
                Char : File
                ByteMap[Char]
            Success:logic = LoadROM(ROM)
            if (Success?):
                set GameLoaded = true
                set SavePath = GetSavePath(Path)
                SaveResult:result(string, io_error) = LoadTextFile(SavePath)
                if (Save := SaveResult.GetSuccess[]):
                    SaveBytes:[]int = for:
                        Char : Save
                        ByteMap[Char]
                    LoadSave(SaveBytes)
                return true
        return false

    PrintStart<private>()<suspends>:void=
        if (Title := GetGameTitle[]):
            Print("Starting Game: {Title}")
        else:
            Print("Starting Game")

    StartEmulation<override>()<suspends>:void=
        sync:
            loop:
                AwaitVerticalBlank()
                Screenshot()
            loop:
                SaveBytes:[]int = AwaitSave()
                if (SavePath.Length > 0):
                    Save:string = for:
                        Byte : SaveBytes
                        Bytes[Byte]
                    SaveTextFile(SavePath, Save)
            loop:
                Path:string = AwaitFilePath()
                Loaded:logic = LoadGame(Path)
                if (Loaded?):
                    PrintStart()
                    loop:
                        HandleState()
                        if (File := PendingROM?):
                            FlushSave()
                            set PendingROM = false
                            NewLoaded:logic = LoadGame(File)
                            if (NewLoaded?):
                                PrintStart()
                                set HeldButtons = ()
                                set Paused = false
                            else:
                                Print("Failed to load ROM.")
                                break
                        if (Stopped?):
                            FlushSave()
                            break
                        if (not Paused?):
                            Update()
                    set GameLoaded = false
                    set HeldButtons = ()
                    set Paused = false
                    set Stopped = false
                    Unload()
                else:
                    Print("Failed to load ROM.")