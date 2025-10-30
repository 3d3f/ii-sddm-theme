// Main.qml
import "."
import "Components"
import QtMultimedia
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import SddmComponents

Pane {
    id: root

    property bool leftleft: config.HaveFormBackground == "true" && partialBlur == "false" && config.FormPosition == "left" && config.BackgroundHorizontalAlignment == "left"
    property bool leftcenter: config.HaveFormBackground == "true" && partialBlur == "false" && config.FormPosition == "left" && config.BackgroundHorizontalAlignment == "center"
    property bool rightright: config.HaveFormBackground == "true" && partialBlur == "false" && config.FormPosition == "right" && config.BackgroundHorizontalAlignment == "right"
    property bool rightcenter: config.HaveFormBackground == "true" && partialBlur == "false" && config.FormPosition == "right" && config.BackgroundHorizontalAlignment == "center"
    property bool partialBlur: Settings.lock_blur_enable

    padding: 0
    palette.window: config.BackgroundColor
    palette.highlight: config.HighlightBackgroundColor
    palette.highlightedText: config.HighlightTextColor
    palette.buttonText: config.HoverSystemButtonsIconsColor
    font.family: "Rubik"
    focus: true
    height: config.ScreenHeight || Screen.height
    width: config.ScreenWidth || Screen.ScreenWidth

    Item {
        id: sizeHelper

        height: parent.height
        width: parent.width
        anchors.fill: parent

        Rectangle {
            id: tintLayer

            height: parent.height
            width: parent.width
            anchors.fill: parent
            z: 2
            color: config.DimBackgroundColor
            opacity: config.DimBackground
        }

        LoginForm {
            id: form

            height: parent.height
            width: parent.width
            z: 10
        }

        Rectangle {
            id: formBackground

            anchors.fill: form
            z: -1
            color: "#000000"
            visible: true
            opacity: partialBlur ? 0.3 : 1
        }

        Image {
            id: backgroundPlaceholderImage

            z: 10
            source: config.BackgroundPlaceholder
            visible: false
        }

        AnimatedImage {
            id: backgroundImage

            height: parent.height
            width: parent.width
            anchors.left: undefined
            anchors.right: undefined
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter
            speed: config.BackgroundSpeed == "" ? 1 : config.BackgroundSpeed
            paused: config.PauseBackground == "true" ? 1 : 0
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: true
            clip: true
            mipmap: true
            Component.onCompleted: {
                var fileType = config.Background.substring(config.Background.lastIndexOf(".") + 1);
                const videoFileTypes = ["avi", "mp4", "mov", "mkv", "m4v", "webm"];
                if (videoFileTypes.includes(fileType)) {
                    backgroundPlaceholderImage.visible = true;
                    player.source = Qt.resolvedUrl(config.Background);
                    player.play();
                } else {
                    backgroundImage.source = config.background || config.Background;
                }
            }

            MediaPlayer {
                id: player

                videoOutput: videoOutput
                autoPlay: true
                playbackRate: config.BackgroundSpeed == "" ? 1 : config.BackgroundSpeed
                loops: -1
                onPlayingChanged: {
                    console.log("Video started.");
                    backgroundPlaceholderImage.visible = false;
                }
            }

            VideoOutput {
                id: videoOutput

                fillMode: VideoOutput.PreserveAspectCrop
                anchors.fill: parent
            }

        }

        MouseArea {
            anchors.fill: backgroundImage
            onClicked: parent.forceActiveFocus()
        }

        ShaderEffectSource {
            id: blurMask

            height: parent.height
            width: form.width
            anchors.centerIn: form
            sourceItem: backgroundImage
            sourceRect: Qt.rect(x, y, width, height)
            visible: config.FullBlur == "true" || partialBlur == "true" ? true : false
        }

        MultiEffect {
            id: blur

            height: parent.height
            width: (config.FullBlur == "true" && partialBlur == "false" && config.FormPosition != "center") ? parent.width - formBackground.width : config.FullBlur == "true" ? parent.width : form.width
            anchors.centerIn: config.FullBlur == "true" ? backgroundImage : form
            source: config.FullBlur == "true" ? backgroundImage : blurMask
            blurEnabled: partialBlur
            autoPaddingEnabled: false
            blur: config.Blur == "" ? 2 : config.Blur
            blurMax: config.BlurMax == "" ? 48 : config.BlurMax
            visible: config.FullBlur == "true" || partialBlur == "true" ? true : false
        }

        Loader {
            id: screenCornersLoader

            anchors.fill: parent
            active: config.ScreenCorners == "true"
            source: "Components/RoundCorner.qml"
            z: 100
            onLoaded: {
                item.cornerType = "inverted";
                item.cornerHeight = 25;
                item.cornerWidth = 25;
                item.corners = [0, 1, 2, 3];
                item.color = "black";
            }
        }

    }

}
