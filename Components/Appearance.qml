import QtQuick
pragma Singleton

QtObject {
    property real font_size_normal: 15
    property real font_size_small: 12
    property real formRowHeight: 57
    property real formRowBottomMargin: 20
    property color listBackground: Colors.primary_container
    property color listTextColor: Colors.on_primary_container
    property color listHighlighted: Colors.primary
    property color listTextHighlighted: Colors.on_primary
    property real listItemSpacing: 5
}
