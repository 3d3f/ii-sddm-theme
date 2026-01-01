// Adapted from syrupderg's win11-sddm-theme
// Modified by 3d3f for "ii-sddm-theme"

import "../"
import QtQuick
import QtQuick.Controls

FocusScope {
    id: falsePass

    signal retry()
    width: Math.max(errorMessage.implicitWidth, 500)
    height: columnLayout.height

    Column {
        id: columnLayout
        spacing: 30
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        

        Text {
            id: errorMessage
            text: "The password is incorrect. Try again."
            color: "white"
            font.pixelSize: 13 
            font.family: Appearance.waffleFont
            renderType: Text.QtRendering
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }

        Item {
            width: 130
            height: 38
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                id: buttonBackground
                anchors.fill: parent
                color: okButton.hovered ? "#50FFFFFF" : "#30FFFFFF"
                radius: 6
                border.color: "white"
                border.width: 1.5

                Behavior on color { ColorAnimation { duration: 120 } }
            }

            // Area interattiva del Bottone
            Button {
                id: okButton
                anchors.fill: parent
                focus: true
                hoverEnabled: true
                
                background: null

                contentItem: Text {
                    text: "OK"
                    color: "white"
                    font.family: Appearance.waffleFont
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    renderType: Text.QtRendering
                }

                onClicked: {
                    falsePass.retry();
                }
                
                Keys.onReturnPressed: {
                    falsePass.retry();
                }
                
                Keys.onEnterPressed: {
                    falsePass.retry();
                }
            }
        }
    }

    onVisibleChanged: {
        if (visible) {
            okButton.forceActiveFocus();
        }
    }
}