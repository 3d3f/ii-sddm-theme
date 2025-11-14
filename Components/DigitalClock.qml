// Adapted from end-4's Hyprland dotfiles (https://github.com/end-4/dots-hyprland)
// Modified by 3d3f for "ii-sddm-theme" (2025)
import QtQuick
import QtQuick.Controls

import "Commons"

Item {
    id: clock

    property string background_quote: Settings.background_widgets_clock_quote_text
    property bool background_showQuote: Settings.background_widgets_clock_quote_enable
    readonly property bool sessionLockedActive: Settings.background_widgets_clock_quote_text && config.ShowSessionLockedText === "true" && config.SessionLockedText !== ""
    readonly property bool quoteActive: background_showQuote && background_quote !== ""
    readonly property int quoteTopMargin: 6
    readonly property int sessionLockedTopMargin: 14

    implicitWidth: timeLabel.implicitWidth
    implicitHeight: timeLabel.implicitHeight + dateLabel.implicitHeight + (quoteLoader.active ? quoteLoader.height : 0) + (sessionLockedLoader.active ? sessionLockedLoader.height : 0)
    anchors.centerIn:parent
    anchors.verticalCenterOffset: 33
    StyledText {
        id: timeLabel
        text: TimeManager.formattedTime
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 0
        font.family: Appearance.font_family_expressive
        font.pixelSize: 90
        font.weight: Font.DemiBold
        color: Colors.primary_fixed_dim
        renderType: Text.NativeRendering
        font.hintingPreference: Font.PreferDefaultHinting
        style: Text.Raised
        styleColor: Colors.colShadow
        animateChange: Settings.background_widgets_clock_digital_animateChange
    }

    StyledText {
        id: dateLabel
        text: TimeManager.formattedDateShort
        anchors.top: timeLabel.bottom
        anchors.horizontalCenter: timeLabel.horizontalCenter
        anchors.topMargin: 4
        font.family: Appearance.font_family_expressive
        font.pixelSize: 20
        font.weight: Font.DemiBold
        color: Colors.primary_fixed_dim
        animateChange: false//Settings.background_widgets_clock_digital_animateChange
    }

    // Quote Label 
    Loader {
        id: quoteLoader

        active: clock.quoteActive
        anchors.top: dateLabel.bottom
        anchors.horizontalCenter: dateLabel.horizontalCenter
        anchors.topMargin: clock.quoteTopMargin
        z: 10

        sourceComponent: Component {
                Label {
                    id: quoteLabel
                    text: clock.background_quote
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: Appearance.font_family_expressive
                    font.pixelSize: 16
                    font.weight: 350
                    font.italic: false
                    color: Colors.primary_fixed_dim
                    horizontalAlignment: Text.AlignHCenter
                    style: Text.Raised
                    styleColor: Colors.colShadow
                }

        }

    }

    Loader {
        id: sessionLockedLoader

        active: clock.sessionLockedActive
        anchors.top: clock.quoteActive ? quoteLoader.bottom : dateLabel.bottom
        anchors.horizontalCenter: dateLabel.horizontalCenter
        anchors.topMargin: clock.sessionLockedTopMargin
        z: 11

        sourceComponent: Component {
            Item {
                width: sessionLockedRow.width
                height: sessionLockedRow.height

                Row {
                    id: sessionLockedRow

                    anchors.centerIn: parent
                    spacing: 4

                    Text {
                        id: lockIcon

                        font.family: "Material Symbols Outlined"
                        font.pixelSize: 20
                        text: "lock"
                        color: Colors.primary_fixed_dim
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        id: sessionLockedText
                        text: config.SessionLockedText
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        renderType: Text.NativeRendering
                        color: Colors.primary_fixed_dim
                        font.family: Appearance.font_family_expressive
                        font.pixelSize: 17
                        font.weight: Font.Normal
                        anchors.verticalCenter: parent.verticalCenter
                    }

                }

            }

        }

    }
}