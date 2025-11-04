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
    Layout.preferredWidth: userRow.implicitWidth + 37
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

        Avatar {
            id: mainUserAvatar
            Layout.alignment: Qt.AlignVCenter
            Layout.bottomMargin: 0
            size: 27
            iconColor: Colors.on_surface_variant
            userName: userModel.data(userModel.index(selectUser.currentIndex, 0), 257)
            source: userModel.data(userModel.index(selectUser.currentIndex, 0), 260)
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

        property real targetHeight: Math.min(userList.contentHeight, 300) + topPadding + bottomPadding
        
        implicitHeight: 0 
        implicitWidth: userRow.width + layoutSelect.width - 6
        x: 10
        y: 10
        padding: 5
        clip: true

        contentItem: ListView {
            id: userList
            implicitHeight: Math.min(contentHeight, 300) 
            clip: true
            model: selectUser.model
            currentIndex: selectUser.highlightedIndex
            spacing: Appearance.listItemSpacing
            y: 10
            opacity: userPopup.opacity

            ScrollIndicator.vertical: ScrollIndicator { }

            delegate: ItemDelegate {
                implicitWidth: userList.width
                implicitHeight: Math.max(48, contentRow.implicitHeight + 16)
                hoverEnabled: true
                topPadding: 8
                bottomPadding: 8
                leftPadding: 12
                rightPadding: 12
                onClicked: {
                    selectUser.currentIndex = index;
                    userPopup.close();
                }

                contentItem: RowLayout {
                    id: contentRow
                    spacing: 2

                    Avatar {
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                        size: 27
                        iconColor: selectUser.highlightedIndex === index ? Colors.on_primary : Colors.on_primary_container
                        userName: model.name
                        source: model.icon

                    }

                    Text {
                        id: textCont
                        Layout.fillWidth: true
                        text: model.name
                        font.family: Appearance.font_family_main
                        font.pixelSize: Appearance.font_size_normal
                        color: selectUser.highlightedIndex === index ? Colors.on_primary : Colors.on_primary_container
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        leftPadding: 5
                        elide: Text.ElideRight

                    }
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
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation { 
                        property: "implicitHeight"; 
                        from: 70; 
                        to: userPopup.targetHeight; 
                        duration: 300; 
                        easing.type: Easing.OutCubic 
                    }
                    NumberAnimation { 
                        property: "opacity"; 
                        from: 0; 
                        to: 1; 
                        duration: 200; 
                        easing.type: Easing.OutQuad 
                    }
                }
            }
        }

        exit: Transition {
            ParallelAnimation {
                NumberAnimation { 
                    property: "implicitHeight"; 
                    from: userPopup.implicitHeight; 
                    to: 0; 
                    duration: 200; 
                    easing.type: Easing.InCubic 
                }
                NumberAnimation { 
                    property: "opacity"; 
                    from: 1; 
                    to: 0; 
                    duration: 150; 
                    easing.type: Easing.InQuad 
                }
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