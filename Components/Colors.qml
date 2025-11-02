import QtQuick
pragma Singleton

// Don't edit this file or the script won't pick up the right background
// ~/.config/ii-sddm-theme/default-background/background.png
QtObject {
    property real contentTransparency: 0.57
    property real backgroundTransparency: 0
    property color background: "#0f1512"
    property color error: "#ffb4ab"
    property color error_container: "#93000a"
    property color inverse_on_surface: "#2c322f"
    property color inverse_primary: "#156b55"
    property color inverse_surface: "#dee4df"
    property color on_background: "#dee4df"
    property color on_error: "#690005"
    property color on_error_container: "#ffdad6"
    property color on_primary: "#00382a"
    property color on_primary_container: "#a4f2d6"
    property color on_primary_fixed: "#002118"
    property color on_primary_fixed_variant: "#00513f"
    property color on_secondary: "#1e352d"
    property color on_secondary_container: "#cee9dc"
    property color on_secondary_fixed: "#082018"
    property color on_secondary_fixed_variant: "#344c43"
    property color on_surface: "#dee4df"
    property color on_surface_variant: "#bfc9c3"
    property color on_tertiary: "#0c3446"
    property color on_tertiary_container: "#c3e8fe"
    property color on_tertiary_fixed: "#001e2c"
    property color on_tertiary_fixed_variant: "#274b5d"
    property color outline: "#89938e"
    property color outline_variant: "#3f4945"
    property color primary: "#88d6ba"
    property color primary_container: "#00513f"
    property color primary_fixed: "#a4f2d6"
    property color primary_fixed_dim: "#88d6ba"
    property color scrim: "#000000"
    property color secondary: "#b2ccc1"
    property color secondary_container: "#344c43"
    property color secondary_fixed: "#cee9dc"
    property color secondary_fixed_dim: "#b2ccc1"
    property color shadow: "#000000"
    property color surface: "#0f1512"
    property color surface_bright: "#343b38"
    property color surface_container: "#1b211e"
    property color surface_container_high: "#252b28"
    property color surface_container_highest: "#303633"
    property color surface_container_low: "#171d1a"
    property color surface_container_lowest: "#090f0d"
    property color surface_dim: "#0f1512"
    property color surface_tint: "#88d6ba"
    property color surface_variant: "#3f4945"
    property color tertiary: "#a8cbe1"
    property color tertiary_container: "#274b5d"
    property color tertiary_fixed: "#c3e8fe"
    property color tertiary_fixed_dim: "#a8cbe1"
    property color colSubtext: outline
    property color colLayer0: mix(transparentize(background, backgroundTransparency), primary, 0.99)
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
