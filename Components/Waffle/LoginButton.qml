// Adapted from syrupderg's win11-sddm-theme (https://github.com/syrupderg/win11-sddm-theme)
// Modified by 3d3f for "ii-sddm-theme" 

import "../"
import QtQuick
import QtQuick.Controls

Button {
    id: loginButton

    hoverEnabled: true
    width: 29
    height: 22
    onPressed: {
        scaleUpAnimation.start();
    }
    onReleased: {
        scaleDownAnimation.start();
    }
    onCanceled: {
        scaleDownAnimation.start();
    }

    NumberAnimation {
        id: scaleUpAnimation

        target: loginButton
        property: "scale"
        to: 1.08
        duration: 100
        easing.type: Easing.OutQuad
    }

    NumberAnimation {
        id: scaleDownAnimation

        target: loginButton
        property: "scale"
        to: 1
        duration: 150
        easing.type: Easing.OutBack
        easing.overshoot: 1.1
    }

    MouseArea {
        id: mouseTracker

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.ArrowCursor
        onPressed: mouse.accepted = false
        onReleased: mouse.accepted = false
        onClicked: mouse.accepted = false
        onExited: {
            if (loginButton.down)
                scaleDownAnimation.start();

        }
    }

    contentItem: Text {
        id: loginText

        color: Appearance.highContrastEnabled ? "#000000" : (loginButton.down || loginButton.hovered ? Colors.on_primary : Colors.on_surface)
        text: "\ue0EA"
        font.family: Appearance.waffleIconFont
        font.pixelSize: Appearance.waffleButtonIconFontSize
        renderType: Text.QtRendering
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        id: loginbuttonBackground

        implicitWidth: 33
        implicitHeight: 24
        color: Appearance.highContrastEnabled ? (loginButton.hovered ? "#FFFFFF" : "#1AEBFF") : (loginButton.down || loginButton.hovered ? Colors.primary : "transparent")
        radius: 4
    }

}
