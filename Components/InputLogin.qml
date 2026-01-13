// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2025 Keyitdev
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html
// Modified by 3d3f for the "ii-sddm-theme" project (2025)
// Licensed under the GNU General Public License v3.0
// Adapted from end-4's Hyprland dotfiles (https://github.com/end-4/dots-hyprland)

import "Commons"
import QtQml.Models
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects 

Item {
    id: loginContainer

    property bool loginFailed: false
    property bool isLoggingIn: false
    property bool usePasswordChars: Settings.lock_materialShapeChars
    property var customShapeSequence: [MaterialShape.Shape.Clover4Leaf, MaterialShape.Shape.Arrow, MaterialShape.Shape.Pill, MaterialShape.Shape.SoftBurst, MaterialShape.Shape.Diamond, MaterialShape.Shape.ClamShell, MaterialShape.Shape.Pentagon]

    Layout.preferredHeight: Appearance.formRowHeight
    Layout.alignment: Qt.AlignBottom
    implicitWidth: inputRow.implicitWidth

    ListModel {
        id: passwordCharsModel
    }

    Rectangle {
        id: sharedBackground
        anchors.fill: parent
        color: Colors.surface_container
        radius: Appearance.rounding.full
    }

    RowLayout {
        id: inputRow
        anchors.fill: parent
        spacing: 6

        Item {
            id: passwordField
            implicitHeight: parent.height
            implicitWidth: 219
            Layout.rightMargin: -Layout.leftMargin

            Rectangle {
                id: fieldBackground
                anchors.fill: parent
                anchors.margins: 8
                color: Colors.surface_container_low
                radius: Appearance.rounding.full
                
                // overkill way to make password chars respect the radius
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        width: fieldBackground.width
                        height: fieldBackground.height
                        radius: fieldBackground.radius
                    }
                }

                Text {
                    id: customPlaceholder
                    visible: usePasswordChars && password.text.length === 0
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    verticalAlignment: Text.AlignVCenter
                    text: loginContainer.loginFailed ? "Incorrect password" : "Enter password"
                    color: loginContainer.loginFailed ? Colors.error : Qt.rgba(Colors.on_surface.r, Colors.on_surface.g, Colors.on_surface.b, 0.6)
                    font.family: Appearance.font_family_main
                    font.pixelSize: Appearance.font.pixelSize.small
                }

                TextField {
                    id: password
                    anchors.fill: parent
                    anchors.leftMargin: 3
                    anchors.rightMargin: 3
                    color: usePasswordChars ? "transparent" : Colors.colOnLayer1
                    focus: true
                    focusPolicy: Qt.StrongFocus
                    Component.onCompleted: password.forceActiveFocus()
                    echoMode: TextInput.Password
                    placeholderText: loginContainer.loginFailed ? "Incorrect password" : "Enter password"
                    placeholderTextColor: loginContainer.loginFailed ? Colors.error : Qt.rgba(Colors.on_surface.r, Colors.on_surface.g, Colors.on_surface.b, 0.6)
                    font.family: Appearance.font_family_main
                    font.pixelSize: Appearance.font.pixelSize.normal
                    cursorVisible: !usePasswordChars
                    opacity: usePasswordChars ? 0 : 1
                    enabled: !loginContainer.isLoggingIn
                    
                    onTextChanged: {
                        if (loginContainer.loginFailed && text.length > 0) loginContainer.loginFailed = false;
                        if (!usePasswordChars) return;

                        var currentLength = passwordCharsModel.count;
                        var newLength = text.length;
                        if (newLength > currentLength) {
                            for (var i = currentLength; i < newLength; i++) {
                                passwordCharsModel.append({"index": i});
                            }
                        } else if (newLength < currentLength) {
                            while (passwordCharsModel.count > newLength) passwordCharsModel.remove(passwordCharsModel.count - 1);
                        }
                    }
                    
                    onAccepted: {
                        if (!loginContainer.isLoggingIn && (config.AllowEmptyPassword == "true" || password.text !== "")) {
                            loginContainer.isLoggingIn = true;
                            const user = config.AllowUppercaseLettersInUsernames == "false" ? selectUser.currentText.toLowerCase() : selectUser.currentText;
                            sddm.login(user, password.text, inputContainer.selectedSession);
                        }
                    }

                    background: Rectangle {
                        id: fieldRect
                        color: Colors.colLayer1
                        radius: Appearance.rounding.full
                    }
                }

                PasswordChars {
                    id: passwordDisplay
                    passwordModel: passwordCharsModel
                    usePasswordChars: loginContainer.usePasswordChars
                    customShapeSequence: loginContainer.customShapeSequence
                    cursorPosition: password.cursorPosition
                    
                    anchors {
                        fill: parent
                        leftMargin: 4
                        rightMargin: -4
                    }
                }

                SequentialAnimation {
                    id: wrongPasswordShakeAnim
                    NumberAnimation { target: passwordField; property: "Layout.leftMargin"; to: -30; duration: 50 }
                    NumberAnimation { target: passwordField; property: "Layout.leftMargin"; to: 30; duration: 50 }
                    NumberAnimation { target: passwordField; property: "Layout.leftMargin"; to: -15; duration: 40 }
                    NumberAnimation { target: passwordField; property: "Layout.leftMargin"; to: 15; duration: 40 }
                    NumberAnimation { target: passwordField; property: "Layout.leftMargin"; to: 0; duration: 30 }
                }

                Item {
                    id: capsLock

                    anchors.right: parent.right
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    implicitWidth: 24
                    implicitHeight: 24
                    states: [
                        State {
                            name: "visible"
                            when: keyboard.capsLock

                            PropertyChanges {
                                target: capsRect
                                opacity: 1
                            }

                            PropertyChanges {
                                target: capsLockIndicator
                                opacity: 1
                                scale: 1
                            }

                        }
                    ]
                    transitions: [
                        Transition {
                            from: "*"
                            to: "visible"
                            reversible: true

                            ParallelAnimation {
                                NumberAnimation {
                                    target: capsRect
                                    property: "opacity"
                                    duration: 100
                                    easing.type: Easing.OutCubic
                                }

                                NumberAnimation {
                                    target: capsLockIndicator
                                    property: "opacity"
                                    duration: 100
                                    easing.type: Easing.OutCubic
                                }

                                NumberAnimation {
                                    target: capsLockIndicator
                                    property: "scale"
                                    duration: 100
                                    easing.type: Easing.OutCubic
                                }

                            }

                        }
                    ]

                    Rectangle {
                        id: capsRect

                        anchors.fill: parent
                        color: Colors.error
                        radius: 4
                        opacity: 0
                    }

                    Text {
                        id: capsLockIndicator

                        property real fill: 1
                        property real truncatedFill: Math.round(fill * 100) / 100
                        property int iconSize: 24

                        anchors.centerIn: parent
                        font.family: Appearance.illogicalIconFont
                        color: Colors.on_error
                        text: "keyboard_capslock"
                        font.pixelSize: iconSize
                        opacity: 0
                        scale: 0.8
                        renderType: fill !== 0 ? Text.CurveRendering : Text.QtRendering
                        font.hintingPreference: Font.PreferFullHinting
                        font.variableAxes: {
                            "FILL": truncatedFill,
                            "opsz": iconSize
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
                focusPolicy: Qt.TabFocus
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
                        sddm.login(user, password.text, inputContainer.selectedSession);
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: loginButton.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onPressed: mouse.accepted = false
                }

                contentItem: Item {
                    anchors.fill: parent

                    Text {
                        id: arrowIcon

                        anchors.centerIn: parent
                        font.family: Appearance.illogicalIconFont
                        font.pixelSize: 22
                        color: loginButton.enabled ? Colors.on_primary : Colors.on_surface_variant
                        text: "arrow_right_alt"
                        opacity: loginContainer.isLoggingIn ? 0 : 1
                        scale: loginContainer.isLoggingIn ? 0.5 : 1
                        rotation: loginContainer.isLoggingIn ? 90 : 0

                        Behavior on opacity {
                            NumberAnimation {
                                duration: Appearance.animation.elementMoveFast.duration
                                easing.type: Appearance.animation.elementMoveFast.type
                                easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
                            }

                        }

                        Behavior on scale {
                            NumberAnimation {
                                duration: Appearance.animation.elementMoveFast.duration
                                easing.type: Appearance.animation.elementMoveFast.type
                                easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
                            }

                        }

                        Behavior on rotation {
                            NumberAnimation {
                                duration: Appearance.animation.elementMoveFast.duration
                                easing.type: Appearance.animation.elementMoveFast.type
                                easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
                            }

                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: Appearance.animation.elementMoveFast.duration
                                easing.type: Appearance.animation.elementMoveFast.type
                                easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
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
                                duration: Appearance.animation.elementMoveFast.duration
                                easing.type: Appearance.animation.elementMoveFast.type
                                easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
                            }

                        }

                        Behavior on scale {
                            NumberAnimation {
                                duration: Appearance.animation.elementMoveFast.duration
                                easing.type: Appearance.animation.elementMoveFast.type
                                easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
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
                                to: "active"

                                NumberAnimation {
                                    properties: "width,height,opacity"
                                    duration: Appearance.animation.clickBounce.duration
                                    easing.type: Appearance.animation.clickBounce.type
                                    easing.bezierCurve: Appearance.animation.clickBounce.bezierCurve
                                }

                            },
                            Transition {
                                to: ""

                                SequentialAnimation {
                                    NumberAnimation {
                                        properties: "opacity"
                                        duration: Appearance.animation.clickBounce.duration
                                        easing.type: Appearance.animation.clickBounce.type
                                        easing.bezierCurve: Appearance.animation.clickBounce.bezierCurve
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
                            duration: Appearance.animation.elementMoveFast.duration
                            easing.type: Appearance.animation.elementMoveFast.type
                            easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
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
            wrongPasswordShakeAnim.restart();
            password.forceActiveFocus();
        }

        function onLoginSucceeded() {
            loginContainer.isLoggingIn = false;
        }

        target: sddm
    }

}
