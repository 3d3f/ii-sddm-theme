// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2025 Keyitdev
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html
// Modified by 3d3f for the "ii-sddm-theme" project (2025)
// Enhanced with advanced screen management and error handling
// Licensed under the GNU General Public License v3.0

// Adapted from uiriansan SilentSDDM (https://github.com/uiriansan/SilentSDDM)
// Modified by 3d3f for "ii-sddm-Theme" (2025)
// See LICENSE in project root for full GPLv3 text


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
    property bool partialBlur: Settings.lock_blur_enable
    property variant screenGeometry: screenModel.geometry(screenModel.primary)
    
    padding: 0
    font.family: Appearance.font_family_main
    focus: true
    
    height: screenGeometry.height
    width: screenGeometry.width 
    x: screenGeometry.x || 0
    y: screenGeometry.y || 0

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
            source: config.BackgroundPlaceholder || ""
            visible: false
            cache: true
        }

        AnimatedImage {
            id: backgroundImage

            property bool isVideo: {
                // Controllo robusto del tipo file
                var bg = config.Background;
                if (!bg || bg.toString().length === 0)
                    return false;
                var parts = bg.toString().split(".");
                if (parts.length === 0)
                    return false;
                var ext = parts[parts.length - 1].toLowerCase();
                return ["avi", "mp4", "mov", "mkv", "m4v", "webm"].indexOf(ext) !== -1;
            }

            property bool displayColor: false

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
                if (isVideo) {
                    // Gestione video
                    if (config.BackgroundPlaceholder && config.BackgroundPlaceholder.length > 0) {
                        backgroundPlaceholderImage.visible = true;
                    }
                    player.source = Qt.resolvedUrl(config.Background);
                    player.play();
                } else {
                    // Gestione immagine statica/animata
                    backgroundImage.source = config.background || config.Background || "";
                }
            }

            onStatusChanged: {
                // Sistema di fallback intelligente per le immagini
                if (status === Image.Error) {
                    console.log("Background image failed to load:", source);
                    if (source !== "" && !displayColor) {
                        // Mostra colore di fallback
                        displayColor = true;
                        console.log("Switching to fallback color background");
                    }
                }
            }

            // Colore di fallback se tutto fallisce
            Rectangle {
                id: backgroundColor
                anchors.fill: parent
                color: config.DimBackgroundColor || "#000000"
                visible: parent.displayColor || (player.playbackState !== MediaPlayer.PlayingState && parent.isVideo && config.BackgroundPlaceholder.length === 0)
                z: -1
            }

            MediaPlayer {
                id: player

                videoOutput: videoOutput
                autoPlay: false
                playbackRate: config.BackgroundSpeed == "" ? 1 : config.BackgroundSpeed
                loops: MediaPlayer.Infinite

                onPlaybackStateChanged: {
                    if (playbackState === MediaPlayer.PlayingState) {
                        console.log("Video started playing");
                        backgroundPlaceholderImage.visible = false;
                    }
                }

                onErrorOccurred: function(error, errorString) {
                    if (error !== MediaPlayer.NoError) {
                        console.log("Video error:", errorString);
                        if (!config.BackgroundPlaceholder || config.BackgroundPlaceholder.length === 0) {
                            backgroundImage.displayColor = true;
                        }
                    }
                }
            }

            VideoOutput {
                id: videoOutput

                fillMode: VideoOutput.PreserveAspectCrop
                anchors.fill: parent
            }

            // Cleanup per prevenire memory leak
            Component.onDestruction: {
                if (player) {
                    player.stop();
                    player.source = "";
                }
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
            
            // Miglioramento: blur solo se immagine visibile
            blurEnabled: (config.FullBlur == "true" || partialBlur == "true") && backgroundImage.visible && !backgroundImage.displayColor
            autoPaddingEnabled: false
            blur: (config.Blur == "" ? 2 : config.Blur) > 0 ? 1.0 : 0.0
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

    // Transizioni fluide per effetti (opzionale, se vuoi animazioni)
    Behavior on opacity {
        enabled: config.EnableAnimations == "true"
        NumberAnimation {
            duration: 150
            easing.type: Easing.InOutQuad
        }
    }

}