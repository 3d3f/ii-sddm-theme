// Adapted from end-4's Hyprland dotfiles (https://github.com/end-4/dots-hyprland)

import QtQuick
import QtQuick.Controls

Flickable {
    id: root

    maximumFlickVelocity: 3500
    boundsBehavior: Flickable.DragOverBounds

    ScrollBar.vertical: ScrollBar {
        policy: ScrollBar.AsNeeded
    }

    ScrollBar.horizontal: ScrollBar {
        policy: ScrollBar.AlwaysOff
    }

    Behavior on contentX {
        enabled: !root.moving

        NumberAnimation {
            duration: Appearance.animation.scroll.duration
            easing.type: Appearance.animation.scroll.type
            easing.bezierCurve: Appearance.animation.scroll.bezierCurve
        }

    }

    Behavior on contentY {
        enabled: !root.moving

        NumberAnimation {
            duration: Appearance.animation.scroll.duration
            easing.type: Appearance.animation.scroll.type
        }

    }

}
