import QtQuick
pragma Singleton

// {{image}}
QtObject {
    property real contentTransparency: 0.57
    property color background: "{{colors.background.default.hex}}"
    property color error: "{{colors.error.default.hex}}"
    property color error_container: "{{colors.error_container.default.hex}}"
    property color inverse_on_surface: "{{colors.inverse_on_surface.default.hex}}"
    property color inverse_primary: "{{colors.inverse_primary.default.hex}}"
    property color inverse_surface: "{{colors.inverse_surface.default.hex}}"
    property color on_background: "{{colors.on_background.default.hex}}"
    property color on_error: "{{colors.on_error.default.hex}}"
    property color on_error_container: "{{colors.on_error_container.default.hex}}"
    property color on_primary: "{{colors.on_primary.default.hex}}"
    property color on_primary_container: "{{colors.on_primary_container.default.hex}}"
    property color on_primary_fixed: "{{colors.on_primary_fixed.default.hex}}"
    property color on_primary_fixed_variant: "{{colors.on_primary_fixed_variant.default.hex}}"
    property color on_secondary: "{{colors.on_secondary.default.hex}}"
    property color on_secondary_container: "{{colors.on_secondary_container.default.hex}}"
    property color on_secondary_fixed: "{{colors.on_secondary_fixed.default.hex}}"
    property color on_secondary_fixed_variant: "{{colors.on_secondary_fixed_variant.default.hex}}"
    property color on_surface: "{{colors.on_surface.default.hex}}"
    property color on_surface_variant: "{{colors.on_surface_variant.default.hex}}"
    property color on_tertiary: "{{colors.on_tertiary.default.hex}}"
    property color on_tertiary_container: "{{colors.on_tertiary_container.default.hex}}"
    property color on_tertiary_fixed: "{{colors.on_tertiary_fixed.default.hex}}"
    property color on_tertiary_fixed_variant: "{{colors.on_tertiary_fixed_variant.default.hex}}"
    property color outline: "{{colors.outline.default.hex}}"
    property color outline_variant: "{{colors.outline_variant.default.hex}}"
    property color primary: "{{colors.primary.default.hex}}"
    property color primary_container: "{{colors.primary_container.default.hex}}"
    property color primary_fixed: "{{colors.primary_fixed.default.hex}}"
    property color primary_fixed_dim: "{{colors.primary_fixed_dim.default.hex}}"
    property color scrim: "{{colors.scrim.default.hex}}"
    property color secondary: "{{colors.secondary.default.hex}}"
    property color secondary_container: "{{colors.secondary_container.default.hex}}"
    property color secondary_fixed: "{{colors.secondary_fixed.default.hex}}"
    property color secondary_fixed_dim: "{{colors.secondary_fixed_dim.default.hex}}"
    property color shadow: "{{colors.shadow.default.hex}}"
    property color surface: "{{colors.surface.default.hex}}"
    property color surface_bright: "{{colors.surface_bright.default.hex}}"
    property color surface_container: "{{colors.surface_container.default.hex}}"
    property color surface_container_high: "{{colors.surface_container_high.default.hex}}"
    property color surface_container_highest: "{{colors.surface_container_highest.default.hex}}"
    property color surface_container_low: "{{colors.surface_container_low.default.hex}}"
    property color surface_container_lowest: "{{colors.surface_container_lowest.default.hex}}"
    property color surface_dim: "{{colors.surface_dim.default.hex}}"
    property color surface_tint: "{{colors.surface_tint.default.hex}}"
    property color surface_variant: "{{colors.surface_variant.default.hex}}"
    property color tertiary: "{{colors.tertiary.default.hex}}"
    property color tertiary_container: "{{colors.tertiary_container.default.hex}}"
    property color tertiary_fixed: "{{colors.tertiary_fixed.default.hex}}"
    property color tertiary_fixed_dim: "{{colors.tertiary_fixed_dim.default.hex}}"
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
