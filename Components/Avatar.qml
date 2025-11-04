// Adapted from uiriansan SilentSDDM (https://github.com/uiriansan/SilentSDDM)
// Modified by 3d3f for "ii-sddm-Theme" (2025)
// See LICENSE in project root for full GPLv3 text

import QtQuick
import QtQuick.Effects

Item {
    id: avatarRoot

    property string source: ""
    property color iconColor: "black"
    property int size: 24 
    property string userName: ""

    width: size
    height: size
    Image {
        id: userImage

        anchors.fill: parent
        source: avatarRoot.source
        smooth: true
        mipmap: true
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter
        fillMode: Image.PreserveAspectCrop
        visible: false
    }

    Rectangle {
        id: mask

        anchors.fill: parent
        radius: size / 2
        color: "black"
        visible: false
        layer.enabled: true
    }

    MultiEffect {
        id: avatarEffect 

        anchors.fill: userImage
        source: userImage
        maskEnabled: true
        maskSource: mask

  
        visible: userImage.status === Image.Ready &&
                 avatarRoot.userName !== "" &&
                 avatarRoot.source.toString().indexOf(avatarRoot.userName) !== -1
        maskSpreadAtMin: 1.0
        maskThresholdMax: 1.0
        maskThresholdMin: 0.5
    }
    Text {
        property real fill: 1
        property real truncatedFill: Math.round(fill * 100) / 100

        anchors.centerIn: parent
        visible: !avatarEffect.visible
        font.family: "Material Symbols Outlined"
        font.pixelSize: size
        text: "account_circle"
        color: avatarRoot.iconColor
        renderType: fill !== 0 ? Text.CurveRendering : Text.NativeRendering
        font.hintingPreference: Font.PreferFullHinting
        font.variableAxes: {
            "FILL": truncatedFill,
            "opsz": size
        }
    }
}