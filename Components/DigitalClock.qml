// Adapted from end-4's Hyprland dotfiles (https://github.com/end-4/dots-hyprland)
// Modified by 3d3f for "ii-sddm-theme" (2025)
import QtQuick
import QtQuick.Controls

Item {
    id: clock

    property string time_format: Settings.time_format
    property string background_quote: Settings.background_quote
    property bool background_showQuote: Settings.background_showQuote
    readonly property bool sessionLockedActive: Settings.lock_showLockedText && config.ShowSessionLockedText === "true" && config.SessionLockedText !== ""
    readonly property bool quoteActive: background_showQuote && background_quote !== ""
    readonly property int quoteTopMargin: 6
    readonly property int sessionLockedTopMargin: 8

    width: 400
    height: 200
    implicitWidth: timeLabel.implicitWidth
    implicitHeight: timeLabel.implicitHeight + dateLabel.implicitHeight + (quoteLoader.active ? quoteLoader.height : 0) + (sessionLockedLoader.active ? sessionLockedLoader.height : 0)
    Component.onCompleted: {
        timeLabel.updateTime();
        dateLabel.updateTime();
        lockScreen.alignItem(clock, Config.clockPosition);
    }
    onTime_formatChanged: {
        console.log("DigitalClock: time_format changed ->", clock.time_format);
        timeLabel.updateTime();
    }

    Label {
        id: timeLabel

        function pad(v) {
            return (v < 10 ? "0" + v : "" + v);
        }

        function updateTime() {
            try {
                var d = new Date();
                var hh = d.getHours();
                var mm = d.getMinutes();
                var out = "";
                var is12 = (clock.time_format.indexOf("ap") !== -1) || (clock.time_format.indexOf("AP") !== -1);
                if (is12) {
                    var hour12 = hh % 12;
                    if (hour12 === 0)
                        hour12 = 12;

                    if (clock.time_format.indexOf("hh") !== -1)
                        out += (hour12 < 10 ? "0" + hour12 : hour12);
                    else
                        out += hour12;
                } else {
                    if (clock.time_format.indexOf("hh") !== -1)
                        out += pad(hh);
                    else if (clock.time_format.indexOf("h") !== -1)
                        out += hh;
                    else
                        out += pad(hh);
                }
                out += ":" + pad(mm);
                if (clock.time_format.indexOf("ap") !== -1)
                    out += (hh < 12 ? " am" : " pm");
                else if (clock.time_format.indexOf("AP") !== -1)
                    out += (hh < 12 ? " AM" : " PM");
                timeLabel.text = out;
            } catch (e) {
                console.log("DigitalClock:updateTime error:", e);
            }
        }
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 0
        font.family: "Space Grotesk"
        font.pixelSize: 90
        font.weight: Font.DemiBold
        color: Colors.primary_fixed_dim
        renderType: Text.NativeRendering
        font.hintingPreference: Font.PreferDefaultHinting
        style: Text.Raised
        styleColor: Colors.colShadow
    }

    Label {
        id: dateLabel

        function updateTime() {
            var d = new Date();
            var day = d.getDate();
            var month = d.getMonth() + 1;
            var dayName = Qt.locale().dayName(d.getDay(), Qt.locale().ShortFormat);
            // Forza l'abbreviazione a 3 lettere
            if (dayName.length > 3)
                dayName = dayName.substring(0, 3);

            dateLabel.text = dayName + ", " + (day < 10 ? "0" + day : day) + "/" + (month < 10 ? "0" + month : month);
        }

        anchors.top: timeLabel.bottom
        anchors.horizontalCenter: timeLabel.horizontalCenter
        anchors.topMargin: 4
        font.family: "Space Grotesk"
        font.pixelSize: 20
        font.weight: Font.DemiBold
        color: Colors.primary_fixed_dim
    }

    // Quote Label - inline component
    Loader {
        id: quoteLoader

        active: clock.quoteActive
        anchors.top: dateLabel.bottom
        anchors.horizontalCenter: dateLabel.horizontalCenter
        anchors.topMargin: clock.quoteTopMargin
        z: 10

        sourceComponent: Component {
            Item {
                width: quoteLabel.width
                height: quoteLabel.height

                Label {
                    id: quoteLabel

                    text: clock.background_quote
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "Rubik"
                    font.pixelSize: 16
                    font.weight: Font.Light
                    font.italic: true
                    color: Colors.primary_fixed_dim
                    wrapMode: Text.WordWrap
                    width: clock.width * 0.8
                    horizontalAlignment: Text.AlignHCenter
                }

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
                        font.family: "Rubik"
                        font.pixelSize: 16
                        font.weight: Font.Normal
                        anchors.verticalCenter: parent.verticalCenter
                    }

                }

            }

        }

    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            timeLabel.updateTime();
            dateLabel.updateTime();
        }
    }

}
