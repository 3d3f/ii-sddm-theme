// Adapted from end-4's Hyprland dotfiles (https://github.com/end-4/dots-hyprland)

import QtQml.Models
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Commons"

StyledFlickable {
    id: passwordCharsFlickable
    
    required property var passwordModel  
    property bool usePasswordChars: true
    property int cursorPosition: 0 
    
    readonly property int charSize: 20

    property var customShapeSequence: [
        MaterialShape.Shape.Clover4Leaf, MaterialShape.Shape.Arrow,
        MaterialShape.Shape.Pill, MaterialShape.Shape.SoftBurst,
        MaterialShape.Shape.Diamond, MaterialShape.Shape.ClamShell,
        MaterialShape.Shape.Pentagon, MaterialShape.Shape.Circle 
    ]
    
    visible: usePasswordChars
    clip: false 

    contentWidth: dotsRow.implicitWidth + 20
    flickableDirection: Flickable.HorizontalFlick
    
    contentX: Math.max(contentWidth - width, 0)
    
    Behavior on contentX {
        NumberAnimation {
            duration: Appearance.animation.elementMoveFast.duration
            easing.type: Appearance.animation.elementMoveFast.type
            easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
        }
    }
        MouseArea {
        anchors.fill: parent
        cursorShape: Qt.IBeamCursor
        acceptedButtons: Qt.NoButton 
    }

    Rectangle {
        id: cursor
        z: 10
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: (passwordCharsFlickable.charSize * passwordCharsFlickable.cursorPosition) + 3.3
        
        width: 2
        height: 19
        color: Colors.primary
        opacity: password.activeFocus ? 1 : 0 

        Behavior on anchors.leftMargin {
            NumberAnimation {
                duration: Appearance.animation.elementMoveFast.duration
                easing.type: Appearance.animation.elementMoveFast.type
                easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
            }
        }
        
        Behavior on opacity { NumberAnimation { duration: 150 } }
    }

    Row {
        id: dotsRow
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 3.3
        }
        spacing: 0
        
        Repeater {
            model: passwordCharsFlickable.passwordModel
            delegate: Item {
                id: charItem
                required property int index
                implicitWidth: passwordCharsFlickable.charSize 
                implicitHeight: passwordCharsFlickable.charSize
                
                MaterialShape {
                    id: materialShape
                    anchors.centerIn: parent
                    shape: customShapeSequence[charItem.index % customShapeSequence.length]
                    color: Colors.primary
                    implicitSize: 0
                    opacity: 0
                    scale: 0.5
                    Component.onCompleted: appearAnim.start()
                    
                    ParallelAnimation {
                        id: appearAnim
                        NumberAnimation { target: materialShape; property: "opacity"; to: 1; duration: 50 }
                        NumberAnimation { 
                            target: materialShape; property: "scale"; to: 1; duration: 200; 
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Appearance.animationCurves?.expressiveFastSpatial || [0.4, 0, 0.2, 1]
                        }
                        NumberAnimation { 
                            target: materialShape; property: "implicitSize"; to: 18; duration: 200;
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Appearance.animationCurves?.expressiveFastSpatial || [0.4, 0, 0.2, 1]
                        }
                        ColorAnimation {
                            target: materialShape; property: "color"
                            from: Colors.primary; to: Colors.colOnLayer1; duration: 1000
                        }
                    }
                }
            }
        }
    }

    TapHandler {
        onTapped: password.forceActiveFocus()
    }
}