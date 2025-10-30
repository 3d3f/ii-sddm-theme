// Adapted from end-4's Hyprland dotfiles (https://github.com/end-4/dots-hyprland)
// Modified by 3d3f for "ii-sddm-theme" (2025)
import QtQuick

Item {
    id: root

    required property int clockMinute
    property string style: "classic" //Settings.background_clock_cookie_minuteHandStyle // "thin", "medium", "bold", "classic", "hide"
    property color color: "black"
    property real handLength: 95
    property real handWidth: {
        if (root.style === "bold")
            return 18;

        if (root.style === "medium")
            return 12;

        if (root.style === "thin")
            return 5;

        if (root.style === "classic")
            return 5;

        return 12;
    }

    anchors.fill: parent
    visible: root.style !== "hide"
    rotation: -90 + (360 / 60) * root.clockMinute

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        x: {
            let position = parent.width / 2 - root.handWidth / 2;
            if (root.style === "classic")
                position -= 15;

            return position;
        }
        width: root.handLength
        height: root.handWidth
        radius: root.style === "classic" ? 2 : root.handWidth / 2
        color: root.color

        Behavior on height {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutQuad
            }

        }

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

}
