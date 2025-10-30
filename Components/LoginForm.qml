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
        active: Settings.background_clock_style !== "none"
        sourceComponent: {
            if (Settings.background_clock_style === "cookie")
                return cookieClockComponent;
            else if (Settings.background_clock_style === "digital")
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
