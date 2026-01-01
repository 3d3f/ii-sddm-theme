import "../"
import QtQuick

Item {
    id: splash

    property int dotCount: 5
    property int dotSize: 6
    property color dotColor: Appearance.highContrastEnabled ? "#1AEBFF" : "white"
    property real radius: 21
    property int loopDuration: 2100
    property int pauseBetweenLoops: 500
    property int timeOffset: 90
    property int fadeDuration: 100
    property real brakingStrength: 48
    property real dotSpacing: 22
    property int verticalOffset: -52

    width: 200
    height: 200
    anchors.centerIn: parent
    visible: true
    anchors.verticalCenterOffset: verticalOffset

    Repeater {
        model: splash.dotCount

        Rectangle {
            id: dot

            property real animProgress: 0
            readonly property real calculatedAngle: (animProgress * 720) + (splash.brakingStrength * Math.sin(animProgress * 4 * Math.PI)) - (index * splash.dotSpacing)

            width: splash.dotSize
            height: splash.dotSize
            radius: splash.dotSize / 2
            color: splash.dotColor
            opacity: 0
            x: splash.width / 2 - width / 2
            y: splash.height / 2 + splash.radius - height / 2

            SequentialAnimation {
                running: true
                loops: Animation.Infinite

                PauseAnimation {
                    duration: index * splash.timeOffset
                }

                ParallelAnimation {
                    NumberAnimation {
                        target: dot
                        property: "animProgress"
                        from: 0
                        to: 1
                        duration: splash.loopDuration
                        easing.type: Easing.Linear
                    }

                    SequentialAnimation {
                        NumberAnimation {
                            target: dot
                            property: "opacity"
                            to: 1
                            duration: splash.fadeDuration
                        }

                        PauseAnimation {
                            duration: splash.loopDuration - (splash.fadeDuration * 2)
                        }

                        NumberAnimation {
                            target: dot
                            property: "opacity"
                            to: 0
                            duration: splash.fadeDuration
                        }

                    }

                }

                PauseAnimation {
                    duration: (splash.dotCount - index) * splash.timeOffset + splash.pauseBetweenLoops
                }

            }

            transform: Rotation {
                id: rotationTransform

                origin.x: splash.width / 2 - dot.x
                origin.y: splash.height / 2 - dot.y
                angle: dot.calculatedAngle
            }

        }

    }

}
