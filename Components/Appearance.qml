import QtQuick
pragma Singleton

QtObject {
    property string font_family_main: "Rubik"
    property string font_family_expressive: "Space Grotesk"
    property string font_family_title: "Gabarito"
    property string font_family_reading: "Readex Pro"
    property real font_size_normal: 15
    property real font_size_small: 12
    property real formRowHeight: 57
    property real formRowBottomMargin: 20
    property real rounding_full: 1000
    property color listBackground: Colors.primary_container
    property color listTextColor: Colors.on_primary_container
    property color listHighlighted: Colors.primary
    property color listTextHighlighted: Colors.on_primary
    property real listItemSpacing: 5
}
