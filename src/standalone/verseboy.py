import base64, ctypes, json, os, re, sys, threading, time, tkinter as tk, webbrowser
from tkinter import filedialog

class VerseBoy:
    FRAME = re.compile(r"data:image/bmp;base64,([A-Za-z0-9+/=]+)")
    ICON = "icon.png"
    KEYS = {
        "d": 0, "right": 0,
        "a": 1, "left": 1,
        "up": 2, "w": 2,
        "down": 3, "s": 3,
        "r": 4, "x": 4,
        "e": 5, "z": 5,
        "shift_l": 6, "shift_r": 6,
        "return": 7, "space": 7
    }
    SAVE_STATE_SLOTS = 8
    SCALE = 5
    STATE_FILE = "state.json"

    def __init__(self):
        self.frame = None
        self.frames = 0
        self.game_title = None
        self.held = set()
        self.icon = None
        self.photo = None
        self.running = False
        self.screenshot = False
        self.since = time.time()
        self.create_window()

    def create_menu(self):
        menu = tk.Menu(self.root)
        file = tk.Menu(menu, tearoff=False)
        file.add_command(label="Load ROM", command=self.load_rom)
        file.add_separator()
        file.add_command(label="Exit", command=self.on_exit)
        self.emulation = tk.Menu(menu, tearoff=False, postcommand=self.update_menu)
        self.paused = tk.BooleanVar(value=False)
        self.emulation.add_checkbutton(label="Pause", variable=self.paused, command=self.pause)
        self.emulation.add_command(label="Stop", command=self.stop)
        self.emulation.add_command(label="Reset", command=self.reset)
        self.emulation.add_command(label="Take Screenshot", command=self.take_screenshot)
        self.emulation.add_separator()
        load_state = tk.Menu(self.emulation, tearoff=0)
        load_state.add_command(label="Load State From File", command=self.load_state_file)
        self.load_slots = tk.Menu(load_state, tearoff=0)
        load_state.add_cascade(label="Load State From Slot", menu=self.load_slots)
        self.emulation.add_cascade(label="Load State", menu=load_state)
        save_state = tk.Menu(self.emulation, tearoff=0)
        save_state.add_command(label="Save State To File", command=self.save_state_file)
        self.save_slots = tk.Menu(save_state, tearoff=0)
        save_state.add_cascade(label="Save State To Slot", menu=self.save_slots)
        self.emulation.add_cascade(label="Save State", menu=save_state)
        view = tk.Menu(menu, tearoff=False)
        palettes = tk.Menu(view, tearoff=0)
        self.palette = tk.IntVar(value=self.get_state().get("palette"))
        palettes.add_radiobutton(label="Palette 1", value=1, variable=self.palette, command=lambda: self.set_palette(1))
        palettes.add_radiobutton(label="Palette 2", value=2, variable=self.palette, command=lambda: self.set_palette(2))
        view.add_cascade(label="Color Palettes", menu=palettes)
        help = tk.Menu(menu, tearoff=False)
        help.add_command(label="Check Updates", command=self.update)
        help.add_separator()
        help.add_command(label="About VerseBoy", command=self.open_about)
        menu.add_cascade(label="File", menu=file)
        menu.add_cascade(label="Emulation", menu=self.emulation)
        menu.add_cascade(label="View", menu=view)
        menu.add_cascade(label="Help", menu=help)
        for slot in range(1, self.SAVE_STATE_SLOTS + 1):
            self.load_slots.add_command(command=lambda slot=slot: self.load_slot(slot))
            self.save_slots.add_command(command=lambda slot=slot: self.save_slot(slot))
        self.root.config(menu=menu)
        self.update_menu()

    def create_window(self):
        self.root = tk.Tk()
        if os.path.exists(self.ICON):
            self.icon = tk.PhotoImage(file=self.ICON)
            self.root.iconphoto(False, self.icon)
        self.root.update_idletasks()
        self.root.resizable(False, False)
        self.label = tk.Label(self.root, bd=0, bg="#1a1a1a", compound="center", fg="#bbbbbb", padx=0, pady=0)
        self.label.pack()
        self.create_menu()
        self.root.bind("<Button-3>", self.switch_palette)
        self.root.bind("<FocusOut>", self.on_unfocus)
        self.root.bind("<<Frame>>", self.show_frame)
        self.root.bind("<KeyPress>", lambda event: self.on_key(event, True))
        self.root.bind("<KeyRelease>", lambda event: self.on_key(event, False))
        self.root.bind("<<Screenshot>>", self.on_screenshot)
        self.root.bind("<<Start>>", self.start)
        self.root.protocol("WM_DELETE_WINDOW", self.on_exit)
        self.show_idle()

    def get_state(self):
        try:
            with open(self.STATE_FILE) as f:
                state = json.load(f)
            return state if isinstance(state, dict) else {}
        except:
            return {"palette":1}

    def load_rom(self):
        rom_path = filedialog.askopenfilename(filetypes=[("Game Boy ROMs", "*.gb;*.gbc")], title="Select a ROM")
        if rom_path:
            self.update_state(action="rom", file=rom_path)

    def load_slot(self, slot):
        path = f"state{slot}.state"
        if os.path.exists(path):
            self.update_state(action="load", file=path)

    def load_state_file(self):
        state_path = filedialog.askopenfilename(filetypes=[("Save States", "*.state"), ("All files", "*.*")], title="Select a Save State")
        if state_path:
            self.update_state(action="load", file=state_path)

    def on_exit(self):
        self.root.after(300, self.root.destroy)
        self.root.withdraw()
        self.update_state(action="exit")

    def on_key(self, event, down):
        button = self.KEYS.get(event.keysym.lower())
        if button is not None and (button in self.held) != down:
            if down:
                self.held.add(button)
            else:
                self.held.discard(button)
            self.update_state(inputs=sorted(self.held))

    def open_about(self):
        webbrowser.open("https://github.com/Ep8Script/VerseBoy")

    def on_screenshot(self, event):
        if not hasattr(self, "screenshot_data"):
            return

        timestamp = time.strftime("%Y%m%d-%H%M%S")
        if self.game_title:
            clean_title = "".join(c for c in self.game_title if c.isalnum() or c in (' ', '_', '-')).strip()
            filename = f"{clean_title}_{timestamp}.bmp"
        else:
            filename = f"VerseBoy_{timestamp}.bmp"
        screenshot_path = filedialog.asksaveasfilename(confirmoverwrite=True, defaultextension=".bmp", filetypes=[("Bitmap Files", "*.bmp")], initialfile=filename, title="Save Screenshot")
        if screenshot_path:
            try:
                bytes = base64.b64decode(self.screenshot_data)
                with open(screenshot_path, "wb") as f:
                    f.write(bytes)
            except:
                pass
        del self.screenshot_data

    def on_stdin(self):
        sys.stdin.reconfigure(errors="replace")
        for line in sys.stdin:
            match = self.FRAME.search(line)
            if match:
                if self.screenshot:
                    self.screenshot = False
                    self.screenshot_data = match.group(1)
                    self.root.event_generate("<<Screenshot>>", when="tail")
                elif self.running:
                    self.frame = match.group(1)
                    self.frames += 1
                    self.root.event_generate("<<Frame>>", when="tail")
            elif line.startswith("Screenshot:"):
                self.screenshot = True
            elif not line.startswith("Log") and not line.startswith("Usage:"):
                if line.startswith("Starting Game"):
                    parts = line.strip().split(":", 1)
                    if len(parts) > 1:
                        self.game_title = parts[1].strip()
                    self.root.event_generate("<<Start>>", when="tail")
                    self.running = True
                print(line, end="")

    def on_unfocus(self, event):
        if self.held:
            self.held.clear()
            self.update_state(inputs=[])

    def pause(self):
        if self.paused.get():
            self.update_state(action="pause")
        else:
            self.update_state(action="play")

    def reset(self):
        self.paused.set(False)
        self.update_state(action="reset")

    def run(self):
        self.root.after(100, self.load_rom)
        self.update_title()
        threading.Thread(target=self.on_stdin, daemon=True).start()
        try:
            self.root.mainloop()
        except:
            pass

    def save_slot(self, slot):
        self.update_state(action="save", file=f"state{slot}.state")

    def save_state_file(self):
        file_name = "save.state"
        if self.game_title:
            file_name = self.game_title + ".state"
        state_path = filedialog.asksaveasfilename(confirmoverwrite=True, defaultextension=".state", filetypes=[("Save States", "*.state")], initialfile=file_name, title="Save State")
        if state_path:
            self.update_state(action="save", file=state_path)

    def set_palette(self, palette):
        self.palette.set(palette)
        self.update_state(palette=palette)

    def show_frame(self, event):
        if not self.running:
            return
        try:
            data, self.frame = self.frame, None
            if data:
                self.photo = tk.PhotoImage(data=self.to_ppm(base64.b64decode(data))).zoom(self.SCALE)
                self.label.config(image=self.photo, text="")
        except:
            pass

    def show_idle(self):
        self.running = False
        self.frame = None
        self.game_title = None
        self.paused.set(False)
        self.photo = tk.PhotoImage(width=160*self.SCALE, height=144*self.SCALE)
        self.photo.put("#1a1a1a", to=(0, 0, 160*self.SCALE, 144*self.SCALE))
        self.root.title("VerseBoy")
        self.label.config(image=self.photo, text="File > Load ROM to start")

    def start(self, event):
        self.paused.set(False)
        self.root.focus_force()

    def stop(self):
        self.show_idle()
        self.update_state(action="stop")

    def switch_palette(self, event):
        self.set_palette(1 if self.get_state().get("palette") == 2 else 2)

    def take_screenshot(self):
        self.update_state(action="screenshot")

    def to_ppm(self, data):
        w, h, off = (int.from_bytes(data[i:i + 4], "little") for i in (18, 22, 10))
        pal = [bytes((data[56 + 4 * i], data[55 + 4 * i], data[54 + 4 * i])) for i in range(16)]
        stride = (w * 4 + 31) // 32 * 4
        rows = (data[off + y * stride:off + (y + 1) * stride] for y in range(h - 1, -1, -1))
        return b"P6 %d %d 255\n" % (w, h) + b"".join(b"".join(pal[v] for b in r for v in (b >> 4, b & 15))[:w * 3] for r in rows)

    def update(self):
        webbrowser.open("https://github.com/Ep8Script/VerseBoy/releases/latest")

    def update_menu(self):
        for label in ("Pause", "Stop", "Reset", "Take Screenshot", "Load State", "Save State"):
            self.emulation.entryconfigure(self.emulation.index(label), state="normal" if self.running else "disabled")
        for slot in range(1, self.SAVE_STATE_SLOTS + 1):
            try:
                saved = time.strftime("%Y-%m-%d %H:%M", time.localtime(os.path.getmtime(f"state{slot}.state")))
            except:
                saved = None
            self.load_slots.entryconfigure(slot - 1, label=f"Load from Slot {slot} - {saved or 'Empty'}", state="normal" if saved else "disabled")
            self.save_slots.entryconfigure(slot - 1, label=f"Save to Slot {slot} - {saved or 'Empty'}")

    def update_state(self, **changes):
        state = {"inputs": [], "palette": 1, **self.get_state(), **changes}
        with open(self.STATE_FILE, "w") as f:
            json.dump(state, f)

    def update_title(self):
        now = time.time()
        fps = round(self.frames / (now - self.since))
        fps_str = f"FPS: {fps}"
        self.frames, self.since = 0, now
        if self.paused.get():
            fps_str = "PAUSED"
        if not self.running:
            self.root.title("VerseBoy")
        elif self.game_title:
            self.root.title(f"VerseBoy | {self.game_title} | {fps_str}")
        else:
            self.root.title(f"VerseBoy | {fps_str}")
        self.root.after(1000, self.update_title)

if __name__ == "__main__":
    if sys.stdin.isatty():
        print("Usage: verse verseboy.verse | py verseboy.py")
        print("Exiting...")
        sys.exit(1)
    try:
        ctypes.windll.shell32.SetCurrentProcessExplicitAppUserModelID("ep8script.verse.verseboy")
    except:
        pass
    verseboy = VerseBoy()
    verseboy.run()