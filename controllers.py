#from PySide import QtCore
from PyQt5 import QtCore


class Controller(QtCore.QObject):

    def __init__(self, parent=None):
        QtCore.QObject.__init__(self, parent=parent)

    #@QtCore.Slot()
    @QtCore.pyqtSlot()
    def play(self):
        print('Play')

    #@QtCore.Slot()
    @QtCore.pyqtSlot()
    def pause(self):
        print('Pause')

    #@QtCore.Slot()
    @QtCore.pyqtSlot()
    def rewind(self):
        print('Rewind')

    #@QtCore.Slot()
    @QtCore.pyqtSlot()
    def forward(self):
        print('Forward')

    #@QtCore.Slot()
    @QtCore.pyqtSlot()
    def shuffle(self):
        print('Shuffle')

    #@QtCore.Slot()
    @QtCore.pyqtSlot()
    def repeat(self):
        print('Repeat')
