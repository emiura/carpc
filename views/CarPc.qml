import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.0
import QtMultimedia 5.0
import QtQuick.Window 2.0

// main
Rectangle 
{
    id: window
    width: 800
    height: 480

    property int margin: 12
    property real tmpVolume: 0.0
    property bool keepPlaying: false
    property bool repeat: false
    property bool random: false
    property int index: 0
    property real volume: 0.0

    Database
    {
        id: musicdb
        width: 800
        height: 480
    }   

    // start
    Component.onCompleted: 
    {
        musicdb.initialize()
        // load from db
        player.volume = musicdb.getSetting("volume")
        repeat = musicdb.getSetting("repeat")
        random = musicdb.getSetting("random")
        index = musicdb.getSetting("index")
        musicdb.getPlaylist(playList)
        playList.currentIndex = index
        setDisplayText("Loaded " + playList.count + " musics.")
        player.source = playList.currentItem.data.path
        keepPlaying = true
        player.play()
        togglePlayButton.mText = "Pause"

    }

    // save database
    function save_all()
    {
        volume = player.volume
        musicdb.setSetting("volume", volume)
        musicdb.setSetting("repeat", repeat)
        musicdb.setSetting("random", random)
        musicdb.setSetting("index", playList.currentIndex)
        console.debug("debug",playList)
        musicdb.setPlaylist(playList)
    }

    // new media player
    MediaPlayer 
    {
        id: player
        volume: 0.0
        
        onStatusChanged: 
        {
            musicdb.setSetting("volume", player.volume)
            musicdb.setSetting("music", player.source)
            if (status == MediaPlayer.EndOfMedia) 
            {
                console.log("EndOfMedia")
                if (random == true) 
                {
                  console.log("random true")
                    player.shuffle
               }     

                if (repeat == true) 
                {
                    console.log("Repeat true")
                    player.play()
                    return
                }
                if (keepPlaying == true) 
                {
                    console.log("keepPlaying true")
                    nextMusic()
                }
            }
        }

       // updates timestamp
        onPositionChanged: 
        {
            musicText.text = Math.floor((player.position/1000) /
60).toString() + ":" + ( Math.floor((player.position/1000) % 60)<10 ?
"0"+Math.floor((player.position/1000) % 60).toString() :
Math.floor((player.position/1000) % 60).toString())
            musicText.text += " / "
            musicText.text += Math.floor((player.duration/1000) /
60).toString() + ":" + ( Math.floor((player.duration/1000) % 60)<10 ?
"0"+Math.floor((player.duration/1000) % 60).toString() :
Math.floor((player.duration/1000) % 60).toString())
            setDisplayText(playList.currentItem.data.name)
        }
    }

    // repeat on/off
    function toggleRepeat() 
    {
        console.log("toggleRepeat()")
        if (repeat == false) 
        {
            repeat = true
            keepPlaying = false 
            setDisplayText("Repeat ON")
        } 
        else 
        {
            repeat = false
            keepPlaying = true
            setDisplayText("Repeat OFF")
        }
    }

    // random on/off
    function toggleRandom() 
    {
        console.log("toggleRandom()")
        if (random == false) 
        {
            random = true
            setDisplayText("Random ON")
        } 
        else 
        {
            random = false
            setDisplayText("Random OFF")
        }
    }


    // show display
    function setDisplayText(text) 
    {
        console.log("setDisplayText()")
        displayText.text = text
    }

    // next
    function nextMusic() 
    {
        console.log("nextMusic()")
        playList.currentIndex = playList.currentIndex + 1
        console.log(playList.currentIndex)
        player.source = playList.currentItem.data.path
        player.play()
    }

    // previous
    function previousMusic() 
    {
        console.log("previousMusic()")
        console.log(playList.currentIndex)
        if (playList.currentIndex == 0 ) 
        {
            console.log("No previous music.")
        } 
        else 
        {
            playList.currentIndex = playList.currentIndex - 1
            player.source = playList.currentItem.data.path
            player.play()
        }
    }

    // increase volume
    function volumeIncrease() 
    {
        // Check if get max of 1.0 and set a message
        player.volume = player.volume + 0.1
        setDisplayText("Volume " + player.volume * 100 + "%")
    }

    // decrease volume
    function volumeDecrease() 
    {
        // Check if get muted of 0.0 and set a message
        player.volume = player.volume - 0.1
        setDisplayText("Volume " + player.volume * 100 + "%")
    }

    // load files
    function load(folder) 
    {
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

    // file load dialog window
    FileDialog 
    {
        id: fileDialog
        title: "Select a folder to load music from"
        selectFolder: true
        nameFilters: [ "Music files (*.mp3 *.wma *.ogg)" ]
        onAccepted: load(folder) 
    }

    // toggle play plause
    function togglePlay() 
    {
        console.log("togglePlay()")
        if (player.playbackState == 1)
        {
            player.pause()
            togglePlayButton.mText = "Play"
        }
        else 
        {
            player.play()
            keepPlaying = true
            togglePlayButton.mText = "Pause"
        }
    }

    // mute/unmute audio
    function mute() {
        console.log("mute()")
        if (player.volume != 0) 
        {
            tmpVolume = player.volume
            player.volume = 0.0
            setDisplayText("MUTE")
        } 
        else 
        { 
            player.volume = tmpVolume
            setDisplayText("Volume " + player.volume * 100 + "%")
        }
    }


    // main player
    Column 
    {

        /** Header
 * ***********************************************************/
        Rectangle 
        {
            id: header
            width: 800
            height: 160 
            color: "gray"

           // vol, mute, random, repeat, usb, exit
            Row 
            {
                anchors.centerIn: parent
                spacing: 12

                // vol-
                CircleButton 
                {
                    mText: "Volume -"
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea 
                    {
                        anchors.fill: parent
                        onPressed: 
                        {
                           volumeDecrease() 
                           parent.color = "brown" 
                     }
                     onReleased: 
                        {
                          parent.color = "white"
                     }
         
                    }
                }

                // mute
                CircleButton 
                {
                    mText: "Mute"
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea 
                    {
                        anchors.fill: parent
                        onPressed: 
                        {
                         mute()
                         parent.color = "brown"
                     }   
                     onReleased:
                        {
                         parent.color = "white"
                     }
                    }
                }

                // vol+
                CircleButton 
                {
                    mText: "Volume +"
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea 
                    {
                        anchors.fill: parent
                        onPressed: 
                        {
                         volumeIncrease() 
                         parent.color = "brown" 
                     }
                     onReleased: 
                        {
                          parent.color = "white"
                     }
                    }
                }
 
                // repeat
                CircleButton 
                {
                    mText: "Repeat"
                    buttonSize: 72
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea 
                    {
                        anchors.fill: parent
                        onPressed: 
                        { 
                           toggleRepeat()
                           parent.color = "brown"
                        } 
                        onReleased: 
                        {
                           parent.color = "white"
                        }
                    }
                }

                // random
                CircleButton 
                {
                    mText: "Random"
                    buttonSize: 72
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea 
                    {
                        anchors.fill: parent
                        onPressed: 
                        {
                           toggleRandom()
                           parent.color = "brown"
                        }
                        onReleased: 
                        {
                           parent.color = "white"
                        }
                    }
                }


              // file load
                CircleButton 
                {
                    mText: "USB"
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea 
                    {
                        anchors.fill: parent
                        onPressed: 
                        {
                           fileDialog.open()
                        }
                        onReleased: 
                        {
                           parent.color = "white"
                        }
                    }
                }

                // quit
                CircleButton 
                {
                    mText: "Exit"
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea 
                    {
                        anchors.fill: parent
                        onPressed: 
                        {
                           parent.color = "brown"
                        }
                        onReleased: 
                        {
                           save_all()
                           Qt.createComponent("Dialog.qml").createObject(window,{});
                           parent.color = "white" 
                        }
                    }
                }
            }
        }
     
        // status display 
        Rectangle 
        {
            id: display 
            width: 800
            height: 160
            color: "lightgray"
           anchors.horizontalCenter: parent.horizontalCenter

            Column 
            {
                anchors.centerIn: parent

                Text 
                {
                    id: displayText
                    text: "Not playing"
                    width: 96
                    font.pointSize: 18
                    font.bold: true
                    horizontalAlignment: Text.Center
                }

                Text 
                {
                    id: musicText
                    text: ""
                    width: 96
                    font.pointSize: 48
                    font.bold: true
                    horizontalAlignment: Text.Center
                }
            }

            Slider 
            {
               id: slider

               anchors.bottom: parent.bottom
               anchors.horizontalCenter: parent.horizontalCenter
               width: parent.width - 100
               maximumValue: player.duration
               stepSize: 1000

               onPressedChanged: 
               {
                  if (!pressed)
                  {
                     player.seek(value)
                  }
               }

               Binding 
               {
                  target: slider
                  property: "value"
                  value: player.position
                  when: !slider.pressed
               }
            }

        }
     
        // rev/play/next
        Rectangle 
        {
            id: footer 
            width: 800
            height: 160
            color: "gray"

            Row 
            {
                anchors.centerIn: parent
                spacing: 12
         
              // prev
                CircleButton 
                {
                    mText: "Previous"
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea 
                    {
                        anchors.fill: parent
                        onPressed: 
                        {
                         previousMusic()
                          parent.color = "brown"
                     }
                     onReleased: 
                        {
                         parent.color = "white"
                     }
                    }
                }

                // play-pause
                CircleButton 
                {
                    id: togglePlayButton
                    mText: "Play"
                    anchors.verticalCenter: parent.verticalCenter
                    buttonSize: 128
                    MouseArea 
                    {
                        anchors.fill: parent
                        onPressed: 
                        { 
                         togglePlay()
                         parent.color = "brown"
                     }
                     onReleased: 
                        {
                         parent.color = "white"
                     }
                    }
                }

                // next
                CircleButton 
                {
                    mText: "Next"
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea 
                    {
                        anchors.fill: parent
                        onPressed: 
                        {
                         nextMusic()
                          parent.color = "brown"
                     }
                     onReleased: 
                        {
                         parent.color = "white"
                     }

                    }
                }
            }
        }
    }

    // playlist
    ListView 
    {
        id: playList
        clip: true
        model: musicModel
        delegate: Text 
        {
           property variant data: model
           text: path
        }
    }
}
