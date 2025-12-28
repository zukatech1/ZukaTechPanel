from PyQt6.QtWidgets import QDialog, QVBoxLayout, QHBoxLayout, QLineEdit, QLabel, QPushButton, QMessageBox

class PatchDialog(QDialog):
    def __init__(self, address: int, original_bytes: bytes, parent=None):
        super().__init__(parent)
        self.setWindowTitle(f"Patch Memory at 0x{address:X}")

        self.original_bytes_hex = original_bytes.hex(' ').upper()

        # --- Widgets ---
        layout = QVBoxLayout(self)
        info_label = QLabel(f"Original Bytes: {self.original_bytes_hex}")
        self.hex_input = QLineEdit()
        self.hex_input.setPlaceholderText("Enter new hex bytes (e.g., 90 90 90)")
        
        button_layout = QHBoxLayout()
        self.patch_button = QPushButton("Patch")
        self.cancel_button = QPushButton("Cancel")
        button_layout.addWidget(self.patch_button)
        button_layout.addWidget(self.cancel_button)

        # --- Assembly ---
        layout.addWidget(info_label)
        layout.addWidget(self.hex_input)
        layout.addLayout(button_layout)

        # --- Connections ---
        self.patch_button.clicked.connect(self.accept)
        self.cancel_button.clicked.connect(self.reject)

    def get_patch_bytes(self) -> bytes | None:
        """
        Parses the hex string from the input field and returns it as a bytes object.
        Returns None if the hex is invalid.
        """
        hex_string = self.hex_input.text().replace(" ", "")
        if not hex_string:
            return None
        try:
            return bytes.fromhex(hex_string)
        except ValueError:
            QMessageBox.critical(self, "Invalid Input", "The provided string is not a valid hex pattern.")
            return None