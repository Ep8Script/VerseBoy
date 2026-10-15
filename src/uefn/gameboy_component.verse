using { Core }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Fortnite.com/Input }
using { /Fortnite.com/Playspaces }
using { Joypad }
using { Materials }
using { PPU }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { Utils }
using { /Verse.org/Assets }
using { /Verse.org/Colors/NamedColors }
using { /Verse.org/Input }
using { /Verse.org/SceneGraph }
using { /Verse.org/Simulation }

gameboy_component <public> := class<final><final_super>(component, gameboy):
    @editable
    bootstrap_rom_prefab_type <private> : ?castable_concrete_subtype(entity) = false

    @editable
    default_rom_prefab_type <private> : castable_concrete_subtype(entity) = entity

    @editable
    var Palette1 <private> : []color = DEFAULT_PALETTE_1

    @editable
    var Palette2 <private> : []color = DEFAULT_PALETTE_2

    var Cancelables <private> : []cancelable = ()
    var LastPalette <private> : []color = ()
    var LastWords <private> : [][]float = for (I := 1..VERTICAL_BLANK_SCAN_LINE * 5) do ()
    LoadedEvent <private> : event() = event(){}
    var RenderedPalette <private> : []color = ()
    var Scanlines <private> : []M_Scanline = for (I := 1..VERTICAL_BLANK_SCAN_LINE) do M_Scanline{}

    BindInput<public>(Action:input_action(logic), Button:int, InPlayer:player):[]cancelable=
        if (PlayerInput := GetPlayerInput[InPlayer]):
            InputBinding:gameboy_input_binding = gameboy_input_binding{Button := Button, Gameboy := Self}
            InputEvents:input_events(logic) = PlayerInput.GetInputEvents(Action)
            PressedEvent:subscribable(tuple(player, logic)) = InputEvents.BeginDetectEvent
            ReleasedEvent:subscribable(tuple(player, float)) = InputEvents.EndDetectEvent
            return (PressedEvent.Subscribe(InputBinding.OnPressed), ReleasedEvent.Subscribe(InputBinding.OnReleased))
        return ()

    LoadBootstrapROM<public>()<suspends>:logic=
        if (valid_bootstrap_rom_prefab_type := bootstrap_rom_prefab_type?, Component := valid_bootstrap_rom_prefab_type{}.GetComponent[rom_component]):
            MaybeROM:?[]int = Component.GetROM()
            if (ROM := MaybeROM?, ROM.Length = 256):
                return LoadROM(valid_bootstrap_rom_prefab_type)
        return false

    LoadROM<public>(rom_prefab_type:castable_concrete_subtype(entity))<suspends>:logic=
        concrete_rom_prefab_type:castable_concrete_subtype(entity) = rom_prefab_type
        if (Component := concrete_rom_prefab_type{}.GetComponent[rom_component]):
            MaybeROM:?[]int = Component.GetROM()
            if (ROM := MaybeROM?):
                Loaded:logic = LoadROM(ROM)
                if (Loaded?):
                    MaybeSave:?[]int = Component.GetSave()
                    if (Save := MaybeSave?):
                        LoadSave(Save)
                    return true
        return false

    LoadROM<public>(rom_prefab_type:castable_concrete_subtype(entity), Save:[]int)<suspends>:logic=
        concrete_rom_prefab_type:castable_concrete_subtype(entity) = rom_prefab_type
        if (Component := concrete_rom_prefab_type{}.GetComponent[rom_component]):
            MaybeROM:?[]int = Component.GetROM()
            if (ROM := MaybeROM?):
                Loaded:logic = LoadROM(ROM)
                if (Loaded?):
                    LoadSave(Save)
                    return true
        return false

    OnBeginSimulation<override>():void=
        if (FortRoundManager := Entity.GetFortRoundManager[]):
            Cancelable:cancelable = FortRoundManager.SubscribeRoundStarted(OnRoundStarted)
            set Cancelables += array{Cancelable}

    OnEndSimulation<override>():void=
        for (Cancelable : Cancelables):
            Cancelable.Cancel()
        set Cancelables = ()

    OnRoundStarted<private>()<suspends>:void=
        if (Player := Entity.GetPlayspaceForEntity[].GetPlayers()[0], PlayerInput := GetPlayerInput[Player]):
            branch:
                var Current:[]logic = for (I := 1..4) do false
                Events := PlayerInput.GetInputEvents(Character.Move)
                sync:
                    loop:
                        Sleep(-1.0)
                        Data := Events.TriggerActivationEvent.Await()
                        New:[]logic = array:
                            logic{Data(1).Left > 0.35}
                            logic{Data(1).Left < -0.35}
                            logic{Data(1).Forward > 0.35}
                            logic{Data(1).Forward < -0.35}
                        for (Button->Pressed : New):
                            if (Current[Button]?):
                                if (not Pressed?, set Current[Button] = false):
                                    SetButtonReleased(Button)
                            else if (Pressed?, set Current[Button] = true):
                                SetButtonPressed(Button)
                    loop:
                        Sleep(-1.0)
                        Events.EndDetectEvent.Await()
                        for (Button->Pressed : Current):
                            if (Pressed?, set Current[Button] = false):
                                SetButtonReleased(Button)
            branch:
                Events:input_events(logic) = PlayerInput.GetInputEvents(Character.WeaponPrimary)
                loop:
                    Sleep(-1.0)
                    Events.BeginDetectEvent.Await()
                    Screenshot()
            branch:
                Events:input_events(logic) = PlayerInput.GetInputEvents(Character.WeaponSecondary)
                loop:
                    Sleep(-1.0)
                    Events.BeginDetectEvent.Await()
                    set Palette = if (Palette = Palette1):
                        Palette2
                    else:
                        Palette1
            if (FortCharacter := Player.GetFortCharacter[]):
                FortCharacter.PutInStasis(stasis_args{AllowEmotes := false, AllowFalling := false, AllowTurning := false})
            if (PlayerUI := GetPlayerUI[Player]):
                Overlay:overlay = overlay:
                    Slots := array:
                        overlay_slot:
                            HorizontalAlignment := horizontal_alignment.Fill
                            VerticalAlignment := vertical_alignment.Fill
                            Widget := color_block:
                                DefaultColor := Black
                        overlay_slot:
                            HorizontalAlignment := horizontal_alignment.Center
                            Widget := stack_box:
                                Orientation := orientation.Vertical
                                Slots := for (Scanline : Scanlines):
                                    stack_box_slot:
                                        Widget := material_block:
                                            DefaultDesiredSize := vector2:
                                                X := 160.0 / (Scanlines.Length * 1.0) * 1080.0
                                                Y := 1080.0 / (Scanlines.Length * 1.0)
                                            DefaultImage := Scanline
                PlayerUI.AddWidget(Overlay)
            set Cancelables += BindInput(Character.Interact, BUTTON_B, Player)
            set Cancelables += BindInput(Character.Jump, BUTTON_START, Player)
            set Cancelables += BindInput(Character.Reload, BUTTON_A, Player)
            set Cancelables += BindInput(Character.Sprint, BUTTON_SELECT, Player)
            if (not HasROM[]):
                LoadedEvent.Await()
            StartEmulation()

    OnSimulate<override>()<suspends>:void=
        Initialize()
        LoadBootstrapROM()
        LoadROM(default_rom_prefab_type)
        if (Title := GetGameTitle[]):
            Print("Loaded Game: {Title}")
        LoadedEvent.Signal()

    StartEmulation<override>()<suspends>:void=
        if (not HasROM[] or Started?):
            return

        if (Title := GetGameTitle[]):
            Print("Starting Game: {Title}")
        else:
            Print("Starting Game")
        branch:
            loop:
                ScreenData:[]int = AwaitVerticalBlank()
                UpdateScanlines(ScreenData)
        loop:
            Update()
            # Emulation works perfectly with only one Sleep, but unfortunately it stalls the material replication for too long...
            if (LastPalette <> Palette):
                set LastPalette = Palette
                Sleep(0.0)
            Sleep(0.0)
            Sleep(0.0)
            Sleep(0.0)
            Sleep(0.0)
            Sleep(0.0)
            Sleep(0.0)

    UpdateScanlines<private>(ScreenData:[]int):void=
        for (Row->Scanline : Scanlines):
            for (Group := 0..4):
                Base:int = Row * 160 + Group * 36
                Valid:int = 160 - Group * 36
                var Word1:int = 0
                var Word2:int = 0
                var Word3:int = 0
                for (K := 0..11, Weight := Pow4[K]):
                    if (K < Valid, Shade := ScreenData[Base + K]):
                        set Word1 += Shade * Weight
                    if (K + 12 < Valid, Shade := ScreenData[Base + 12 + K]):
                        set Word2 += Shade * Weight
                    if (K + 24 < Valid, Shade := ScreenData[Base + 24 + K]):
                        set Word3 += Shade * Weight
                Index:int = Row * 5 + Group
                Words:tuple(float, float, float) = (Word1 * 1.0, Word2 * 1.0, Word3 * 1.0)
                if (LastWords[Index] <> Words, set LastWords[Index] = Words):
                    Color := ToColor(Words)
                    case (Group):
                        0 => set Scanline.Words1 = Color
                        1 => set Scanline.Words2 = Color
                        2 => set Scanline.Words3 = Color
                        3 => set Scanline.Words4 = Color
                        4 => set Scanline.Words5 = Color
                        _ => {}
            if (Palette <> RenderedPalette, Color1 := Palette[0], Color2 := Palette[1], Color3 := Palette[2], Color4 := Palette[3]):
                set Scanline.Palette123 = ToColor(PackColor(Color1), PackColor(Color2), PackColor(Color3))
                set Scanline.Palette4 = PackColor(Color4)
        set RenderedPalette = Palette

gameboy_input_binding := class:
    Button <public> : int
    Gameboy <public> : gameboy_component

    OnPressed<public>(Player:player, Value:logic):void=
        Gameboy.SetButtonPressed(Button)

    OnReleased<public>(Player:player, Time:float):void=
        Gameboy.SetButtonReleased(Button)