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

            Item {
                id: dayBubble

                x: 15
                y: 15
                width: 36
                height: 36

                MaterialCookie {
                    anchors.fill: parent
                    implicitSize: 63
                    color: Colors.tertiary_container
                    sides: 4
                    constantlyRotate: false
                }

                Text {
                    anchors.centerIn: parent
                    text: root.dayOfMonth
                    color: Colors.primary
                    font.pixelSize: 28
                    font.weight: Font.Bold
                    font.family: "Space Grotesk"
                }

            }

            Item {
                id: monthBubble

                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: 15
                anchors.bottomMargin: 15
                width: 28
                height: 28

                MaterialCookie {
                    anchors.fill: parent
                    implicitSize: 60
                    color: Colors.primary_container
                    sides: 0
                    constantlyRotate: false
                }

                Text {
                    anchors.centerIn: parent
                    text: root.monthNumber
                    color: Colors.primary
                    font.pixelSize: 28
                    font.weight: Font.Bold
                    font.family: "Space Grotesk"
                }

            }

        }

    }

    Component {
        id: rectDateComponent

        Item {
            anchors.fill: parent

            Rectangle {
                property color colCustom: Colors.mix(Colors.primary, Colors.colLayer1, 0.45)

                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: 85
                width: 45
                height: 30
                radius: 12
                color: colCustom

                Text {
                    anchors.centerIn: parent
                    text: root.dayOfMonth
                    font.pixelSize: 20
                    font.weight: Font.Bold
                    font.family: "Space Grotesk"
                    color: Colors.secondary_fixed_dim
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
                        family: "Gabarito"
                        pixelSize: 30
                        weight: Font.Bold
                        hintingPreference: Font.PreferNoHinting
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
