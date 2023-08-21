conky.config = {
-- Behaviour
   background = false,
   double_buffer = true,
   update_interval = 2,
   no_buffers = true,
   out_to_console = false,
   out_to_stderr = false,
   extra_newline = false,

-- Dimensions
   alignment = 'top_middle',
   gap_x = 0,
   gap_y = 0,
   minimum_height = 5,
   minimum_width = 5,
   border_width = 1,
   border_inner_margin = 8,
   border_outer_margin = 0,

-- Window
   own_window = true,
   own_window_argb_value = 0,
   own_window_argb_visual = true,
   own_window_class = "Conky",
   own_window_hints = "undecorated,below,sticky,skip_taskbar,skip_pager",
   own_window_transparent = false,
   own_window_type = 'desktop',

-- Samples
   diskio_avg_samples = 2,
   cpu_avg_samples = 2,
   net_avg_samples = 2,

-- Appearance
   use_xft = true,
   font = 'Noto Sans:size=8',
   override_utf8_locale = true,
   default_color = "white",
   default_outline_color = "#555",
   default_shade_color = "#555",
   draw_borders = false,
   stippled_borders = 0,
   draw_graph_borders = true,
   show_graph_scale = false,
   show_graph_range = false,
   draw_outline = false,
   draw_shades = false,
   uppercase = true,
   use_spacer = 'none',

   lua_load = '~/.config/conky/utils.lua',
}

conky.text = [[
${font Noto Sans Medium:size=35}${alignc}${time %H:%M:%S}${font}
${color gray}${hr 1}${color}
${font Noto Sans Medium:size=20}${alignc}${time  %B %d, %Y}${font}
${font Noto Sans Medium:size=15}${alignc}${time %A}${font}

${color gray}${battery_bar}${color}
${font Noto Sans Medium:size=10}${alignc}${battery}
${alignc}${battery_time}${font}
]]