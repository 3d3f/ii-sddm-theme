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
            radius: 1000
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
