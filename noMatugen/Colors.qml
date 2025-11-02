import QtQuick
pragma Singleton

// Here you can edit your theme color scheme, i suggest you to use a material you color scheme
QtObject {
    property real contentTransparency: 0.57
    property real backgroundTransparency: 0
    property color background: "#121314"
    property color error: "#ffb4ab"
    property color error_container: "#93000a"
    property color inverse_on_surface: "#303031"
    property color inverse_primary: "#4b626b"
    property color inverse_surface: "#e3e2e2"
    property color on_background: "#e3e2e2"
    property color on_error: "#690005"
    property color on_error_container: "#ffdad6"
    property color on_primary: "#1c343c"
    property color on_primary_container: "#c1dae5"
    property color on_primary_fixed: "#051e27"
    property color on_primary_fixed_variant: "#334a53"
    property color on_secondary: "#293235"
    property color on_secondary_container: "#d9e1e6"
    property color on_secondary_fixed: "#141d20"
    property color on_secondary_fixed_variant: "#3f484c"
    property color on_surface: "#e3e2e2"
    property color on_surface_variant: "#c2c7ca"
    property color on_tertiary: "#392c3f"
    property color on_tertiary_container: "#e4d0ea"
    property color on_tertiary_fixed: "#231729"
    property color on_tertiary_fixed_variant: "#504256"
    property color outline: "#8c9194"
    property color outline_variant: "#42484a"
    property color primary: "#b2cad5"
    property color primary_container: "#2d444d"
    property color primary_fixed: "#cde6f2"
    property color primary_fixed_dim: "#b2cad5"
    property color scrim: "#000000"
    property color secondary: "#bfc8cc"
    property color secondary_container: "#3f484c"
    property color secondary_fixed: "#dbe4e9"
    property color secondary_fixed_dim: "#bfc8cc"
    property color shadow: "#000000"
    property color surface: "#121314"
    property color surface_bright: "#38393a"
    property color surface_container: "#1f2020"
    property color surface_container_high: "#292a2b"
    property color surface_container_highest: "#343535"
    property color surface_container_low: "#1b1c1c"
    property color surface_container_lowest: "#0d0e0f"
    property color surface_dim: "#121314"
    property color surface_tint: "#b2cad5"
    property color surface_variant: "#42484a"
    property color tertiary: "#d4c0d9"
    property color tertiary_container: "#4a3c50"
    property color tertiary_fixed: "#f0dcf5"
    property color tertiary_fixed_dim: "#d4c0d9"
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
