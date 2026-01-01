import QtQuick
import "../"

Text {
    id: root
    
    // Animation properties
    property bool animateChange: false
    property real animationDistanceX: 0
    property real animationDistanceY: 6
    
    // Font properties
    property var defaultFont: Appearance.font_family_main
    
    // Rendering settings
    renderType: Text.QtRendering
    verticalAlignment: Text.AlignVCenter
    
    font {
        hintingPreference: Font.PreferDefaultHinting
        family: defaultFont
        pixelSize: 15
    }
    
    // Default colors
    color: Colors.on_surface
    linkColor: Colors.primary
    
    // Animation component
    component Anim: NumberAnimation {
        target: root
        duration: 300 / 2
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
    }
    
    // Initialize original position
    Component.onCompleted: {
        textAnimationBehavior.originalX = root.x;
        textAnimationBehavior.originalY = root.y;
    }
    
    // Text change animation behavior
    Behavior on text {
        id: textAnimationBehavior
        property real originalX: root.x
        property real originalY: root.y
        enabled: root.animateChange
        
        SequentialAnimation {
            alwaysRunToEnd: true
            
            // Fade out and slide away
            ParallelAnimation {
                Anim {
                    property: "x"
                    to: textAnimationBehavior.originalX - root.animationDistanceX
                    easing.type: Easing.InSine
                }
                Anim {
                    property: "y"
                    to: textAnimationBehavior.originalY - root.animationDistanceY
                    easing.type: Easing.InSine
                }
                Anim {
                    property: "opacity"
                    to: 0
                    easing.type: Easing.InSine
                }
            }
            
            // Update text at this point
            PropertyAction {}
            
            // Reset position for slide in
            PropertyAction {
                target: root
                property: "x"
                value: textAnimationBehavior.originalX + root.animationDistanceX
            }
            PropertyAction {
                target: root
                property: "y"
                value: textAnimationBehavior.originalY + root.animationDistanceY
            }
            
            // Fade in and slide back
            ParallelAnimation {
                Anim {
                    property: "x"
                    to: textAnimationBehavior.originalX
                    easing.type: Easing.OutSine
                }
                Anim {
                    property: "y"
                    to: textAnimationBehavior.originalY
                    easing.type: Easing.OutSine
                }
                Anim {
                    property: "opacity"
                    to: 1
                    easing.type: Easing.OutSine
                }
            }
        }
    }
}