import "../"
import "../Commons"
// Adapted from end-4's Hyprland dotfiles (https://github.com/end-4/dots-hyprland)
// Modified by 3d3f for "ii-sddm-theme" (2025)
import QtQuick

Item {
    id: root

    property color color: "black"
    property string style: "rect"
    property string dateText: ""
    property string dayOfMonth: ""
    property string monthNumber: ""
    property int clockSecond: 0
    property bool secondHandVisible: false

    Component {
        id: bubbleDateComponent

        Item {
            anchors.fill: parent

            MaterialShape {
                id: dayBubble

                anchors.left: parent.left
                anchors.top: parent.top
                z: 5
                implicitSize: 64
                color: Colors.tertiary_container
                shape: MaterialShape.Shape.Pentagon

                StyledText {
                    anchors.centerIn: parent
                    z: 6
                    text: root.dayOfMonth
                    color: Colors.on_tertiary_container
                    font.pixelSize: 30
                    font.weight: Font.Black
                    font.family: Appearance.font_family_expressive
                }

            }

            MaterialShape {
                id: monthBubble

                anchors.right: parent.right
                anchors.bottom: parent.bottom
                z: 5
                implicitSize: 64
                color: Colors.secondary_container
                shape: MaterialShape.Shape.Pill

                StyledText {
                    anchors.centerIn: parent
                    z: 6
                    text: root.monthNumber
                    color: Colors.on_secondary_container
                    font.pixelSize: 30
                    font.weight: Font.Black
                    font.family: Appearance.font_family_expressive
                }

            }

        }

    }

    Component {
        id: rectDateComponent

        Item {
            anchors.fill: parent

            Rectangle {
                // ToDo i can't get the right color
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: 85
                implicitWidth: 45
                implicitHeight: 30
                radius: Appearance.rounding_small
                color: Colors.mix(Colors.secondary_container, Colors.primary, 0.5)

                StyledText {
                    anchors.centerIn: parent
                    text: root.dayOfMonth
                    font.pixelSize: 20
                    font.weight: 1000
                    font.family: Appearance.font_family_expressive
                    color: Colors.secondary
                }

            }

        }

    }

    Component {
        id: borderDateComponent

        Item {
            anchors.fill: parent
            rotation: {
                if (!root.secondHandVisible)
                    return 0;

                var angleStep = 12 * Math.PI / 180;
                var centeringOffset = (angleStep / Math.PI * 180 * root.dateText.length) / 2;
                return (360 / 60 * root.clockSecond) + 180 - centeringOffset;
            }

            Repeater {
                model: root.dateText.length

                delegate: Text {
                    required property int index
                    property real angleStep: 12 * Math.PI / 180
                    property real angle: index * angleStep - Math.PI / 2

                    x: parent.width / 2 + 90 * Math.cos(angle) - width / 2
                    y: parent.height / 2 + 90 * Math.sin(angle) - height / 2
                    rotation: angle * 180 / Math.PI + 90
                    renderType: Text.QtRendering
                    color: root.color
                    text: root.dateText.charAt(index)

                    font {
                        family: Appearance.font_family_main
                        pixelSize: 30
                        Component.onCompleted: {
                            font.variableAxes = {
                                "wght": 350
                            };
                        }
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

    }

    Loader {
        id: dateLoader

        anchors.fill: parent
        sourceComponent: {
            switch (root.style) {
            case "bubble":
                return bubbleDateComponent;
            case "rect":
                return rectDateComponent;
            case "border":
                return borderDateComponent;
            case "hide":
                return null;
            default:
                return bubbleDateComponent;
            }
        }
    }

}
