import QtQuick
pragma Singleton

// Here you can edit your theme color scheme, i suggest you to use a material color scheme

QtObject {
    property real contentTransparency: 0.57
    property real backgroundTransparency: 0
    property color background: "#131314"
    property color error: "#ffb4ab"
    property color error_container: "#93000a"
    property color inverse_on_surface: "#303031"
    property color inverse_primary: "#546067"
    property color inverse_surface: "#e4e2e2"
    property color on_background: "#e4e2e2"
    property color on_error: "#690005"
    property color on_error_container: "#ffdad6"
    property color on_primary: "#263239"
    property color on_primary_container: "#d4e1ea"
    property color on_primary_fixed: "#111d23"
    property color on_primary_fixed_variant: "#3c484f"
    property color on_secondary: "#2d3134"
    property color on_secondary_container: "#e1e4e8"
    property color on_secondary_fixed: "#181c1f"
    property color on_secondary_fixed_variant: "#43474a"
    property color on_surface: "#e4e2e2"
    property color on_surface_variant: "#c3c7ca"
    property color on_tertiary: "#362d39"
    property color on_tertiary_container: "#eadbea"
    property color on_tertiary_fixed: "#211923"
    property color on_tertiary_fixed_variant: "#4d434f"
    property color outline: "#8d9194"
    property color outline_variant: "#43474a"
    property color primary: "#bcc8d1"
    property color primary_container: "#3c484f"
    property color primary_fixed: "#d8e4ed"
    property color primary_fixed_dim: "#bcc8d1"
    property color scrim: "#000000"
    property color secondary: "#c3c7ca"
    property color secondary_container: "#454a4d"
    property color secondary_fixed: "#dfe3e6"
    property color secondary_fixed_dim: "#c3c7ca"
    property color shadow: "#000000"
    property color surface: "#131314"
    property color surface_bright: "#393939"
    property color surface_container: "#1f2020"
    property color surface_container_high: "#2a2a2a"
    property color surface_container_highest: "#353535"
    property color surface_container_low: "#1b1c1c"
    property color surface_container_lowest: "#0e0e0f"
    property color surface_dim: "#131314"
    property color surface_tint: "#bcc8d1"
    property color surface_variant: "#43474a"
    property color tertiary: "#d0c2d1"
    property color tertiary_container: "#4d434f"
    property color tertiary_fixed: "#eddeed"
    property color tertiary_fixed_dim: "#d0c2d1"
    property color colSubtext: outline
    property color colLayer0: mix(transparentize(background, backgroundTransparency), primary, Config.options.appearance.extraBackgroundTint ? 0.99 : 1)
    property color colOnLayer0: on_background
    property color colLayer0Hover: transparentize(mix(colLayer0, colOnLayer0, 0.9), contentTransparency)
    property color colLayer0Active: transparentize(mix(colLayer0, colOnLayer0, 0.8), contentTransparency)
    property color colLayer0Border: mix(outline_variant, colLayer0, 0.4)
    property color colLayer1: transparentize(surface_container_low, contentTransparency)
    property color colOnLayer1: on_surface_variant
    property color colOnLayer1Inactive: mix(colOnLayer1, colLayer1, 0.45)
    property color colLayer2: transparentize(surface_container, contentTransparency)
    property color colOnLayer2: on_surface
    property color colOnLayer2Disabled: mix(colOnLayer2, background, 0.4)
    property color colLayer1Hover: transparentize(mix(colLayer1, colOnLayer1, 0.92), contentTransparency)
    property color colLayer1Active: transparentize(mix(colLayer1, colOnLayer1, 0.85), contentTransparency)
    property color colLayer2Hover: transparentize(mix(colLayer2, colOnLayer2, 0.9), contentTransparency)
    property color colLayer2Active: transparentize(mix(colLayer2, colOnLayer2, 0.8), contentTransparency)
    property color colLayer2Disabled: transparentize(mix(colLayer2, background, 0.8), contentTransparency)
    property color colLayer3: transparentize(surface_container_high, contentTransparency)
    property color colOnLayer3: on_surface
    property color colLayer3Hover: transparentize(mix(colLayer3, colOnLayer3, 0.9), contentTransparency)
    property color colLayer3Active: transparentize(mix(colLayer3, colOnLayer3, 0.8), contentTransparency)
    property color colLayer4: transparentize(surface_container_highest, contentTransparency)
    property color colOnLayer4: on_surface
    property color colLayer4Hover: transparentize(mix(colLayer4, colOnLayer4, 0.9), contentTransparency)
    property color colLayer4Active: transparentize(mix(colLayer4, colOnLayer4, 0.8), contentTransparency)
    property color colPrimary: primary
    property color colOnPrimary: on_primary
    property color colPrimaryHover: mix(colPrimary, colLayer1Hover, 0.87)
    property color colPrimaryActive: mix(colPrimary, colLayer1Active, 0.7)
    property color colPrimaryContainer: primary_container
    property color colPrimaryContainerHover: mix(colPrimaryContainer, on_primary_container, 0.9)
    property color colPrimaryContainerActive: mix(colPrimaryContainer, on_primary_container, 0.8)
    property color colSecondary: secondary
    property color colSecondaryHover: mix(secondary, colLayer1Hover, 0.85)
    property color colSecondaryActive: mix(secondary, colLayer1Active, 0.4)
    property color colSecondaryContainer: secondary_container
    property color colSecondaryContainerHover: mix(secondary_container, on_secondary_container, 0.9)
    property color colSecondaryContainerActive: mix(secondary_container, on_secondary_container, 0.54)
    property color colTertiary: tertiary
    property color colTertiaryHover: mix(tertiary, colLayer1Hover, 0.85)
    property color colTertiaryActive: mix(tertiary, colLayer1Active, 0.4)
    property color colTertiaryContainer: tertiary_container
    property color colTertiaryContainerHover: mix(tertiary_container, on_tertiary_container, 0.9)
    property color colTertiaryContainerActive: mix(tertiary_container, colLayer1Active, 0.54)
    property color colSurfaceContainerLow: transparentize(surface_container_low, contentTransparency)
    property color colSurfaceContainer: transparentize(surface_container, contentTransparency)
    property color colSurfaceContainerHigh: transparentize(surface_container_high, contentTransparency)
    property color colSurfaceContainerHighest: transparentize(surface_container_highest, contentTransparency)
    property color colSurfaceContainerHighestHover: mix(surface_container_highest, on_surface, 0.95)
    property color colSurfaceContainerHighestActive: mix(surface_container_highest, on_surface, 0.85)
    property color colOnSurface: on_surface
    property color colOnSurfaceVariant: on_surface_variant
    property color colTooltip: inverse_surface
    property color colOnTooltip: inverse_on_surface
    property color colScrim: transparentize(scrim, 0.5)
    property color colShadow: transparentize(shadow, 0.7)
    property color colOutline: outline
    property color colOutlineVariant: outline_variant
    property color colError: error
    property color colErrorHover: mix(error, colLayer1Hover, 0.85)
    property color colErrorActive: mix(error, colLayer1Active, 0.7)
    property color colOnError: on_error
    property color colErrorContainer: error_container
    property color colErrorContainerHover: mix(error_container, on_error_container, 0.9)
    property color colErrorContainerActive: mix(error_container, on_error_container, 0.7)

    function transparentize(color, percentage) {
        if (percentage === undefined)
            percentage = 1;

        var c = Qt.color(color);
        return Qt.rgba(c.r, c.g, c.b, c.a * (1 - percentage));
    }

    function mix(color1, color2, percentage) {
        if (percentage === undefined)
            percentage = 0.5;

        var c1 = Qt.color(color1);
        var c2 = Qt.color(color2);
        return Qt.rgba(percentage * c1.r + (1 - percentage) * c2.r, percentage * c1.g + (1 - percentage) * c2.g, percentage * c1.b + (1 - percentage) * c2.b, percentage * c1.a + (1 - percentage) * c2.a);
    }

}
