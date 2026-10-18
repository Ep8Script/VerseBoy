using { PPU }
using { Utils }

BitmapHeader <internal> : []int = (66, 77, 70, 45, 0, 0, 0, 0, 0, 0, 70, 0, 0, 0, 40, 0, 0, 0, 160, 0, 0, 0, 144, 0, 0, 0, 1, 0, 4, 0, 0, 0, 0, 0, 0, 45, 0, 0, 19, 11, 0, 0, 19, 11, 0, 0, 4, 0, 0, 0, 4, 0, 0, 0, 255, 255, 255, 0, 170, 170, 170, 0, 85, 85, 85, 0, 0, 0, 0, 0)

gameboy <public> := interface:
    Emulator <private> : emulator = emulator{}
    var Loading <private> : ?[]int = false
    var QueuedButtons <private> : []tuple(int, logic) = ()
    var Palette <protected> : []color = DefaultPalette1
    var ReleasedButtons <private> : []int = ()
    var Saving <private> : logic = false
    var <private> Started <final><protected> : logic = false
    StateSavedEvent <private> : event([]int) = event([]int){}
    var WaitedToSave <private> : int = 0

    AwaitSave<final><public>()<suspends>:[]int=
        Emulator.Cartridge.AwaitSave()
        GetSave()

    AwaitStateSaved<final><public>()<suspends>:[]int=
        StateSavedEvent.Await()

    AwaitVerticalBlank<final><public>()<suspends>:[]int=
        Emulator.PPU.AwaitVerticalBlank()
        Emulator.PPU.ScreenData

    GetGameTitle<final><public>()<decides><transacts>:string=
        Emulator.Cartridge.GetTitle[]

    GetSave<final><public>()<reads>:[]int=
        Emulator.Cartridge.GetSave()

    HandleInput<private>():void=
        var Pressed:[]logic = for (I := 0..7) do false
        for (Button : ReleasedButtons):
            Emulator.Joypad.ButtonReleased(Button)
        set ReleasedButtons = ()
        for (Data : QueuedButtons):
            if (Data(1)?, set Pressed[Data(0)] = true):
                Emulator.Joypad.ButtonPressed(Data(0))
                set ReleasedButtons = ReleasedButtons.RemoveAllElements(Data(0))
            else if (Pressed[Data(0)]?, set Pressed[Data(0)] = false):
                set ReleasedButtons += array{Data(0)}
            else:
                Emulator.Joypad.ButtonReleased(Data(0))
        set QueuedButtons = ()

    HasROM<final><public>()<decides><reads>:void=
        Emulator.HasROM[]

    HandleStates<private>():void=
        if (Saving?):
            if (Emulator.ReadyToSave[] or WaitedToSave >= 3):
                State:emulator_state = Emulator.SaveState()
                set Saving = false
                set WaitedToSave = 0
                StateSavedEvent.Signal(State.Encode())
            else:
                set WaitedToSave += 1
                Emulator.StopAtNextVerticalBlank()
        if (StateBytes := Loading?):
            set Loading = false
            if (State := DecodeState[StateBytes]):
                Loaded:logic = Emulator.LoadState(State)
                if (Loaded?):
                    set QueuedButtons = ()
                    set ReleasedButtons = ()

    Initialize<final><public>()<transacts>:void=
        Emulator.Initialize()

    LoadROM<final><public>(ROM:[]int):logic=
        Emulator.LoadROM(ROM)

    LoadSave<final><public>(Save:[]int):logic=
        Emulator.Cartridge.LoadSave(Save)

    LoadState<final><public>(StateBytes:[]int):void=
        set Loading = option{StateBytes}

    Reset<final><public>():void=
        set QueuedButtons = ()
        set ReleasedButtons = ()
        Emulator.Reset()

    SaveState<final><public>()<suspends>:[]int=
        set Saving = true
        AwaitStateSaved()

    SetButtonPressed<final><public>(Button:int):void=
        set QueuedButtons += array{(Button, true)}

    SetButtonReleased<final><public>(Button:int):void=
        set QueuedButtons += array{(Button, false)}

    Screenshot<final><public>()<suspends>:void=
        Body:[]int = for (Index := 0..143, ByteIndex := 0..79):
            Pixel:int = (143 - Index) * 160 + ByteIndex * 2
            if (Left := Emulator.PPU.ScreenData[Pixel], Right := Emulator.PPU.ScreenData[Pixel + 1]):
                Left * 16 + Right
            else:
                0
        ColorBytes:[]int = for (Color : Palette, Byte : array{ToByte[Color.B], ToByte[Color.G], ToByte[Color.R], 0}) do Byte
        Data:[]int = if (ColorBytes.Length = 16):
            BitmapPart:[]int = for:
                I := 0..53
                Byte := BitmapHeader[I]
            BitmapPart + ColorBytes + Body
        else:
            BitmapHeader + Body
        Remainder:int = Mod[Data.Length, 3] or 0
        Padded:[]int = if (Remainder = 1):
            Data + (0, 0)
        else if (Remainder = 2):
            Data + array{0}
        else:
            Data
        Encoded:string = for:
            I := 0..Quotient[Padded.Length, 3] - 1
            B0 := Padded[I * 3]
            B1 := Padded[I * 3 + 1]
            B2 := Padded[I * 3 + 2]
            Char : ToBase64(B0 * 0x10000 + B1 * 0x100 + B2)
        Pad:int = Remainder = 0 and 0 or 3 - Remainder
        Padding:string = Pad = 2 and "==" or Pad = 1 and "=" or ""
        Trimmed:string = Encoded.Slice[0, Encoded.Length - Pad] or Encoded
        Print("data:image/bmp;base64,{Trimmed}{Padding}")

    StartEmulation<public>()<suspends>:void

    Unload<final><public>():void=
        Emulator.Cartridge.Unload()

    Update<final><protected>():void=
        if (not Started?):
            set Started = true
        HandleInput()
        HandleStates()
        Emulator.Update()