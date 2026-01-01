// Adapted from syrupderg's win11-sddm-theme (https://github.com/syrupderg/win11-sddm-theme)
// Modified by 3d3f for "ii-sddm-theme" 

import "../"
import QtQuick
import QtQuick.Controls

Rectangle {
    id: capsButton

    color: "transparent"

    Text {
        color: "white"
        font.family: Appearance.waffleFont
        text: "Caps Lock is on"
        renderType: Text.QtRendering
        font.weight: Font.Bold
        font.pixelSize: 13
        anchors.centerIn: parent
    }

}
