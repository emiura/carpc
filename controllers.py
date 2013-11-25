import os

from PyQt5 import QtCore


class Controller(QtCore.QObject):

    def __init__(self, parent):
        QtCore.QObject.__init__(self, parent=parent)
        self.musicModel = parent.musicModel

    @QtCore.pyqtSlot(str)
    # load musics from folder
    def load(self, folder):
        for path, directories, files in os.walk(folder.replace('file://', '')):
            for f in files:
                name, ext = os.path.splitext(f)
                if ext in ['.mp3', '.wma', '.ogg', '.oga']:
                    self.musicModel.add({'path': '{0}/{1}'.format(path, f),
                                         'name': name})
            #break

    @QtCore.pyqtSlot()
    # reset music
    def reset(self):
       self.musicModel.reset()

    @QtCore.pyqtSlot(str)
    # add music from db
    def add(self, music):
        music = music.replace('file://', '')
        path, f = os.path.split(music)
        name, ext = os.path.splitext(f)
        self.musicModel.add({'path': '{0}/{1}'.format(path, f), 'name': name})
