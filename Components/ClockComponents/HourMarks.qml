import "../"
// Adapted from end-4's Hyprland dotfiles (https://github.com/end-4/dots-hyprland)
// Modified by 3d3f for "ii-sddm-theme" (2025)
import QtQuick

Item {
    id: root

    property real implicitSize: 135
    property real markLength: 12
    property real markWidth: 4
    property color color: Colors.on_secondary_container
    property color colOnBackground: Colors.secondary_container
    property real padding: 8

    anchors.fill: parent

    Rectangle {
        color: root.color
        anchors.centerIn: parent
        implicitWidth: root.implicitSize
        implicitHeight: root.implicitSize
        radius: width / 2

        Repeater {
            model: 12

            Item {
                required property int index

                anchors.fill: parent
                rotation: 360 / 12 * index

                Rectangle {
                    implicitWidth: root.markLength
                    implicitHeight: root.markWidth
                    radius: width / 2
                    color: root.colOnBackground

                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: root.padding
                    }

                }

            }

        }

    }

}
