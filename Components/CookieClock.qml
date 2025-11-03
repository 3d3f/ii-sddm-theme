// Adapted from end-4's Hyprland dotfiles (https://github.com/end-4/dots-hyprland)
// Modified by 3d3f for "ii-sddm-theme" (2025)
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Shapes

Item {
    id: root

    // Time properties
    property int clockHour: 0
    property int clockMinute: 0
    property int clockSecond: 0
    // Date properties
    property string dateText: ""
    property string dayNumber: ""
    property string monthNumber: ""
    property string fullDateString: ""
    property color colShadow: Colors.colShadow
    property color colBackground: Colors.primary_container
    property color colOnBackground: Colors.mix(Colors.secondary, Colors.primary_container, 0.15)
    property color colHourHand: Colors.primary
    property color colMinuteHand: Colors.tertiary
    property color colSecondHand: Colors.primary
    property color colDateBackground: Colors.mix(Colors.primary, Colors.secondary_container, 0.55)
    property color colColumnTime:  Colors.mix(Colors.primary, Colors.primary_container, 0.55)
    property string time_format: Settings.time_format
    readonly property bool is12HourFormat: {
        return (time_format.indexOf("ap") !== -1) || (time_format.indexOf("AP") !== -1);
    }
    readonly property string timeString: _formatTimeString()
    readonly property int baseMargin: 47
    readonly property bool sessionLockedActive: {
        return Settings.lock_showLockedText && config.ShowSessionLockedText === "true" && config.SessionLockedText !== "";
    }
    readonly property bool quoteActive: {
        return config.CookieClockQuote === "true" && Settings.background_showQuote && Settings.background_quote !== "";
    }

    function _formatTimeString() {
        var h = clockHour;
        var m = clockMinute;
        // Format hour
        var hourStr = "";
        if (is12HourFormat) {
            var hour12 = (h % 12 === 0 ? 12 : h % 12);
            hourStr = hour12.toString().padStart(2, "0");
        } else {
            var usePadding = (time_format.indexOf("hh") !== -1);
            hourStr = usePadding ? h.toString().padStart(2, "0") : h.toString();
        }
        // Format minute (always padded)
        var minStr = m.toString().padStart(2, "0");
        // Format AM/PM
        var ampm = "";
        if (time_format.indexOf("ap") !== -1)
            ampm = (h < 12 ? "am" : "pm");
        else if (time_format.indexOf("AP") !== -1)
            ampm = (h < 12 ? "AM" : "PM");
        // Combine parts
        return (ampm !== "") ? (hourStr + " " + minStr + " " + ampm) : (hourStr + " " + minStr);
    }

    function _updateDateTime() {
        var now = new Date();
        clockHour = now.getHours();
        clockMinute = now.getMinutes();
        clockSecond = now.getSeconds();
        dateText = Qt.formatDate(now, "dd");
        dayNumber = Qt.formatDate(now, "dd");
        fullDateString = Qt.formatDate(now, "ddd dd");
        monthNumber = Qt.formatDate(now, "M");
    }

    // Dimensions
    width: 230
    height: 230
    anchors.topMargin: 20

    // Shadow effect
    DropShadow {
        source: cookieShape
        anchors.fill: source
        horizontalOffset: 0
        verticalOffset: 1
        radius: 8
        samples: radius * 2 + 1
        color: root.colShadow
        transparentBorder: true
    }

    // Main clock shape
    MaterialCookie {
        id: cookieShape

        implicitSize: root.width
        amplitude: root.width / 70
        sides: Settings.background_clock_cookie_sides || 14
        color: root.colBackground
        constantlyRotate: Settings.background_clock_cookie_constantlyRotate

        // Minute marks (outermost)
        MinuteMarks {
            id: minuteMarks

            anchors.fill: parent
            z: 0
            color: root.colOnBackground
            dialNumberStyle: Settings.background_clock_cookie_dialNumberStyle
        }

        // Hour marks
        HourMarks {
            id: hourMarks

            anchors.centerIn: parent
            implicitSize: 135
            color: root.colOnBackground
            colOnBackground: Colors.mix(root.colDateBackground, root.colOnBackground, 0.5)
            visible: Settings.background_clock_cookie_hourMarks
        }

        // Digital time display
        TimeColumn {
            anchors.fill: parent
            color: root.colColumnTime
            timeString: root.timeString
            enabled: Settings.background_clock_cookie_timeIndicators
            isCompact: Settings.background_clock_cookie_hourMarks
        }

        // Hour hand
        HourHand {
            anchors.fill: parent
            z: 1
            color: root.colHourHand
            style: Settings.background_clock_cookie_hourHandStyle
            clockHour: root.clockHour
            clockMinute: root.clockMinute
        }

        // Minute hand
        MinuteHand {
            anchors.fill: parent
            z: 2
            color: root.colMinuteHand
            style: Settings.background_clock_cookie_minuteHandStyle
            clockMinute: root.clockMinute
        }

        // Second hand
        SecondHand {
            anchors.fill: parent
            z: 3
            color: root.colSecondHand
            style: Settings.background_clock_cookie_secondHandStyle
            clockSecond: root.clockSecond
            visible: Settings.time_secondPrecision
        }

        // Date indicator
        DateIndicator {
            anchors.fill: parent
            color: root.colDateBackground
            style: Settings.background_clock_cookie_dateStyle
            dateText: root.fullDateString
            dayOfMonth: root.dayNumber
            monthNumber: root.monthNumber
            clockSecond: root.clockSecond
            secondHandVisible: Settings.time_secondPrecision && Settings.background_clock_cookie_secondHandStyle !== "hide"
        }

        // Center dot
        Rectangle {
            anchors.centerIn: parent
            z: 4
            width: 6
            height: 6
            radius: width / 2
            color: Settings.background_clock_cookie_minuteHandStyle === "medium" ? root.colBackground : root.colMinuteHand
            visible: Settings.background_clock_cookie_minuteHandStyle !== "bold"
        }

    }

    // Session locked text
    Loader {
        id: sessionLockedTextLoader

        active: root.sessionLockedActive
        source: "CookieSessionLocked.qml"
        z: 11
        onLoaded: {
            item.text = config.SessionLockedText;
            item.backgroundColor = Colors.secondary_container;
            item.textColor = Colors.on_secondary_container;
            item.shadowColor = Colors.colShadow;
        }

        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: -root.baseMargin
        }

    }

    // Quote text
    Loader {
        id: quoteLoader

        active: root.quoteActive
        source: "CookieQuote.qml"
        z: 10
        onLoaded: {
            item.text = Settings.background_quote;
            item.backgroundColor = Colors.secondary_container;
            item.textColor = Colors.on_secondary_container;
            item.shadowColor = Colors.colShadow;
        }

        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: root.sessionLockedActive ? -(root.baseMargin + 13) : -root.baseMargin
        }

    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: root._updateDateTime()
    }

}
