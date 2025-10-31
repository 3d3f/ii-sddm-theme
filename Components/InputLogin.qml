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

Item {
    id: loginContainer

    property bool loginFailed: false
    property bool isLoggingIn: false

    Layout.preferredHeight: Appearance.formRowHeight
    Layout.alignment: Qt.AlignBottom
    implicitWidth: inputRow.implicitWidth

    Rectangle {
        id: sharedBackground

        anchors.fill: parent
        color: Colors.surface_container
        radius: Appearance.rounding_full
    }

    RowLayout {
        id: inputRow

        anchors.fill: parent
        spacing: 6

        Item {
            id: passwordField

            implicitHeight: parent.height
            implicitWidth: 219

            TextField {
                id: password

                anchors.fill: parent
                leftPadding: 20
                rightPadding: keyboard.capsLock ? 50 : 20
                verticalAlignment: TextInput.AlignVCenter
                horizontalAlignment: TextInput.AlignLeft
                font.family: Appearance.font_family_main
                font.pixelSize: Appearance.font_size_normal
                font.bold: false
                color: Colors.on_surface_variant
                focus: true
                echoMode: TextInput.Password
                placeholderText: loginContainer.loginFailed ? "Incorrect password" : "Enter password"
                placeholderTextColor: loginContainer.loginFailed ? Colors.error : Qt.rgba(Colors.on_surface.r, Colors.on_surface.g, Colors.on_surface.b, 0.6)
                renderType: Text.QtRendering
                selectByMouse: true
                selectionColor: Colors.primary_container
                selectedTextColor: Colors.on_primary_container
                enabled: !loginContainer.isLoggingIn
                onTextChanged: {
                    if (loginContainer.loginFailed && text.length > 0)
                        loginContainer.loginFailed = false;

                }
                onAccepted: {
                    if (!loginContainer.isLoggingIn && (config.AllowEmptyPassword == "true" || password.text !== "")) {
                        loginContainer.isLoggingIn = true;
                        const user = config.AllowUppercaseLettersInUsernames == "false" ? selectUser.currentText.toLowerCase() : selectUser.currentText;
                        sddm.login(user, password.text, sessionSelect.selectedSession);
                    }
                }
                KeyNavigation.right: loginButton

                background: Rectangle {
                    color: Colors.surface_container_low
                    radius: Appearance.rounding_full
                    anchors.fill: parent
                    anchors.margins: 8

                    Text {
                        id: capsLockIndicator

                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        font.family: "Material Symbols Outlined"
                        font.pixelSize: 20
                        color: Colors.error
                        text: "keyboard_capslock_badge"
                        opacity: 0
                        scale: 0.8

                        states: State {
                            name: "visible"
                            when: keyboard.capsLock

                            PropertyChanges {
                                target: capsLockIndicator
                                opacity: 1
                                scale: 1
                            }

                        }

                        transitions: Transition {
                            ParallelAnimation {
                                NumberAnimation {
                                    properties: "opacity"
                                    duration: 200
                                    easing.type: Easing.OutCubic
                                }

                                NumberAnimation {
                                    properties: "scale"
                                    duration: 200
                                    easing.type: Easing.OutBack
                                }

                            }

                        }

                    }

                    Behavior on border.color {
                        ColorAnimation {
                            duration: 200
                            easing.type: Easing.OutCubic
                        }

                    }

                    Behavior on border.width {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutCubic
                        }

                    }

                }

            }

        }

        Item {
            id: login

            Layout.fillHeight: true
            Layout.preferredWidth: loginButton.implicitWidth + 18
            Layout.alignment: Qt.AlignVCenter
            Layout.leftMargin: -18

            Button {
                id: loginButton

                anchors.centerIn: parent
                implicitWidth: 40
                implicitHeight: 40
                text: ""
                hoverEnabled: true
                focusPolicy: Qt.NoFocus
                enabled: !loginContainer.isLoggingIn && (config.AllowEmptyPassword == "true" || (selectUser.currentText !== "" && password.text !== ""))
                onPressed: {
                    if (!loginContainer.isLoggingIn)
                        loginRipple.state = "active";

                }
                onReleased: loginRipple.state = ""
                onClicked: {
                    if (!loginContainer.isLoggingIn) {
                        loginContainer.isLoggingIn = true;
                        const user = config.AllowUppercaseLettersInUsernames == "false" ? selectUser.currentText.toLowerCase() : selectUser.currentText;
                        sddm.login(user, password.text, sessionSelect.selectedSession);
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: loginButton.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onPressed: mouse.accepted = false // Passa il click al Button
                }

                contentItem: Item {
                    anchors.fill: parent

                    Text {
                        id: arrowIcon

                        anchors.centerIn: parent
                        font.family: "Material Symbols Outlined"
                        font.pixelSize: 22
                        color: loginButton.enabled ? Colors.on_primary : Colors.on_surface_variant
                        text: "arrow_right_alt"
                        opacity: loginContainer.isLoggingIn ? 0 : 1
                        scale: loginContainer.isLoggingIn ? 0.5 : 1
                        rotation: loginContainer.isLoggingIn ? 90 : 0

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 200
                                easing.type: Easing.InOutCubic
                            }

                        }

                        Behavior on scale {
                            NumberAnimation {
                                duration: 200
                                easing.type: Easing.InOutCubic
                            }

                        }

                        Behavior on rotation {
                            NumberAnimation {
                                duration: 200
                                easing.type: Easing.InOutCubic
                            }

                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                                easing.type: Easing.OutCubic
                            }

                        }

                    }

                    Canvas {
                        id: spinner

                        property color spinnerColor: Colors.on_primary

                        anchors.centerIn: parent
                        width: 22
                        height: 22
                        opacity: loginContainer.isLoggingIn ? 1 : 0
                        scale: loginContainer.isLoggingIn ? 1 : 0.5
                        rotation: 0
                        antialiasing: true
                        visible: opacity > 0
                        onPaint: {
                            var ctx = getContext("2d");
                            ctx.reset();
                            ctx.strokeStyle = spinnerColor;
                            ctx.lineWidth = 2.5;
                            ctx.lineCap = "round";
                            ctx.beginPath();
                            ctx.arc(width / 2, height / 2, (width / 2) - 2, 0, Math.PI * 1.5);
                            ctx.stroke();
                        }

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 200
                                easing.type: Easing.InOutCubic
                            }

                        }

                        Behavior on scale {
                            NumberAnimation {
                                duration: 200
                                easing.type: Easing.InOutCubic
                            }

                        }

                        RotationAnimator on rotation {
                            running: loginContainer.isLoggingIn
                            from: 0
                            to: 360
                            duration: 1000
                            loops: Animation.Infinite
                        }

                    }

                }

                background: Rectangle {
                    id: buttonBackground

                    color: loginContainer.isLoggingIn ? Colors.primary : (loginButton.enabled ? Colors.primary : Colors.surface_variant)
                    radius: width / 2

                    Rectangle {
                        id: loginRipple

                        anchors.centerIn: parent
                        width: 0
                        height: 0
                        radius: width / 2
                        color: Colors.on_primary
                        opacity: 0
                        transitions: [
                            Transition {
                                from: ""
                                to: "active"

                                NumberAnimation {
                                    properties: "width,height,opacity"
                                    duration: 200
                                    easing.type: Easing.OutCubic
                                }

                            },
                            Transition {
                                from: "active"
                                to: ""

                                SequentialAnimation {
                                    NumberAnimation {
                                        properties: "opacity"
                                        duration: 400
                                        easing.type: Easing.OutCubic
                                        to: 0
                                    }

                                    ScriptAction {
                                        script: {
                                            loginRipple.width = 0;
                                            loginRipple.height = 0;
                                        }
                                    }

                                }

                            }
                        ]

                        states: State {
                            name: "active"

                            PropertyChanges {
                                target: loginRipple
                                width: parent.width * 1.5
                                height: parent.height * 1.5
                                opacity: 0.3
                            }

                        }

                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                            easing.type: Easing.OutCubic
                        }

                    }

                }

            }

        }

    }

    Connections {
        function onLoginFailed() {
            loginContainer.loginFailed = true;
            loginContainer.isLoggingIn = false;
            password.text = "";
            password.forceActiveFocus();
        }

        function onLoginSucceeded() {
            // Opzionale: gestire il successo
            loginContainer.isLoggingIn = false;
        }

        target: sddm
    }

}
