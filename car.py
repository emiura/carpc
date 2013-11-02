#!/usr/bin/env python

import sys

from PyQt5 import QtCore, QtQuick, QtGui, QtQml, QtWidgets

from controllers import Controller
from models import MusicModel


class CarView(QtQuick.QQuickView):

    def __init__(self, parent=None):
        QtQuick.QQuickView.__init__(self, parent)

        self.musicModel = MusicModel(self)

        self.controller = Controller(self)

        self.context = self.rootContext()
        self.context.setContextProperty('musicModel', self.musicModel)
        self.context.setContextProperty('controller', self.controller)

        self.setSource(QtCore.QUrl('views/CarPc.qml'))
        self.setResizeMode(QtQuick.QQuickView.SizeRootObjectToView)


def start():

    app = QtWidgets.QApplication(sys.argv)

    view = CarView() 
    view.show()
    app.exec_()


if __name__ == '__main__':
    start()
