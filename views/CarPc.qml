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
    property real volume: 0.5
    property real tmpVolume: 0.0

    MediaPlayer {
        id: player
        volume: volume
    }

    function load(folder) {
        controller.load(folder)
        playList.currentIndex = 1
        //console.log(playList.count)
        //console.log(playList.currentItem.data.path)
        player.source = playList.currentItem.data.path
        player.play()
    }

    function togglePlay() {
        console.log(player.playbackState)
        if (player.playbackState == 0) {
            player.play()
        }
        if (player.playbackState > 0) {
            player.pause()
        }
    }

    function mute() {
        if (player.volume != 0) {
            tmpVolume = player.volume
            player.volume = 0.0
        } else { 
            player.volume = tmpVolume
        }
    }

    FileDialog {
        id: fileDialog
        title: "Select a folder to load music from"
        selectFolder: true
        nameFilters: [ "Music files (*.mp3 *.wav *.ogg)" ]
        onAccepted: load(folder) 
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
                        onClicked: mute()
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
                    mText: "Play"
                    buttonSize: 128
                    MouseArea {
                        anchors.fill: parent
                        onClicked: togglePlay()
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

    ListView {
        id: playList
        clip: true
        model: musicModel
        delegate: Text {
           property variant data: model
           text: path
        }
    }
}
