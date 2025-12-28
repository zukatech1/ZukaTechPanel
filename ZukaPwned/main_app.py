# main_app.py [VERSION: COMPLETE, WITH EVASIVE SPAWNING]
import sys
import os
import subprocess
import frida
import pefile
import shutil
from capstone import Cs, CS_ARCH_X86, CS_MODE_64, CS_MODE_32
from PyQt6.QtCore import QObject, QThread, pyqtSignal
from PyQt6.QtWidgets import (
    QApplication, QMainWindow, QTextEdit, QMenuBar, QStatusBar, QMessageBox,
    QFileDialog, QPushButton, QVBoxLayout, QWidget, QMenu, QInputDialog
)
from PyQt6.QtGui import QAction, QFont, QActionGroup, QContextMenuEvent

# --- Assume Local Module Imports Exist ---
try:
    from process_dialog import ProcessDialog
    # ... other dialogs
except ImportError:
    print("WARNING: UI Dialog files not found. Using placeholder dialogs.")
    class ProcessDialog(QInputDialog):
        def __init__(self, parent=None):
            super().__init__(parent)
            self.selected_pid = None
        def exec(self):
            text, ok = self.getText(self, "Attach to Process", "Enter PID:")
            if ok and text.isdigit():
                self.selected_pid = int(text)
                return True
            return False
        def get_selected_pid(self):
            return self.selected_pid

# --- Worker Classes (Unchanged, included for completeness) ---
class DisassemblyWorker(QObject):
    progress = pyqtSignal(str)
    finished = pyqtSignal(str)
    error = pyqtSignal(str)
    def __init__(self, filepath: str): super().__init__(); self.filepath = filepath; self.is_running = True
    def run(self):
        try:
            pe = pefile.PE(self.filepath)
            is_64bit = pe.FILE_HEADER.Machine == pefile.MACHINE_TYPE['IMAGE_FILE_MACHINE_AMD64']
            arch, mode = (CS_ARCH_X86, CS_MODE_64) if is_64bit else (CS_ARCH_X86, CS_MODE_32)
            code_section = next((s for s in pe.sections if s.Name.startswith(b'.text')), None)
            if not code_section: self.error.emit("Could not find a '.text' code section."); return
            code_bytes = code_section.get_data()
            base_address = pe.OPTIONAL_HEADER.ImageBase
            virtual_address = base_address + code_section.VirtualAddress
            self.progress.emit(f"--- Static Disassembly of {os.path.basename(self.filepath)} ---\n")
            self.progress.emit(f"--- .text section at 0x{virtual_address:X}, size: {len(code_bytes)} bytes ---\n\n")
            md = Cs(arch, mode)
            output = "".join([f"0x{i.address:x}:\t{i.mnemonic}\t{i.op_str}\n" for i in md.disasm(code_bytes, virtual_address)])
            self.progress.emit(output)
            self.finished.emit("Static analysis complete.")
        except Exception as e: self.error.emit(f"An unexpected error occurred: {e}")
    def stop(self): self.is_running = False

# ... Other worker classes (MemorySearchWorker, ReconstructionWorker) would go here ...

# --- Main Application Window ---
class MainApp(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Lightweight Hybrid Disassembler")
        self.setGeometry(100, 100, 900, 700)
        self.thread = None; self.worker = None; self.frida_session = None
        self.frida_script = None; self.attached_pid = None; self.instruction_map = {}
        self.undo_stack = []
        central_widget = QWidget()
        layout = QVBoxLayout(central_widget)
        self.disassembly_view = QTextEdit()
        self.disassembly_view.setReadOnly(True)
        self.disassembly_view.setFont(QFont("Courier", 10))
        self.disassembly_view.setStyleSheet("background-color: #1E1E1E; color: #D4D4D4;")
        self.stop_button = QPushButton("Stop Current Task")
        self.stop_button.clicked.connect(self.stop_analysis)
        self.stop_button.setEnabled(False)
        layout.addWidget(self.disassembly_view)
        layout.addWidget(self.stop_button)
        self.setCentralWidget(central_widget)
        self.setup_ui()

    def setup_ui(self):
        self.menu_bar = self.menuBar()
        file_menu = self.menu_bar.addMenu("File")
        
        open_file_action = QAction("Open File for Static Analysis...", self)
        open_file_action.triggered.connect(self.open_file_dialog)
        file_menu.addAction(open_file_action)
        
        file_menu.addSeparator()

        attach_action = QAction("Attach to Running Process...", self)
        attach_action.triggered.connect(self.attach_to_process_dialog)
        file_menu.addAction(attach_action)

        # --- NEW MENU ACTION FOR SPAWNING ---
        spawn_action = QAction("Spawn and Attach to Executable...", self)
        spawn_action.triggered.connect(self.spawn_process_dialog)
        file_menu.addAction(spawn_action)
        
        detach_action = QAction("Detach from Process", self)
        detach_action.triggered.connect(self.detach_from_process)
        file_menu.addAction(detach_action)
        
        file_menu.addSeparator()
        exit_action = QAction("Exit", self)
        exit_action.triggered.connect(self.close)
        file_menu.addAction(exit_action)
        
        # ... other menus (Edit, Search, Tools, etc.) ...
        
        self.status_bar = QStatusBar()
        self.setStatusBar(self.status_bar)
        self.status_bar.showMessage("Ready.")
        self.update_ui_state()
    
    def update_ui_state(self):
        is_attached = self.frida_session is not None and not self.frida_session.is_detached
        # self.rebuild_action.setEnabled(is_attached) # Example for other actions

    def on_script_message(self, message, data):
        if message['type'] != 'send': return
        payload = message.get('payload', {})
        if payload.get('status') == 'found_call':
            address_str = payload.get('address', '0x0')
            address_int = int(address_str, 16)
            self.status_bar.showMessage(f"Xeno call detected! Address: {address_str}. Jumping...", 10000)
            QMessageBox.information(self, "Reconnaissance Success", f"The Xeno DLL function call was intercepted.\n\nReturn Address: {address_str}\n\nJumping to this location for analysis.")
            self.jump_to_address(address_int)
        elif 'log' in payload:
            self.status_bar.showMessage(f"Script: {payload['log']}", 5000)

    def open_file_dialog(self):
        filepath, _ = QFileDialog.getOpenFileName(self, "Open Executable", "", "Executables (*.exe *.dll)")
        if filepath: self.disassemble_from_file(filepath)

    def disassemble_from_file(self, filepath: str):
        self.disassembly_view.clear()
        self.status_bar.showMessage(f"Starting static analysis on: {os.path.basename(filepath)}...")
        self.stop_button.setEnabled(True)
        self.thread = QThread(); self.worker = DisassemblyWorker(filepath)
        self.worker.moveToThread(self.thread); self.thread.started.connect(self.worker.run)
        self.worker.finished.connect(self.on_analysis_finished); self.worker.error.connect(self.on_analysis_error)
        self.worker.progress.connect(self.update_disassembly_view)
        self.worker.finished.connect(self.thread.quit); self.worker.finished.connect(self.worker.deleteLater)
        self.thread.finished.connect(self.thread.deleteLater); self.thread.start()

    def attach_to_process_dialog(self):
        dialog = ProcessDialog(self)
        if dialog.exec():
            pid = dialog.get_selected_pid()
            if pid: self.disassemble_from_process(pid)

    def disassemble_from_process(self, pid: int):
        """
        Standard attachment method. Attaches to an already running process.
        Vulnerable to anti-cheat systems that are already initialized.
        """
        self.detach_from_process()
        self.status_bar.showMessage(f"Attaching to PID: {pid}...")
        try:
            target_pid = int(pid)
            self.frida_session = frida.attach(target_pid)
            self.attached_pid = target_pid
            self.inject_interceptor_script()
            main_module = self.frida_session.get_main_module()
            self.jump_to_address(main_module.base_address)
            self.status_bar.showMessage(f"Successfully attached to {main_module.name} (PID: {target_pid})")
        except Exception as e:
            QMessageBox.critical(self, "Attachment Failed", f"Could not attach to PID {pid}:\n{e}")
            self.status_bar.showMessage("Attachment failed.", 5000)
            self.detach_from_process()
        self.update_ui_state()

    # --- NEW: Evasive Spawning Methods ---
    def spawn_process_dialog(self):
        """Opens a file dialog to select an executable to spawn."""
        filepath, _ = QFileDialog.getOpenFileName(self, "Select Executable to Spawn", "", "Executables (*.exe)")
        if filepath:
            self.spawn_and_disassemble(filepath)

    def spawn_and_disassemble(self, executable_path: str):
        """
        Spawns a new process with Frida. This is the superior method for bypassing
        anti-cheat, as it injects our tools before the target's main thread begins,
        preempting the initialization of many security measures.
        """
        self.detach_from_process()
        self.status_bar.showMessage(f"Spawning {os.path.basename(executable_path)}...")
        QApplication.processEvents()
        try:
            pid = frida.spawn([executable_path])
            self.status_bar.showMessage(f"Process spawned with PID {pid}. Attaching...")
            
            self.frida_session = frida.attach(pid)
            self.attached_pid = pid

            self.inject_interceptor_script()

            self.status_bar.showMessage("Resuming main thread...")
            frida.resume(pid)
            
            main_module = self.frida_session.get_main_module()
            self.jump_to_address(main_module.base_address)
            self.status_bar.showMessage(f"Successfully spawned and attached to {main_module.name} (PID: {pid})")
        except frida.ExecutableNotFoundError:
            QMessageBox.critical(self, "Spawning Failed", f"Could not find the executable: {executable_path}")
        except frida.PermissionDeniedError:
            QMessageBox.critical(self, "Spawning Failed", "Permission denied. Try running as Administrator.")
        except Exception as e:
            QMessageBox.critical(self, "Spawning Failed", f"An unexpected error occurred:\n{e}")
            self.detach_from_process()
        self.update_ui_state()
    
    def inject_interceptor_script(self):
        """Helper function to load and inject our Frida script."""
        if not self.frida_session or self.frida_session.is_detached:
            return

        try:
            script_path = os.path.join(os.path.dirname(__file__), "xeno_interceptor.js")
            if os.path.exists(script_path):
                self.status_bar.showMessage("Injecting Xeno interceptor script...")
                with open(script_path, "r", encoding="utf-8") as f:
                    script_code = f.read()
                self.frida_script = self.frida_session.create_script(script_code)
                self.frida_script.on('message', self.on_script_message)
                self.frida_script.load()
            else:
                QMessageBox.warning(self, "Script Not Found", "xeno_interceptor.js was not found.")
        except Exception as e:
            QMessageBox.critical(self, "Script Injection Failed", f"Could not inject Frida script:\n{e}")

    def detach_from_process(self):
        if self.frida_session and not self.frida_session.is_detached:
            try: self.frida_session.detach()
            except Exception as e: print(f"Note: Error during detach: {e}")
        self.frida_session = None; self.frida_script = None
        self.attached_pid = None; self.disassembly_view.clear()
        self.status_bar.showMessage("Detached from process.")
        self.update_ui_state()

    def jump_to_address(self, address: int):
        if not (self.frida_session and not self.frida_session.is_detached):
            QMessageBox.warning(self, "Not Attached", "Cannot read process memory.")
            return
        self.instruction_map.clear()
        try:
            self.status_bar.showMessage(f"Disassembling memory at 0x{address:X}...")
            code_bytes = self.frida_session.read_bytes(address, 512)
            arch, mode = (CS_ARCH_X86, CS_MODE_64) if self.frida_session.arch == 'x64' else (CS_ARCH_X86, CS_MODE_32)
            md = Cs(arch, mode)
            disassembly_text = f"--- Disassembly from address 0x{address:X} ---\n\n"
            line_counter = 2
            for instruction in md.disasm(code_bytes, address):
                self.instruction_map[line_counter] = {'address': instruction.address, 'bytes': instruction.bytes}
                disassembly_text += f"0x{instruction.address:x}:\t{instruction.mnemonic}\t{instruction.op_str}\n"
                line_counter += 1
            self.disassembly_view.setText(disassembly_text)
            self.status_bar.showMessage(f"Jump to 0x{address:X} complete.", 4000)
        except Exception as e:
            self.disassembly_view.setText(f"--- FAILED TO READ MEMORY AT 0x{address:X} ---\n\n{e}")
            QMessageBox.critical(self, "Error", f"Failed to read memory at 0x{address:X}:\n{e}")

    def stop_analysis(self):
        if self.worker and self.thread and self.thread.isRunning():
            self.worker.stop()
            self.stop_button.setEnabled(False)

    def update_disassembly_view(self, text):
        self.disassembly_view.append(text)

    def on_analysis_finished(self, status):
        self.status_bar.showMessage(status, 5000)
        self.stop_button.setEnabled(False)

    def on_analysis_error(self, message):
        QMessageBox.critical(self, "Analysis Error", message)
        self.on_analysis_finished(f"Error: {message}")

    def closeEvent(self, event):
        self.stop_analysis()
        self.detach_from_process()
        event.accept()

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainApp()
    window.show()
    sys.exit(app.exec())
