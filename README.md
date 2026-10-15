# VerseBoy
VerseBoy is a highly accurate Game Boy (DMG) emulator built in Verse, the programming language powering UEFN and Unreal Engine 6!

The emulator can be ran inside an Unreal Editor for Fortnite (UEFN) session where it is displayed on a UI material in-game, or ran standalone using the latest builds of UE6 and a Python tool to handle the visuals.

## Features
* Accurate scanlines and timers ✅
* Boot ROM execution (`boot.gb`, `bootstrap.gb` or `dmg_boot.bin` in the emulator's root) ✅
* Loading/saving ✅
* MBC1 (including multicart), MBC2, MBC3 and MBC5 ✅
* Multiple color palettes ✅
* Save States ✅
* Screenshots ✅
* Works in UEFN and standalone ✅
* Audio ❌
* Real-Time Clock ❌

## Screenshots
![Kirby's Dream Land](/images/KIRBYDREAMLAND.bmp)
![Pokemon Red](/images/POKEMONRED.bmp)
![Super Mario Land 2](/images/MARIOLAND2.bmp)
![Tetris](/images/TETRIS.bmp)

## Running
### Standalone
#### *Requires Python*
1. Download `VerseBoy-standalone.zip` from the [latest release](https://github.com/Ep8Script/VerseBoy/releases/latest) and extract it.
2. Download the latest VerseCMD build from [here](https://github.com/jameswnichols/UnrealEngine/releases) or build it manually from UE6's source, then add `verse.exe` to your PATH.
3. Open the extracted `VerseBoy` folder and run the command `verse verseboy.verse | py verseboy.py` to start the emulator.
4. Load a ROM from the `File` menu. You can create and load save states from the `Emulation` menu, and cartridge save data will automatically be loaded from a matching `.sav` file in the ROM's directory.

### UEFN
1. Download `VerseBoy-UEFN.zip` from the [latest release](https://github.com/Ep8Script/VerseBoy/releases/latest) and extract it.
2. Copy the "**VerseBoy**" folder to your UEFN project's root directory (or whereever you keep your Verse).
3. Add the `gameboy_component` to an entity in the scene.
4. Create a prefab that contains a `rom_component` which stores the data of a Game Boy cartridge's ROM **converted to hexadecimal**, and set the `gameboy_component`'s `default_rom_prefab_type` editable to that new prefab. If you'd like, you can also convert a save file to hex and store that in the component as well.
5. **Recommended**: Enable "**Use Verse VM**" in the menu next to Launch Session for much faster performance.

## Was this vibe-coded?!
No! It was originally based on [Codeslinger's Game Boy emulator](http://www.codeslinger.co.uk/pages/projects/gameboy.html) and manually ported to Verse by hand- even the tedious parts. For transparency, I did use Claude for some bug fixing, to find the occasional typo and to help out with some math for passing the screen data to materials in UEFN and via the Python tool (such as `gameboy.Screenshot()`), along with some assistance with passing a couple of test ROMs.

This was done by giving Claude snippets of my code and asking questions on its website before manually transcribing its suggestions in my Verse scripts. My intention was to learn more about emulation and see if creating this in UEFN was even possible. The performance is quite slow and that might not be fixable for some time due to the speed of the language's development, but it's quite cool to use nonetheless.

## Controls
| Game Boy | Key |
| --- | --- |
| Dpad | Arrow Keys/WASD |
| A | R (Reload) |
| B | E (Interact) |
| Select | Shift (Sprint) |
| Start | Space (Jump) |

### Standalone (Alternatives)
| Game Boy | Key |
| --- | --- |
| A | X |
| B | Z |
| Start | Enter |

## Tests
## Blarrg's Test ROMs
| Test | Result |
| --- | --- |
| cpu_instrs | ✅ |
| dmg_sound | ❌ |
| halt_bug | ✅ |
| instr_timing | ✅ |
| interrupt_time | ✅ |
| mem_timing | ✅ |
| oam_bug | ❌ |

## Mooneye Test Suite
### Acceptance
| Test | Result |
| --- | --- |
| add_sp_e_timing | ✅ |
| boot_div-dmgABCmgb | ✅ |
| boot_hwio-dmgABCmgb | ✅ |
| boot_regs-dmgABC | ✅ |
| call_cc_timing | ✅ |
| call_cc_timing2 | ✅ |
| call_timing | ✅ |
| call_timing2 | ✅ |
| di_timing-GS | ✅ |
| div_timing | ✅ |
| ei_sequence | ✅ |
| ei_timing | ✅ |
| halt_ime0_ei | ✅ |
| halt_ime0_nointr_timing | ✅ |
| halt_ime1_timing | ✅ |
| halt_ime1_timing2-GS | ✅ |
| if_ie_registers | ✅ |
| intr_timing | ✅ |
| jp_cc_timing | ✅ |
| jp_timing | ✅ |
| ld_hl_sp_e_timing | ✅ |
| oam_dma_restart | ✅ |
| oam_dma_start | ✅ |
| oam_dma_timing | ✅ |
| pop_timing | ✅ |
| push_timing | ✅ |
| rapid_di_ei | ✅ |
| ret_cc_timing | ✅ |
| ret_timing | ✅ |
| reti_intr_timing | ✅ |
| reti_timing | ✅ |
| rst_timing | ✅ |

#### Bits
| Test | Result |
| --- | --- |
| mem_oam | ✅ |
| reg_f | ✅ |
| unused_hwio-GS | ✅ |

#### Instr
| Test | Result |
| --- | --- |
| daa | ✅ |

#### Interrupts
| Test | Result |
| --- | --- |
| ie_push | ✅ |

#### OAM_DMA
| Test | Result |
| --- | --- |
| basic | ✅ |
| reg_read | ✅ |
| sources-GS | ✅ |

#### PPU
| Test | Result |
| --- | --- |
| hblank_ly_scx_timing-GS | ✅ |
| intr_1_2_timing-GS | ✅ |
| intr_2_0_timing | ✅ |
| intr_2_mode0_timing | ✅ |
| intr_2_mode0_timing_sprites | ✅ |
| intr_2_mode3_timing | ✅ |
| intr_2_oam_ok_timing | ✅ |
| lcdon_timing-GS | ✅ |
| lcdon_write_timing-GS | ✅ |
| stat_irq_blocking | ✅ |
| stat_lyc_onoff | ✅ |
| vblank_stat_intr-GS | ✅ |

#### Serial
| Test | Result |
| --- | --- |
| boot_sclk_align-dmgABCmgb | ✅ |

#### Timer
| Test | Result |
| --- | --- |
| div_write | ✅ |
| rapid_toggle | ✅ |
| tim00 | ✅ |
| tim00_div_trigger | ✅ |
| tim01 | ✅ |
| tim01_div_trigger | ✅ |
| tim10 | ✅ |
| tim10_div_trigger | ✅ |
| tim11 | ✅ |
| tim11_div_trigger | ✅ |
| tima_reload | ✅ |
| tima_write_reloading | ✅ |
| tma_write_reloading | ✅ |

### Emulator-Only
#### MBC1
| Test | Result |
| --- | --- |
| bits_bank1 | ✅ |
| bits_bank2 | ✅ |
| bits_mode | ✅ |
| bits_ramg | ✅ |
| multicart_rom_8Mb | ✅ |
| ram_256kb | ✅ |
| ram_1Mb | ✅ |
| ram_2Mb | ✅ |
| ram_4Mb | ✅ |
| ram_8Mb | ✅ |
| ram_16Mb | ✅ |
| ram_512kb | ✅ |

#### MBC2
| Test | Result |
| --- | --- |
| bits_ramg | ✅ |
| bits_romb | ✅ |
| bits_unused | ✅ |
| ram | ✅ |
| rom_1MB | ✅ |
| rom_2MB | ✅ |
| rom_512kb | ✅ |

#### MBC5
| Test | Result |
| --- | --- |
| rom_1Mb | ✅ |
| rom_2Mb | ✅ |
| rom_4Mb | ✅ |
| rom_8Mb | ✅ |
| rom_16Mb | ✅ |
| rom_32Mb | ✅ |
| rom_64Mb | ✅ |
| rom_512kb | ✅ |

### Emulator-Only
| Test | Result |
| --- | --- |
| sprite_priority | ✅ |

## PPU Accuracy
- dmg-acid2 ✅
- pocket.gb ✅
- Prehistorik Man ✅