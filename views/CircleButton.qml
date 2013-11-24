import QtQuick 2.1

// actually, circle ...
Rectangle {
    width: buttonSize
    height: buttonSize
    radius: buttonSize / 2

    property var mText: "Button"
    property var buttonSize: 96

    Text {
        anchors.centerIn: parent
        text: mText 
        font.bold: true
    }

    MouseArea {
        anchors.fill: parent
        onPressed: {
	    console.log("Button clicked!")
	}
	onReleased: {
	    parent.color = "white"
	}
    }
}
