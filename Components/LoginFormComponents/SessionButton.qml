// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2025 Keyitdev
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html
// Modified by 3d3f for the "ii-sddm-theme" project (2025)
// Licensed under the GNU General Public License v3.0
// See: https://www.gnu.org/licenses/gpl-3.0.txt

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: sessionButton

    property alias selectedSession: selectSession.currentIndex
    property alias exposeSession: selectSession

    Layout.preferredHeight: Appearance.formRowHeight
    Layout.preferredWidth: selectSession.animatedWidth
    Layout.alignment: Qt.AlignVCenter

    ComboBox {
        id: selectSession

        property real animatedWidth: Math.max(contentRow.implicitWidth + 40, 120)

        model: sessionModel
        currentIndex: model.lastIndex
        textRole: "name"
        hoverEnabled: true
        indicator: null
        clip: true
        focusPolicy: Qt.StrongFocus
        height: Appearance.formRowHeight
        width: animatedWidth
        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_Up || event.key === Qt.Key_Down) {
                if (!popup.opened)
                    popup.open();

            }
        }

        Behavior on animatedWidth {
            NumberAnimation {
                duration: 300
                easing.type: Easing.InOutCubic
            }

        }

        background: Item {
            Rectangle {
                anchors.fill: parent
                radius: Appearance.rounding_full
                color: selectSession.hovered ? Colors.surface_container_highest : Colors.surface_container

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (popupHandler.opened)
                            popupHandler.close();
                        else
                            popupHandler.open();
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
            id: contentRow

            spacing: 8
            anchors.fill: parent
            clip: true

            Text {
                id: labelText

                text: selectSession.displayText
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: Colors.on_surface_variant
                font.family: Appearance.font_family_main
                font.pixelSize: Appearance.font_size_normal
                elide: Text.ElideRight
            }

        }

        popup: Popup {
            id: popupHandler

            property real targetHeight: Math.min(listView.contentHeight + 10, 300)

            width: selectSession.width
            height: 0
            clip: true
            padding: 5

            contentItem: ListView {
                id: listView

                implicitHeight: Math.min(contentHeight, 300)
                clip: true
                model: selectSession.model
                currentIndex: selectSession.highlightedIndex
                spacing: Appearance.listItemSpacing
                opacity: popupHandler.opacity

                ScrollIndicator.vertical: ScrollIndicator {
                }

                delegate: ItemDelegate {
                    implicitWidth: listView.width
                    implicitHeight: Math.max(48, textContent.implicitHeight + 16)
                    hoverEnabled: true
                    padding: 8
                    leftPadding: 12
                    rightPadding: 12
                    ToolTip.visible: false
                    onClicked: {
                        selectSession.currentIndex = index;
                        popupHandler.close();
                    }

                    contentItem: Text {
                        id: textContent

                        text: model.name
                        font.family: Appearance.font_family_main
                        font.pixelSize: Appearance.font_size_normal
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight
                        color: selectSession.highlightedIndex === index ? Colors.on_primary : (parent.hovered ? Colors.on_primary_container : Colors.on_primary_container)
                    }

                    background: Rectangle {
                        color: selectSession.highlightedIndex === index ? Colors.primary : (parent.hovered ? Colors.colPrimaryContainerHover : Colors.primary_container)
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
                            target: popupHandler
                            property: "height"
                            from: 70
                            to: popupHandler.targetHeight
                            duration: 300
                            easing.type: Easing.OutCubic
                        }

                        NumberAnimation {
                            target: popupHandler
                            property: "opacity"
                            from: 0
                            to: 1
                            duration: 200
                            easing.type: Easing.OutQuad
                        }

                    }

                }

            }

            exit: Transition {
                ParallelAnimation {
                    NumberAnimation {
                        target: popupHandler
                        property: "height"
                        from: popupHandler.height
                        to: 0
                        duration: 200
                        easing.type: Easing.InCubic
                    }

                    NumberAnimation {
                        target: popupHandler
                        property: "opacity"
                        from: 1
                        to: 0
                        duration: 150
                        easing.type: Easing.InQuad
                    }

                }

            }

        }

    }

}
