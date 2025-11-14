import QtQuick

import "../"

Rectangle {
    id: focusRing

    property Item target
    property real offset: 0
    property color ringColor: Colors.primary
    property int ringWidth: 2
    property real ringRadius: 1000

    anchors.fill: parent
    anchors.margins: -offset
    radius: ringRadius
    color: "transparent"
    border.color: ringColor
    opacity: target && target.activeFocus ? 1 : 0
    border.width: target && target.activeFocus ? ringWidth + 1 : ringWidth

    Behavior on opacity {
        NumberAnimation {
            duration: 150
            easing.type: Easing.OutCubic
        }

    }

    Behavior on border.width {
        NumberAnimation {
            duration: 150
            easing.type: Easing.OutCubic
        }

    }

}
