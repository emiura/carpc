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
                anchors.centerIn: parent
                text: "Do you really want to quit?"
                font.pointSize: 18
                horizontalAlignment: Text.center
            }
            
            Row
            {
                Button
                {
                    text: "Yes"
                    height: 80
                    onClicked:
                    {
                        Qt.quit()
                        controller.quitProgram()
                    }
               }
               Button
               {
                    text: "No"
                    height: 80
                    onClicked:
                    {
                        dialogComponent.destroy()
                    }
                }
            }
        }
    }
}
