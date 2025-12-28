# reconstruction_dialog.py
from PyQt6.QtWidgets import QDialog, QVBoxLayout, QHBoxLayout, QLineEdit, QLabel, QPushButton, QMessageBox

class ReconstructionDialog(QDialog):
    """
    A dialog to get the Original Entry Point (OEP) from the user.
    """
    def __init__(self, default_oep: int, parent=None):
        super().__init__(parent)
        self.setWindowTitle("Process Reconstruction")

        layout = QVBoxLayout(self)
        info_label = QLabel("Enter the Original Entry Point (OEP) of the unpacked code.\nThis is required to correctly rebuild the import table.")
        self.oep_input = QLineEdit()
        self.oep_input.setPlaceholderText("Enter OEP as a hex address (e.g., 0x401000)")
        self.oep_input.setText(f"0x{default_oep:X}") # Pre-fill with module base as a suggestion

        button_layout = QHBoxLayout()
        self.ok_button = QPushButton("Reconstruct")
        self.cancel_button = QPushButton("Cancel")
        button_layout.addWidget(self.ok_button)
        button_layout.addWidget(self.cancel_button)

        layout.addWidget(info_label)
        layout.addWidget(self.oep_input)
        layout.addLayout(button_layout)

        self.ok_button.clicked.connect(self.accept)
        self.cancel_button.clicked.connect(self.reject)

    def get_oep(self) -> int | None:
        """
        Parses the hex string from the input and returns it as an integer.
        """
        oep_string = self.oep_input.text().strip()
        if not oep_string:
            return None
        try:
            return int(oep_string, 16)
        except ValueError:
            QMessageBox.critical(self, "Invalid Input", "The provided string is not a valid hex address.")
            return None