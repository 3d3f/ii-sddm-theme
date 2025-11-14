import QtQuick
import "../"

Text {
    id: root

    renderType: Text.NativeRendering
    verticalAlignment: Text.AlignVCenter
    color: Colors.on_surface
    linkColor: Colors.primary

    font {
        hintingPreference: Font.PreferDefaultHinting
        family: Appearance.font_family_main
        pixelSize: Appearance.font_size_normal
    }

}
