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
    alignment = 'top_right',
    gap_x = 10,
    gap_y = 5,
    minimum_height = 5,
    minimum_width = 5,
    border_width = 1,
    border_inner_margin = 8,
    border_outer_margin = 0,

-- Window
    own_window = true,
    own_window_argb_value = 100,
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
    uppercase = false,
    use_spacer = 'none',

    lua_load = '~/.config/conky/utils.lua',
}

conky.text = [[
${font Noto Sans Black:size=10}SYSTEM ${color gray}${hr 2}${color}${font}
${sysname} ${kernel} ${alignr}${machine}

Hostname:${alignr}${nodename}
Uptime:${alignr}${uptime}
File System: ${alignr}${fs_type}
Temp: ${alignr}${acpitemp}°C

${font Noto Sans Black:size=10}PROCESSES ${color gray}${hr 2}${color}${font}
All: $processes ${alignr}Running: $running_processes

${font Noto Sans Black:size=8}NAME${alignr} PID   CPU  MEM   DSK${font}
${top name 1} ${alignr} ${top pid 1}  ${top cpu 1} ${top mem 1} ${top io_perc 1}
${top name 2} ${alignr} ${top pid 2}  ${top cpu 2} ${top mem 2} ${top io_perc 2}
${top name 3} ${alignr} ${top pid 3}  ${top cpu 3} ${top mem 3} ${top io_perc 3}
${top name 4} ${alignr} ${top pid 4}  ${top cpu 4} ${top mem 4} ${top io_perc 4}
${top name 5} ${alignr} ${top pid 5}  ${top cpu 5} ${top mem 5} ${top io_perc 5}
${top name 6} ${alignr} ${top pid 6}  ${top cpu 6} ${top mem 6} ${top io_perc 6}
${top name 7} ${alignr} ${top pid 7}  ${top cpu 7} ${top mem 7} ${top io_perc 7}
${top name 8} ${alignr} ${top pid 8}  ${top cpu 8} ${top mem 8} ${top io_perc 8}

${font Noto Sans Black:size=10}RESOURCES ${color gray}${hr 2}${color}${font}
${execi 3600 grep model /proc/cpuinfo | cut -d : -f2 | tail -1 | sed 's/s//'}

${font Noto Sans Black:size=8}CPU${alignc}${freq_g} GHz${alignr}${cpu}%${font}
${color gray}${cpugraph cpu0 25,60} ${cpugraph cpu1 25,60} ${cpugraph cpu2 25,60} ${cpugraph cpu3 25,60}${color}

${font Noto Sans Black:size=8}DSK${alignc}${fs_used} / ${fs_size}${alignr}${fs_used_perc}%${font}
${color gray}${diskiograph_read 25,125} ${alignr}${diskiograph_write 25,125}${color}

${font Noto Sans Black:size=8}RAM${alignc}${mem} / ${memmax}${alignr}${memperc}%${font}
${color gray}${membar}${color}

${font Noto Sans Black:size=8}SWP${alignc}${swap} / ${swapmax}${alignr}${swapperc}%${font}
${color gray}${swapbar}${color}

${font Noto Sans Black:size=10}NETWORK ${color gray}${hr 2}${color}${font}
${if_existing /proc/net/route wlp3s0}${addr wlp3s0}\
${else}${if_existing /proc/net/route enp2s0}${addr enp2s0}\
${else}Network disconnected${endif}${endif}\
${alignr}${texeci 3600  curl -4 icanhazip.com; echo}
${if_existing /proc/net/route wlp3s0}
${font Noto Sans Mono Black:size=8}▼ ${downspeed wlp3s0}/s ${alignr} ${upspeed wlp3s0}/s ▲${font}
    ${totaldown wlp3s0}${alignr}${totalup wlp3s0}    \
${endif}\
${if_existing /proc/net/route enp2s0}
${font Noto Sans Mono Black:size=8}▼ ${downspeed enp2s0}/s ${alignr} ${upspeed enp2s0}/s ▲${font}
    ${totaldown enp3s0}${alignr}${totalup enp3s0}    \
${endif}\
]]