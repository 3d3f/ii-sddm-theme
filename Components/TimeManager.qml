// Time management singleton for ii-sddm-theme
// Created by 3d3f (2025)
// Licensed under the GNU General Public License v3.0
import QtQuick

pragma Singleton

QtObject {
    id: timeManager

    // Raw time values
    property int hours: 0
    property int minutes: 0
    property int seconds: 0
    
    // Date values
    property int dayOfMonth: 1
    property int month: 1
    property int dayOfWeek: 0
    property int year: 2025
    
    // Formatted strings (cached for performance)
    property string dayName: ""
    property string dayNameShort: ""
    property string monthName: ""
    property string monthNameShort: ""
    
    // Time format settings
    property string timeFormat: Settings.time_format
    readonly property bool is12HourFormat: {
        return (timeFormat.indexOf("ap") !== -1) || (timeFormat.indexOf("AP") !== -1);
    }
    readonly property bool shouldPadHours: timeFormat.indexOf("hh") !== -1
    
    // Formatted time string (auto-updates)
    readonly property string formattedTime: _formatTime()
    
    // Formatted date strings
    readonly property string formattedDateShort: _formatDateShort()
    readonly property string formattedDateFull: _formatDateFull()
    
    // Hour in 12-hour format (for analog clocks)
    readonly property int hour12: {
        var h = hours % 12;
        return h === 0 ? 12 : h;
    }
    
    // AM/PM indicator
    readonly property string amPm: hours < 12 ? "am" : "pm"
    readonly property string amPmUpper: hours < 12 ? "AM" : "PM"
    
    // Internal timer
    property var _timer: Timer {
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: timeManager._updateTime()
    }
    
    // Update all time/date properties
    function _updateTime() {
        var now = new Date();
        
        // Update raw values
        hours = now.getHours();
        minutes = now.getMinutes();
        seconds = now.getSeconds();
        dayOfMonth = now.getDate();
        month = now.getMonth() + 1; // JavaScript months are 0-based
        dayOfWeek = now.getDay();
        year = now.getFullYear();
        
        // Update formatted strings
        var locale = Qt.locale();
        dayName = locale.dayName(dayOfWeek, Qt.locale.LongFormat);
        dayNameShort = locale.dayName(dayOfWeek, Qt.locale.ShortFormat);
        
        // Force 3-letter abbreviation for day name
        if (dayNameShort.length > 3) {
            dayNameShort = dayNameShort.substring(0, 3);
        }
        
        monthName = locale.monthName(month - 1, Qt.locale.LongFormat);
        monthNameShort = locale.monthName(month - 1, Qt.locale.ShortFormat);
    }
    
    // Format time string based on current format settings
    function _formatTime() {
        var h = hours;
        var m = minutes;
        
        // Format hour
        var hourStr = "";
        if (is12HourFormat) {
            var hour12Val = (h % 12 === 0 ? 12 : h % 12);
            hourStr = shouldPadHours ? _pad(hour12Val) : hour12Val.toString();
        } else {
            hourStr = shouldPadHours ? _pad(h) : h.toString();
        }
        
        // Format minute (always padded)
        var minStr = _pad(m);
        
        // Format AM/PM
        var ampmStr = "";
        if (timeFormat.indexOf("ap") !== -1) {
            ampmStr = " " + amPm;
        } else if (timeFormat.indexOf("AP") !== -1) {
            ampmStr = " " + amPmUpper;
        }
        
        return hourStr + ":" + minStr + ampmStr;
    }
    
    // Format short date (e.g., "Mon, 13/11")
    function _formatDateShort() {
        return dayNameShort + ", " + _pad(dayOfMonth) + "/" + _pad(month);
    }
    
    // Format full date (e.g., "Mon 13")
    function _formatDateFull() {
        return dayNameShort + " " + _pad(dayOfMonth);
    }
    
    // Utility: pad number with leading zero
    function _pad(num) {
        return num < 10 ? "0" + num : num.toString();
    }
    
    // Public utility functions for custom formatting
    function getHourFormatted(use12Hour, padded) {
        var h = use12Hour !== undefined && use12Hour ? hour12 : hours;
        return padded !== undefined && padded ? _pad(h) : h.toString();
    }
    
    function getMinuteFormatted(padded) {
        var shouldPad = padded !== undefined ? padded : true;
        return shouldPad ? _pad(minutes) : minutes.toString();
    }
    
    function getSecondFormatted(padded) {
        var shouldPad = padded !== undefined ? padded : true;
        return shouldPad ? _pad(seconds) : seconds.toString();
    }
}