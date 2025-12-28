from PyQt6.QtCore import pyqtSignal
from PyQt6.QtWidgets import (
    QDialog, QVBoxLayout, QHBoxLayout, QLineEdit, QComboBox,
    QPushButton, QListWidget, QLabel, QDialogButtonBox
)

class SearchDialog(QDialog):
    """
    A dialog for initiating and displaying memory search results.
    Emits a signal when a result address is selected by the user.
    """
    # Signal: emits the memory address (int) of the selected result
    result_selected = pyqtSignal(int)

    def __init__(self, parent=None, is_attached=False):
        super().__init__(parent)
        self.setWindowTitle("Find Memory Pattern")
        self.setGeometry(200, 200, 500, 400)

        # --- Layouts and Widgets ---
        layout = QVBoxLayout(self)
        
        # Input section
        input_layout = QHBoxLayout()
        self.pattern_input = QLineEdit()
        self.pattern_input.setPlaceholderText("Enter pattern...")
        self.search_type_combo = QComboBox()
        self.search_type_combo.addItems(["Text (UTF-8)", "Hex String"])
        
        input_layout.addWidget(QLabel("Pattern:"))
        input_layout.addWidget(self.pattern_input)
        input_layout.addWidget(QLabel("Type:"))
        input_layout.addWidget(self.search_type_combo)

        # Results list
        self.results_list = QListWidget()
        self.results_list.itemDoubleClicked.connect(self.on_result_selected)

        # Buttons
        self.button_box = QDialogButtonBox(QDialogButtonBox.StandardButton.Ok | QDialogButtonBox.StandardButton.Cancel)
        self.search_button = self.button_box.button(QDialogButtonBox.StandardButton.Ok)
        self.search_button.setText("Search")
        
        self.search_button.clicked.connect(self.accept) # Accept the dialog to start search
        self.button_box.rejected.connect(self.reject)

        # --- Assembly ---
        layout.addLayout(input_layout)
        layout.addWidget(QLabel("Search Results (double-click to jump):"))
        layout.addWidget(self.results_list)
        layout.addWidget(self.button_box)

        # --- Initial State ---
        self.search_button.setEnabled(is_attached)
        if not is_attached:
            self.pattern_input.setText("Attach to a process to enable search.")
            self.pattern_input.setDisabled(True)

    def get_search_parameters(self) -> tuple[str, str] | None:
        """Returns the user's input."""
        pattern = self.pattern_input.text()
        search_type = self.search_type_combo.currentText()
        if pattern:
            return pattern, search_type
        return None

    def add_result(self, address: int):
        """Safely adds a found address to the results list."""
        self.results_list.addItem(f"0x{address:X}")

    def on_result_selected(self, item):
        """When a result is double-clicked, parse the address and emit it."""
        address = int(item.text(), 16)
        self.result_selected.emit(address)

    def clear_results(self):
        self.results_list.clear()