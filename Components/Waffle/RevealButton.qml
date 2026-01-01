// Adapted from syrupderg's win11-sddm-theme (https://github.com/syrupderg/win11-sddm-theme)
// Modified by 3d3f for "ii-sddm-theme" 

import "../"
import QtQuick
import QtQuick.Controls

Button {
    id: revealButton

    property bool isRevealed: false

    hoverEnabled: true
    width: 26
    height: 22
    states: [
        State {
            name: "on"
            when: revealButton.down

            PropertyChanges {
                target: passwordField
                echoMode: TextInput.Normal
            }

            PropertyChanges {
                target: passwordFieldPin
                echoMode: TextInput.Normal
            }

            PropertyChanges {
                target: revealText
                color: Appearance.highContrastEnabled ? "#1AEBFF" : Colors.on_surface
            }

            PropertyChanges {
                target: revealButton
                isRevealed: true
            }

        },
        State {
            name: "off"

            PropertyChanges {
                target: passwordField
                echoMode: TextInput.Password
            }

            PropertyChanges {
                target: passwordFieldPin
                echoMode: TextInput.Password
            }

            PropertyChanges {
                target: revealButton
                isRevealed: false
            }

        }
    ]

    Text {
        id: revealText

        color: {
            if (Appearance.highContrastEnabled) {
                return revealButton.hovered ? "#1AEBFF" : "#FFFFFF";
            } else {
                if (revealButton.down)
                    return Colors.on_surface_variant;

                return Colors.on_surface;
            }
        }
        text: "\ue5F3"
        font.family: Appearance.waffleIconFont
        font.pixelSize: 17
        renderType: Text.QtRendering
        anchors.centerIn: parent

        Behavior on color {
            ColorAnimation {
                duration: 100
            }

        }

    }

    background: Rectangle {
        id: revealButtonBackground

        color: {
            if (Appearance.highContrastEnabled) {
                return "#000000";
            } else {
                if (revealButton.down)
                    return "#08FFFFFF";

                return revealButton.hovered ? "#15FFFFFF" : "transparent";
            }
        }
        border.color: Appearance.highContrastEnabled && revealButton.hovered ? "#1AEBFF" : "transparent"
        border.width: Appearance.highContrastEnabled && revealButton.hovered ? 1 : 0
        radius: 4

        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        Behavior on color {
            ColorAnimation {
                duration: 100
            }

        }

    }

}
