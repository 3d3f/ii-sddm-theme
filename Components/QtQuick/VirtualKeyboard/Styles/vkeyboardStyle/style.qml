// Copyright (C) 2016 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only
// Taken from https://github.com/qt/qtvirtualkeyboard/blob/16fbddbbc03777e0a006daa998eda14624d62268/src/styles/builtin/default/style.qml#L11

import "../../../../../Components"
import "../../../../../Components/Waffle"
import QtQuick
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import QtQuick.VirtualKeyboard.Styles

KeyboardStyle {
    id: currentStyle

    property bool isWaffleTheme: Settings.panelFamily === "waffle"
    readonly property bool compactSelectionList: [InputEngine.InputMode.Pinyin, InputEngine.InputMode.Cangjie, InputEngine.InputMode.Zhuyin].indexOf(InputContext.inputEngine.inputMode) !== -1
    readonly property string fontFamily: isWaffleTheme ? Appearance.waffleFont : Appearance.font_family_main
    readonly property real keyBackgroundMargin: Math.round(13 * scaleHint)
    readonly property real keyContentMargin: Math.round(40 * scaleHint)
    readonly property real keyIconScale: scaleHint * 0.8
    readonly property string inputLocale: InputContext.locale
    readonly property real spacialKeyScale: isWaffleTheme ? 20 : 25
    property color keyboardBackgroundColor: isWaffleTheme ? keyboardBackgroundColorWaffle : Colors.surface_container_low
    property color keyboardBackgroundColorWaffle: Appearance.highContrastEnabled ? "#000000" : Colors.surface
    property color normalKeyBackgroundColor: Appearance.highContrastEnabled ? "#000000" : Colors.surface_container
    property color highlightedKeyBackgroundColor: Appearance.highContrastEnabled ? "#000000" : Colors.surface_container
    property color capsLockKeyAccentColor: Appearance.highContrastEnabled ? "#FFFFFF" : Colors.on_surface_variant
    property color modeKeyAccentColor: Appearance.highContrastEnabled ? "#FFFFFF" : Colors.on_primary
    property color keyTextColor: Appearance.highContrastEnabled ? "#FFFFFF" : Colors.on_surface_variant
    property color keySmallTextColor: Appearance.highContrastEnabled ? "#FFFFFF" : Colors.on_surface_variant
    property color popupBackgroundColor: Appearance.highContrastEnabled ? "#000000" : Colors.surface_container_high
    property color popupBorderColor: isWaffleTheme ? popupBorderColorWaffle : Colors.surface_container_high
    property color popupBorderColorWaffle: Appearance.highContrastEnabled ? "#1AEBFF" : Colors.shadow
    property color popupTextColor: Appearance.highContrastEnabled ? "#FFFFFF" : Colors.on_surface_variant
    property color popupHighlightColor: Appearance.highContrastEnabled ? "#1AEBFF" : Colors.secondary
    property color selectionListTextColor: Appearance.highContrastEnabled ? "#FFFFFF" : Colors.on_surface_variant
    property color selectionListSeparatorColor: Appearance.highContrastEnabled ? "#1AEBFF" : Colors.tertiary
    property color selectionListBackgroundColor: "transparent"
    property color navigationHighlightColor: Appearance.highContrastEnabled ? "#1AEBFF" : Colors.primary
    property real inputLocaleIndicatorOpacity: 1
    property Timer inputLocaleIndicatorHighlightTimer
    property Component component_settingsIcon
    property color specialKeyActive: Appearance.highContrastEnabled ? "#1AEBFF" : Colors.primary
    property color specialKeyActiveText: Appearance.highContrastEnabled ? "#000000" : Colors.on_primary
    property color keyboardBackgroundBorderColor: Appearance.highContrastEnabled ? "#1AEBFF" : Colors.shadow
    property color listBackground: Appearance.highContrastEnabled ? "#000000" : Colors.primary_container
    property color listTextColor: Appearance.highContrastEnabled ? "#FFFFFF" : Colors.on_primary_container
    property color listHighlighted: Appearance.highContrastEnabled ? "#1AEBFF" : Colors.primary
    property color listTextHighlighted: Appearance.highContrastEnabled ? "#000000" : Colors.on_primary

    onInputLocaleChanged: {
        inputLocaleIndicatorOpacity = 1;
        inputLocaleIndicatorHighlightTimer.restart();
    }
    keyboardDesignWidth: 2560
    keyboardDesignHeight: 900
    keyboardRelativeLeftMargin: 30 / keyboardDesignWidth
    keyboardRelativeRightMargin: 30 / keyboardDesignWidth
    keyboardRelativeTopMargin: 30 / keyboardDesignHeight
    keyboardRelativeBottomMargin: 30 / keyboardDesignHeight
    characterPreviewMargin: 0
    alternateKeysListItemWidth: 120 * scaleHint
    alternateKeysListItemHeight: 170 * scaleHint
    selectionListHeight: 85 * scaleHint
    languagePopupListEnabled: true
    fullScreenInputMargins: Math.round(30 * scaleHint)
    fullScreenInputPadding: 0
    fullScreenInputColor: selectionListTextColor
    fullScreenInputFont.pixelSize: 44 * scaleHint

    inputLocaleIndicatorHighlightTimer: Timer {
        interval: 1000
        onTriggered: inputLocaleIndicatorOpacity = 0.5
    }

    component_settingsIcon: Component {
        Item {
            width: 80 * keyIconScale
            height: 80 * keyIconScale

            Text {
                anchors.centerIn: parent
                text: isWaffleTheme ? String.fromCodePoint(59155) : "settings"
                font.family: isWaffleTheme ? Appearance.waffleIconFont : Appearance.illogicalIconFont
                font.pixelSize: 48 * keyIconScale
                color: Colors.on_surface_variant
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

        }

    }

    keyboardBackground: Rectangle {
        color: "transparent"
        radius: 0

        Rectangle {
            z: parent.z - 1
            anchors.fill: parent
            color: keyboardBackgroundColor
            opacity: 1
            radius: isWaffleTheme ? 8 : 17
            border.width: isWaffleTheme ? 1 : 0
            border.color: keyboardBackgroundBorderColor
        }

    }

    keyPanel: KeyPanel {
        id: keyPanel

        states: [
            State {
                name: "pressed"
                when: control.pressed

                PropertyChanges {
                    target: keyBackground
                    opacity: 0.75
                }

                PropertyChanges {
                    target: keyText
                    opacity: 0.5
                }

            },
            State {
                name: "disabled"
                when: !control.enabled

                PropertyChanges {
                    target: keyBackground
                    opacity: 0.75
                }

                PropertyChanges {
                    target: keyText
                    opacity: 0.05
                }

            }
        ]

        Rectangle {
            id: keyBackground

            radius: isWaffleTheme ? 4 : 12
            color: control && control.highlighted ? highlightedKeyBackgroundColor : normalKeyBackgroundColor
            anchors.fill: keyPanel
            anchors.margins: keyBackgroundMargin
            border.width: isWaffleTheme ? 0.8 : 0
            border.color: keyboardBackgroundBorderColor
            states: [
                State {
                    when: control.smallText === "\u2699" && control.smallTextVisible

                    PropertyChanges {
                        target: keySmallText
                        visible: false
                    }

                    PropertyChanges {
                        target: loader_settingsIcon
                        sourceComponent: component_settingsIcon
                    }

                }
            ]

            Text {
                id: keySmallText

                text: control.smallText
                visible: control.smallTextVisible
                color: keySmallTextColor
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: keyContentMargin / 3

                font {
                    family: fontFamily
                    weight: Font.Normal
                    pixelSize: 60 * scaleHint
                    capitalization: control.uppercased ? Font.AllUppercase : Font.MixedCase
                }

            }

            Loader {
                id: loader_settingsIcon

                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: keyContentMargin / 3
            }

            Text {
                id: keyText

                text: control.displayText
                color: keyTextColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: control.displayText.length > 1 ? Text.AlignVCenter : Text.AlignBottom
                anchors.fill: parent
                anchors.leftMargin: keyContentMargin
                anchors.topMargin: keyContentMargin
                anchors.rightMargin: keyContentMargin
                anchors.bottomMargin: keyContentMargin

                font {
                    family: fontFamily
                    weight: Font.Normal
                    pixelSize: 60 * scaleHint
                    capitalization: control.uppercased ? Font.AllUppercase : Font.MixedCase
                }

            }

        }

    }

    backspaceKeyPanel: KeyPanel {
        id: backspaceKeyPanel

        states: [
            State {
                name: "pressed"
                when: control.pressed

                PropertyChanges {
                    target: backspaceKeyBackground
                    opacity: 0.8
                }

                PropertyChanges {
                    target: backspaceKeyIcon
                    opacity: 0.6
                }

            },
            State {
                name: "disabled"
                when: !control.enabled

                PropertyChanges {
                    target: backspaceKeyBackground
                    opacity: 0.8
                }

                PropertyChanges {
                    target: backspaceKeyIcon
                    opacity: 0.2
                }

            }
        ]

        Rectangle {
            id: backspaceKeyBackground

            radius: isWaffleTheme ? 4 : 12
            color: control && control.highlighted ? highlightedKeyBackgroundColor : normalKeyBackgroundColor
            anchors.fill: backspaceKeyPanel
            anchors.margins: keyBackgroundMargin
            border.width: isWaffleTheme ? 0.8 : 0
            border.color: keyboardBackgroundBorderColor

            Text {
                id: backspaceKeyIcon

                anchors.centerIn: parent
                text: isWaffleTheme ? "\uf1B2" : "backspace"
                font.family: isWaffleTheme ? Appearance.waffleIconFont : Appearance.illogicalIconFont
                font.pixelSize: spacialKeyScale
                color: keyTextColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

        }

    }

    languageKeyPanel: KeyPanel {
        id: languageKeyPanel

        states: [
            State {
                name: "pressed"
                when: control.pressed

                PropertyChanges {
                    target: languageKeyBackground
                    opacity: 0.8
                }

                PropertyChanges {
                    target: languageKeyIcon
                    opacity: 0.75
                }

            },
            State {
                name: "disabled"
                when: !control.enabled

                PropertyChanges {
                    target: languageKeyBackground
                    opacity: 0.8
                }

                PropertyChanges {
                    target: languageKeyIcon
                    opacity: 0.2
                }

            }
        ]

        Rectangle {
            id: languageKeyBackground

            radius: isWaffleTheme ? 4 : 12
            color: control && control.highlighted ? highlightedKeyBackgroundColor : normalKeyBackgroundColor
            anchors.fill: languageKeyPanel
            anchors.margins: keyBackgroundMargin
            border.width: isWaffleTheme ? 0.8 : 0
            border.color: keyboardBackgroundBorderColor

            Text {
                id: languageKeyIcon

                anchors.centerIn: parent
                text: isWaffleTheme ? "\ue6B2" : "language"
                font.family: isWaffleTheme ? Appearance.waffleIconFont : Appearance.illogicalIconFont
                font.pixelSize: spacialKeyScale
                color: keyTextColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

        }

    }

    enterKeyPanel: KeyPanel {
        id: enterKeyPanel

        states: [
            State {
                name: "pressed"
                when: control.pressed

                PropertyChanges {
                    target: enterKeyBackground
                    opacity: 0.8
                }

                PropertyChanges {
                    target: enterKeyTexy
                    opacity: 0.6
                }

                PropertyChanges {
                    target: enterKeyText
                    opacity: 0.6
                }

            },
            State {
                name: "disabled"
                when: !control.enabled

                PropertyChanges {
                    target: enterKeyBackground
                    opacity: 0.8
                }

                PropertyChanges {
                    target: enterKeyIcon
                    opacity: 0.2
                }

                PropertyChanges {
                    target: enterKeyText
                    opacity: 0.2
                }

            }
        ]

        Rectangle {
            id: enterKeyBackground

            radius: isWaffleTheme ? 4 : 12
            color: control && control.highlighted ? highlightedKeyBackgroundColor : normalKeyBackgroundColor
            anchors.fill: enterKeyPanel
            anchors.margins: keyBackgroundMargin
            border.width: isWaffleTheme ? 0.8 : 0
            border.color: keyboardBackgroundBorderColor

            Text {
                id: enterKeyTexy

                anchors.centerIn: parent
                text: isWaffleTheme ? "\uf068" : "keyboard_return" 
                font.family: isWaffleTheme ? Appearance.waffleIconFont : Appearance.illogicalIconFont
                font.pixelSize: spacialKeyScale
                color: keyTextColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                id: enterKeyText

                visible: text.length !== 0
                text: control.actionId !== EnterKeyAction.None ? control.displayText : ""
                clip: true
                fontSizeMode: Text.HorizontalFit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: keyTextColor
                anchors.fill: parent
                anchors.margins: Math.round(42 * scaleHint)

                font {
                    family: fontFamily
                    weight: Font.Normal
                    pixelSize: 50 * scaleHint
                    capitalization: Font.AllUppercase
                }

            }

        }

    }

    hideKeyPanel: KeyPanel {
        id: hideKeyPanel

        property bool isPressed: false

        states: [
            State {
                name: "pressed"
                when: hideKeyPanel.isPressed

                PropertyChanges {
                    target: hideKeyBackground
                    opacity: 0.8
                }

                PropertyChanges {
                    target: hideKeyText
                    opacity: 0.6
                }

            },
            State {
                name: "disabled"
                when: !control.enabled

                PropertyChanges {
                    target: hideKeyBackground
                    opacity: 0.8
                }

                PropertyChanges {
                    target: hideKeyText
                    opacity: 0.2
                }

            }
        ]

        Rectangle {
            id: hideKeyBackground

            radius: isWaffleTheme ? 4 : 12
            color: control && control.highlighted ? highlightedKeyBackgroundColor : normalKeyBackgroundColor
            anchors.fill: hideKeyPanel
            anchors.margins: keyBackgroundMargin
            border.width: isWaffleTheme ? 0.8 : 0
            border.color: keyboardBackgroundBorderColor

            Text {
                id: hideKeyText

                anchors.centerIn: parent
                text: isWaffleTheme ? "\uf2A1" : "keyboard_hide"
                font.family: isWaffleTheme ? Appearance.waffleIconFont : Appearance.illogicalIconFont
                font.pixelSize: spacialKeyScale
                color: keyTextColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

        }

        MouseArea {
            anchors.fill: parent
            onPressed: hideKeyPanel.isPressed = true
            onReleased: hideKeyPanel.isPressed = false
            onClicked: virtualKeyboard.activated = false
        }

    }

    shiftKeyPanel: KeyPanel {
        id: shiftKeyPanel

        states: [
            State {
                name: "pressed"
                when: control.pressed

                PropertyChanges {
                    target: shiftKeyBackground
                    opacity: 0.8
                }

                PropertyChanges {
                    target: shiftText
                    opacity: 0.6
                }

            },
            State {
                name: "disabled"
                when: !control.enabled

                PropertyChanges {
                    target: shiftKeyBackground
                    opacity: 0.8
                }

                PropertyChanges {
                    target: shiftText
                    opacity: 0.2
                }

            }
        ]

        Rectangle {
            id: shiftKeyBackground

            radius: isWaffleTheme ? 4 : 12
            color: control && control.highlighted ? highlightedKeyBackgroundColor : normalKeyBackgroundColor
            anchors.fill: shiftKeyPanel
            anchors.margins: keyBackgroundMargin
            border.width: isWaffleTheme ? 0.8 : 0
            border.color: keyboardBackgroundBorderColor
            states: [
                State {
                    name: "capsLockActive"
                    when: InputContext.capsLockActive

                    PropertyChanges {
                        target: shiftKeyBackground
                        color: specialKeyActive
                    }

                    PropertyChanges {
                        target: shiftText
                        color: specialKeyActiveText
                    }

                },
                State {
                    name: "shiftActive"
                    when: InputContext.shiftActive

                    PropertyChanges {
                        target: shiftKeyBackground
                        color: specialKeyActive
                    }

                    PropertyChanges {
                        target: shiftText
                        color: specialKeyActiveText
                    }

                }
            ]

            Text {
                id: shiftText

                anchors.centerIn: parent
                text: isWaffleTheme ? "\ue752" : "shift"
                font.family: isWaffleTheme ? Appearance.waffleIconFont : Appearance.illogicalIconFont
                font.pixelSize: spacialKeyScale
                color: keyTextColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

        }

    }

    spaceKeyPanel: KeyPanel {
        id: spaceKeyPanel

        states: [
            State {
                name: "pressed"
                when: control.pressed

                PropertyChanges {
                    target: spaceKeyBackground
                    opacity: 0.8
                }

            },
            State {
                name: "disabled"
                when: !control.enabled

                PropertyChanges {
                    target: spaceKeyBackground
                    opacity: 0.8
                }

            }
        ]

        Rectangle {
            id: spaceKeyBackground

            radius: isWaffleTheme ? 4 : 12
            color: control && control.highlighted ? highlightedKeyBackgroundColor : normalKeyBackgroundColor
            anchors.fill: spaceKeyPanel
            anchors.margins: keyBackgroundMargin
            border.width: isWaffleTheme ? 0.8 : 0
            border.color: keyboardBackgroundBorderColor

            Text {
                id: spaceKeyText

                text: Qt.locale(InputContext.locale).nativeLanguageName
                color: Appearance.highContrastEnabled ? "#FFFFFF" : Colors.on_surface_variant
                opacity: Appearance.highContrastEnabled ? 1 : 0.4
                anchors.centerIn: parent

                font {
                    family: fontFamily
                    weight: Font.Normal
                    pixelSize: 60 * scaleHint
                }

            }

        }

    }

    symbolKeyPanel: KeyPanel {
        id: symbolKeyPanel

        states: [
            State {
                name: "pressed"
                when: control.pressed

                PropertyChanges {
                    target: symbolKeyBackground
                    opacity: 0.8
                }

                PropertyChanges {
                    target: symbolKeyText
                    opacity: 0.6
                }

            },
            State {
                name: "disabled"
                when: !control.enabled

                PropertyChanges {
                    target: symbolKeyBackground
                    opacity: 0.8
                }

                PropertyChanges {
                    target: symbolKeyText
                    opacity: 0.2
                }

            }
        ]

        Rectangle {
            id: symbolKeyBackground

            radius: isWaffleTheme ? 4 : 12
            color: control && control.highlighted ? highlightedKeyBackgroundColor : normalKeyBackgroundColor
            anchors.fill: symbolKeyPanel
            anchors.margins: keyBackgroundMargin
            border.width: isWaffleTheme ? 0.8 : 0
            border.color: keyboardBackgroundBorderColor

            Text {
                id: symbolKeyText

                text: control.displayText
                color: keyTextColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.fill: parent
                anchors.margins: keyContentMargin

                font {
                    family: fontFamily
                    weight: Font.Normal
                    pixelSize: 60 * scaleHint
                    capitalization: Font.AllUppercase
                }

            }

        }

    }

    modeKeyPanel: KeyPanel {
        id: modeKeyPanel

        states: [
            State {
                name: "pressed"
                when: control.pressed

                PropertyChanges {
                    target: modeKeyBackground
                    opacity: 0.8
                }

                PropertyChanges {
                    target: modeKeyText
                    opacity: 0.6
                }

            },
            State {
                name: "disabled"
                when: !control.enabled

                PropertyChanges {
                    target: modeKeyBackground
                    opacity: 0.8
                }

                PropertyChanges {
                    target: modeKeyText
                    opacity: 0.2
                }

            }
        ]

        Rectangle {
            id: modeKeyBackground

            radius: isWaffleTheme ? 4 : 12
            color: control && control.highlighted ? highlightedKeyBackgroundColor : normalKeyBackgroundColor
            anchors.fill: modeKeyPanel
            anchors.margins: keyBackgroundMargin
            border.width: isWaffleTheme ? 0.8 : 0
            border.color: keyboardBackgroundBorderColor

            Text {
                id: modeKeyText

                text: control.displayText
                color: keyTextColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.fill: parent
                anchors.margins: keyContentMargin

                font {
                    family: fontFamily
                    weight: Font.Normal
                    pixelSize: 60 * scaleHint
                    capitalization: Font.AllUppercase
                }

            }

            Rectangle {
                id: modeKeyIndicator

                implicitHeight: parent.height * 0.1
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.leftMargin: parent.width * 0.4
                anchors.rightMargin: parent.width * 0.4
                anchors.bottomMargin: parent.height * 0.12
                color: modeKeyAccentColor
                radius: 3
                visible: control.mode
            }

        }

    }

    handwritingKeyPanel: KeyPanel {
        id: handwritingKeyPanel

        states: [
            State {
                name: "pressed"
                when: control.pressed

                PropertyChanges {
                    target: hwrKeyBackground
                    opacity: 0.8
                }

                PropertyChanges {
                    target: hwrKeyIcon
                    opacity: 0.6
                }

            },
            State {
                name: "disabled"
                when: !control.enabled

                PropertyChanges {
                    target: hwrKeyBackground
                    opacity: 0.8
                }

                PropertyChanges {
                    target: hwrKeyIcon
                    opacity: 0.2
                }

            }
        ]

        Rectangle {
            id: hwrKeyBackground

            radius: isWaffleTheme ? 4 : 12
            color: control && control.highlighted ? highlightedKeyBackgroundColor : normalKeyBackgroundColor
            anchors.fill: handwritingKeyPanel
            anchors.margins: keyBackgroundMargin
            border.width: isWaffleTheme ? 0.8 : 0
            border.color: keyboardBackgroundBorderColor

            Text {
                id: hwrKeyIcon

                anchors.centerIn: parent
                text: keyboard.handwritingMode ? "edit_note" : "draw"
                font.family: isWaffleTheme ? Appearance.waffleIconFont : Appearance.illogicalIconFont
                font.pixelSize: spacialKeyScale
                color: keyTextColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

        }

    }

    characterPreviewDelegate: Item {
        id: characterPreview

        property string text
        property string flickLeft
        property string flickTop
        property string flickRight
        property string flickBottom
        readonly property bool flickKeysSet: flickLeft || flickTop || flickRight || flickBottom
        readonly property bool flickKeysVisible: text && flickKeysSet && text !== flickLeft && text !== flickTop && text !== flickRight && text !== flickBottom

        Rectangle {
            id: characterPreviewBackground

            readonly property int largeTextHeight: Math.round(height / 3 * 2)
            readonly property int smallTextHeight: Math.round(height / 3)
            readonly property int smallTextMargin: Math.round(3 * scaleHint)

            anchors.fill: parent
            color: popupBackgroundColor
            radius: isWaffleTheme ? 4 : 12

            Text {
                id: characterPreviewText

                color: popupTextColor
                text: characterPreview.text
                fontSizeMode: Text.VerticalFit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: characterPreviewBackground.largeTextHeight

                font {
                    family: fontFamily
                    weight: Font.Normal
                    pixelSize: 82 * scaleHint
                }

            }

            Text {
                color: popupTextColor
                text: characterPreview.flickLeft
                visible: characterPreview.flickKeysVisible
                opacity: 0.8
                fontSizeMode: Text.VerticalFit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                anchors.leftMargin: characterPreviewBackground.smallTextMargin
                anchors.verticalCenter: parent.verticalCenter
                height: characterPreviewBackground.smallTextHeight

                font {
                    family: fontFamily
                    weight: Font.Normal
                    pixelSize: 62 * scaleHint
                }

            }

            Text {
                color: popupTextColor
                text: characterPreview.flickTop
                visible: characterPreview.flickKeysVisible
                opacity: 0.8
                fontSizeMode: Text.VerticalFit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.top: parent.top
                anchors.topMargin: characterPreviewBackground.smallTextMargin
                anchors.horizontalCenter: parent.horizontalCenter
                height: characterPreviewBackground.smallTextHeight

                font {
                    family: fontFamily
                    weight: Font.Normal
                    pixelSize: 62 * scaleHint
                }

            }

            Text {
                color: popupTextColor
                text: characterPreview.flickRight
                visible: characterPreview.flickKeysVisible
                opacity: 0.8
                fontSizeMode: Text.VerticalFit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.right: parent.right
                anchors.rightMargin: characterPreviewBackground.smallTextMargin
                anchors.verticalCenter: parent.verticalCenter
                height: characterPreviewBackground.smallTextHeight

                font {
                    family: fontFamily
                    weight: Font.Normal
                    pixelSize: 62 * scaleHint
                }

            }

            Text {
                color: popupTextColor
                text: characterPreview.flickBottom
                visible: characterPreview.flickKeysVisible
                opacity: 0.8
                fontSizeMode: Text.VerticalFit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: characterPreviewBackground.smallTextMargin
                anchors.horizontalCenter: parent.horizontalCenter
                height: characterPreviewBackground.smallTextHeight

                font {
                    family: fontFamily
                    weight: Font.Normal
                    pixelSize: 62 * scaleHint
                }

            }

            states: State {
                name: "flickKeysVisible"
                when: characterPreview.flickKeysVisible

                PropertyChanges {
                    target: characterPreviewText
                    height: characterPreviewBackground.smallTextHeight
                }

            }

        }

    }

    alternateKeysListDelegate: Item {
        id: alternateKeysListItem

        width: alternateKeysListItemWidth
        height: alternateKeysListItemHeight

        Text {
            id: listItemText

            text: model.text
            color: popupTextColor
            opacity: 0.8
            anchors.centerIn: parent

            font {
                family: fontFamily
                weight: Font.Normal
                pixelSize: 60 * scaleHint
            }

        }

        states: State {
            name: "current"
            when: alternateKeysListItem.ListView.isCurrentItem

            PropertyChanges {
                target: listItemText
                opacity: 1
                color: specialKeyActiveText
            }

        }

    }

    alternateKeysListHighlight: Rectangle {
        color: popupHighlightColor
        radius: isWaffleTheme ? 4 : 12
    }

    alternateKeysListBackground: Item {
        Rectangle {
            readonly property real margin: 20 * scaleHint

            x: -margin
            y: -margin
            width: parent.width + 2 * margin
            height: parent.height + 2 * margin
            radius: isWaffleTheme ? 1 : 12
            color: popupBackgroundColor

            border {
                width: isWaffleTheme ? 1 : 0
                color: popupBorderColor
            }

        }

    }

    selectionListDelegate: SelectionListItem {
        id: selectionListItem

        width: Math.round(selectionListLabel.width + selectionListLabel.anchors.leftMargin * 2)

        Text {
            id: selectionListLabel

            function decorateText(text, wordCompletionLength) {
                if (wordCompletionLength > 0)
                    return text.slice(0, -wordCompletionLength) + '<u>' + text.slice(-wordCompletionLength) + '</u>';

                return text;
            }

            anchors.left: parent.left
            anchors.leftMargin: Math.round((compactSelectionList ? 50 : 140) * scaleHint)
            anchors.verticalCenter: parent.verticalCenter
            text: decorateText(display, wordCompletionLength)
            color: selectionListTextColor
            opacity: 0.9

            font {
                family: fontFamily
                weight: Font.Normal
                pixelSize: 44 * scaleHint
            }

        }

        Rectangle {
            id: selectionListSeparator

            width: 4 * scaleHint
            height: 36 * scaleHint
            radius: 2
            color: selectionListSeparatorColor
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.left
        }

        states: State {
            name: "current"
            when: selectionListItem.ListView.isCurrentItem

            PropertyChanges {
                target: selectionListLabel
                opacity: 1
            }

        }

    }

    selectionListBackground: Rectangle {
        color: selectionListBackgroundColor
    }

    selectionListAdd: Transition {
        NumberAnimation {
            property: "y"
            from: wordCandidateView.height
            duration: 200
        }

        NumberAnimation {
            property: "opacity"
            from: 0
            to: 1
            duration: 200
        }

    }

    selectionListRemove: Transition {
        NumberAnimation {
            property: "y"
            to: -wordCandidateView.height
            duration: 200
        }

        NumberAnimation {
            property: "opacity"
            to: 0
            duration: 200
        }

    }

    navigationHighlight: Rectangle {
        color: "transparent"
        border.color: navigationHighlightColor
        border.width: 5
    }

    traceInputKeyPanelDelegate: TraceInputKeyPanel {
        id: traceInputKeyPanel

        traceMargins: keyBackgroundMargin

        Rectangle {
            id: traceInputKeyPanelBackground

            radius: isWaffleTheme ? 4 : 12
            color: normalKeyBackgroundColor
            anchors.fill: traceInputKeyPanel
            anchors.margins: keyBackgroundMargin

            Text {

                id: hwrInputModeIndicator

                visible: control.patternRecognitionMode === InputEngine.PatternRecognitionMode.Handwriting
                text: {
                    switch (InputContext.inputEngine.inputMode) {
                    case InputEngine.InputMode.Numeric:
                        if (["ar", "fa"].indexOf(InputContext.locale.substring(0, 2)) !== -1)
                            return "\u0660\u0661\u0662";

                    case InputEngine.InputMode.Dialable:
                        return "123";
                    case InputEngine.InputMode.Greek:
                        return "ΑΒΓ";
                    case InputEngine.InputMode.Cyrillic:
                        return "АБВ";
                    case InputEngine.InputMode.Arabic:
                        if (InputContext.locale.substring(0, 2) === "fa")
                            return "\u0627\u200C\u0628\u200C\u067E";

                        return "\u0623\u200C\u0628\u200C\u062C";
                    case InputEngine.InputMode.Hebrew:
                        return "\u05D0\u05D1\u05D2";
                    case InputEngine.InputMode.ChineseHandwriting:
                        return "中文";
                    case InputEngine.InputMode.JapaneseHandwriting:
                        return "日本語";
                    case InputEngine.InputMode.KoreanHandwriting:
                        return "한국어";
                    case InputEngine.InputMode.Thai:
                        return "กขค";
                    default:
                        return "Abc";
                    }
                }
                color: keyTextColor
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: keyContentMargin

                font {
                    family: fontFamily
                    weight: Font.Normal
                    pixelSize: 44 * scaleHint
                    capitalization: {
                        if (InputContext.capsLockActive)
                            return Font.AllUppercase;

                        if (InputContext.shiftActive)
                            return Font.MixedCase;

                        return Font.AllLowercase;
                    }
                }

            }

        }

        Canvas {
            id: traceInputKeyGuideLines

            anchors.fill: traceInputKeyPanelBackground
            opacity: 0.1
            onPaint: {
                var ctx = getContext("2d");
                ctx.lineWidth = 1;
                ctx.strokeStyle = Qt.rgba(255, 255, 255);
                ctx.clearRect(0, 0, width, height);
                var i;
                var margin = Math.round(30 * scaleHint);
                if (control.horizontalRulers) {
                    for (; i < control.horizontalRulers.length; i++) {
                        ctx.beginPath();
                        var y = Math.round(control.horizontalRulers[i]);
                        var rightMargin = Math.round(width - margin);
                        if (i + 1 === control.horizontalRulers.length) {
                            ctx.moveTo(margin, y);
                            ctx.lineTo(rightMargin, y);
                        } else {
                            var dashLen = Math.round(20 * scaleHint);
                            for (var dash = margin, dashCount = 0; dash < rightMargin; dash += dashLen, dashCount++) {
                                if ((dashCount & 1) === 0) {
                                    ctx.moveTo(dash, y);
                                    ctx.lineTo(Math.min(dash + dashLen, rightMargin), y);
                                }
                            }
                        }
                        ctx.stroke();
                    }
                }
                if (control.verticalRulers) {
                    for (; i < control.verticalRulers.length; i++) {
                        ctx.beginPath();
                        ctx.moveTo(control.verticalRulers[i], margin);
                        ctx.lineTo(control.verticalRulers[i], Math.round(height - margin));
                        ctx.stroke();
                    }
                }
            }

            Connections {
                function onHorizontalRulersChanged() {
                    traceInputKeyGuideLines.requestPaint();
                }

                function onVerticalRulersChanged() {
                    traceInputKeyGuideLines.requestPaint();
                }

                target: control
            }

        }

    }

    traceCanvasDelegate: TraceCanvas {
        id: traceCanvas

        onAvailableChanged: {
            if (!available)
                return ;

            var ctx = getContext("2d");
            if (parent.canvasType === "fullscreen") {
                ctx.lineWidth = 10;
                ctx.strokeStyle = Qt.rgba(0, 0, 0);
            } else {
                ctx.lineWidth = 10 * scaleHint;
                ctx.strokeStyle = Qt.rgba(255, 255, 255);
            }
            ctx.lineCap = "round";
            ctx.fillStyle = ctx.strokeStyle;
        }
        autoDestroyDelay: 800
        onTraceChanged: {
            if (trace === null)
                opacity = 0;

        }

        Behavior on opacity {
            PropertyAnimation {
                easing.type: Easing.OutCubic
                duration: 150
            }

        }

    }

    popupListDelegate: SelectionListItem {
        id: popupListItem

        property real cursorAnchor: popupListLabel.x + popupListLabel.width

        width: popupListLabel.width + popupListLabel.anchors.leftMargin * 2
        height: popupListLabel.height + popupListLabel.anchors.topMargin * 2

        Text {
            id: popupListLabel

            function decorateText(text, wordCompletionLength) {
                if (wordCompletionLength > 0)
                    return text.slice(0, -wordCompletionLength) + '<u>' + text.slice(-wordCompletionLength) + '</u>';

                return text;
            }

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: popupListLabel.height / 2
            anchors.topMargin: popupListLabel.height / 3
            text: decorateText(display, wordCompletionLength)
            color: popupTextColor
            opacity: 0.8

            font {
                family: fontFamily
                weight: Font.Normal
                pixelSize: Qt.inputMethod.cursorRectangle.height * 0.8
            }

        }

        states: State {
            name: "current"
            when: popupListItem.ListView.isCurrentItem

            PropertyChanges {
                target: popupListLabel
                opacity: 1
            }

        }

    }

    popupListBackground: Item {
        Rectangle {
            width: parent.width
            height: parent.height
            color: popupBackgroundColor

            border {
                width: 1
                color: popupBorderColor
            }

        }

    }

    popupListAdd: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0
            to: 1
            duration: 200
        }

    }

    popupListRemove: Transition {
        NumberAnimation {
            property: "opacity"
            to: 0
            duration: 200
        }

    }

    languageListDelegate: SelectionListItem {
        id: languageListItem

        width: languageNameTextMetrics.width * 17
        height: languageNameTextMetrics.height + languageListLabel.anchors.topMargin + languageListLabel.anchors.bottomMargin

        Text {
            id: languageListLabel

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 4 + languageNameTextMetrics.height / 3
            anchors.bottomMargin: anchors.topMargin - 3
            text: languageNameFormatter.elidedText
            color: listTextColor
            horizontalAlignment: Text.AlignHCenter
            opacity: 0.8

            font {
                family: fontFamily
                weight: Font.Normal
                pixelSize: 50 * scaleHint
            }

        }

        TextMetrics {
            id: languageNameTextMetrics

            text: "X"

            font {
                family: fontFamily
                weight: Font.Normal
                pixelSize: 60 * scaleHint
            }

        }

        TextMetrics {
            id: languageNameFormatter

            elide: Text.ElideRight
            elideWidth: languageListItem.width - languageListLabel.anchors.leftMargin - languageListLabel.anchors.rightMargin
            text: displayName

            font {
                family: fontFamily
                weight: Font.Normal
                pixelSize: 50 * scaleHint
            }

        }

        states: State {
            name: "current"
            when: languageListItem.ListView.isCurrentItem

            PropertyChanges {
                target: languageListLabel
                opacity: 1
                color: listTextHighlighted
            }

        }

    }

    languageListHighlight: Rectangle {
        color: listHighlighted
        radius: 5
    }

    languageListBackground: Item {
        readonly property real backgroundPadding: 20 * scaleHint

        Rectangle {
            x: -backgroundPadding
            y: -backgroundPadding
            width: parent.width + 2 * backgroundPadding
            height: parent.height + 2 * backgroundPadding
            color: listBackground
            radius: isWaffleTheme ? 4 : 12
        }

    }

    languageListAdd: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0
            to: 1
            duration: 200
        }

    }

    languageListRemove: Transition {
        NumberAnimation {
            property: "opacity"
            to: 0
            duration: 200
        }

    }

    selectionHandle: Item {
        width: 20
        height: 20

        Text {
            anchors.centerIn: parent
            text: "drag_handle"
            font.family: isWaffleTheme ? Appearance.waffleIconFont : Appearance.illogicalIconFont
            font.pixelSize: spacialKeyScale
            color: Colors.on_surface_variant
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

    }

    fullScreenInputContainerBackground: Item {
        clip: true

        Rectangle {
            y: border.width
            color: selectionListBackgroundColor
            width: parent.width
            height: parent.height
        }

    }

    fullScreenInputBackground: Item {
    }

    fullScreenInputCursor: Rectangle {
        width: 1
        color: selectionListTextColor
        visible: parent.blinkStatus
    }

    functionPopupListDelegate: Item {
        id: functionPopupListItem

        readonly property real iconMargin: 40 * scaleHint
        readonly property real iconWidth: 144 * keyIconScale
        readonly property real iconHeight: 144 * keyIconScale

        width: iconWidth + 2 * iconMargin
        height: iconHeight + 2 * iconMargin

        Text {
            id: functionIcon

            anchors.centerIn: parent
            font.family: isWaffleTheme ? Appearance.waffleIconFont : Appearance.illogicalIconFont
            font.pixelSize: 48 * keyIconScale
            color: Colors.on_surface_variant
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: {
                switch (keyboardFunction) {
                case QtVirtualKeyboard.KeyboardFunction.HideInputPanel:
                    return "keyboard_hide"; 
                case QtVirtualKeyboard.KeyboardFunction.ChangeLanguage:
                    return "language"; 
                case QtVirtualKeyboard.KeyboardFunction.ToggleHandwritingMode:
                    return keyboard.handwritingMode ? "edit_note" : "draw"; 
                default:
                    return "help"; 
                }
            }
        }

    }

    functionPopupListBackground: Item {
        Rectangle {
            readonly property real backgroundMargin: 20 * scaleHint

            x: -backgroundMargin
            y: -backgroundMargin
            width: parent.width + 2 * backgroundMargin
            height: parent.height + 2 * backgroundMargin
            radius: isWaffleTheme ? 4 : 12
            color: popupBackgroundColor

            border {
                width: 1
                color: popupBorderColor
            }

        }

    }

    functionPopupListHighlight: Rectangle {
        color: popupHighlightColor
        radius: isWaffleTheme ? 4 : 12
    }

}
