// Adapted from end-4's Hyprland dotfiles (https://github.com/end-4/dots-hyprland)

import QtQuick
import QtQuick.Controls

import "../"

ScrollBar {
    id: root

    policy: ScrollBar.AsNeeded
    topPadding: 17
    bottomPadding: 17

    contentItem: Rectangle {
        implicitWidth: 4
        implicitHeight: root.visualSize
        radius: width / 2
        color: Colors.on_surface_variant
        
        opacity: root.policy === ScrollBar.AlwaysOn || (root.active && root.size < 1.0) ? 0.5 : 0
        Behavior on opacity {
            NumberAnimation {
                duration: 350
                easing.type: Appearance.animation.elementMoveFast.type
                easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
            }
        }
    }
}
