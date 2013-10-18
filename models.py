#from PySide import QtCore
from PyQt4 import QtCore


class MusicModel(QtCore.QAbstractListModel):

    COLUMNS = ('music',)

    def __init__(self, parent):
        QtCore.QAbstractListModel.__init__(self, parent=parent)
        self.__music = []
        self.setRoleNames(dict(enumerate(MusicModel.COLUMNS)))

    def rowCount(self, parent=QtCore.QModelIndex()):
        return len(self.__music)

    def data(self, index, role):
        if index.isValid() and role == MusicModel.COLUMNS.index('music'):
            return self.__music[index.row()]
        return None

    def add(self, musicDetails):
        self.beginInsertRows(QtCore.QModelIndex(), len(self.__music),
                             len(self.__music))
        self.__users.append(musicDetails)
        self.endInsertRows()

    def delete(self, musicName, row):
        self.beginRemoveRows(QtCore.QModelIndex(), row, row)
        self.__music.pop(row)
        self.endRemoveRows()

    def populate(self):
        pass
        #for user in interface.ListUsers():
        #    self.__users.append(User(user, self))


class Music(QtCore.QObject):

    def __init__(self, path, parent):
        QtCore.QObject.__init__(self, parent=parent)
        self.__path = path
        self.__mane = None

    def __getPath(self):
        return self.__path

    def __setPath(self, path):
        self.__path = path

    def __getName(self):
        return self.__name

    def __setName(self, name):
        self.__name = name

    #changed = QtCore.Signal()
    changed = QtCore.pyqtSignal()

    """
    path = QtCore.Property(unicode, __getPath, __setPath, notify=changed)
    name = QtCore.Property(unicode, __getName, __setName, notify=changed)
    """

    path = QtCore.pyqtProperty(unicode, __getPath, __setPath, notify=changed)
    name = QtCore.pyqtProperty(unicode, __getName, __setName, notify=changed)
