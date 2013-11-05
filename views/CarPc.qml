import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.0
import QtMultimedia 5.0
import QtQuick.Window 2.0

Rectangle {
    id: window
    width: 800
    height: 480

    property int margin: 12

    MediaPlayer {
        id: player
        volume: 0.5 
    }

    function play(music) {
        player.source = music 
        player.play()
    }

    FileDialog {
        id: fileDialog
        title: "Select a folder to load music from"
        selectFolder: true
        nameFilters: [ "Music files (*.mp3 *.wav *.ogg)" ]
        onAccepted: controller.load(folder)
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


    Column {

        /** Header ***********************************************************/
        Rectangle {
            id: header
            width: 800
            height: 160 
            color: "red"

            Row {
                anchors.centerIn: parent
                spacing: 12
                CircleButton {
                    mText: "Volume +"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: console.log("Button Plus clicked!")
                    }
                }
                CircleButton {
                    mText: "Mute"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: console.log("Button Mute clicked!")
                    }
                }
                CircleButton {
                    mText: "Volume -"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: console.log("Button Minus clicked!")
                    }
                }
                CircleButton {
                    mText: "Repeat"
                    buttonSize: 72
                    MouseArea {
                        anchors.fill: parent
                        onClicked: console.log("Button Repeat clicked!")
                    }
                }
                CircleButton {
                    mText: "Random"
                    buttonSize: 72
                    MouseArea {
                        anchors.fill: parent
                        onClicked: console.log("Button Random clicked!")
                    }
                }
                CircleButton {
                    mText: "USB"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: fileDialog.open()
                    }
                }
                CircleButton {
                    mText: "Exit"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: console.log("Button Exit clicked!")
                    }
                }
            }
        }
     
        /** Display **********************************************************/
        Rectangle {
            id: display 
            width: 800
            height: 160
            color: "green"

            Text {
                id: displayText
                anchors.centerIn: parent
                text: "Not playing"
                width: 96
                font.bold: true
                horizontalAlignment: Text.Center
            }
        }
     
        /** Footer ***********************************************************/
        Rectangle {
            id: footer 
            width: 800
            height: 160
            color: "blue"

            Row {
                anchors.centerIn: parent
                spacing: 12
                CircleButton {
                    mText: "Previous"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: console.log("Button Prevous clicked!")
                    }
                }
                CircleButton {
                    mText: "Random"
                    buttonSize: 128
                    MouseArea {
                        anchors.fill: parent
                        onPressed:  { player.play() }
                    }
                }
                CircleButton {
                    mText: "Next"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: console.log("Button Next clicked!")
                    }
                }
            }
        }
    }

    /**
    ToolBar {
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

    Component {
        id: playListDelegate

        Rectangle {
            width: parent.width
            height: 32
            color: ((index % 2 == 0) ? "#808080": "#999999")

            Row {
                spacing: 4
                anchors.left: parent.left
                anchors.leftMargin: 4

                Text {
                    text: name
                    anchors.verticalCenter: parent.verticalCenter
                    color: "black"
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                   play(path)
                }
            }
        }
    }

    Rectangle {
        y: toolbar.height
        width: parent.width
        height: parent.height - toolbar.height
        color: "lightsteelblue"
        ListView {
            width: parent.width
            height: parent.height
            clip: true
            model: musicModel
            delegate: playListDelegate
        }
    }
    **/
}
