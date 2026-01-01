import "Commons"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

FocusScope {
    id: userIsland

    property alias currentIndex: userList.currentIndex
    property bool isOpen: false
    readonly property string currentText: selectedTextMetrics.text
    readonly property int baseHeight: 42
    readonly property int popupHeight: Math.min(400, userList.contentHeight + 8)
    readonly property int baseWidth: Math.ceil(selectedTextMetrics.advanceWidth + 60)
    readonly property int expandedWidth: Math.ceil(Math.max(100, longestTextMetrics.advanceWidth + 90))

    focusPolicy: Qt.ClickFocus 
    implicitWidth: isOpen ? expandedWidth : baseWidth
    // IMPORTANTE: Teniamo l'altezza fissa a 42 per permettere l'espansione verso l'alto
    implicitHeight: baseHeight 

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

    // RIMOSSO: Il MouseArea outsideCloser per la chiusura esterna

    TextMetrics {
        id: selectedTextMetrics
        font.family: Appearance.font_family_main
        font.pixelSize: Appearance.font_size_normal
        text: userModel.data(userModel.index(userList.currentIndex, 0), 257) || ""
    }

    TextMetrics {
        id: longestTextMetrics
        font.family: Appearance.font_family_main
        font.pixelSize: Appearance.font_size_normal
        text: {
            var longest = "";
            for (var i = 0; i < userModel.count; i++) {
                var name = userModel.data(userModel.index(i, 0), 257);
                if (name && name.length > longest.length)
                    longest = name;
            }
            return longest;
        }
    }

    Rectangle {
        id: animatedContainer
        // Ancorato al fondo del FocusScope (che è alto 42)
        anchors.bottom: parent.bottom 
        width: parent.width
        // Quando cresce in altezza, può crescere solo verso l'alto perché il fondo è bloccato
        height: isOpen ? userIsland.popupHeight : userIsland.baseHeight
        antialiasing: true
        clip: true
        color: isOpen ? Colors.primary_container : (userButton.hovered ? Colors.surface_container_highest : Colors.surface_container)
        radius: isOpen ? 16 : Appearance.rounding_full
        
        z: 1 // Sopra gli elementi sottostanti

        // Questo MouseArea impedisce i click di "passare attraverso" il container
        // mantenendo il focus sul componente quando si clicca all'interno del popup
        MouseArea {
            anchors.fill: parent
            enabled: isOpen
            onClicked: (mouse) => { mouse.accepted = true; }
        }

        Button {
            id: userButton
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom // Sempre al fondo
            height: userIsland.baseHeight
            hoverEnabled: true
            focusPolicy: Qt.NoFocus
            opacity: isOpen ? 0 : 1
            visible: opacity > 0
            onClicked: {
                userIsland.forceActiveFocus();
                isOpen = true;
            }

            background: Item {
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.NoButton
                }
            }

            contentItem: RowLayout {
                spacing: 8
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12

                Avatar {
                    size: 24
                    userName: selectedTextMetrics.text
                    source: userModel.data(userModel.index(userList.currentIndex, 0), 260) || ""
                    iconColor: Colors.on_surface_variant
                }

                Text {
                    Layout.fillWidth: true
                    text: selectedTextMetrics.text
                    font: selectedTextMetrics.font
                    color: Colors.on_surface_variant
                    elide: Text.ElideRight
                }
            }
        }

        ListView {
            id: userList
            anchors.fill: parent
            anchors.topMargin: 4
            anchors.bottomMargin: 0
            anchors.leftMargin: 2
            anchors.rightMargin: 2
            model: userModel
            spacing: 2
            focusPolicy: Qt.NoFocus
            focus: isOpen
            opacity: isOpen ? 1 : 0
            visible: opacity > 0
            currentIndex: userModel.lastIndex

            delegate: ItemDelegate {
                id: userDelegate
                width: userList.width
                height: 48
                highlighted: ListView.isCurrentItem
                focusPolicy: Qt.NoFocus
                onClicked: {
                    userList.currentIndex = index;
                    isOpen = false;
                }

                contentItem: RowLayout {
                    spacing: 8
                    Avatar {
                        size: 26
                        Layout.leftMargin: 4
                        userName: model.name
                        source: model.icon || ""
                        iconColor: userDelegate.highlighted ? Colors.on_primary : Colors.on_primary_container
                    }
                    Text {
                        text: model.name
                        font: selectedTextMetrics.font
                        color: userDelegate.highlighted ? Colors.on_primary : Colors.on_primary_container
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                background: Rectangle {
                    color: userDelegate.highlighted ? Colors.primary : (userDelegate.hovered ? Colors.colPrimaryContainerHover : Colors.primary_container)
                    radius: 12
                }
            }
        }

        Behavior on height {
            NumberAnimation { duration: 250; easing.type: Easing.InOutQuad }
        }

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }

    Behavior on implicitWidth {
        NumberAnimation { duration: 250; easing.type: Easing.InOutQuad }
    }
}