// Adapted from syrupderg's win11-sddm-theme (https://github.com/syrupderg/win11-sddm-theme)
// Modified by 3d3f for "ii-sddm-theme"

import "../"
import "../Assets"
import Qt5Compat.GraphicalEffects
import QtMultimedia
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import SddmComponents as SDDM
import "Waffle"

Item {
    id: waffle

    property bool unlocked: false

    anchors.fill: parent

    SDDM.TextConstants {
        id: textConstants
    }

    Rectangle {
        id: startupBg

        anchors.fill: parent
        color: "transparent"
        z: 5

        MouseArea {
            id: mouseArea

            property bool dragActive: drag.active

            anchors.fill: parent
            drag.target: timeDate
            drag.axis: Drag.YAxis
            drag.minimumY: -parent.height / 2
            drag.maximumY: 0
            focus: true
            focusPolicy: Qt.StrongFocus
            cursorShape: Qt.ArrowCursor
            Component.onCompleted: {
                forceActiveFocus();
            }
            onClicked: {
                waffle.unlocked = true;
                this.enabled = false;
                this.visible = false;
                listView.focus = true;
                mouseArea.focus = false;
                mouseArea.enabled = false;
                timeDateYAnim.to = -100;
                seqStart.start();
                parStart.start();
            }
            Keys.onPressed: function(event) {
                waffle.unlocked = true;
                mouseArea.enabled = false;
                mouseArea.visible = false;
                listView.forceActiveFocus();
                timeDateYAnim.to = -100;
                seqStart.start();
                parStart.start();
                event.accepted = true;
            }
            onDragActiveChanged: {
                if (!drag.active) {
                    var threshold = -300;
                    if (timeDate.y < threshold) {
                        waffle.unlocked = true;
                        this.enabled = false;
                        this.visible = false;
                        listView.forceActiveFocus();
                        timeDateYAnim.to = -timeDate.parent.height;
                        seqStart.start();
                        parStart.start();
                    } else {
                        snapBackAnimation.start();
                    }
                }
            }
        }

        NumberAnimation {
            id: snapBackAnimation

            target: timeDate
            property: "y"
            to: 0
            duration: 200
            easing.type: Easing.OutQuad
        }

        ParallelAnimation {
            id: parStart

            running: false

            NumberAnimation {
                id: timeDateYAnim

                target: timeDate
                properties: "y"
                to: -100
                duration: 150
            }

            NumberAnimation {
                target: timeDate
                properties: "visible"
                from: 1
                to: 0
                duration: 175
            }

            NumberAnimation {
                target: startupBg
                properties: "opacity"
                from: 1
                to: 0
                duration: 180
            }

        }

        SequentialAnimation {
            id: seqStart

            running: false

            ParallelAnimation {
                ScaleAnimator {
                    target: sizeHelper
                    from: 1
                    to: 1.01
                    duration: 250
                }

                NumberAnimation {
                    target: centerPanel
                    properties: "opacity"
                    from: 0
                    to: 1
                    duration: 225
                }

                NumberAnimation {
                    target: rightPanel
                    properties: "opacity"
                    from: 0
                    to: 1
                    duration: 100
                }

                NumberAnimation {
                    target: leftPanel
                    properties: "opacity"
                    from: 0
                    to: 1
                    duration: 100
                }

            }

        }

        Rectangle {
            id: timeDate

            width: parent.width
            height: parent.height
            color: "transparent"

            Column {
                id: timeContainer

                property date dateTime: new Date()

                anchors {
                    top: parent.top
                    topMargin: 145
                    horizontalCenter: parent.horizontalCenter
                }

                Timer {
                    interval: 100
                    running: true
                    repeat: true
                    onTriggered: timeContainer.dateTime = new Date()
                }

                Text {
                    id: time

                    color: "white"
                    font.pixelSize: 133
                    font.family: Appearance.waffleFont
                    renderType: Text.QtRendering
                    text: Qt.formatTime(timeContainer.dateTime, "hh:mm")

                    anchors {
                        horizontalCenter: parent.horizontalCenter
                    }

                }

                Rectangle {
                    id: spacingRect

                    color: "transparent"
                    width: 5
                    height: 5

                    anchors {
                        horizontalCenter: parent.horizontalCenter
                    }

                }

                Text {
                    id: date

                    color: "white"
                    font.pixelSize: 28
                    font.family: Appearance.waffleFont
                    font.weight: Font.DemiBold
                    renderType: Text.QtRendering
                    horizontalAlignment: Text.AlignLeft
                    text: Qt.formatDate(timeContainer.dateTime, "dddd, d MMMM")

                    anchors {
                        horizontalCenter: parent.horizontalCenter
                    }

                }

            }

        }

    }

    Item {
        id: centerPanel

        anchors.fill: parent
        z: 2
        opacity: 0

        Component {
            id: userDelegate

            FocusScope {
                property string userName: {
                    var data = userModel.data(userModel.index(index, 0), 257);
                    return data || model.name;
                }
                property string userRealName: {
                    if (model.realName === "" || !model.realName)
                        return userName;

                    return model.realName;
                }
                property string userIcon: {
                    var iconData = userModel.data(userModel.index(index, 0), 260);
                    if (iconData)
                        return iconData;

                    return "/var/lib/AccountsService/icons/" + userName;
                }
                property int currentListIndex: listView.currentIndex
                property alias password: passwordField.text
                property int session: sessionListPanel.session
                readonly property bool isMainImageValid: icon.status === Image.Ready && userName !== "" && icon.source.toString().indexOf(userName) !== -1

                onCurrentListIndexChanged: {
                    falsePass.visible = false;
                    passwordField.enabled = true;
                    passwordField.visible = true;
                }
                width: listView.width
                height: listView.height
                visible: ListView.isCurrentItem

                Connections {
                    function onLoginFailed() {
                        truePass.visible = false;
                        passwordField.visible = false;
                        passwordField.enabled = false;
                        passwordField.focus = false;
                        rightPanel.visible = false;
                        leftPanel.visible = false;
                        falsePass.visible = true;
                        falsePass.focus = true;
                        bootani.stop();
                    }

                    function onLoginSucceeded() {
                    }

                    target: sddm
                }

                Connections {
                    function onRetry() {
                        passwordField.text = "";
                        passwordField.visible = true;
                        passwordField.enabled = true;
                        passwordField.focus = true;
                        rightPanel.visible = true;
                        leftPanel.visible = true;
                        falsePass.visible = false;
                    }

                    target: falsePass
                }

                Image {
                    id: icon

                    width: 192
                    height: 192
                    smooth: true
                    visible: false
                    source: Qt.resolvedUrl(userIcon)
                    x: (parent.width - width) / 2
                    y: (parent.height / 2) - height - 37
                }

                OpacityMask {
                    anchors.fill: icon
                    source: icon
                    maskSource: mask
                    visible: isMainImageValid
                }

                Item {
                    anchors.fill: icon
                    visible: !isMainImageValid

                    Rectangle {
                        id: fallbackBackground

                        width: icon.width
                        height: icon.height
                        radius: width / 2
                        color: "#10FFFFFF"
                    }

                    Image {
                        id: fallbackIcon

                        anchors.centerIn: parent
                        width: parent.width * 0.53
                        height: parent.height * 0.53
                        source: Qt.resolvedUrl("../Assets/user-192-alt.png")
                        fillMode: Image.PreserveAspectFit
                        visible: false
                    }

                    ColorOverlay {
                        anchors.fill: fallbackIcon
                        source: fallbackIcon
                        color: "#FFFFFF"
                    }

                }

                Item {
                    id: mask

                    width: icon.width
                    height: icon.height
                    layer.enabled: true
                    visible: false

                    Rectangle {
                        width: icon.width
                        height: icon.height
                        radius: width / 2
                        color: "black"
                    }

                }

                Text {
                    id: name

                    color: "white"
                    font.pixelSize: 26
                    font.family: Appearance.waffleFont
                    font.weight: Font.Bold
                    renderType: Text.QtRendering
                    text: userRealName
                    x: (parent.width - width) / 2
                    y: icon.y + icon.height + 15
                }

                PasswordField {
                    id: passwordField

                    function loginLogic() {
                        truePass.visible = true;
                        passwordField.visible = false;
                        passwordField.enabled = false;
                        rightPanel.visible = false;
                        leftPanel.visible = false;
                        sddm.login(userName, passwordField.text, session);
                        bootani.start();
                        capsOn.z = -1;
                    }

                    visible: true
                    enabled: true
                    focus: true
                    x: (parent.width - width) / 2
                    y: name.y + name.height + 25
                    userName: parent.userName
                    userSession: parent.session
                    onLoginRequested: function(username, password, session) {
                        truePass.visible = true;
                        passwordField.visible = false;
                        passwordField.enabled = false;
                        rightPanel.visible = false;
                        leftPanel.visible = false;
                        sddm.login(username, password, session);
                        bootani.start();
                        capsOn.z = -1;
                    }
                    Keys.onReturnPressed: loginLogic()
                    Keys.onEnterPressed: loginLogic()
                }

                FalsePass {
                    id: falsePass

                    visible: false
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: 2
                    y: name.y + name.height + 65
                    onRetry: {
                        passwordField.text = "";
                        passwordField.visible = true;
                        passwordField.enabled = true;
                        passwordField.focus = true;
                        rightPanel.visible = true;
                        leftPanel.visible = true;
                        falsePass.visible = false;
                    }
                }

                Rectangle {
                    id: truePass

                    color: "transparent"
                    visible: false
                    width: 250
                    height: 150
                    x: (parent.width - width) / 2
                    y: name.y + name.height + 35

                    Text {
                        id: welcome

                        color: "white"
                        font.family: Appearance.waffleFont
                        text: "Welcome"
                        renderType: Text.QtRendering
                        font.pixelSize: 26
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 63
                    }

                    Rectangle {
                        id: trueButton

                        color: "transparent"
                        anchors.fill: parent

                        LoginAnim {
                        }

                    }

                }

                CapsOn {
                    id: capsOn

                    visible: false
                    state: keyboard.capsLock ? "on" : "off"
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: passwordField.y + passwordField.height + 20
                    states: [
                        State {
                            name: "on"

                            PropertyChanges {
                                target: capsOn
                                visible: true
                            }

                        },
                        State {
                            name: "off"

                            PropertyChanges {
                                target: capsOn
                                visible: false
                                z: -1
                            }

                        }
                    ]
                }

            }

        }

        ListView {
            id: listView

            anchors.fill: parent
            focus: true
            model: userModel
            delegate: userDelegate
            currentIndex: userModel.lastIndex
            interactive: false
            highlightMoveDuration: 0
            highlightMoveVelocity: -1
            highlightRangeMode: ListView.StrictlyEnforceRange
            preferredHighlightBegin: 0
            preferredHighlightEnd: 0
        }

    }

    Item {
        id: rightPanel

        z: 2
        opacity: 0

        anchors {
            bottom: parent.bottom
            right: parent.right
            margins: 65
        }

        PowerPanel {
            id: powerPanel

            z: 2
        }

        AccessibilityPanel {
            id: settingsPanel

            anchors {
                right: powerPanel.left
                rightMargin: 10
            }

        }

        SessionListPanel {
            id: sessionListPanel

            anchors {
                right: settingsPanel.left
                rightMargin: 10
            }

        }

        LayoutPanel {
            id: layoutPanel

            anchors {
                right: sessionListPanel.left
                rightMargin: 10
            }

        }

    }

    Rectangle {
        id: leftPanel

        color: "transparent"
        anchors.fill: parent
        z: 2
        opacity: 0
        visible: listView2.count > 1 ? true : false
        enabled: listView2.count > 1 ? true : false

        Component {
            id: userDelegate2

            UserList {
                userName: userModel.data(userModel.index(index, 0), 257) || model.name
                name: {
                    var rName = model.realName;
                    return (rName === "" || !rName) ? userName : rName;
                }
                iconSource: userModel.data(userModel.index(index, 0), 260) || ""
                anchors.horizontalCenter: parent.horizontalCenter
            }

        }

        Rectangle {
            width: 140
            height: listView2.count > 17 ? parent.height - 68 : 58 * listView2.count
            color: "transparent"
            clip: true

            anchors {
                bottom: parent.bottom
                bottomMargin: 30
                left: parent.left
                leftMargin: 30
            }

            Item {
                id: usersContainer2

                width: 140
                height: parent.height

                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }

                Button {
                    id: prevUser2

                    visible: true
                    enabled: false
                    width: 0

                    anchors {
                        bottom: parent.bottom
                        left: parent.left
                    }

                }

                ListView {
                    id: listView2

                    height: parent.height
                    focus: true
                    model: userModel
                    currentIndex: userModel.lastIndex
                    delegate: userDelegate2
                    verticalLayoutDirection: ListView.TopToBottom
                    orientation: ListView.Vertical
                    interactive: listView2.count > 17 ? true : false

                    anchors {
                        left: prevUser2.right
                        right: nextUser2.left
                    }

                }

                Connections {
                    function onCurrentIndexChanged() {
                        listView.currentIndex = listView2.currentIndex;
                    }

                    target: listView2
                }

                Button {
                    id: nextUser2

                    visible: true
                    width: 0
                    enabled: false

                    anchors {
                        bottom: parent.bottom
                        right: parent.right
                    }

                }

            }

        }

    }

    CVKeyboard {
        id: virtualKeyboard
    }

}
