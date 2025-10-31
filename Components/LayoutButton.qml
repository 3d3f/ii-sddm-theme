import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: layoutButton

    Layout.preferredHeight: Appearance.formRowHeight
    Layout.preferredWidth: contentRow.implicitWidth
    Layout.leftMargin: -4
    Layout.alignment: Qt.AlignVCenter

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        RowLayout {
            id: contentRow

            spacing: 4
            anchors.centerIn: parent

            Text {
                id: iconText

                property real fill: 1
                property real truncatedFill: Math.round(fill * 100) / 100

                Layout.topMargin: 2.5
                text: "keyboard_alt"
                font.family: "Material Symbols Outlined"
                font.pixelSize: 24
                color: Colors.on_surface_variant
                renderType: fill !== 0 ? Text.CurveRendering : Text.NativeRendering

                font {
                    hintingPreference: Font.PreferFullHinting
                    variableAxes: {
                        "FILL": truncatedFill,
                        "opsz": font.pixelSize
                    }
                }

            }

            Text {
                id: labelText

                Layout.topMargin: 2
                text: keyboard && keyboard.layouts && keyboard.layouts.length > 0 ? keyboard.layouts[keyboard.currentLayout].shortName.toLowerCase() : "en"
                font.family: Appearance.font_family_main
                font.pixelSize: Appearance.font_size_normal
                color: Colors.on_surface_variant
                rightPadding: 15

                Behavior on opacity {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.InOutQuad
                    }

                }

            }

            Behavior on Layout.preferredWidth {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.InOutCubic
                }

            }

        }

        Behavior on color {
            ColorAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }

        }

    }

    Behavior on Layout.preferredWidth {
        NumberAnimation {
            duration: 300
            easing.type: Easing.InOutCubic
        }

    }

}
