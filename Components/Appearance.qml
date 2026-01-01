import QtQuick
pragma Singleton

QtObject {
    id: root

    property string font_family_main: "Google Sans Flex"
    property string font_family_expressive: "Space Grotesk"
    property string font_family_reading: "Readex Pro"
    property string illogicalIconFont: "Material Symbols Outlined"
    property string waffleFont: "Noto Sans"
    property string waffleIconFont: "FluentSystemIcons-Regular"
    property string animfont: "Segoe Boot Semilight"
    
    property real font_size_normal: 15
    property real font_size_small: 12
    property real date_square_size: 64
    property real rounding_full: 1000
    property real rounding_small: 12
    property real waffleButtonIconFontSize: 20
    property real wafflePopupTextFont: 13

    property real formRowHeight: 57
    property real formRowBottomMargin: 20
    property real listItemSpacing: 5
    
    property color waffleButtonBackground: Colors.transparentize("#FFFFFF", 0.9)
    property color wafflePopupBackground: Colors.surface_container
    property color wafflePopupBorder: Colors.transparentize(Colors.shadow, 0.5)
    
    property bool highContrastEnabled: false
    
    property color dynamicSwitchActiveBorder: highContrastEnabled ? "#1AEBFF" : Colors.colPrimaryActive
    property color dynamicSwitchActiveBackground: highContrastEnabled ? "#1AEBFF" : Colors.colPrimaryActive
    property color dynamicSwitchActiveKnob: highContrastEnabled ? "#000000" : Colors.on_surface
    property color dynamicSwitchInactiveBorder: highContrastEnabled ? "#FFFFFF" : Colors.on_surface_variant
    property color dynamicSwitchInactiveKnob: highContrastEnabled ? "#FFFFFF" : Colors.on_surface_variant
    property color dynamicSwitchHoverBorder: highContrastEnabled ? "#1AEBFF" : Colors.on_surface
    property color dynamicSwitchHoverKnob: highContrastEnabled ? "#1AEBFF" : Colors.on_surface
    property color dynamicSwitchActiveHoverBorder: highContrastEnabled ? "#1AEBFF" : Colors.colPrimaryActive
    property color dynamicSwitchActiveHoverBackground: highContrastEnabled ? "#000000" : Colors.colPrimaryActive
    property color dynamicSwitchActiveHoverKnob: highContrastEnabled ? "#1AEBFF" : Colors.on_surface  
    property color dynamicPopupBackground: highContrastEnabled ? "#000000" : Colors.surface_container
    property color dynamicPopupBorder: highContrastEnabled ? "#FFFFFF" : Colors.transparentize(Colors.shadow, 0.5)
    property color dynamicPopupText: highContrastEnabled ? "#FFFFFF" : Colors.on_surface
    property color dynamicButtonBackground: highContrastEnabled ? "#1AEBFF" : Colors.transparentize("#FFFFFF", 0.9)
    property color dynamicButtonIcon: highContrastEnabled ? "#000000" : "#FFFFFF"
    property color dynamicListSelectedBackground: highContrastEnabled ? "#1AEBFF" : Colors.primary_container

    readonly property QtObject colors: QtObject {
        property color colOnSecondaryContainer: Colors.on_secondary_container || Colors.on_surface
        property color colSecondaryContainer: Colors.secondary_container || Colors.surface_container
        property color colPrimaryActive: Colors.primary || "#1AEBFF"
        property color colShadow: Colors.shadow || "#00000080"
        property color colOnErrorContainer: Colors.on_error_container || Colors.on_error
    }

    readonly property QtObject rounding: QtObject {
        property int unsharpen: 2
        property int unsharpenmore: 6
        property int verysmall: 8
        property int small: 12
        property int normal: 17
        property int large: 23
        property int verylarge: 30
        property int full: 9999
        property int screenRounding: large
        property int windowRounding: 18
    }
    
    readonly property QtObject font: QtObject {

        readonly property QtObject family: QtObject {
            property string main: root.font_family_main
            property string numbers: root.font_family_main
            property string title: root.font_family_main
            property string iconMaterial: "Material Symbols Outlined"
            property string iconNerd: root.waffleIconFont
            property string monospace: "JetBrains Mono"
            property string reading: root.font_family_reading
            property string expressive: root.font_family_expressive
        }
        
        readonly property QtObject variableAxes: QtObject {
            property var main: ({
                "wght": 450,
                "wdth": 100
            })
            property var numbers: ({
                "wght": 450,
                "wdth": 100,
                "ROND": 0
            })
            property var title: ({
                "wght": 550
            })
        }
        
        readonly property QtObject pixelSize: QtObject {
            property int smallest: 10
            property int smaller: 12
            property int smallie: 13
            property int small: 15
            property int normal: 16
            property int large: 17
            property int larger: 19
            property int huge: 22
            property int hugeass: 23
            property int title: huge
        }
    }

    readonly property QtObject animationCurves: QtObject {
        readonly property list<real> expressiveFastSpatial: [0.42, 1.67, 0.21, 0.90, 1, 1]
        readonly property list<real> expressiveDefaultSpatial: [0.38, 1.21, 0.22, 1.00, 1, 1]
        readonly property list<real> expressiveSlowSpatial: [0.39, 1.29, 0.35, 0.98, 1, 1]
        readonly property list<real> expressiveEffects: [0.34, 0.80, 0.34, 1.00, 1, 1]
        readonly property list<real> emphasized: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
        readonly property list<real> emphasizedFirstHalf: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82]
        readonly property list<real> emphasizedLastHalf: [5 / 24, 0.82, 0.25, 1, 1, 1]
        readonly property list<real> emphasizedAccel: [0.3, 0, 0.8, 0.15, 1, 1]
        readonly property list<real> emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
        readonly property list<real> standard: [0.2, 0, 0, 1, 1, 1]
        readonly property list<real> standardAccel: [0.3, 0, 1, 1, 1, 1]
        readonly property list<real> standardDecel: [0, 0, 0, 1, 1, 1]
        readonly property real expressiveFastSpatialDuration: 350
        readonly property real expressiveDefaultSpatialDuration: 500
        readonly property real expressiveSlowSpatialDuration: 650
        readonly property real expressiveEffectsDuration: 200
    }

    readonly property QtObject animation: QtObject {
        property QtObject elementMove: QtObject {
            property int duration: root.animationCurves.expressiveDefaultSpatialDuration
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: root.animationCurves.expressiveDefaultSpatial
            
            readonly property QtObject numberAnimation: QtObject {
                function createObject(parent) {
                    return Qt.createQmlObject(`
                        import QtQuick 2.15
                        NumberAnimation {
                            duration: ${duration}
                            easing.type: ${type}
                            easing.bezierCurve: [${bezierCurve.join(",")}]
                        }
                    `, parent, "elementMove")
                }
            }
        }

        property QtObject elementMoveEnter: QtObject {
            property int duration: 400
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: root.animationCurves.emphasizedDecel
        }

        property QtObject elementMoveExit: QtObject {
            property int duration: 200
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: root.animationCurves.emphasizedAccel
        }

        property QtObject elementMoveFast: QtObject {
            property int duration: root.animationCurves.expressiveEffectsDuration
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: root.animationCurves.expressiveEffects
            
            readonly property QtObject numberAnimation: QtObject {
                function createObject(parent) {
                    return Qt.createQmlObject(`
                        import QtQuick 2.15
                        NumberAnimation {
                            duration: ${duration}
                            easing.type: ${type}
                            easing.bezierCurve: [${bezierCurve.join(",")}]
                        }
                    `, parent, "elementMoveFast")
                }
            }
        }

        property QtObject elementResize: QtObject {
            property int duration: 300
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: root.animationCurves.emphasized
            
            readonly property QtObject numberAnimation: QtObject {
                function createObject(parent) {
                    return Qt.createQmlObject(`
                        import QtQuick 2.15
                        NumberAnimation {
                            duration: ${duration}
                            easing.type: ${type}
                            easing.bezierCurve: [${bezierCurve.join(",")}]
                        }
                    `, parent, "elementResize")
                }
            }
        }

        property QtObject clickBounce: QtObject {
            property int duration: 400
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: root.animationCurves.expressiveDefaultSpatial
        }
        
        property QtObject scroll: QtObject {
            property int duration: 200
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: root.animationCurves.standardDecel
        }

        property QtObject menuDecel: QtObject {
            property int duration: 350
            property int type: Easing.OutExpo
        }
    }
}