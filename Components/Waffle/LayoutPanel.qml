// Adapted from syrupderg's win11-sddm-theme (https://github.com/syrupderg/win11-sddm-theme)
// Modified by 3d3f for "ii-sddm-theme" 

import "../"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

FocusScope {
    id: layoutRoot

    signal valueChanged(int id)

    function getLayoutData(index, property) {
        if (keyboard.layouts && index >= 0 && index < keyboard.layouts.length)
            return keyboard.layouts[index][property];

        return "";
    }

    implicitHeight: 40
    implicitWidth: 40
    onActiveFocusChanged: {
        if (!activeFocus)
            layoutPopup.isOpen = false;

    }

    Timer {
        id: mainTooltipTimer

        interval: 1000
        onTriggered: layoutButtonTip.visible = true
    }

    Connections {
        function onHoveredChanged() {
            if (layoutButton.hovered && !layoutPopup.isOpen) {
                mainTooltipTimer.restart();
            } else {
                mainTooltipTimer.stop();
                layoutButtonTip.visible = false;
            }
        }

        target: layoutButton
    }

    Button {
        id: layoutButton

        anchors.fill: parent
        hoverEnabled: true
        focusPolicy: Qt.ClickFocus
        onClicked: {
            layoutPopup.isOpen = !layoutPopup.isOpen;
            if (layoutPopup.isOpen)
                layoutRoot.forceActiveFocus();

        }

        background: Rectangle {
            color: (layoutButton.hovered || layoutButton.visualFocus || layoutPopup.isOpen) ? Appearance.dynamicButtonBackground : "transparent"
            radius: 5
        }

        contentItem: Text {
            text: getLayoutData(keyboard.currentLayout, "shortName")
            color: (layoutButton.hovered || layoutButton.visualFocus || layoutPopup.isOpen) ? Appearance.dynamicButtonIcon : "white"
            font.family: Appearance.waffleFont
            font.capitalization: Font.AllUppercase
            renderType: Text.QtRendering
            font.pixelSize: Appearance.wafflePopupTextFont
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

    }

    Rectangle {
        id: layoutButtonTip

        visible: false
        anchors.bottom: layoutButton.top
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

            anchors.centerIn: parent
            text: getLayoutData(keyboard.currentLayout, "longName")
            font.family: Appearance.waffleFont
        }

    }

    Rectangle {
        id: layoutPopup

        property bool isOpen: false

        x: Math.round((parent.width - width) / 2) - 78
        y: -height - 10
        width: 200
        height: Math.min(layoutList.contentHeight + 8, 300)
        color: Appearance.dynamicPopupBackground
        border.width: 1
        border.color: Appearance.dynamicPopupBorder
        radius: 0
        z: 2
        opacity: isOpen ? 1 : 0
        visible: opacity > 0

        ListView {
            id: layoutList

            anchors.fill: parent
            anchors.topMargin: 4
            anchors.bottomMargin: 4
            anchors.leftMargin: 0
            anchors.rightMargin: 0
            model: keyboard.layouts
            currentIndex: keyboard.currentLayout
            clip: true

            delegate: Item {
                id: layoutEntry

                readonly property bool isSelected: layoutList.currentIndex === index
                readonly property bool isHovered: mouseAreaEntry.containsMouse

                width: layoutList.width
                height: 48

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 0
                    radius: 0
                    color: {
                        if (isSelected)
                            return Appearance.dynamicListSelectedBackground;

                        if (isHovered)
                            return Appearance.dynamicButtonBackground;

                        return "transparent";
                    }
                    opacity: isSelected ? 1 : (isHovered ? 0.6 : 0)
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 10

                    Text {
                        text: modelData.shortName.toUpperCase()
                        font.family: Appearance.waffleFont
                        font.pixelSize: 16
                        font.weight: Font.Bold
                        color: isSelected ? Appearance.dynamicListSelectedBackgroundText : Appearance.dynamicPopupText
                        Layout.preferredWidth: 32
                        leftPadding: 5
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0

                        Text {
                            text: modelData.longName
                            font.family: Appearance.waffleFont
                            font.pixelSize: Appearance.wafflePopupTextFont
                            color: isSelected ? Appearance.dynamicListSelectedBackgroundText : Appearance.dynamicPopupText
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }

                        Text {
                            text: "Keyboard"
                            font.family: Appearance.waffleFont
                            font.pixelSize: Appearance.wafflePopupTextFont           
                            color: isSelected ? Appearance.dynamicListSelectedBackgroundText : Appearance.dynamicPopupText
                            opacity: Appearance.highContrastEnabled ? 1 : 0.7
                            Layout.fillWidth: true
                        }

                    }

                }

                MouseArea {
                    id: mouseAreaEntry

                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        keyboard.currentLayout = index;
                        layoutRoot.valueChanged(index);
                        layoutPopup.isOpen = false;
                    }
                }

            }

            ScrollBar.vertical: ScrollBar {
                policy: layoutList.contentHeight > layoutPopup.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
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
