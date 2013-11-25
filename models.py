from PyQt5 import QtCore


class MusicModel(QtCore.QAbstractListModel):

    PathRole = QtCore.Qt.UserRole + 1
    NameRole = QtCore.Qt.UserRole + 2

    _roles = {PathRole: 'path', NameRole: "name"}

    def __init__(self, parent):
        QtCore.QAbstractListModel.__init__(self, parent=parent)
        self._musics = []

    # music time
    def rowCount(self, parent=QtCore.QModelIndex()):
        return len(self._musics)

    # file name and path
    def data(self, index, role=QtCore.Qt.DisplayRole):
        try:
            music = self._musics[index.row()]
        except IndexError:
            return QVariant()

        if role == self.PathRole:
            return music.path

        if role == self.NameRole:
            return music.name

        return QVariant()

    def roleNames(self):
        return self._roles


    # add music to list
    def add(self, music):
        self.beginInsertRows(QtCore.QModelIndex(), len(self._musics),
                             len(self._musics))
        m = Music(music['path'], music['name'], self)
        self._musics.append(m)
        self.endInsertRows()

    # delete music from list
    def delete(self, musicName, row):
        self.beginRemoveRows(QtCore.QModelIndex(), row, row)
        self._musics.pop(row)
        self.endRemoveRows()

    # reset list
    def reset(self):
        self.beginResetModel()
        self._musics = []
        self.endResetModel()


class Music(QtCore.QObject):

    def __init__(self, path, name, parent):
        QtCore.QObject.__init__(self, parent=parent)
        self.__path = path
        self.__name = name

    # get  
    @QtCore.pyqtProperty('QString')
    def path(self):
        return self.__path

    # set
    @path.setter
    def path(self, path):
        self.__path = path

    # get
    @QtCore.pyqtProperty('QString')
    def name(self):
        return self.__name

    # set
    @name.setter
    def name(self, name):
        self.__name = name

    changed = QtCore.pyqtSignal()
