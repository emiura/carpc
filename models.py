#from PySide import QtCore
from PyQt5 import QtCore


class MusicModel(QtCore.QAbstractListModel):

    PathRole = QtCore.Qt.UserRole + 1
    NameRole = QtCore.Qt.UserRole + 2

    _roles = {PathRole: 'path', NameRole: "name"}

    def __init__(self, parent):
        QtCore.QAbstractListModel.__init__(self, parent=parent)
        self._music = []

    def rowCount(self, parent=QtCore.QModelIndex()):
        return len(self._music)

    def data(self, index, role=QtCore.Qt.DisplayRole):
        try:
            music = self._musics[index.row()]
        except IndexError:
            return QVariant()

        if role == self.PathRole:
            return music.pach

        if role == self.NameRole:
            return music.name

        return QVariant()

    def roleNames(self):
        return self._roles


    def add(self, musicDetails):
        self.beginInsertRows(QtCore.QModelIndex(), len(self._music),
                             len(self._music))
        self._music.append(musicDetails)
        self.endInsertRows()

    def delete(self, musicName, row):
        self.beginRemoveRows(QtCore.QModelIndex(), row, row)
        self._music.pop(row)
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

    @QtCore.pyqtProperty('QString')
    def path(self):
        return self.__path

    @path.setter
    def path(self, path):
        self.__path = path

    @QtCore.pyqtProperty('QString')
    def name(self):
        return self.__name

    @name.setter
    def name(self, name):
        self.__name = name

    changed = QtCore.pyqtSignal()
