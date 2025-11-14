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
    
    property var customShapeSequence: [
        MaterialShape.Shape.Clover4Leaf,
        MaterialShape.Shape.Arrow,
        MaterialShape.Shape.Pill,
        MaterialShape.Shape.SoftBurst,
        MaterialShape.Shape.Diamond,
        MaterialShape.Shape.ClamShell,
        MaterialShape.Shape.Pentagon,
        MaterialShape.Shape.Circle // Can add more
    ]
    
    visible: usePasswordChars
    contentWidth: dotsRow.implicitWidth
    flickableDirection: Flickable.HorizontalFlick
    contentX: Math.max(contentWidth - width, 0)
    
    Behavior on contentX {
        NumberAnimation {
            duration: Appearance.animation.elementMoveEnter.duration || 200
            easing.type: Appearance.animation.elementMoveEnter.type || Easing.OutCubic
            easing.bezierCurve: Appearance.animation.elementMoveEnter.bezierCurve || []
        }
    }
    
    Row {
        id: dotsRow
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 3.3
        }
        spacing: 10
        
        Repeater {
            model: passwordCharsFlickable.passwordModel
            
            delegate: Item {
                id: charItem
                
                required property int index
                
                implicitWidth: 10
                implicitHeight: 10
                
                MaterialShape {
                    id: materialShape
                    anchors.centerIn: parent
                    
                    shape: customShapeSequence[charItem.index % customShapeSequence.length]
                    color: Colors.primary
                    implicitSize: 0
                    opacity: 0
                    scale: 0.5
                    
                    Component.onCompleted: {
                        appearAnim.start();
                    }
                    
                    ParallelAnimation {
                        id: appearAnim
                        
                        NumberAnimation {
                            target: materialShape
                            properties: "opacity"
                            to: 1
                            duration: 50
                            easing.type: Appearance.animation.elementMoveFast.type
                            easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
                        }
                        
                        NumberAnimation {
                            target: materialShape
                            properties: "scale"
                            to: 1
                            duration: 200
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Appearance.animationCurves?.expressiveFastSpatial || [0.4, 0.0, 0.2, 1.0]
                        }
                        
                        NumberAnimation {
                            target: materialShape
                            properties: "implicitSize"
                            to: 18
                            duration: 200
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Appearance.animationCurves?.expressiveFastSpatial || [0.4, 0.0, 0.2, 1.0]
                        }
                        
                        ColorAnimation {
                            target: materialShape
                            properties: "color"
                            from: Colors.primary
                            to: Colors.colOnLayer1
                            duration: 1000
                            easing.type: Appearance.animation.elementMoveFast.type
                            easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
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