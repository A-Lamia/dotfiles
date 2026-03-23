from dataclasses import dataclass


@dataclass
class colors:
    transparent = "{{colors.surface.default.rgba | set_alpha: 0}}"
    surface = "{{colors.surface.default.rgba | set_alpha: 128}}"
    surface_op = "{{colors.surface.default.rgba | set_alpha: 230}}"
    on_surface = "{{colors.on_surface.default.rgb}}"
    surface_container = "{{colors.surface_container.default.rgb}}"

    primary = "{{colors.primary.default.rgb}}"
    on_primary = "{{colors.on_primary.default.rgb}}"
    on_primary_container = "{{colors.on_primary_container.default.rgb}}"

    primary_shade = (
        "{{colors.primary.default.rgba | auto_lightness: 15.0 | set_alpha: 255}}"
    )
    on_primary_shade = (
        "{{colors.on_primary.default.rgba | auto_lightness: 15.0 | set_alpha: 255}}"
    )
    on_primary_container_shade = "{{colors.on_primary_container.default.rgba | auto_lightness: 15.0 | set_alpha: 255}}"

    compliment = "{{colors.primary.default.rgb | set_hue: -180.0}}"
    on_compliment = "{{colors.on_primary.default.rgb | set_hue: -180.0}}"
    on_compliment_container = (
        "{{colors.on_primary_container.default.rgb | set_hue: -180.0}}"
    )

    secondary = "{{colors.secondary.default.rgb}}"
    on_secondary = "{{colors.on_secondary.default.rgb}}"
    on_secondary_container = "{{colors.on_secondary_container.default.rgb}}"

    tertiary = "{{colors.tertiary.default.rgb}}"
    on_tertiary = "{{colors.on_tertiary.default.rgb}}"
    on_tertiary_container = "{{colors.on_tertiary_container.default.rgb}}"

    error = "{{colors.error.default.rgb}}"
    on_error = "{{colors.on_error.default.rgb}}"
    on_error_container = "{{colors.on_error_container.default.rgb}}"

    private = "{{colors.magenta.default.rgba | set_alpha: 128}}"
    on_private = "{{colors.on_magenta.default.rgb}}"

    red = "{{colors.red.default.rgb}}"
    on_red = "{{colors.on_red.default.rgb}}"
    green = "{{colors.green.default.rgb}}"
    on_green = "{{colors.on_green.default.rgb}}"
    blue = "{{colors.blue.default.rgb}}"
    on_blue = "{{colors.on_blue.default.rgb}}"
    purple = "{{colors.magenta.default.rgb}}"
    on_purple = "{{colors.on_magenta.default.rgb}}"
    yellow = "{{colors.yellow.default.rgb}}"
    on_yellow = "{{colors.on_yellow.default.rgb}}"
