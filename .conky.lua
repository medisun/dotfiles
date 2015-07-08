require 'cairo'

-- cairo surface
cr = nil

screen_width       = 1920 - 30 -- without panel
screen_height      = 1080

updates = 0

default_color       = 0xafffef8f
default_font_face   = 'Monospace'
default_font_size   = 10.3
default_font_slant  = CAIRO_FONT_SLANT_NORMAL
default_font_weight = CAIRO_FONT_WEIGHT_NORMAL

conky_start = true


function shell(cmd)
    local file  = io.popen(cmd)
    local lines = file:lines()
    local output = ''
    for line in lines do
        output = output .. line .. "\n"
    end
    file:close()
    return output
end

function prefill( text, size, sym )
    local text = tostring(text) 
    local n = string.len(text)
    for i = n, size do
        text = sym .. text
    end
    return text
end

function set_color( color )
    cairo_set_source_rgba ( cr,
                            ((color / 0x1000000) % 0x100) / 256.,
                            ((color / 0x10000) % 0x100) / 256.,
                            ((color / 0x100) % 0x100) / 256.,
                            (color % 0x100) / 256.)
    -- cairo_set_source_rgb (cr, 0.0, 0.0, 0.0)
    -- cairo_paint_with_alpha (cr, 0.5)
end

function text( text, x, y, color, size, font, bold, cut )

    slant  = default_font_slant
    weight = default_font_weight

 -- set font
    if color ~= nil then 
        set_color(color)
    end

 -- set font
    if font ~= nil then 
        cairo_select_font_face (cr, font, slant, weight)
    end

 -- set size
    if size ~= nil then 
        cairo_set_font_size (cr, size)
    else 
        size = default_font_size
    end
    


    y = y + size + 3

 -- loop for multiline. Sometime symbol of end line is \02
    for line in string.gmatch(text, "[^\n]*[\n]?") do
        if string.sub(line, -1) == "\n" then
            line = string.sub(line, 1, -2)
        end
        if (cut ~= nil) then
            line = string.sub(line, 1, cut)
        end

        cairo_move_to (cr, x, y)
        cairo_show_text (cr, line)
        cairo_stroke (cr)
        y = y + size
    end

    if font ~= nil or size ~= nil or color ~= nil then 
        reset_font()
    end
end

function conky(c)
    return conky_parse(c)
end

function reset_font()
    set_color(default_color)
    cairo_set_font_size (cr, default_font_size)
    cairo_select_font_face (cr, default_font_face, default_font_slant, default_font_weight)
end

function user_main()

    reset_font()

    text(
        conky(
            " - CP  ${cpu 0}%  ${cpu 1}%\n"
         .. " - MM  ${memperc}%  ${swapperc}%\n"
         .. " - IO  ${diskio}\n"
        )
    , 250, 15, nil, 12)

    text(
        conky(
            " - ${time}\n  '\n"
         .. " - ${uptime} up\n  '\n"
         .. " - CPU  < ${cpu 0}% ${cpu 1}% >\n"
         .. "  `-${top cpu 1}% ${top name 1}\n"
         .. "  `-${top cpu 2}% ${top name 2}\n"
         .. "  `- proc ${processes} / ${running_processes}\n  '\n"
         .. " - MEM  < ${memperc}% >\n"
         .. "  `- ${mem}/${memmax}\n"
         .. " - SWAP < ${swapperc}% >\n"
         .. "  `- ${swap}/${swapmax}\n"
         .. "  `-${top_mem mem 1}% ${top_mem name 1}\n"
         .. "  `-${top_mem mem 2}% ${top_mem name 2}\n  '\n"
         .. " - IO   < ${diskio} >\n"
         .. "  `- W ${diskio_write}  R ${diskio_read}\n"
         .. "  `-${top_io io_perc 1}% ${top_io name 1}\n"
         .. "  `-${top_io io_perc 2}% ${top_io name 2}\n  '\n"
         .. " - IP   < ${addr p4p1} > \n"
         .. "  `- UP   < ${upspeed p4p1} >\n"
         .. "  `- DOWN < ${downspeed p4p1} >\n"
         .. "  `- PING " .. shell("ping -c1 192.232.219.83 | tail -1 | awk -F '/' '{print \"< \"$5\"ms >\"}'") .. "  '\n"
         .. "  `- PORT in < ${tcp_portmon 1 32767 count} / ${tcp_portmon 32768 61000 count} > out\n"
         .. "  `- REMOTE \n"
         .. "    `- ${tcp_portmon 32768 61000 rservice 0} ${tcp_portmon 32768 61000 rhost 0}\n"
         .. "    `- ${tcp_portmon 32768 61000 rservice 1} ${tcp_portmon 32768 61000 rhost 1}\n" 
         .. "    `- ${tcp_portmon 32768 61000 rservice 2} ${tcp_portmon 32768 61000 rhost 2}\n" 
         .. "    `- ${tcp_portmon 32768 61000 rservice 3} ${tcp_portmon 32768 61000 rhost 3}\n" 
         .. "    `- ${tcp_portmon 32768 61000 rservice 4} ${tcp_portmon 32768 61000 rhost 4}\n" 
         .. "    `- ${tcp_portmon 32768 61000 rservice 5} ${tcp_portmon 32768 61000 rhost 5}\n" 
         .. "    `- ${tcp_portmon 32768 61000 rservice 6} ${tcp_portmon 32768 61000 rhost 6}\n" 
         .. "    `- ${tcp_portmon 32768 61000 rservice 7} ${tcp_portmon 32768 61000 rhost 7}\n" 
         .. "    `- ${tcp_portmon 32768 61000 rservice 8} ${tcp_portmon 32768 61000 rhost 8}\n" 
         .. "  `- LOCAL \n"
         .. "  `- ${tcp_portmon 1 32767 rhost 0} ${tcp_portmon 1 32767 lservice 0}\n"
         .. "  `- ${tcp_portmon 1 32767 rhost 1} ${tcp_portmon 1 32767 lservice 1}\n" 
         .. "  `- ${tcp_portmon 1 32767 rhost 2} ${tcp_portmon 1 32767 lservice 2}\n" 
         .. "\n\n\n"
         .. "${if_running apache2}ON ${else}OFF${endif} apache\n"
         .. "${if_running dnsmasq}ON ${else}OFF${endif} dnsmasq\n"
         .. "${if_running mysqld}ON ${else}OFF${endif} mysql\n"
         .. "${if_running nginx}ON ${else}OFF${endif} nginx\n\n"
         .. "${if_existing /tmp/google_drive_backup_sync/backup_details.txt}${head /tmp/google_drive_backup_sync/backup_details.txt 1}${else}No backup details${endif}"
        )
    , 15, 15)

    text(
        shell("w") .. "\n"
     .. shell("df -h | mawk '{print $5 \"\t\" $2 \"\t\" $4 \"\t\" $6}' | sort -g | expand")
    , 15, 560)
end


function conky_main()
    if conky_window == nil then return end

    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
    cr = cairo_create(cs)

    updates = tonumber(conky('${updates}'))
    -- print(updates)

    -- important for reading cpu% 
    -- but its generally a good idea to have these lines anyway (one less thing to cause an error)
    if updates > 5  then
        user_main()
    end -- if updates > 5

    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr = nil
end -- end main function
