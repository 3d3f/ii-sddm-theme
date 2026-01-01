import "../"
import QtQuick

Text {
    id: tipText

    anchors.centerIn: parent
    text: ""
    font.family: Appearance.waffleFont
    color: Appearance.dynamicPopupText
    renderType: Text.QtRendering
    font.pixelSize: 12
    font.weight: Font.DemiBold
}
