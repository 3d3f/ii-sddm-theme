// Adapted from syrupderg's win11-sddm-theme (https://github.com/syrupderg/win11-sddm-theme)
// Modified by 3d3f for "ii-sddm-theme" 

import "../"
import "../../"
import QtQuick
import QtQuick.Controls

FocusScope {
    id: root

    width: 40
    height: 40
    onActiveFocusChanged: {
        if (!activeFocus)
            customPopup.isOpen = false;

    }

    Timer {
        id: mainTooltipTimer

        interval: 1000
        onTriggered: mainButtonTip.visible = true
    }

    Connections {
        function onHoveredChanged() {
            if (powerButton.hovered && !customPopup.isOpen) {
                mainTooltipTimer.restart();
            } else {
                mainTooltipTimer.stop();
                mainButtonTip.visible = false;
            }
        }

        target: powerButton
    }

    Button {
        id: powerButton

        anchors.fill: parent
        hoverEnabled: true
        focusPolicy: Qt.ClickFocus
        onClicked: {
            customPopup.isOpen = !customPopup.isOpen;
            if (customPopup.isOpen)
                root.forceActiveFocus();

        }

        background: Rectangle {
            id: powerButtonBackground

            color: (powerButton.hovered || powerButton.visualFocus || customPopup.isOpen) ? Appearance.dynamicButtonBackground : "transparent"
            radius: 5
        }

        contentItem: Text {
            color: (powerButton.hovered || powerButton.visualFocus || customPopup.isOpen) ? Appearance.dynamicButtonIcon : "white"
            font.family: Appearance.waffleIconFont
            text: "\uf610"
            renderType: Text.QtRendering
            font.pixelSize: Appearance.waffleButtonIconFontSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

    }

    Rectangle {
        id: mainButtonTip

        visible: false
        anchors.bottom: powerButton.top
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        width: tipText.implicitWidth + 22
        height: tipText.implicitHeight + 12
        color: Appearance.dynamicPopupBackground
        border.color: Appearance.dynamicPopupBorder
        border.width: 1
        radius: 0
        z: 3

        TooltipText {
            id: tipText

            text: "Power"
        }

    }

    Rectangle {
        id: customPopup

        property bool isOpen: false

        x: -97
        y: -height - 10
        width: 140
        height: menuColumn.height + 14
        color: Appearance.dynamicPopupBackground
        border.color: Appearance.dynamicPopupBorder
        border.width: 1
        radius: 5
        clip: false
        z: 2
        opacity: isOpen ? 1 : 0
        visible: opacity > 0

        Column {
            id: menuColumn

            width: parent.width - 14
            anchors.centerIn: parent
            spacing: 2

            PowerOption {
                icon: "\uf87F"
                label: "Sleep"
                description: "The PC stays on but uses low power. Apps stay open so you're instantly back."
                callback: function() {
                    sddm.suspend();
                }
            }

            PowerOption {
                icon: "\ue0B3"
                label: "Restart"
                description: "Closes all apps, turns off the PC, and then turns it on again."
                callback: function() {
                    sddm.reboot();
                }
            }

            PowerOption {
                icon: "\uf610"
                label: "Shut down"
                description: "Closes all apps and turns off the PC."
                callback: function() {
                    sddm.powerOff();
                }
            }

            component PowerOption: Item {
                id: optItem

                property string icon: ""
                property string label: ""
                property string description: ""
                property var callback: null

                width: parent.width
                height: 36

                Timer {
                    id: optionTooltipTimer

                    interval: 1000
                    onTriggered: optionTooltip.visible = true
                }

                Rectangle {
                    id: bg

                    anchors.fill: parent
                    radius: 4
                    color: Appearance.highContrastEnabled ? (mouseArea.containsMouse ? "#1AEBFF" : "transparent") : (mouseArea.containsMouse ? Colors.surface_variant : "transparent")
                }

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    spacing: 12

                    Text {
                        text: optItem.icon
                        font.family: Appearance.waffleIconFont
                        font.pixelSize: Appearance.waffleButtonIconFontSize
                        color: Appearance.highContrastEnabled ? (mouseArea.containsMouse ? "#000000" : "#FFFFFF") : Colors.on_surface
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: optItem.label
                        font.family: Appearance.waffleFont
                        font.pixelSize: Appearance.wafflePopupTextFont
                        color: Appearance.highContrastEnabled ? (mouseArea.containsMouse ? "#000000" : "#FFFFFF") : Colors.on_surface
                        anchors.verticalCenter: parent.verticalCenter
                    }

                }

                MouseArea {
                    id: mouseArea

                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: optionTooltipTimer.restart()
                    onExited: {
                        optionTooltipTimer.stop();
                        optionTooltip.visible = false;
                    }
                    onClicked: {
                        if (optItem.callback)
                            optItem.callback();

                        customPopup.isOpen = false;
                    }
                }

                Rectangle {
                    id: optionTooltip

                    visible: false
                    x: parent.width - 187
                    y: -60
                    width: 200
                    height: optDesc.implicitHeight + 16
                    color: Appearance.dynamicPopupBackground
                    border.color: Appearance.dynamicPopupBorder
                    border.width: 1
                    radius: 0
                    z: 3

                    Text {
                        id: optDesc

                        width: parent.width - 16
                        anchors.centerIn: parent
                        text: optItem.description
                        font.family: Appearance.waffleFont
                        font.pixelSize: Appearance.wafflePopupTextFont
                        color: Appearance.highContrastEnabled ? "#FFFFFF" : Colors.on_surface
                        wrapMode: Text.WordWrap
                        renderType: Text.QtRendering
                    }

                }

            }

        }

        Behavior on opacity {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutCubic
            }

        }

    }

}
