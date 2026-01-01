import "../"
import "Commons"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SddmComponents as SDDM

FocusScope {
    id: sessionIsland

    property alias selectedSession: sessionList.currentIndex
    property bool isOpen: false
    // Dimensioni dinamiche
    readonly property int baseWidth: Math.ceil(Math.max(140, Math.min(300, selectedTextMetrics.advanceWidth + 50)))
    readonly property int expandedWidth: Math.ceil(Math.max(200, Math.min(300, longestTextMetrics.advanceWidth + 70)))
    readonly property int baseHeight: Appearance.formRowHeight
    readonly property int expandedHeight: Math.ceil(Math.min(sessionList.contentHeight + 16, 450))

    implicitWidth: isOpen ? expandedWidth : baseWidth
    implicitHeight: isOpen ? expandedHeight : baseHeight
    Layout.alignment: Qt.AlignBottom
    focusPolicy: Qt.ClickFocus
    
    onActiveFocusChanged: {
        if (!activeFocus)
            isOpen = false;
    }

    Keys.onPressed: function(event) {
        if (!isOpen) {
            if (event.key === Qt.Key_Up || event.key === Qt.Key_Down || event.key === Qt.Key_Return) {
                isOpen = true;
                event.accepted = true;
            }
        } else {
            if (event.key === Qt.Key_Escape || event.key === Qt.Key_Return) {
                isOpen = false;
                event.accepted = true;
            }
        }
    }

    TextMetrics {
        id: selectedTextMetrics

        font.family: Appearance.font_family_main
        font.pixelSize: Appearance.font_size_normal
        text: sessionList.currentItem ? sessionList.currentItem.sessionName : ""
    }

    TextMetrics {
        id: longestTextMetrics

        font.family: Appearance.font_family_main
        font.pixelSize: Appearance.font_size_normal
        text: {
            var longest = "";
            for (var i = 0; i < sessionModel.count; i++) {
                var name = sessionModel.data(sessionModel.index(i, 0), 257);
                if (name && name.length > longest.length)
                    longest = name;

            }
            return longest;
        }
    }

    Rectangle {
        id: animatedContainer

        anchors.fill: parent
        antialiasing: true
        clip: true
        color: isOpen ? Colors.primary_container : (sessionButton.hovered ? Colors.surface_container_highest : Colors.surface_container)
        radius: isOpen ? 16 : Appearance.rounding_full

        Button {
            id: sessionButton

            anchors.fill: parent
            hoverEnabled: true
            focusPolicy: Qt.NoFocus
            opacity: isOpen ? 0 : 1
            visible: opacity > 0
            enabled: !isOpen
            onClicked: {
                sessionIsland.forceActiveFocus();
                isOpen = true;
            }

            background: Item {
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.NoButton
                }

            }

            contentItem: Text {
                text: selectedTextMetrics.text
                font: selectedTextMetrics.font
                color: Colors.on_surface_variant
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

        }

        ListView {
            id: sessionList

            anchors.fill: parent
            anchors.margins: 8
            model: sessionModel
            clip: true
            spacing: 8
            focusPolicy: Qt.NoFocus
            focus: isOpen
            opacity: isOpen ? 1 : 0
            visible: opacity > 0
            currentIndex: sessionModel.lastIndex

            delegate: Item {
                id: sessionEntry

                readonly property string sessionName: name

                width: sessionList.width
                height: 48

                Rectangle {
                    anchors.fill: parent
                    radius: 12
                    color: sessionList.currentIndex === index ? Colors.primary : (ma.containsMouse ? Colors.colPrimaryContainerHover : Colors.primary_container)
                }

                Text {
                    anchors.centerIn: parent
                    width: parent.width - 20
                    text: name
                    font.family: Appearance.font_family_main
                    font.pixelSize: Appearance.font_size_normal
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    color: sessionList.currentIndex === index ? Colors.on_primary : Colors.on_primary_container
                }

                MouseArea {
                    id: ma

                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        sessionList.currentIndex = index;
                        isOpen = false;
                    }
                }

            }

        }

        Behavior on color {
            ColorAnimation {
                duration: 200
            }

        }

        Behavior on radius {
            NumberAnimation {
                duration: 250
            }

        }

    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 250
            easing.type: Easing.InOutQuad
        }

    }

    Behavior on implicitHeight {
        NumberAnimation {
            duration: 250
            easing.type: Easing.InOutQuad
        }

    }

}