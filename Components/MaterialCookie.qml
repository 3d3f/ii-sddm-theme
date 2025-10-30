// Adapted from end-4's Hyprland dotfiles (https://github.com/end-4/dots-hyprland)
// Modified by 3d3f for "ii-sddm-theme" (2025)
import QtQuick
import QtQuick.Shapes

Item {
    id: root

    property real sides: 12
    property int implicitSize: 100
    property real amplitude: implicitSize / 50
    property int renderPoints: 360
    property color color: "#605790"
    property alias strokeWidth: shapePath.strokeWidth
    property bool constantlyRotate: Settings.background_clock_cookie_constantlyRotate
    property real shapeRotation: 0

    implicitWidth: implicitSize
    implicitHeight: implicitSize

    Loader {
        active: constantlyRotate

        sourceComponent: FrameAnimation {
            running: true
            onTriggered: {
                root.shapeRotation += 0.05;
            }
        }

    }

    Shape {
        id: shape

        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            id: shapePath

            strokeWidth: 0
            fillColor: root.color
            pathHints: ShapePath.PathSolid & ShapePath.PathNonIntersecting

            PathPolyline {
                property var pointsList: {
                    var points = [];
                    var cx = shape.width / 2;
                    var cy = shape.height / 2;
                    var steps = root.renderPoints;
                    var radius = root.implicitSize / 2 - root.amplitude;
                    for (var i = 0; i <= steps; i++) {
                        var angle = (i / steps) * 2 * Math.PI;
                        var rotatedAngle = angle * root.sides + Math.PI / 2 + (root.shapeRotation * root.constantlyRotate);
                        var wave = Math.sin(rotatedAngle) * root.amplitude;
                        var x = Math.cos(angle) * (radius + wave) + cx;
                        var y = Math.sin(angle) * (radius + wave) + cy;
                        points.push(Qt.point(x, y));
                    }
                    return points;
                }

                path: pointsList
            }

        }

    }

    Behavior on sides {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutQuad
        }

    }

}
