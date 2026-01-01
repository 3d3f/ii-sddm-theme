import "Commons"
// Adapted from end-4's Hyprland dotfiles (https://github.com/end-4/dots-hyprland)
// Modified by 3d3f for "ii-sddm-theme" (2025)
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: clock

    property string background_quote: Settings.background_widgets_clock_quote_text
    property bool background_showQuote: Settings.background_widgets_clock_quote_enable
    readonly property bool sessionLockedActive: config.ShowSessionLockedText === "true" && config.SessionLockedText !== ""
    readonly property bool quoteActive: background_showQuote && background_quote !== ""
    readonly property int quoteTopMargin: 6
    readonly property int sessionLockedTopMargin: 14
    readonly property bool isVertical: Settings.background_widgets_clock_digital_vertical
    readonly property bool showDate: Settings.background_widgets_clock_digital_showDate
    readonly property bool animateChange: Settings.background_widgets_clock_digital_animateChange
    readonly property bool adaptiveAlignment: Settings.background_widgets_clock_digital_adaptiveAlignment
    readonly property string fontFamily: Settings.background_widgets_clock_digital_font_family
    readonly property int fontSize: Settings.background_widgets_clock_digital_font_size
    readonly property int fontWeight: Settings.background_widgets_clock_digital_font_weight
    readonly property real fontWidth: Settings.background_widgets_clock_digital_font_width
    readonly property int fontRoundness: Settings.background_widgets_clock_digital_font_roundness
    readonly property var fontVariableAxes: ({
        "wght": clock.fontWeight,
        "wdth": clock.fontWidth,
        "ROND": clock.fontRoundness
    })

    implicitWidth: clockColumn.implicitWidth
    implicitHeight: clockColumn.implicitHeight + (quoteLoader.active ? quoteLoader.height : 0) + (sessionLockedLoader.active ? sessionLockedLoader.height : 0)
    anchors.centerIn: parent
    anchors.verticalCenterOffset: 33

    ColumnLayout {
        id: clockColumn

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        spacing: clock.isVertical ? 4 : 4

        StyledText {
            id: timeLabel

            text: clock.isVertical ? TimeManager.formattedTime.split(":")[0].padStart(2, "0") : TimeManager.formattedTime
            Layout.alignment: Qt.AlignHCenter
            animateChange: clock.animateChange
            animationDistanceY: 6
            animationDistanceX: 0
            defaultFont: clock.fontFamily
            font.pixelSize: clock.fontSize
            color: Colors.primary_fixed_dim
            style: Text.Raised
            styleColor: Colors.colShadow
            horizontalAlignment: Text.AlignHCenter
            Component.onCompleted: {
                font.variableAxes = clock.fontVariableAxes;
            }
        }

        Loader {
            id: timeBottomLoader

            Layout.topMargin: clock.isVertical ? -40 : 0
            active: clock.isVertical
            visible: active
            Layout.alignment: Qt.AlignHCenter

            sourceComponent: StyledText {
                text: TimeManager.formattedTime.split(":")[1].split(" ")[0].padStart(2, "0")
                animateChange: clock.animateChange
                animationDistanceY: 6
                animationDistanceX: 0
                defaultFont: clock.fontFamily
                font.pixelSize: clock.fontSize
                color: Colors.primary_fixed_dim
                style: Text.Raised
                styleColor: Colors.colShadow
                horizontalAlignment: Text.AlignHCenter
                Component.onCompleted: {
                    font.variableAxes = clock.fontVariableAxes;
                }
            }

        }

        StyledText {
            id: dateLabel

            visible: clock.showDate
            text: TimeManager.formattedDateShort
            Layout.topMargin: clock.isVertical ? -20 : 4
            Layout.alignment: Qt.AlignHCenter
            animateChange: false
            defaultFont: Appearance.font_family_main
            font.pixelSize: 20
            color: Colors.primary_fixed_dim
            horizontalAlignment: Text.AlignHCenter
            Component.onCompleted: {
                font.variableAxes = {
                    "wght": 350
                };
            }
        }

        Loader {
            id: quoteLoader

            active: clock.quoteActive
            Layout.topMargin: clock.quoteTopMargin
            Layout.alignment: Qt.AlignHCenter

            sourceComponent: StyledText {
                text: clock.background_quote
                animateChange: false
                defaultFont: Appearance.font_family_main
                font.pixelSize: 16
                font.italic: false
                color: Colors.primary_fixed_dim
                horizontalAlignment: Text.AlignHCenter
                style: Text.Raised
                styleColor: Colors.colShadow
                Component.onCompleted: {
                    font.variableAxes = {
                        "wght": 350
                    };
                }
            }

        }

        Loader {
            id: sessionLockedLoader

            active: clock.sessionLockedActive
            Layout.topMargin: clock.sessionLockedTopMargin
            Layout.alignment: Qt.AlignHCenter

            sourceComponent: Item {
                width: sessionLockedRow.width
                height: sessionLockedRow.height

                Row {
                    id: sessionLockedRow

                    anchors.centerIn: parent
                    spacing: 4

                    Text {
                        id: lockIcon

                        font.family: Appearance.illogicalIconFont
                        font.pixelSize: 20
                        text: "lock"
                        color: Colors.primary_fixed_dim
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    StyledText {
                        id: sessionLockedText

                        text: config.SessionLockedText
                        animateChange: false
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        color: Colors.primary_fixed_dim
                        defaultFont: Appearance.font_family_main
                        font.pixelSize: 17
                        anchors.verticalCenter: parent.verticalCenter
                        Component.onCompleted: {
                            font.variableAxes = {
                                "wght": Font.Normal
                            };
                        }
                    }

                }

            }

        }

    }

}
