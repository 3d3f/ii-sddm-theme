// Adapted from end-4's Hyprland dotfiles (https://github.com/end-4/dots-hyprland)
// Modified by 3d3f for "ii-sddm-theme" (2025)

import "../"
import "../Commons"
import QtQuick

Item {
    id: root

    property color color: Colors.on_secondary_container
    property string timeString: ""
    property bool enabled: true
    property bool isCompact: true

    visible: root.enabled && root.timeString !== ""

    Column {
        id: timeColumn

        anchors.centerIn: parent
        spacing: -16

        Repeater {
            model: root.timeString.split(/\s+/)

            delegate: Text {
                required property string modelData
                property bool isAmPm: !text.match(/^\d+$/)
                property real normalSize: isAmPm ? 26 : 68
                property real compactSize: isAmPm ? 20 : 40
                property real finalSize: root.isCompact ? compactSize : normalSize

                text: modelData
                anchors.horizontalCenter: parent.horizontalCenter
                color: root.color

                font {
                    family: Appearance.font_family_expressive
                    weight: Font.Bold
                    pixelSize: finalSize
                }

            }

        }

    }

}
