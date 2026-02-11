// Adapted from end-4's Hyprland dotfiles (https://github.com/end-4/dots-hyprland)

import QtQuick
import QtQuick.Effects

import "../"

RectangularShadow {
    required property var target
    anchors.fill: target
    radius: 1000
    blur: 0.9 * 10
    offset: Qt.vector2d(0.0, 1.0)
    spread: 1
    color: Colors.colShadow
    cached: true
}
