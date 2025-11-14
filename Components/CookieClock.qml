// Adapted from end-4's Hyprland dotfiles (https://github.com/end-4/dots-hyprland)
// Modified by 3d3f for "ii-sddm-theme" (2025)
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts

import "ClockComponents"
import "Commons"

Item {
    id: root

    property real implicitSize: 230
    
    // TimeManager properties
    readonly property int clockHour: TimeManager.hours
    readonly property int clockMinute: TimeManager.minutes
    readonly property int clockSecond: TimeManager.seconds
    readonly property string dateText: TimeManager.dayOfMonth.toString().padStart(2, "0")
    readonly property string dayNumber: TimeManager.dayOfMonth.toString().padStart(2, "0")
    readonly property string monthNumber: TimeManager.month.toString()
    readonly property string fullDateString: TimeManager.formattedDateFull
    
    // Color properties
    property color colShadow: Colors.colShadow
    property color colBackground: Colors.primary_container
    property color colOnBackground: Colors.mix(Colors.secondary, Colors.primary_container, 0.15)
    property color colHourHand: Colors.primary
    property color colMinuteHand: Colors.tertiary
    property color colSecondHand: Colors.primary
    property color colDateBackground: Colors.mix(Colors.primary, Colors.secondary_container, 0.55)
    property color colColumnTime: Colors.mix(Colors.primary, Colors.primary_container, 0.55)
    
    // Time format - using TimeManager
    readonly property bool is12HourFormat: TimeManager.is12HourFormat
    readonly property string timeString: _formatTimeString()
    
    readonly property bool sessionLockedActive: {
        return Settings.lock_showLockedText && config.ShowSessionLockedText === "true" && config.SessionLockedText !== "";
    }
    readonly property bool quoteActive: {
        return config.CookieClockQuote === "true" && Settings.background_widgets_clock_quote_enable && Settings.background_widgets_clock_quote_text !== "";
    }

    // Cookie type selector
    property bool useSineCookie: Settings.background_widgets_clock_cookie_useSineCookie || false

    function _formatTimeString() {
        var h = clockHour;
        var m = clockMinute;
        
        // Format hour
        var hourStr = "";
        if (is12HourFormat) {
            var hour12 = (h % 12 === 0 ? 12 : h % 12);
            hourStr = hour12.toString().padStart(2, "0");
        } else {
            var usePadding = TimeManager.shouldPadHours;
            hourStr = usePadding ? h.toString().padStart(2, "0") : h.toString();
        }
        
        // Format minute (always padded)
        var minStr = m.toString().padStart(2, "0");
        
        // Format AM/PM
        var ampm = "";
        if (TimeManager.timeFormat.indexOf("ap") !== -1)
            ampm = TimeManager.amPm;
        else if (TimeManager.timeFormat.indexOf("AP") !== -1)
            ampm = TimeManager.amPmUpper;
        
        // Combine parts
        return (ampm !== "") ? (hourStr + " " + minStr + " " + ampm) : (hourStr + " " + minStr);
    }

    implicitWidth: implicitSize
    implicitHeight: implicitSize

    DropShadow {
        source: useSineCookie ? sineCookieLoader : materialCookieLoader
        anchors.fill: source
        horizontalOffset: 0
        verticalOffset: 1
        radius: 8
        samples: radius * 2 + 1
        color: root.colShadow
        transparentBorder: true

        RotationAnimation on rotation {
            running: Settings.background_widgets_clock_cookie_constantlyRotate
            duration: 30000
            easing.type: Easing.Linear
            loops: Animation.Infinite
            from: 360
            to: 0
        }
    }

    // SineCookie loader
    Loader {
        id: sineCookieLoader
        z: 0
        visible: false 
        active: useSineCookie
        sourceComponent: SineCookie {
            implicitSize: root.implicitSize
            sides: Settings.background_widgets_clock_cookie_sides || 14
            color: root.colBackground
        }
    }

    // MaterialCookie loader
    Loader {
        id: materialCookieLoader
        z: 0
        visible: false 
        active: !useSineCookie
        sourceComponent: MaterialCookie {
            implicitSize: root.implicitSize
            sides: Settings.background_widgets_clock_cookie_sides || 14
            color: root.colBackground
        }
    }

    // Minute marks
    Loader {
        id: minuteMarksLoader
        anchors.fill: parent
        z: 0
        active: true
        sourceComponent: MinuteMarks {
            anchors.fill: parent
            color: root.colOnBackground
            dialNumberStyle: Settings.background_widgets_clock_cookie_dialNumberStyle
        }
    }

    // Hour marks
    Loader {
        id: hourMarksLoader
        anchors.centerIn: parent
        active: Settings.background_widgets_clock_cookie_hourMarks
        sourceComponent: HourMarks {
            implicitSize: 135 * (1.75 - 0.75)
            color: root.colOnBackground
            colOnBackground: Colors.mix(root.colDateBackground, root.colOnBackground, 0.5)
        }
    }

    // Digital time display
    Loader {
        id: timeColumnLoader
        anchors.fill: parent
        active: Settings.background_widgets_clock_cookie_timeIndicators
        sourceComponent: TimeColumn {
            anchors.fill: parent
            color: root.colColumnTime
            timeString: root.timeString
            isCompact: Settings.background_widgets_clock_cookie_hourMarks
        }
    }

    // Hour hand
    Loader {
        id: hourHandLoader
        anchors.fill: parent
        z: 2
        active: Settings.background_widgets_clock_cookie_hourHandStyle !== "hide"
        sourceComponent: HourHand {
            anchors.fill: parent
            color: root.colHourHand
            style: Settings.background_widgets_clock_cookie_hourHandStyle
            clockHour: root.clockHour
            clockMinute: root.clockMinute
        }
    }

    // Minute hand
    Loader {
        id: minuteHandLoader
        anchors.fill: parent
        z: 1
        active: Settings.background_widgets_clock_cookie_minuteHandStyle !== "hide"
        sourceComponent: MinuteHand {
            anchors.fill: parent
            color: root.colMinuteHand
            style: Settings.background_widgets_clock_cookie_minuteHandStyle
            clockMinute: root.clockMinute
        }
    }

    // Second hand
    Loader {
        id: secondHandLoader
        anchors.fill: parent
        z: 3
        active: Settings.time_secondPrecision && Settings.background_widgets_clock_cookie_secondHandStyle !== "hide"
        sourceComponent: SecondHand {
            anchors.fill: parent
            color: root.colSecondHand
            style: Settings.background_widgets_clock_cookie_secondHandStyle
            clockSecond: root.clockSecond
        }
    }

    // Date indicator
    Loader {
        id: dateIndicatorLoader
        anchors.fill: parent
        active: Settings.background_widgets_clock_cookie_dateStyle !== "hide"
        sourceComponent: DateIndicator {
            anchors.fill: parent
            color: root.colDateBackground
            style: Settings.background_widgets_clock_cookie_dateStyle
            dateText: root.fullDateString
            dayOfMonth: root.dayNumber
            monthNumber: root.monthNumber
            clockSecond: root.clockSecond
            secondHandVisible: Settings.time_secondPrecision && Settings.background_widgets_clock_cookie_secondHandStyle !== "hide"
        }
    }

    // Center dot
    Loader {
        id: centerDotLoader
        anchors.centerIn: parent
        z: 4
        active: Settings.background_widgets_clock_cookie_minuteHandStyle !== "bold"
        sourceComponent: Rectangle {
            width: 6
            height: 6
            radius: width / 2
            color: Settings.background_widgets_clock_cookie_minuteHandStyle === "medium" ? root.colBackground : root.colMinuteHand
        }
    }

    ColumnLayout {
        id: textContainer
        anchors {
            top: useSineCookie ? sineCookieLoader.bottom : materialCookieLoader.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 10
        }
        spacing: 10 

        // Quote text
        Loader {
            id: quoteLoader
            active: root.quoteActive
            source: "ClockComponents/CookieQuote.qml"
            Layout.alignment: Qt.AlignHCenter
            
            onLoaded: {
                item.text = Settings.background_widgets_clock_quote_text;
                item.backgroundColor = Colors.secondary_container;
                item.textColor = Colors.on_secondary_container;
                item.shadowColor = Colors.colShadow;
            }
        }

        // Session locked text
        Loader {
            id: sessionLockedTextLoader
            active: root.sessionLockedActive
            source: "ClockComponents/CookieSessionLocked.qml"
            Layout.alignment: Qt.AlignHCenter
            
            onLoaded: {
                item.text = config.SessionLockedText;
                item.backgroundColor = Colors.secondary_container;
                item.textColor = Colors.on_secondary_container;
                item.shadowColor = Colors.colShadow;
            }
        }
    }
}