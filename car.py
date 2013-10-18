#!/usr/bin/env python

import sys

from PyQt4 import QtCore, QtGui, QtDeclarative

from controllers import Controller
from models import MusicModel


class CarView(QtDeclarative.QDeclarativeView):

    def __init__(self, parent=None):
        QtDeclarative.QDeclarativeView.__init__(self, parent)

        self.musicModel = MusicModel(self)
        self.musicModel.populate()

        self.controller = Controller(self)

        self.context = self.rootContext()

        self.context.setContextProperty('musicModel', self.musicModel)
        self.context.setContextProperty('controller', self.controller)

        self.setSource(QtCore.QUrl('views/CarPc.qml'))

        self.setResizeMode(QtDeclarative.QDeclarativeView.SizeRootObjectToView)
        self.setWindowTitle('CarPc player')


def start():

    app = QtGui.QApplication(sys.argv)

    locale = QtCore.QLocale.system()
    translator = QtCore.QTranslator()

    i18n_file = 'CarPc_' + locale.name() + '.qm'
    i18n_path = '/usr/share/carpc/views/i18n/'

    if (translator.load(i18n_file, i18n_path)):
        app.installTranslator(translator)

    view = CarView()
    view.show()
    app.exec_()


if __name__ == '__main__':
    start()
