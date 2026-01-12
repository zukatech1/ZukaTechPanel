import tkinter as tk
from tkinter import filedialog, messagebox
import requests
import threading
import pickle

# === Load Roblox API index ===
with open("roblox_api_index.pkl", "rb") as f:
    ROBLOX_API = pickle.load(f)

# === API CONFIG ===
CALLUM_API_KEY = "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"
FREE_MODEL = "tngtech/deepseek-r1t-chimera:free"
BASE_URL = "https://openrouter.ai/api/v1/chat/completions"


# ====== Helper functions ======
def find_relevant_classes(prompt, api_index, limit=3):
    prompt_lower = prompt.lower()
    matches = []
    for class_name in api_index:
        if class_name.lower() in prompt_lower:
            matches.append(class_name)
    return matches[:limit]


def build_api_context(classes, api_index):
    blocks = []
    for cls in classes:
        data = api_index.get(cls)
        if not data:
            continue
        block = f"""
Class: {cls}
Inherits: {data['inherits']}
Properties: {', '.join(data['properties'][:12])}
Methods: {', '.join(data['methods'][:12])}
Events: {', '.join(data['events'][:8])}
"""
        blocks.append(block.strip())
    return "\n\n".join(blocks)


# ====== Main App ======
class ZukaArchitectDesktop:
    def __init__(self):
        # === Theme ===
        self.THEME = {
            "bg": "#08080a",
            "panel": "#0f0f12",
            "editor": "#101014",
            "accent": "#00ffb4",
            "accent_muted": "#005040",
            "text": "#f0f0f5",
            "button": "#18181c",
        }

        # === App Window ===
        self.root = tk.Tk()
        self.root.title("Callum-AI | Lua IDE Architect")
        self.root.geometry("1000x700")
        self.root.configure(bg=self.THEME["bg"])

        # === Build UI ===
        self.build_ui()

    # -------------------- GUI --------------------
    def build_ui(self):
        # Title bar
        self.title_bar = tk.Frame(self.root, bg=self.THEME["panel"], height=40)
        self.title_bar.pack(fill="x")

        self.title_label = tk.Label(
            self.title_bar,
            text="Bill gates once said he'd hire someone lazy because they'd find a faster solution for problems.. So I made Callum.",
            fg=self.THEME["accent"],
            bg=self.THEME["panel"],
            font=("Consolas", 14, "bold")
        )
        self.title_label.pack(side="left", padx=12)

        # Main layout
        self.main = tk.Frame(self.root, bg=self.THEME["bg"])
        self.main.pack(fill="both", expand=True, padx=10, pady=10)

        # Sidebar
        self.sidebar = tk.Frame(self.main, width=160, bg=self.THEME["panel"])
        self.sidebar.pack(side="left", fill="y")

        self.make_button("GENERATE", self.generate_ai, accent=True)
        self.make_button("LOAD", self.load_script)
        self.make_button("SAVE", self.save_script)

        # Editor frame
        self.editor_frame = tk.Frame(self.main, bg=self.THEME["editor"])
        self.editor_frame.pack(side="right", fill="both", expand=True)

        # Text editor
        self.text_editor = tk.Text(
            self.editor_frame,
            bg=self.THEME["editor"],
            fg=self.THEME["text"],
            insertbackground="white",
            font=("Consolas", 11),
            undo=True,
            wrap="none"
        )

        # Scrollbars
        self.scroll_y = tk.Scrollbar(self.editor_frame, orient="vertical", command=self.text_editor.yview)
        self.text_editor.configure(yscrollcommand=self.scroll_y.set)
        self.scroll_y.pack(side="right", fill="y")
        self.text_editor.pack(side="left", fill="both", expand=True)

        # Starter message
        self.text_editor.insert("1.0", "-- CALLUM: Input a prompt to generate Lua.\n")

    def make_button(self, text, command, accent=False):
        btn = tk.Button(
            self.sidebar,
            text=text,
            command=command,
            bg=self.THEME["accent"] if accent else self.THEME["button"],
            fg="black" if accent else self.THEME["text"],
            activebackground=self.THEME["accent_muted"],
            relief="flat",
            font=("Consolas", 10),
            height=2
        )
        btn.pack(fill="x", padx=10, pady=6)

    # -------------------- AI --------------------
    def generate_ai(self):
        prompt = self.text_editor.get("1.0", "end").strip()
        if not prompt:
            return
        self.text_editor.insert("end", "\n\n-- GENERATING...\n")
        threading.Thread(target=self._generate_thread, args=(prompt,), daemon=True).start()

    def _generate_thread(self, prompt):
        # Build API context
        relevant_classes = find_relevant_classes(prompt, ROBLOX_API, limit=5)
        api_context = build_api_context(relevant_classes, ROBLOX_API)

        system_prompt = f"""
IDENTITY: Callum
ROLE: Expert Roblox Luau Exploit Client Engineer

ROBLOX API CONTEXT:
{api_context}

RULES:
- Use ONLY documented Roblox APIs
- Prefer methods and properties listed above
- Output RAW Luau code only
- No comments
- No explanations
"""

        payload = {
            "model": FREE_MODEL,
            "messages": [
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": prompt}
            ]
        }

        headers = {
            "Authorization": f"Bearer {CALLUM_API_KEY}",
            "Content-Type": "application/json",
            "HTTP-Referer": "http://localhost",
            "X-Title": "Callum-AI Lua Generator"
        }

        try:
            res = requests.post(BASE_URL, headers=headers, json=payload, timeout=60)
            if res.status_code == 200:
                code = res.json()["choices"][0]["message"]["content"]
                self.insert_output(self.strip_comments(code))
            else:
                self.insert_output(f"-- HTTP ERROR {res.status_code}")
        except requests.exceptions.ReadTimeout:
            self.insert_output("-- ERROR: Request timed out. Try shorter prompt or fewer classes.")
        except Exception as e:
            self.insert_output(f"-- ERROR: {e}")

    def insert_output(self, text):
        self.text_editor.insert("end", f"\n{text}\n")
        self.text_editor.see("end")

    # -------------------- Files --------------------
    def save_script(self):
        path = filedialog.asksaveasfilename(defaultextension=".lua", filetypes=[("Lua Script", "*.lua")])
        if not path:
            return
        with open(path, "w", encoding="utf-8") as f:
            f.write(self.text_editor.get("1.0", "end"))

    def load_script(self):
        path = filedialog.askopenfilename(filetypes=[("Lua Script", "*.lua")])
        if not path:
            return
        with open(path, "r", encoding="utf-8") as f:
            self.text_editor.delete("1.0", "end")
            self.text_editor.insert("1.0", f.read())

    # -------------------- Utils --------------------
    def strip_comments(self, code):
        lines = []
        for line in code.split("\n"):
            clean = line.split("--")[0].rstrip()
            if clean:
                lines.append(clean)
        return "\n".join(lines)

    def run(self):
        self.root.mainloop()


# === Run the app ===
if __name__ == "__main__":
    app = ZukaArchitectDesktop()
    app.run()
