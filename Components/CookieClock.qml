// Adapted from end-4's Hyprland dotfiles (https://github.com/end-4/dots-hyprland)
// Modified by 3d3f for "ii-sddm-theme" (2025)
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Shapes

Item {
    id: root

    property color colShadow: Colors.colShadow
    property color colBackground: Colors.secondary_container
    property color colOnBackground: Colors.mix(Colors.secondary, Colors.secondary_container, 0.15)
    property color colHourHand: Colors.primary
    property color colMinuteHand: Colors.secondary
    property color colSecondHand: Colors.tertiary
    property color colDateBackground: Colors.mix(Colors.primary, Colors.secondary_container, 0.55)
    property color colColumnTime: Colors.mix(Colors.primary, Colors.secondary_container, 0.55)
    property int clockHour: 0
    property int clockMinute: 0
    property int clockSecond: 0
    property string dateText: ""
    property string dayNumber: ""
    property string fullDateString: ""
    property string time_format: Settings.time_format
    property string monthNumber: ""
    property string timeString: {
        var h = root.clockHour;
        var m = root.clockMinute;
        var is12 = (root.time_format.indexOf("ap") !== -1) || (root.time_format.indexOf("AP") !== -1);
        var hour12 = (h % 12 === 0 ? 12 : h % 12);
        var hourStr = "";
        if (is12) {
            if (root.time_format.indexOf("hh") !== -1)
                hourStr = hour12.toString().padStart(2, "0");
            else
                hourStr = hour12.toString();
        } else {
            if (root.time_format.indexOf("hh") !== -1)
                hourStr = h.toString().padStart(2, "0");
            else
                hourStr = h.toString();
        }
        var minStr = m.toString().padStart(2, "0");
        var ampm = "";
        if (root.time_format.indexOf("ap") !== -1)
            ampm = (h < 12 ? "am" : "pm");
        else if (root.time_format.indexOf("AP") !== -1)
            ampm = (h < 12 ? "AM" : "PM");
        return (ampm !== "") ? (hourStr + " " + minStr + " " + ampm) : (hourStr + " " + minStr);
    }
    readonly property int baseMargin: 47
    readonly property bool sessionLockedActive: Settings.lock_showLockedText && config.ShowSessionLockedText === "true" && config.SessionLockedText !== ""
    readonly property bool quoteActive: config.CookieClockQuote === "true" && Settings.background_showQuote && Settings.background_quote !== ""

    width: 230
    height: 230
    Component.onCompleted: {
        lockScreen.alignItem(root, Config.clockPosition);
    }

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

    MaterialCookie {
        id: cookieShape

        implicitSize: root.width
        amplitude: root.width / 70
        sides: Settings.background_clock_cookie_sides || 14
        color: root.colBackground
        constantlyRotate: Settings.background_clock_cookie_constantlyRotate

        MinuteMarks {
            id: minuteMarks

            anchors.fill: parent
            z: 0
            color: root.colOnBackground
            dialNumberStyle: Settings.background_clock_cookie_dialNumberStyle
        }

        HourMarks {
            id: hourMarks

            anchors.centerIn: parent
            implicitSize: 135
            color: root.colOnBackground
            colOnBackground: Colors.mix(root.colDateBackground, root.colOnBackground, 0.5)
            visible: Settings.background_clock_cookie_hourMarks
        }

        TimeColumn {
            anchors.fill: parent
            color: root.colColumnTime
            timeString: root.timeString
            enabled: Settings.background_clock_cookie_timeIndicators
            isCompact: Settings.background_clock_cookie_hourMarks
        }

        HourHand {
            anchors.fill: parent
            z: 1
            color: root.colHourHand
            style: Settings.background_clock_cookie_hourHandStyle
            clockHour: root.clockHour
            clockMinute: root.clockMinute
        }

        MinuteHand {
            anchors.fill: parent
            z: 2
            color: root.colMinuteHand
            style: Settings.background_clock_cookie_minuteHandStyle
            clockMinute: root.clockMinute
        }

        SecondHand {
            anchors.fill: parent
            z: 3
            color: root.colSecondHand
            style: Settings.background_clock_cookie_secondHandStyle
            clockSecond: root.clockSecond
            visible: Settings.time_secondPrecision
        }

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

    Loader {
        id: sessionLockedTextLoader

        active: root.sessionLockedActive
        source: "CookieSessionLocked.qml"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: -root.baseMargin
        z: 11
        onLoaded: {
            item.text = config.SessionLockedText;
            item.backgroundColor = Colors.secondary_container;
            item.textColor = Colors.on_secondary_container;
            item.shadowColor = Colors.colShadow;
        }
    }

    Loader {
        id: quoteLoader

        active: root.quoteActive
        source: "CookieQuote.qml"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: root.sessionLockedActive ? -(root.baseMargin + 13) : -root.baseMargin
        z: 10
        onLoaded: {
            item.text = Settings.background_quote;
            item.backgroundColor = Colors.secondary_container;
            item.textColor = Colors.on_secondary_container;
            item.shadowColor = Colors.colShadow;
        }
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {
            var now = new Date();
            root.clockHour = now.getHours();
            root.clockMinute = now.getMinutes();
            root.clockSecond = now.getSeconds();
            root.dateText = Qt.formatDate(now, "dd");
            root.dayNumber = Qt.formatDate(now, "dd");
            root.fullDateString = Qt.formatDate(now, "ddd dd");
            root.monthNumber = Qt.formatDate(now, "M");
        }
    }

    anchors {
        topMargin: 20
    }

}
