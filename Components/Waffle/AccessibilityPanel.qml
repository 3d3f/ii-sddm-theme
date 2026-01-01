// Adapted from syrupderg's win11-sddm-theme (https://github.com/syrupderg/win11-sddm-theme)
// Modified by 3d3f for "ii-sddm-theme" 

import "../"
import "../../"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

FocusScope {
    id: settingsRoot

    implicitHeight: 40
    implicitWidth: 40
    onActiveFocusChanged: {
        if (!activeFocus)
            settingsPopup.isOpen = false;

    }

    Timer {
        id: mainTooltipTimer

        interval: 1000
        onTriggered: settingsButtonTip.visible = true
    }

    Connections {
        function onHoveredChanged() {
            if (settingsButton.hovered && !settingsPopup.isOpen) {
                mainTooltipTimer.restart();
            } else {
                mainTooltipTimer.stop();
                settingsButtonTip.visible = false;
            }
        }

        target: settingsButton
    }

    Button {
        id: settingsButton

        anchors.fill: parent
        hoverEnabled: true
        focusPolicy: Qt.ClickFocus
        onClicked: {
            settingsPopup.isOpen = !settingsPopup.isOpen;
            if (settingsPopup.isOpen)
                settingsRoot.forceActiveFocus();

        }

        background: Rectangle {
            id: settingsButtonBackground

            color: (settingsButton.hovered || settingsButton.visualFocus || settingsPopup.isOpen) ? Appearance.dynamicButtonBackground : "transparent"
            radius: 5
        }

        contentItem: Text {
            color: (settingsButton.hovered || settingsButton.visualFocus || settingsPopup.isOpen) ? Appearance.dynamicButtonIcon : "white"
            font.family: Appearance.waffleIconFont
            text: "\ue001"
            renderType: Text.QtRendering
            font.pixelSize: Appearance.waffleButtonIconFontSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

    }

    Rectangle {
        id: settingsButtonTip

        visible: false
        anchors.bottom: settingsButton.top
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

            text: "Accessibility"
        }

    }

    Rectangle {
        id: settingsPopup

        property bool isOpen: false

        x: -230
        y: -height - 10
        width: 320
        height: contentLayout.implicitHeight + 24
        color: Appearance.dynamicPopupBackground
        border.width: 1
        border.color: Appearance.dynamicPopupBorder
        radius: 5
        z: 2
        opacity: isOpen ? 1 : 0
        visible: opacity > 0

        ColumnLayout {
            id: contentLayout

            anchors.fill: parent
            anchors.margins: 12
            spacing: 16

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Text {
                    color: Appearance.dynamicPopupText
                    font.family: Appearance.waffleIconFont
                    text: "\uf33C"
                    renderType: Text.QtRendering
                    font.pixelSize: Appearance.waffleButtonIconFontSize
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    text: "Contrast themes"
                    color: Appearance.dynamicPopupText
                    font.family: Appearance.waffleFont
                    font.pixelSize: Appearance.wafflePopupTextFont
                    Layout.fillWidth: true
                    verticalAlignment: Text.AlignVCenter
                    renderType: Text.QtRendering
                }

                Rectangle {
                    id: contrastSwitch

                    property bool isHovered: hcMouseArea.containsMouse

                    implicitWidth: 44
                    implicitHeight: 22
                    radius: height / 2
                    color: {
                        if (Appearance.highContrastEnabled)
                            return hcMouseArea.containsMouse ? Appearance.dynamicSwitchActiveHoverBackground : Appearance.dynamicSwitchActiveBackground;
                        else
                            return "transparent";
                    }
                    border.color: {
                        if (Appearance.highContrastEnabled)
                            return isHovered ? Appearance.dynamicSwitchActiveHoverBorder : Appearance.dynamicSwitchActiveBorder;
                        else
                            return isHovered ? Appearance.dynamicSwitchHoverBorder : Appearance.dynamicSwitchInactiveBorder;
                    }
                    border.width: 2

                    Rectangle {
                        width: 14
                        height: 14
                        radius: 7
                        color: {
                            if (Appearance.highContrastEnabled)
                                return contrastSwitch.isHovered ? Appearance.dynamicSwitchActiveHoverKnob : Appearance.dynamicSwitchActiveKnob;
                            else
                                return contrastSwitch.isHovered ? Appearance.dynamicSwitchHoverKnob : Appearance.dynamicSwitchInactiveKnob;
                        }
                        anchors.verticalCenter: parent.verticalCenter
                        x: Appearance.highContrastEnabled ? parent.width - width - 4 : 4

                        Behavior on x {
                            NumberAnimation {
                                duration: 150
                                easing.type: Easing.OutCubic
                            }

                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 30
                            }

                        }

                    }

                    MouseArea {
                        id: hcMouseArea

                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: Appearance.highContrastEnabled = !Appearance.highContrastEnabled
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 30
                        }

                    }

                    Behavior on border.color {
                        ColorAnimation {
                            duration: 30
                        }

                    }

                }

            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Text {
                    color: Appearance.dynamicPopupText
                    font.family: Appearance.waffleIconFont
                    text: "\ue74A"
                    renderType: Text.QtRendering
                    font.pixelSize: Appearance.waffleButtonIconFontSize
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    text: "On-Screen Keyboard"
                    color: Appearance.dynamicPopupText
                    font.family: Appearance.waffleFont
                    font.pixelSize: Appearance.wafflePopupTextFont
                    Layout.fillWidth: true
                    verticalAlignment: Text.AlignVCenter
                    renderType: Text.QtRendering
                }

                Rectangle {
                    id: keyboardSwitch

                    property bool isHovered: kbMouseArea.containsMouse

                    implicitWidth: 44
                    implicitHeight: 22
                    radius: height / 2
                    color: {
                        if (virtualKeyboard.activated)
                            return kbMouseArea.containsMouse ? Appearance.dynamicSwitchActiveHoverBackground : Appearance.dynamicSwitchActiveBackground;
                        else
                            return "transparent";
                    }
                    border.color: {
                        if (virtualKeyboard.activated)
                            return isHovered ? Appearance.dynamicSwitchActiveHoverBorder : Appearance.dynamicSwitchActiveBorder;
                        else
                            return isHovered ? Appearance.dynamicSwitchHoverBorder : Appearance.dynamicSwitchInactiveBorder;
                    }
                    border.width: 2

                    Rectangle {
                        width: 14
                        height: 14
                        radius: 7
                        color: {
                            if (virtualKeyboard.activated)
                                return keyboardSwitch.isHovered ? Appearance.dynamicSwitchActiveHoverKnob : Appearance.dynamicSwitchActiveKnob;
                            else
                                return keyboardSwitch.isHovered ? Appearance.dynamicSwitchHoverKnob : Appearance.dynamicSwitchInactiveKnob;
                        }
                        anchors.verticalCenter: parent.verticalCenter
                        x: virtualKeyboard.activated ? parent.width - width - 4 : 4

                        Behavior on x {
                            NumberAnimation {
                                duration: 150
                                easing.type: Easing.OutCubic
                            }

                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 30
                            }

                        }

                    }

                    MouseArea {
                        id: kbMouseArea

                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: virtualKeyboard.activated = !virtualKeyboard.activated
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 30
                        }

                    }

                    Behavior on border.color {
                        ColorAnimation {
                            duration: 30
                        }

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
