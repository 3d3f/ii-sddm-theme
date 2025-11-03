// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2025 Keyitdev
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html
// Modified by 3d3f for the "ii-sddm-theme" project (2025)
// Licensed under the GNU General Public License v3.0
// See: https://www.gnu.org/licenses/gpl-3.0.txt
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ComboBox {
    id: selectUser

    Layout.preferredHeight: Appearance.formRowHeight
    Layout.alignment: Qt.AlignVCenter
    Layout.preferredWidth: userRow.implicitWidth + 40
    model: userModel
    currentIndex: model.lastIndex
    textRole: "name"
    hoverEnabled: true
    indicator: null
    clip: true
    focusPolicy: Qt.StrongFocus
    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Up || event.key === Qt.Key_Down) {
            if (!popup.opened)
                popup.open();

        }
    }

    background: Item {
        Rectangle {
            anchors.fill: parent
            anchors.margins: 8
            radius: Appearance.rounding_full
            color: selectUser.hovered ? Colors.surface_container_highest : Colors.surface_container

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (userPopup.opened)
                        userPopup.close();
                    else
                        userPopup.open();
                }
            }

            Behavior on color {
                ColorAnimation {
                    duration: 200
                    easing.type: Easing.InOutQuad
                }

            }

        }

    }

    contentItem: RowLayout {
        id: userRow

        spacing: 8
        anchors.fill: parent
        anchors.leftMargin: 17
        clip: true

        Text {
            id: icon

            property real fill: 1
            property real truncatedFill: Math.round(fill * 100) / 100
            property int iconSize: 24 

            font.family: "Material Symbols Outlined"
            font.pixelSize: iconSize
            color: Colors.on_surface_variant
            Layout.alignment: Qt.AlignVCenter
            text: "account_circle"
            renderType: fill !== 0 ? Text.CurveRendering : Text.NativeRendering
            font.hintingPreference: Font.PreferFullHinting
            font.variableAxes: {
                "FILL": truncatedFill,
                "opsz": iconSize  
            }
        }

        Text {
            id: userName

            Layout.alignment: Qt.AlignVCenter
            text: selectUser.displayText
            color: Colors.on_surface_variant
            font.family: "Rubik"
            font.pixelSize: Appearance.font_size_normal
            font.bold: false
            font.capitalization: Font.MixedCase
        }

        Item {
            Layout.fillWidth: true
        }

    }

    popup: Popup {
        id: userPopup

        implicitHeight: contentItem.implicitHeight + 10
        implicitWidth: userRow.width
        x: 10
        y: 10
        padding: 5
        clip: true

        contentItem: ListView {
            id: userList

            implicitHeight: contentHeight
            clip: true
            model: selectUser.model
            currentIndex: selectUser.highlightedIndex
            spacing: Appearance.listItemSpacing
            y: 8
            opacity: userPopup.opacity

            ScrollIndicator.vertical: ScrollIndicator {
            }

            delegate: ItemDelegate {
                implicitWidth: userList.width
                implicitHeight: Math.max(48, textCont.implicitHeight + 16)
                hoverEnabled: true
                topPadding: 8
                bottomPadding: 8
                leftPadding: 12
                rightPadding: 12
                onClicked: {
                    selectUser.currentIndex = index;
                    userPopup.close();
                }

                contentItem: Text {
                    id: textCont

                    text: model.name
                    font.family: Appearance.font_family_main
                    font.pixelSize: Appearance.font_size_normal
                    color: selectUser.highlightedIndex === index ? Colors.on_primary : Colors.on_primary_container
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                background: Rectangle {
                    color: selectUser.highlightedIndex === index ? Colors.primary : (parent.hovered ? Colors.colPrimaryContainerHover : Colors.primary_container)
                    radius: 12

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                            easing.type: Easing.InOutQuad
                        }

                    }

                }

            }

        }

        background: Rectangle {
            radius: 16
            color: Colors.primary_container
            layer.enabled: true
        }

        enter: Transition {
            NumberAnimation {
                property: "implicitHeight"
                from: 70
                to: userPopup.contentItem.implicitHeight + 10
                duration: 300
                easing.type: Easing.OutExpo
            }

            NumberAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 0
                easing.type: Easing.OutCubic
            }

        }

        exit: Transition {
            NumberAnimation {
                property: "implicitHeight"
                from: userPopup.implicitHeight
                to: 0
                duration: 200
                easing.type: Easing.InCubic
            }

            NumberAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 150
                easing.type: Easing.InCubic
            }

        }

    }

    Behavior on Layout.preferredWidth {
        NumberAnimation {
            duration: 300
            easing.type: Easing.InOutCubic
        }

    }

}