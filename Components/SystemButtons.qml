// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2025 Keyitdev
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html
// Modified by 3d3f for the "ii-sddm-theme" project (2025)
// Licensed under the GNU General Public License v3.0
// See: https://www.gnu.org/licenses/gpl-3.0.txt

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "Commons"

Item {
    property var shutdown: ["power_settings_new", config.TranslateShutdown || textConstants.shutdown, sddm.canPowerOff]
    property var reboot: ["restart_alt", config.TranslateReboot || textConstants.reboot, sddm.canReboot]
    property var suspend: ["dark_mode", config.TranslateSuspend || textConstants.suspend, sddm.canSuspend]
    property var hibernate: ["bedtime", config.TranslateHibernate || textConstants.hibernate, sddm.canHibernate]
    property ComboBox exposedSession

    Layout.preferredHeight: Appearance.formRowHeight
    implicitWidth: buttonRow.implicitWidth + 10
    Layout.preferredWidth: implicitWidth

    Rectangle {
        anchors.fill: parent
        color: Colors.surface_container
        border.color: "transparent"
        border.width: 0
        radius: height / 2
    }

    RowLayout {
        id: buttonRow

        anchors.centerIn: parent
        spacing: 2

        Repeater {
            id: systemButtons

            model: [suspend, shutdown, reboot]

            Item {
                Layout.preferredWidth: 45
                Layout.preferredHeight: 45

                RoundButton {
                    id: btn

                    anchors.fill: parent
                    visible: config.HideSystemButtons != "true"
                    hoverEnabled: true
                    focusPolicy: Qt.TabFocus
                    Keys.onReturnPressed: clicked()
                    Keys.onEnterPressed: clicked()
                    onClicked: {
                        parent.forceActiveFocus();
                        index == 0 ? sddm.suspend() : index == 1 ? sddm.powerOff() : sddm.reboot();
                    }

                    background: Rectangle {
                        anchors.fill: parent
                        anchors.margins: 2
                        radius: width / 2
                        color: {
                            if (btn.down)
                                return Qt.rgba(1, 1, 1, 0.12);

                            if (btn.hovered)
                                return Qt.rgba(1, 1, 1, 0.08);

                            return "transparent";
                        }


                        Rectangle {
                            id: ripple

                            anchors.centerIn: parent
                            width: parent.width
                            height: parent.height
                            radius: width / 2
                            color: Qt.rgba(1, 1, 1, 0.2)
                            opacity: 0

                            Connections {
                                function onPressed() {
                                    ripple.opacity = 0.3;
                                    rippleAnimation.restart();
                                }

                                target: btn
                            }

                            NumberAnimation on opacity {
                                id: rippleAnimation

                                to: 0
                                duration: 300
                                easing.type: Easing.OutCubic
                            }

                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                                easing.type: Easing.OutCubic
                            }

                        }

                    }

                    contentItem: Text {
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: modelData[0]
                        font.family: Appearance.illogicalIconFont
                        font.pixelSize: 24
                        color: {

                            if (btn.down)
                                return Colors.on_surface_variant;

                            if (btn.hovered)
                                return Colors.on_surface_variant;

                            return Colors.on_surface_variant;
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                                easing.type: Easing.OutCubic
                            }

                        }

                    }

                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onPressed: {
                        btn.forceActiveFocus();
                        mouse.accepted = false;
                    }
                }

            }

        }

    }

}
