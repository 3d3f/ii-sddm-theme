// Adapted from end-4's Hyprland dotfiles (https://github.com/end-4/dots-hyprland)
// Modified by 3d3f for "ii-sddm-theme" (2025)

import Qt5Compat.GraphicalEffects
import QtQuick
import "../"


Item {
    id: sessionLockedContainer

    property alias text: sessionLockedText.text
    property color backgroundColor: Colors.secondary_container
    property color textColor: Colors.on_secondary_container
    property color shadowColor: Colors.colShadow

    visible: text !== ""
    width: sessionLockedBox.width
    height: sessionLockedBox.height
    z: 10

    DropShadow {
        source: sessionLockedBox
        anchors.fill: sessionLockedBox
        horizontalOffset: 0
        verticalOffset: 2
        radius: 12
        samples: radius * 2 + 1
        color: shadowColor
        transparentBorder: true
    }

    Rectangle {
        id: sessionLockedBox

        radius: 12
        color: backgroundColor
        anchors.horizontalCenter: parent.horizontalCenter
        implicitWidth: sessionLockedRow.width + 34
        implicitHeight: sessionLockedRow.height + 14

        Row {
            id: sessionLockedRow

            anchors.centerIn: parent
            spacing: 4

            Text {
                id: lockIcon

                font.family: "Material Symbols Outlined"
                font.pixelSize: 20
                text: "lock"
                color: textColor
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: sessionLockedText

                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                renderType: Text.NativeRendering
                color: textColor
                font.family: Appearance.font_family_expressive
                font.pixelSize: 17
                font.weight: Font.Normal
                style: Text.Raised
                styleColor: Colors.colShadow
                anchors.verticalCenter: parent.verticalCenter
            }

        }

    }

}
