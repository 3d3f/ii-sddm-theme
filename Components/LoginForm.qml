// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2025 Keyitdev
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html
// Modified by 3d3f for the "ii-sddm-theme" project (2025)
// Licensed under the GNU General Public License v3.0
// See: https://www.gnu.org/licenses/gpl-3.0.txt

import QtQuick
import QtQuick.Layouts
import SddmComponents as SDDM

Item {
    id: formContainer

    anchors.fill: parent

    SDDM.TextConstants {
        id: textConstants
    }

    Loader {
        id: clockLoader

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -45
        active: Settings.background_widgets_clock_style !== "none"
        sourceComponent: {
            if (Settings.background_widgets_clock_style === "cookie")
                return cookieClockComponent;
            else if (Settings.background_widgets_clock_style === "digital")
                return digitalClockComponent;
            return null;
        }
    }

    Component {
        id: digitalClockComponent

        DigitalClock {
            id: digitalClock
        }

    }

    Component {
        id: cookieClockComponent

        CookieClock {
            id: cookieClock
        }

    }

    CVKeyboard {
        id: virtualKeyboard
    }

    RowLayout {
        id: mainRow

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Appearance.formRowBottomMargin
        spacing: 10

        SessionButton {
            id: sessionSelect

            Layout.alignment: Qt.AlignBottom
        }

        Input {
            id: input

            Layout.alignment: Qt.AlignBottom
        }

        SystemButtons {
            id: systemButtons

            Layout.alignment: Qt.AlignBottom
            exposedSession: input.exposeSession
        }

        VirtualKeyboardButton {
            Layout.alignment: Qt.AlignBottom
        }

    }

}
