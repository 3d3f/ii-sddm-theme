// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2025 Keyitdev
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html
// Modified by 3d3f for the "ii-sddm-theme" project (2025)
// Licensed under the GNU General Public License v3.0
// See: https://www.gnu.org/licenses/gpl-3.0.txt

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

RowLayout {
    id: inputContainer

    property ComboBox exposeSession: sessionSelect.exposeSession
    property bool failed

    Layout.preferredHeight: 400
    spacing: 10

    RowLayout {
        id: usernameField

        anchors.bottom: inputContainer.bottom
        Layout.preferredHeight: Appearance.formRowHeight
        spacing: 0

        Rectangle {
            id: usernameBackground

            anchors.fill: parent
            color: Colors.surface_container
            radius: Appearance.rounding_full
        }

        InputUserComboBox {
            id: selectUser
        }

        LayoutButton {
            id: layoutSelect

            Layout.alignment: Qt.AlignVCenter
        }

    }

    InputLogin {
        id: loginContainer
    }

    Connections {
        function onLoginSucceeded() {
        }

        function onLoginFailed() {
            failed = true;
            if (resetError.running)
                resetError.stop();

            resetError.start();
        }

        target: sddm
    }

    Timer {
        id: resetError

        interval: 2000
        onTriggered: failed = false
        running: false
    }

}
