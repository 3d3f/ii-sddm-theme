// Adapted from end-4's Hyprland dotfiles (https://github.com/end-4/dots-hyprland)
// Modified by 3d3f for "ii-sddm-theme" (2025)

import QtQuick

Item {
    id: root

    required property int clockSecond
    property string style: "classic" 
    property color color: "black"
    property real handWidth: 2
    property real handLength: 100
    property real dotSize: 20

    anchors.fill: parent
    visible: root.style !== "hide"
    rotation: (360 / 60 * root.clockSecond) + 90

    Rectangle {
        id: mainHand

        width: root.style === "dot" ? root.dotSize : root.handLength
        height: root.style === "dot" ? root.dotSize : root.handWidth
        radius: Math.min(width, height) / 2
        color: root.color

        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 10
        }

        Behavior on width {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutQuad
            }

        }

        Behavior on height {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutQuad
            }

        }

    }

    Rectangle {
        width: 14
        height: 14
        radius: width / 2
        color: root.color
        visible: root.style === "classic"

        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 40
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutQuad
            }

        }

    }

    Behavior on rotation {
        RotationAnimation {
            duration: 100
            direction: RotationAnimation.Clockwise
        }

    }

}
