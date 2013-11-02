import os

from PyQt5 import QtCore


class Controller(QtCore.QObject):

    def __init__(self, parent):
        QtCore.QObject.__init__(self, parent=parent)
        self.musicModel = parent.musicModel

    @QtCore.pyqtSlot()
    def play(self):
        print('Play')

    @QtCore.pyqtSlot()
    def pause(self):
        print('Pause')

    @QtCore.pyqtSlot()
    def rewind(self):
        print('Rewind')

    @QtCore.pyqtSlot()
    def forward(self):
        print('Forward')

    @QtCore.pyqtSlot()
    def shuffle(self):
        print('Shuffle')

    @QtCore.pyqtSlot()
    def repeat(self):
        print('Repeat')

    @QtCore.pyqtSlot(str)
    def load(self, folder):
        print('Loading folder: {0}'.format(folder))
        for path, directories, files in os.walk(folder.replace('file://', '')):
            for f in files:
                name, ext = os.path.splitext(f)
                if ext in ['.mp3', '.wma', '.ogg', '.oga']:
                    self.musicModel.add({'path': path, 'name': name})
            break
