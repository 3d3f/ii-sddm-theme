import QtQuick
pragma Singleton

// Here you can edit your theme settings, be sure to check ii-sddm.conf from this same folder for more settings
// On the comment on the right there are all possible options
QtObject {
    property string time_format: "h:mm ap" // "h:mm","h:mm ap","h:mm AP"
    property string background_widgets_clock_style: "digital" // "none", "digital", "cookie"
    property bool background_widgets_clock_cookie_constantlyRotate: false // true, false
    property string background_widgets_clock_cookie_dateStyle: "bubble" // "hide", "rect", "bubble", "border"
    property string background_widgets_clock_cookie_dialNumberStyle: "full" // "full", "dots", "numbers", "none"
    property string background_widgets_clock_cookie_hourHandStyle: "hollow" // "fill", "hollow", "classic", "hide"
    property bool background_widgets_clock_cookie_hourMarks: false // true, false
    property string background_widgets_clock_cookie_minuteHandStyle: "thin" // "thin", "medium", "bold", "classic", "hide"
    property string background_widgets_clock_cookie_secondHandStyle: "line" // "dot", "classic", "line", "hide"
    property int background_widgets_clock_cookie_sides: 14 // 0 to i dont know what is the limit, i wouldn't go too high
    property bool background_widgets_clock_cookie_timeIndicators: true // true, false
    property string background_widgets_clock_quote_text: "Welcome to ii-sddm-theme" // "you can write anything you want"
    property bool background_widgets_clock_quote_enable: true // true, false
    property bool lock_blur_enable: false // true, false
    property bool lock_showLockedText: true // true, false
    property bool time_secondPrecision: true // true, false
    property bool lock_materialShapeChars: true // true, false
}
