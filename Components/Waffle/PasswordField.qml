// Adapted from syrupderg's win11-sddm-theme (https://github.com/syrupderg/win11-sddm-theme)
// Modified by 3d3f for "ii-sddm-theme" 

import "../"
import "../../"
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls

TextField {
    id: passwordField

    property string userName: ""
    property int userSession: 0

    readonly property bool isHighlighted: hovered || activeFocus || revealButton.hovered || loginButton.hovered || revealButton.pressed || loginButton.pressed
    readonly property bool isInputActive: activeFocus || revealButton.pressed || loginButton.pressed

    signal loginRequested(string username, string password, int session)

    width: 296
    height: 36
    focus: true
    focusPolicy: Qt.StrongFocus
    selectByMouse: true
    hoverEnabled: true
    horizontalAlignment: TextInput.AlignLeft
    verticalAlignment: TextInput.AlignVCenter
    leftPadding: 12
    rightPadding: revealButton.visible ? 75 : 40
    echoMode: revealButton.isRevealed ? TextInput.Normal : TextInput.Password
    placeholderText: ""
    color: Appearance.highContrastEnabled ? "#FFFFFF" : Colors.on_surface
    selectionColor: Appearance.highContrastEnabled ? "#1AEBFF" : Colors.primary
    renderType: Text.QtRendering
    onTextChanged: revealButton.visible = (text !== "")
    onAccepted: loginButton.clicked()

    font {
        family: Appearance.waffleFont
        pixelSize: 14
    }

    Text {
        id: customPlaceholder

        text: "Password"
        font: passwordField.font
        color: Appearance.highContrastEnabled ? "#FFFFFF" : Colors.on_surface
        opacity: Appearance.highContrastEnabled ? 1 : 0.8
        visible: passwordField.text === ""
        anchors.fill: parent
        anchors.leftMargin: passwordField.leftPadding
        verticalAlignment: Text.AlignVCenter
        renderType: Text.QtRendering
    }

    LoginButton {
        id: loginButton

        z: 2
        onClicked: {
            passwordField.loginRequested(passwordField.userName, passwordField.text, passwordField.userSession);
        }

        anchors {
            right: parent.right
            rightMargin: 6
            verticalCenter: parent.verticalCenter
        }

    }

    Timer {
        id: loginTooltipTimer

        interval: 1000
        onTriggered: customLoginTip.visible = true
    }

    Connections {
        function onHoveredChanged() {
            if (loginButton.hovered) {
                loginTooltipTimer.restart();
            } else {
                loginTooltipTimer.stop();
                customLoginTip.visible = false;
            }
        }

        target: loginButton
    }

    Rectangle {
        id: customLoginTip

        visible: false
        x: loginButton.x + (loginButton.width - width) / 2
        y: -height - 10
        width: tipText.implicitWidth + 22
        height: tipText.implicitHeight + 12
        color: Appearance.highContrastEnabled ? "#000000" : Appearance.wafflePopupBackground
        border.color: Appearance.highContrastEnabled ? "#FFFFFF" : Appearance.wafflePopupBorder
        border.width: 1
        radius: 0
        z: 3
        opacity: visible ? 1 : 0

        TooltipText {
            id: tipText

            text: "Submit"
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 100
            }

        }

    }

    RevealButton {
        id: revealButton

        visible: false
        focusPolicy: Qt.NoFocus
        z: 2

        anchors {
            right: loginButton.left
            rightMargin: 4
            verticalCenter: parent.verticalCenter
        }

    }

    MouseArea {
        cursorShape: Qt.IBeamCursor
        acceptedButtons: Qt.NoButton

        anchors {
            fill: parent
            rightMargin: revealButton.visible ? 70 : 35
        }

    }

    background: Rectangle {
        radius: 6
        color: Appearance.highContrastEnabled ? "#000000" : (passwordField.isHighlighted ? Colors.transparentize(Colors.surface, 0.3) : Colors.transparentize(Colors.surface, 0.9))

        border {
            color: Appearance.highContrastEnabled ? (passwordField.isInputActive ? "#1AEBFF" : "#FFFFFF") : Colors.transparentize(Colors.on_surface, 0.85)
            width: Appearance.highContrastEnabled ? 2 : 1.2
        }

        Item {
            visible: !Appearance.highContrastEnabled
            width: parent.width
            height: 2
            anchors.bottom: parent.bottom
            clip: true

            Rectangle {
                width: parent.width
                height: 36
                radius: 6
                anchors.bottom: parent.bottom
                color: "transparent"

                border {
                    width: 2.5
                    color: passwordField.isInputActive ? Colors.primary : Colors.transparentize(Colors.on_surface, 0.3)
                }

            }

        }

    }

}
