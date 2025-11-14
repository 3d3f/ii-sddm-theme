// Adapted from end-4's Hyprland dotfiles (https://github.com/end-4/dots-hyprland)
// Modified by 3d3f for "ii-sddm-theme" (2025)
import Qt5Compat.GraphicalEffects
import QtQuick
import "../"


Item {
    id: quoteContainer

    property alias text: quoteStyledText.text
    property color backgroundColor: Colors.secondary_container
    property color textColor: Colors.on_secondary_container
    property color shadowColor: Colors.colShadow

    visible: text !== ""
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottomMargin: 0
    z: 10

    DropShadow {
        source: quoteBox
        anchors.fill: quoteBox
        horizontalOffset: 0
        verticalOffset: 2
        radius: 12
        samples: radius * 2 + 1
        color: shadowColor
        transparentBorder: true
    }

    Rectangle {
        id: quoteBox

        radius: 12
        color: backgroundColor
        anchors.horizontalCenter: parent.horizontalCenter
        implicitWidth: quoteRow.implicitWidth + 8 * 2
        implicitHeight: quoteRow.implicitHeight + 4 * 2

        Row {
            id:quoteRow
            anchors.centerIn: parent
            spacing: 4

            Text {
                id: quoteIcon

                font.family: "Material Symbols Outlined"
                font.pixelSize: 22
                text: "format_quote"
                color: textColor
            }

            Text {
                id: quoteStyledText

                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                renderType: Text.NativeRendering
                color: textColor
                font.family: "Readex Pro"
                font.pixelSize: 17
                font.weight: Font.Normal
            }

        }

    }

}
