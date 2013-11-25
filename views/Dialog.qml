import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.0
import QtQuick.Window 2.0
 
Item 
{
    id: dialogComponent
    anchors.fill: parent
   
    Rectangle 
    {
        anchors.fill: parent
        id: overlay
        color: "#000000"
        opacity: 0.6
        MouseArea 
        {
            anchors.fill: parent
        }
    }
   
    Rectangle 
    {
        id: dialogWindow
        width: 800
        height: 480
        anchors.centerIn: parent
        Column
        { 
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            Text 
            {
                text: "Do you really want to quit?"
                font.pointSize: 18
                width: 800
                height: 50
                horizontalAlignment: Text.AlignHCenter
            }
            
            Row
            {
                spacing: 10
                Button
                {
                    text: "Yes"
                    width: 80
                    height: 40
                    onClicked:
                    {
                        Qt.quit()
                        controller.quitProgram()
                    }
               }
               Button
               {
                    text: "No"
                    width: 80
                    height: 40
                    onClicked:
                    {
                        dialogComponent.destroy()
                    }
                }
            }
        }
    }
}
