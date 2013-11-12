import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.0
import QtMultimedia 5.0
import QtQuick.Window 2.0
import QtQuick.LocalStorage 2.0
import "database.js" as Db

Rectangle {
    id: window
    width: 800
    height: 480

    property int margin: 12
    property real tmpVolume: 0.0
    property bool keepPlaying: false
    property bool repeat: false


    Component.onCompleted: {
        Db.initialize()
        console.debug("INITIALIZED")
        if (Db.getSetting("initialized") !== "true") {
            // initialize settings
            console.debug("reset settings")
            Db.setSetting("initialized", "true")
            Db.setSetting("volume", "0.5")
            Db.setSetting("music", "false")
        }
        player.volume = Db.getSetting("volume")
        if (Db.getSetting("music") !== "false") {
            player.source = Db.getSetting("music")
            controller.add(Db.getSetting("music"))
            setDisplayText(Db.getSetting("music"))
        }
    }

    MediaPlayer {
        id: player
        volume: 0.0
        onStatusChanged: {
            Db.setSetting("volume", player.volume)
            Db.setSetting("music", player.source)
            if (status == MediaPlayer.EndOfMedia) {
               console.log("EndOfMedia")
               if (repeat == true) {
                   console.log("Repeat true")
                   player.play()
                   return
               }
               if (keepPlaying == true) {
                   console.log("keepPlaying true")
                   nextMusic()
               }
            }
        }
        onPositionChanged: {
            musicText.text = Math.floor((player.position/1000) / 60).toString() + ":" + (
                        Math.floor((player.position/1000) % 60)<10 ? "0"+Math.floor((player.position/1000) % 60).toString() :
                                                          Math.floor((player.position/1000) % 60).toString())
            musicText.text += " / "
            musicText.text += Math.floor((player.duration/1000) / 60).toString() + ":" + (
                        Math.floor((player.duration/1000) % 60)<10 ? "0"+Math.floor((player.duration/1000) % 60).toString() :
                                                          Math.floor((player.duration/1000) % 60).toString())
            setDisplayText(playList.currentItem.data.path)
        }
    }

    function toggleRepeat() {
        console.log("toggleRepeat()")
        if (repeat == false) {
            repeat = true
            keepPlaying = false 
            setDisplayText("Repeat ON")
        } else {
            repeat = false
            keepPlaying = true
            setDisplayText("Repeat OFF")
        }
    }

    function setDisplayText(text) {
        console.log("setDisplayText()")
        displayText.text = text
    }

    function nextMusic() {
        console.log("nextMusic()")
        playList.currentIndex = playList.currentIndex + 1
        console.log(playList.currentIndex)
        player.source = playList.currentItem.data.path
        player.play()
    }

    function previousMusic() {
        console.log("previousMusic()")
        console.log(playList.currentIndex)
        if (playList.currentIndex == 0 ) {
            console.log("No previous music.")
        } else {
            playList.currentIndex = playList.currentIndex - 1
            player.source = playList.currentItem.data.path
            player.play()
        }
    }

    function volumeIncrease() {
        // Check if get max of 1.0 and set a message
        player.volume = player.volume + 0.1
        setDisplayText("Volume " + player.volume * 100 + "%")
    }

    function volumeDecrease() {
        // Check if get muted of 0.0 and set a message
        player.volume = player.volume - 0.1
        setDisplayText("Volume " + player.volume * 100 + "%")
    }

    function load(folder) {
        console.log("load()")
        controller.reset()
        controller.load(folder)
        playList.currentIndex = 0
        setDisplayText("Loaded " + playList.count + " musics.")
        player.source = playList.currentItem.data.path
        keepPlaying = true
        player.play()
        togglePlayButton.mText = "Pause"
    }

    function togglePlay() {
        console.log("togglePlay()")
        if (player.playbackState == 1){
            player.pause()
            togglePlayButton.mText = "Play"
        }
        else{
            player.play()
            keepPlaying = true
            togglePlayButton.mText = "Pause"
        }
    }

    function mute() {
        console.log("mute()")
        if (player.volume != 0) {
            tmpVolume = player.volume
            player.volume = 0.0
            setDisplayText("MUTE")
        } else { 
            player.volume = tmpVolume
            setDisplayText("Volume " + player.volume * 100 + "%")
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
                        onClicked: volumeIncrease()
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
                        onClicked: volumeDecrease() 
                    }
                }
                CircleButton {
                    mText: "Repeat"
                    buttonSize: 72
                    MouseArea {
                        anchors.fill: parent
                        onClicked: toggleRepeat()
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
                        onClicked: closeDialog.visible = true
                    }
                }
            }

            Rectangle {
                id: closeDialog 
                width: 300
                height: 150
                visible: false
                color: "orange"
                border.color: "black" 
                anchors.centerIn: parent

                Column {
                    anchors.centerIn: parent
                    spacing: 24
                    
                    Text {
                        text: "Did you really want to quit?"
                        width: 150
                        font.bold: true
                        horizontalAlignment: Text.Center
                    }

                    Row {
                        spacing: 6
                        anchors.right: parent.right

                        Button {
                            text: "Yes"
                            height: 27
                            onClicked: {
                                closeDialog.visible = false
                                Qt.quit()
                            }
                        }

                        Button {
                            text: "Cancel"
                            height: 27
                            onClicked: closeDialog.visible = false
                        }
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

            Column {
                anchors.centerIn: parent

                Text {
                    id: displayText
                    //anchors.centerIn: parent
                    text: "Not playing"
                    width: 96
                    font.bold: true
                    horizontalAlignment: Text.Center
                }

                Text {
                    id: musicText
                    //anchors.centerIn: parent
                    text: ""
                    width: 96
                    font.bold: true
                    horizontalAlignment: Text.Center
                }
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
                        onClicked: previousMusic()
                    }
                }
                CircleButton {
                    id: togglePlayButton
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
                        onClicked: nextMusic()
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
