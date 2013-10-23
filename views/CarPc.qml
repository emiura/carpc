import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.0
import QtMultimedia 5.0
import QtQuick.Window 2.0

ApplicationWindow {
    title: qsTr("CarPc")
    width: 800
    height: 480

    MediaPlayer {
        id: player
        volume: (slider.value - slider.minimumValue) / (slider.maximumValue - slider.minimumValue)
    }

    function play(source) {
        player.source = source
        player.play()
    }

    FileDialog {
        id: fileDialog
        nameFilters: [ "Music files (*.mp3 *.wav *.ogg)" ]
        onAccepted: play(fileUrl)
    }

    Action {
        id: openAction
        text: "&Open"
        shortcut: "Ctrl+O"
        iconSource: "images/folder-visiting.png"
        onTriggered: fileDialog.open()
        tooltip: "Open a music"
    }

    Action {
        id: playAction
        text: "&Play"
        shortcut: "Ctrl+P"
        iconSource: "images/media-playback-start.png"
        onTriggered: player.play()
        tooltip: "Play music"
    }

    Action {
        id: pauseAction
        text: "Pa&use"
        shortcut: "Ctrl+U"
        iconSource: "images/media-playback-pause.png"
        onTriggered: player.pause()
        tooltip: "Plause music"
    }

    Action {
        id: forwardAction
        text: "&Forward"
        shortcut: "Ctrl+F"
        iconSource: "images/media-seek-forward.png"
        onTriggered: player.seek(10)
        tooltip: "Forward music"
    }

    Action {
        id: backwardAction
        text: "&Backward"
        shortcut: "Ctrl+B"
        iconSource: "images/media-seek-backward.png"
        onTriggered: player.seek(-10)
        tooltip: "Backward music"
    }

    Action {
        id: repeatAction
        text: "&Repeat"
        shortcut: "Ctrl+R"
        iconSource: "images/media-playlist-repeat.png"
        //onTriggered:
        tooltip: "Repeat music"
    }

    Action {
        id: shuffleAction
        text: "&Shuffle"
        shortcut: "Ctrl+S"
        iconSource: "images/media-playlist-shuffle.png"
        //onTriggered:
        tooltip: "Shuffle music"
    }

    toolBar: ToolBar {
        id: toolbar
        RowLayout {
            id: toolbarLayout
            spacing: 12
            width: parent.width
            ToolButton { action: openAction }
            ToolButton { action: playAction }
            ToolButton { action: pauseAction }
            ToolButton { action: backwardAction }
            ToolButton { action: forwardAction }
            ToolButton { action: repeatAction }
            ToolButton { action: shuffleAction }
            Item { Layout.fillWidth: true }
            Image { source: "images/audio-volume-high-panel.png" }
            Slider {
                id: slider
                value: 0.5
                width: 100
            }
        }
    }

    menuBar: MenuBar {
        Menu {
            title: "&File"
            MenuItem { action: openAction }
            MenuItem {
                text: "Close"
                shortcut: "Ctrl+Q"
                onTriggered: Qt.quit()
            }
        }
        Menu {
            title: "&Controls"
            MenuItem { action: playAction }
            MenuItem { action: pauseAction }
            MenuItem { action: forwardAction }
            MenuItem { action: backwardAction }
            MenuItem { action: repeatAction }
            MenuItem { action: shuffleAction }
        }
    }
}
