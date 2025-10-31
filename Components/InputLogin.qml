import QtQml.Models
// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2025 Keyitdev
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html
// Modified by 3d3f for the "ii-sddm-theme" project (2025)
// Licensed under the GNU General Public License v3.0
// Adapted from end-4's Hyprland dotfiles (https://github.com/end-4/dots-hyprland)
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: loginContainer

    property bool loginFailed: false
    property bool isLoggingIn: false
    property bool usePasswordChars: Settings.lock_materialShapeChars
    property var customShapeSequence: [4, 6, 5, 8, 7]

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
        radius: Appearance.rounding_full
    }

    RowLayout {
        id: inputRow

        anchors.fill: parent
        spacing: 6
        clip: true

        Item {
            id: passwordField

            implicitHeight: parent.height
            implicitWidth: 219

            Rectangle {
                id: fieldBackground

                anchors.fill: parent
                anchors.margins: 8
                color: Colors.surface_container_low
                radius: Appearance.rounding_full
                clip: true

                TextField {
                    id: password

                    anchors.fill: parent
                    anchors.margins: 8
                    color: "transparent"
                    focus: true
                    focusPolicy: Qt.StrongFocus
                    echoMode: TextInput.Password
                    placeholderText: loginContainer.loginFailed ? "Incorrect password" : "Enter password"
                    placeholderTextColor: loginContainer.loginFailed ? Colors.error : Qt.rgba(Colors.on_surface.r, Colors.on_surface.g, Colors.on_surface.b, 0.6)
                    font.family: Appearance.font_family_main
                    font.pixelSize: Appearance.font_size_normal
                    selectByMouse: true
                    selectionColor: Colors.primary_container
                    selectedTextColor: Colors.on_primary_container
                    enabled: !loginContainer.isLoggingIn
                    onTextChanged: {
                        if (loginContainer.loginFailed && text.length > 0)
                            loginContainer.loginFailed = false;

                        if (!usePasswordChars)
                            return ;

                        var currentLength = passwordCharsModel.count;
                        var newLength = text.length;
                        if (newLength > currentLength) {
                            for (var i = currentLength; i < newLength; i++) {
                                passwordCharsModel.append({
                                    "index": i
                                });
                            }
                        } else if (newLength < currentLength) {
                            while (passwordCharsModel.count > newLength)passwordCharsModel.remove(passwordCharsModel.count - 1)
                        }
                        if (usePasswordChars && passwordCharsFlickable.contentWidth > passwordCharsFlickable.width)
                            passwordCharsFlickable.contentX = passwordCharsFlickable.contentWidth - passwordCharsFlickable.width;

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
                        color: "transparent"
                    }

                }

                Rectangle {
                    id: customCursor

                    visible: password.activeFocus && usePasswordChars && password.text.length === 0
                    color: Qt.rgba(Colors.on_surface.r, Colors.on_surface.g, Colors.on_surface.b, 0.6)
                    width: 2
                    height: password.height * 0.8
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: -1
                    anchors.left: passwordCharsFlickable.left
                    anchors.leftMargin: 0
                    enabled: false

                    Behavior on opacity {
                        NumberAnimation {
                            duration: Appearance.animation.elementMoveFast.duration
                            easing.type: Appearance.animation.elementMoveFast.type
                            easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
                        }

                    }

                }

                StyledFlickable {
                    id: passwordCharsFlickable

                    visible: usePasswordChars
                    anchors.fill: parent
                    anchors.margins: 8
                    anchors.leftMargin: 13
                    contentWidth: dotsRow.implicitWidth + 20
                    flickableDirection: Flickable.HorizontalFlick

                    Row {
                        id: dotsRow

                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 3

                        Repeater {
                            model: passwordCharsModel

                            delegate: MaterialCookie {
                                id: cookie

                                required property int index

                                implicitSize: 19
                                color: Colors.on_surface_variant
                                sides: loginContainer.customShapeSequence[index % loginContainer.customShapeSequence.length]
                                amplitude: 1.5
                                opacity: 0
                                scale: 0.5

                                SequentialAnimation {
                                    id: appearAnim

                                    running: true

                                    ParallelAnimation {
                                        NumberAnimation {
                                            target: cookie
                                            properties: "opacity"
                                            to: 1
                                            duration: Appearance.animation.elementMoveEnter.duration
                                            easing.type: Appearance.animation.elementMoveEnter.type
                                            easing.bezierCurve: Appearance.animation.elementMoveEnter.bezierCurve
                                        }

                                        NumberAnimation {
                                            target: cookie
                                            properties: "scale"
                                            to: 1
                                            duration: Appearance.animation.elementMoveEnter.duration
                                            easing.type: Appearance.animation.elementMoveEnter.type
                                            easing.bezierCurve: Appearance.animation.elementMoveEnter.bezierCurve
                                        }

                                    }

                                }

                            }

                        }

                    }

                    TapHandler {
                        onTapped: password.forceActiveFocus()
                    }

                }

                Text {
                    id: capsLockIndicator

                    anchors.right: parent.right
                    anchors.rightMargin: 18
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
                                duration: Appearance.animation.elementMoveEnter.duration
                                easing.type: Appearance.animation.elementMoveEnter.type
                                easing.bezierCurve: Appearance.animation.elementMoveEnter.bezierCurve
                            }

                            NumberAnimation {
                                properties: "scale"
                                duration: Appearance.animation.elementMoveEnter.duration
                                easing.type: Appearance.animation.elementMoveEnter.type
                                easing.bezierCurve: Appearance.animation.elementMoveEnter.bezierCurve
                            }

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
                    onPressed: mouse.accepted = false
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

    Timer {
        id: cursorBlinkTimer

        interval: 530
        running: password.activeFocus && loginContainer.usePasswordChars && password.text.length === 0
        repeat: true
        onTriggered: {
            customCursor.opacity = (customCursor.opacity === 0) ? 1 : 0;
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
            loginContainer.isLoggingIn = false;
        }

        target: sddm
    }

}
