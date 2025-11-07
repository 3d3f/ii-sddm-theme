// Adapted from end-4's Hyprland dotfiles (https://github.com/end-4/dots-hyprland)
// Modified by 3d3f for "ii-sddm-theme" (2025)
import QtQuick

Item {
    id: root

    required property int clockHour
    required property int clockMinute
    property string style: Settings.background_widgets_clock_cookie_hourHandStyle // "fill", "hollow", "classic", "hide"
    property color color: "black"
    property real handLength: 72
    property real handWidth: 18
    property real fillColorAlpha: root.style === "hollow" ? 0 : 1

    visible: root.style !== "hide"
    rotation: -90 + (360 / 12) * (root.clockHour + root.clockMinute / 60)

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        x: (parent.width - root.handWidth) / 2 - 15 * (root.style === "classic")
        width: root.handLength
        height: root.style === "classic" ? 8 : root.handWidth
        radius: root.style === "classic" ? 2 : root.handWidth / 2
        color: Qt.rgba(root.color.r, root.color.g, root.color.b, root.fillColorAlpha)
        border.color: root.color
        border.width: 4

        Behavior on x {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutQuad
            }

        }

    }

    Behavior on rotation {
        RotationAnimation {
            duration: 300
            direction: RotationAnimation.Clockwise
        }

    }

    Behavior on fillColorAlpha {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutQuad
        }

    }

}
