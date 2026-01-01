// Adapted from syrupderg's win11-sddm-theme (https://github.com/syrupderg/win11-sddm-theme)
// Modified by 3d3f for "ii-sddm-theme" 

import "../"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SddmComponents as SDDM

FocusScope {
    id: sessionListPanel

    property alias session: sessionList.currentIndex

    implicitHeight: 40
    implicitWidth: 40
    onActiveFocusChanged: {
        if (!activeFocus)
            sessionPopup.isOpen = false;

    }

    Timer {
        id: mainTooltipTimer

        interval: 1000
        onTriggered: sessionButtonTip.visible = true
    }

    Connections {
        function onHoveredChanged() {
            if (sessionButton.hovered && !sessionPopup.isOpen) {
                mainTooltipTimer.restart();
            } else {
                mainTooltipTimer.stop();
                sessionButtonTip.visible = false;
            }
        }

        target: sessionButton
    }

    Button {
        id: sessionButton

        anchors.fill: parent
        hoverEnabled: true
        focusPolicy: Qt.ClickFocus
        onClicked: {
            sessionPopup.isOpen = !sessionPopup.isOpen;
            if (sessionPopup.isOpen)
                sessionListPanel.forceActiveFocus();

        }

        background: Rectangle {
            id: sessionButtonBackground

            color: (sessionButton.hovered || sessionButton.visualFocus || sessionPopup.isOpen) ? Appearance.dynamicButtonBackground : "transparent"
            radius: 5
        }

        contentItem: Text {
            color: (sessionButton.hovered || sessionButton.visualFocus || sessionPopup.isOpen) ? Appearance.dynamicButtonIcon : "white"
            font.family: Appearance.waffleIconFont
            text: "\uf35A"
            renderType: Text.QtRendering
            font.pixelSize: Appearance.waffleButtonIconFontSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

    }

    Rectangle {
        id: sessionButtonTip

        visible: false
        anchors.bottom: sessionButton.top
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

            text: "Session"
        }

    }

    Rectangle {
        id: sessionPopup

        property bool isOpen: false

        x: -110
        y: -height - 10
        width: 250
        height: Math.min(sessionList.contentHeight + 14, 300)
        color: Appearance.dynamicPopupBackground
        border.width: 1
        border.color: Appearance.dynamicPopupBorder
        radius: 5
        z: 2
        opacity: isOpen ? 1 : 0
        visible: opacity > 0

        ListView {
            id: sessionList

            anchors.fill: parent
            anchors.margins: 7
            model: sessionModel
            clip: true
            spacing: 7
            Component.onCompleted: currentIndex = sessionModel.lastIndex

            delegate: Item {
                id: sessionEntry

                readonly property bool isSelected: sessionList.currentIndex === index

                width: sessionList.width
                height: 36

                Rectangle {
                    id: sessionEntryBackground

                    anchors.fill: parent
                    radius: 4
                    color: {
                        if (Appearance.highContrastEnabled) {
                            if (mouseAreaEntry.containsMouse)
                                return "#1AEBFF";

                            if (isSelected)
                                return "#1AEBFF";

                            return "transparent";
                        } else {
                            if (isSelected)
                                return Colors.primary_container;

                            if (mouseAreaEntry.containsMouse)
                                return Colors.surface_variant;

                            return "transparent";
                        }
                    }
                }

                Text {
                    id: sessionEntryText

                    anchors.fill: parent
                    anchors.leftMargin: 10
                    text: name
                    renderType: Text.QtRendering
                    font.family: Appearance.waffleFont
                    font.pixelSize: Appearance.wafflePopupTextFont
                    verticalAlignment: Text.AlignVCenter
                    color: {
                        if (Appearance.highContrastEnabled) {
                            if (mouseAreaEntry.containsMouse)
                                return "#000000";

                            if (isSelected)
                                return "#000000";

                            return "#FFFFFF";
                        } else {
                            return isSelected ? Colors.on_primary_container : Colors.on_surface;
                        }
                    }
                }

                MouseArea {
                    id: mouseAreaEntry

                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        sessionList.currentIndex = index;
                        sessionPopup.isOpen = false;
                    }
                }

            }

            ScrollBar.vertical: ScrollBar {
                policy: sessionList.contentHeight > sessionPopup.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
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
