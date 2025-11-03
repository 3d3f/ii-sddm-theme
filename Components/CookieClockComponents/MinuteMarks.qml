// Adapted from end-4's Hyprland dotfiles (https://github.com/end-4/dots-hyprland)
// Modified by 3d3f for "ii-sddm-theme" (2025)
import QtQuick

Item {
    id: root

    property color color: "black"
    property string dialNumberStyle: Settings.background_clock_cookie_dialNumberStyle

    Component {
        id: fullMarksComponent

        Item {
            Repeater {
                model: 12

                Item {
                    required property int index

                    anchors.fill: parent
                    rotation: 360 / 12 * index

                    Rectangle {
                        width: 18
                        height: 4
                        radius: width / 2
                        color: root.color

                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                            leftMargin: 12
                        }

                    }

                }

            }

            Repeater {
                model: 60

                Item {
                    required property int index

                    anchors.fill: parent
                    rotation: 360 / 60 * index
                    visible: index % 5 !== 0

                    Rectangle {
                        width: 7
                        height: 2
                        radius: width / 2
                        color: root.color

                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                            leftMargin: 12
                        }

                    }

                }

            }

        }

    }

    Component {
        id: dotsMarksComponent

        Repeater {
            model: 12

            Item {
                required property int index

                anchors.fill: parent
                rotation: 360 / 12 * index

                Rectangle {
                    width: 12
                    height: 12
                    radius: width / 2
                    color: root.color

                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: 12
                    }

                }

            }

        }

    }

    Component {
        id: numbersMarksComponent

        Repeater {
            model: 4

            Item {
                id: numberItem

                required property int index

                anchors.fill: parent
                rotation: 360 / 4 * index

                Item {
                    width: 40
                    height: 40

                    anchors {
                        top: parent.top
                        horizontalCenter: parent.horizontalCenter
                        topMargin: 28
                    }

                    Text {
                        anchors.centerIn: parent
                        text: (index * 3) || 12
                        color: root.color
                        rotation: -numberItem.rotation

                        font {
                            family: "Readex Pro"
                            pixelSize: 80
                            weight: Font.Bold
                        }

                    }

                }

            }

        }

    }

    Loader {
        id: marksLoader

        anchors.fill: parent
        active: root.dialNumberStyle !== "none"
        sourceComponent: {
            switch (root.dialNumberStyle) {
            case "full":
                return fullMarksComponent;
            case "dots":
                return dotsMarksComponent;
            case "numbers":
                return numbersMarksComponent;
            default:
                return null;
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutQuad
            }

        }

    }

}
