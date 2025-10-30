// Adapted from uiriansan SilentSDDM (https://github.com/uiriansan/SilentSDDM)
// Modified by 3d3f for "ii-sddm-Theme" (2025)
// See LICENSE in project root for full GPLv3 text

import QtQuick
import QtQuick.VirtualKeyboard
import QtQuick.VirtualKeyboard.Settings

InputPanel {
    id: virtualKeyboard

    property bool activated: false
    property bool keyboardOpen: false

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: mainRow.bottom
    anchors.bottomMargin: keyboardOpen ? systemButtons.Layout.preferredHeight + 20 : -height - 20
    width: 750
    opacity: keyboardOpen ? 1 : 0
    active: keyboardOpen
    visible: opacity > 0
    externalLanguageSwitchEnabled: false
    Component.onCompleted: {
        VirtualKeyboardSettings.styleName = "vkeyboardStyle";
        VirtualKeyboardSettings.layout = "symbols";
    }
    onActivatedChanged: {
        keyboardOpen = activated;
    }

    Behavior on anchors.bottomMargin {
        enabled: true

        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }

    }

    Behavior on opacity {
        enabled: true

        NumberAnimation {
            duration: 250
            easing.type: Easing.OutCubic
        }

    }

}
