// Adapted from syrupderg's win11-sddm-theme (https://github.com/syrupderg/win11-sddm-theme)
// Modified by 3d3f for "ii-sddm-theme" 

import "../"
import "../../Assets"
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls

Rectangle {
    id: container

    property string userName: ""
    property alias name: nameText.text
    property alias iconSource: icon.source
    readonly property bool isSelected: listView2.currentIndex === index
    readonly property bool isImageValid: icon.status === Image.Ready && userName !== "" && icon.source.toString().includes(userName)
    property bool isPressed: false

    width: parent.width
    height: 58
    radius: 5
    color: {
        if (isPressed) {
            if (isSelected)
                return "#40" + Appearance.dynamicButtonBackground.substring(1);

            return "#10FFFFFF";
        }
        if (isSelected)
            return Appearance.dynamicButtonBackground;

        if (hoverArea.containsMouse)
            return "#20FFFFFF";

        return "transparent";
    }

    MouseArea {
        id: hoverArea

        anchors.fill: parent
        hoverEnabled: true
        onPressed: {
            container.isPressed = true;
            pressAnimation.start();
        }
        onReleased: {
            container.isPressed = false;
            releaseAnimation.start();
        }
        onClicked: {
            listView2.currentIndex = index;
            listView.currentIndex = index;
            listView.forceActiveFocus();
        }
    }

    Item {
        id: contentContainer

        anchors.fill: parent

        NumberAnimation {
            id: pressAnimation

            target: contentContainer
            property: "scale"
            to: 0.98
            duration: 150
            easing.type: Easing.OutQuad
        }

        NumberAnimation {
            id: releaseAnimation

            target: contentContainer
            property: "scale"
            to: 1
            duration: 150
            easing.type: Easing.OutBack
            easing.overshoot: 1.2
        }

        Row {
            spacing: 12

            anchors {
                left: parent.left
                leftMargin: 12
                verticalCenter: parent.verticalCenter
            }

            Item {
                width: 48
                height: 48

                Image {
                    id: icon

                    anchors.fill: parent
                    smooth: true
                    fillMode: Image.PreserveAspectCrop
                    visible: false
                }

                Item {
                    id: mask

                    width: 48
                    height: 48
                    layer.enabled: true
                    visible: false

                    Rectangle {
                        width: 48
                        height: 48
                        radius: 24
                        color: "black"
                    }

                }

                OpacityMask {
                    anchors.fill: parent
                    source: icon
                    maskSource: mask
                    visible: container.isImageValid
                }

                OpacityMask {
                    anchors.fill: parent
                    maskSource: mask
                    visible: !container.isImageValid

                    source: Image {
                        source: Qt.resolvedUrl("../../Assets/user-192.png")
                        smooth: true
                    }

                }

            }

            Text {
                id: nameText

                width: container.width - 80
                anchors.verticalCenter: parent.verticalCenter
                renderType: Text.QtRendering
                elide: Text.ElideRight
                color: (isSelected && Appearance.highContrastEnabled) ? "black" : "white"

                font {
                    family: Appearance.waffleFont
                    pixelSize: Appearance.wafflePopupTextFont
                }

            }

        }

    }

}
