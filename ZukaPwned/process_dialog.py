# process_dialog.py
import psutil
from PyQt6.QtWidgets import QDialog, QListWidget, QListWidgetItem, QPushButton, QVBoxLayout, QLineEdit

class ProcessDialog(QDialog):
    """
    A dialog window that lists running processes and allows the user to
    select one. It emits a signal with the selected process ID (PID).
    """
    def __init__(self, parent=None):
        super().__init__(parent)
        self.setWindowTitle("Attach to Process")
        self.setGeometry(300, 300, 400, 500)

        self.layout = QVBoxLayout(self)

        self.filter_input = QLineEdit(self)
        self.filter_input.setPlaceholderText("Filter processes by name...")
        self.filter_input.textChanged.connect(self.filter_processes)

        self.process_list_widget = QListWidget(self)
        
        self.attach_button = QPushButton("Attach", self)
        self.attach_button.setEnabled(False)
        self.attach_button.clicked.connect(self.accept)

        self.layout.addWidget(self.filter_input)
        self.layout.addWidget(self.process_list_widget)
        self.layout.addWidget(self.attach_button)

        self.process_list_widget.itemSelectionChanged.connect(self.on_selection_changed)
        
        self.all_processes = []
        self.populate_processes()

    def populate_processes(self):
        """
        Uses psutil to get all running processes and adds them to the list.
        """
        self.process_list_widget.clear()
        self.all_processes = sorted(
            [p for p in psutil.process_iter(['pid', 'name']) if p.info['name']],
            key=lambda p: p.info['name'].lower()
        )
        self.filter_processes()


    def filter_processes(self):
        """
        Filters the process list based on the text in the filter input.
        """
        filter_text = self.filter_input.text().lower()
        self.process_list_widget.clear()
        for p in self.all_processes:
            if filter_text in p.info['name'].lower():
                item = QListWidgetItem(f"{p.info['name']} (PID: {p.info['pid']})")
                item.setData(1, p.info['pid']) # Store PID in a custom data role
                self.process_list_widget.addItem(item)

    def on_selection_changed(self):
        self.attach_button.setEnabled(len(self.process_list_widget.selectedItems()) > 0)

    def get_selected_pid(self) -> int | None:
        """
        Returns the PID of the selected process.
        """
        selected_items = self.process_list_widget.selectedItems()
        if selected_items:
            return selected_items[0].data(1)
        return None