// Adapted from end-4's Hyprland dotfiles (https://github.com/end-4/dots-hyprland)
import QtQml.Models
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

StyledFlickable {
    id: passwordCharsFlickable
    
    visible: usePasswordChars
    anchors.fill: parent
    anchors.topMargin: 0
    anchors.bottomMargin: 0
    anchors.leftMargin: 5
    anchors.rightMargin: 5
    contentWidth: dotsRow.implicitWidth
    flickableDirection: Flickable.HorizontalFlick
    
    contentX: Math.max(contentWidth - width, 0)
    
    Row {
        id: dotsRow
        
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 0  
            rightMargin: 0 
        }
        spacing: 3
        
        Repeater {
            model: passwordCharsModel
            
            delegate: MaterialCookie {
                id: cookie
                required property int index
                
                implicitSize: 19
                color: Colors.primary
                sides: loginContainer.customShapeSequence[index % loginContainer.customShapeSequence.length]
                amplitude: 1.5
                opacity: 0
                scale: 0.5
                
                ParallelAnimation {
                    id: appearAnim
                    
                    NumberAnimation {
                        target: cookie
                        properties: "opacity"
                        to: 1
                        duration: 50
                        easing.type: Appearance.animation.elementMoveFast.type
                        easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
                    }
                    
                    NumberAnimation {
                        target: cookie
                        properties: "scale"
                        to: 1 
                        duration: 300 
                        easing.type: Easing.OutBack
                    }
                    
                    ColorAnimation {
                        target: cookie
                        properties: "color"
                        from: Colors.primary
                        to: Colors.colOnLayer1
                        duration: 1000
                        easing.type: Appearance.animation.elementMoveFast.type
                        easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
                    }
                }
                
                Component.onCompleted: appearAnim.start()
            }
        }
    }
    
    TapHandler {
        onTapped: password.forceActiveFocus()
    }
}