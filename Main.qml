// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2025 Keyitdev
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html
// Modified by 3d3f for the "ii-sddm-theme" project (2025)

import "."
import "../"
import "Components"
import Qt5Compat.GraphicalEffects
import QtMultimedia
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import SddmComponents

Pane {
    id: root

    readonly property variant screenGeometry: screenModel.geometry(screenModel.primary)

    padding: 0
    focus: true
    anchors.fill: parent
    x: screenGeometry.x || 0
    y: screenGeometry.y || 0

    Item {
        id: sizeHelper
        anchors.fill: parent

        AnimatedImage {
            id: backgroundImage

            readonly property bool isVideo: {
                const bg = config.Background?.toString() || "";
                if (!bg) return false;
                const ext = bg.split(".").pop()?.toLowerCase() || "";
                return ["avi", "mp4", "mov", "mkv", "m4v", "webm"].includes(ext);
            }
            property bool showFallbackColor: false

            anchors.fill: parent
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter
            fillMode: Image.PreserveAspectCrop
            speed: config.BackgroundSpeed || 1
            paused: config.PauseBackground == "true"
            asynchronous: true
            cache: true
            clip: true
            mipmap: true
            visible: true

            Component.onCompleted: {
                if (isVideo) {
                    player.source = Qt.resolvedUrl(config.Background);
                    player.play();
                } else {
                    source = config.background || config.Background || "";
                }
            }

            onStatusChanged: {
                if (status === Image.Error && !showFallbackColor) {
                    console.log("Background load failed, using fallback");
                    showFallbackColor = true;
                }
            }

            Rectangle {
                anchors.fill: parent
                color: config.DimBackgroundColor || "#000000"
                visible: parent.showFallbackColor || 
                        (player.playbackState !== MediaPlayer.PlayingState && 
                         parent.isVideo && 
                         !config.BackgroundPlaceholder)
                z: -2
            }

            Image {
                anchors.fill: parent
                source: backgroundImage.isVideo ? (config.BackgroundPlaceholder || "") : ""
                visible: source !== "" && player.playbackState !== MediaPlayer.PlayingState
                cache: true
                asynchronous: false
                z: -1
            }

            MediaPlayer {
                id: player
                videoOutput: videoOutput
                playbackRate: config.BackgroundSpeed || 1
                loops: MediaPlayer.Infinite
                
                onErrorOccurred: (error, errorString) => {
                    if (error !== MediaPlayer.NoError) {
                        console.log("Video error:", errorString);
                        if (!config.BackgroundPlaceholder)
                            backgroundImage.showFallbackColor = true;
                    }
                }
            }

            VideoOutput {
                id: videoOutput
                anchors.fill: parent
                fillMode: VideoOutput.PreserveAspectCrop
            }
        }

        Rectangle {
            id: highContrastBackground
            anchors.fill: parent
            color: "black"
            z: 0.5 
            visible: Appearance.highContrastEnabled
        }

        GaussianBlur {
            id: blur
            anchors.fill: backgroundImage
            source: backgroundImage
            radius: {
                if (Settings.panelFamily === "waffle")
                    return (loginInterfaceLoader.item?.unlocked) ? 100 : 0;
                return 100;
            }
            samples: radius * 2 + 1
            
            visible: !Appearance.highContrastEnabled && (
                Settings.panelFamily === "waffle" ? radius > 0 
                : (Settings.panelFamily === "ii" && Settings.lock_blur_enable)
            )
        }

        MouseArea {
            anchors.fill: parent
            onClicked: parent.forceActiveFocus()
        }

        Loader {
            id: loginInterfaceLoader
            anchors.fill: parent
            z: 2
            sourceComponent: Settings.panelFamily === "waffle" 
                ? waffleLoginInterface 
                : iiLoginInterface

            Component {
                id: iiLoginInterface
                IILoginInterface {
                    anchors.fill: parent
                }
            }

            Component {
                id: waffleLoginInterface
                WaffleLoginInterface {
                    anchors.fill: parent
                }
            }
        }

        Loader {
            id: screenCornersLoader
            anchors.fill: parent
            active: config.ScreenCorners == "true" && !Appearance.highContrastEnabled 
            source: "Components/Commons/RoundCorner.qml"
            z: 10
            
            onLoaded: {
                item.cornerType = "inverted";
                item.cornerHeight = 25;
                item.cornerWidth = 25;
                item.corners = [0, 1, 2, 3];
                item.color = "black";
            }
        }
    }

    // Behavior on opacity {
    //     enabled: animationsEnabled
    //     NumberAnimation {
    //         duration: 150
    //         easing.type: Easing.InOutQuad
    //     }
    // }
}