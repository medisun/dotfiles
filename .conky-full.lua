require 'cairo'
-- require 'slnunicode' utf8.len

font_size_default  = 12.0
font_face_default  = "Monospace"
color_hex_default  = 0xffffffff
screen_width       = 1920 - 30 -- without panel
screen_height      = 1080

-- salexander-yakushev: utf8charbyte, utf8len 

-- returns the number of bytes used by the UTF-8 character at byte i in s
-- also doubles as a UTF-8 character validator   
function utf8charbytes( s, i )
   -- argument defaults
   i = i or 1
   local c = string.byte(s, i)
   
   -- determine bytes needed for character, based on RFC 3629
   if c > 0 and c <= 127 then
      -- UTF8-1
      return 1
   elseif c >= 194 and c <= 223 then
      -- UTF8-2
      local c2 = string.byte(s, i + 1)
      return 2
   elseif c >= 224 and c <= 239 then
      -- UTF8-3
      local c2 = s:byte(i + 1)
      local c3 = s:byte(i + 2)
      return 3
   elseif c >= 240 and c <= 244 then
      -- UTF8-4
      local c2 = s:byte(i + 1)
      local c3 = s:byte(i + 2)
      local c4 = s:byte(i + 3)
      return 4
   end
end

-- returns the number of characters in a UTF-8 string
function utf8len( s )
   local pos = 1
   local bytes = string.len(s)
   local len = 0
   
   while pos <= bytes and len ~= chars do
      local c = string.byte(s,pos)
      len = len + 1
      
      pos = pos + utf8charbytes(s, pos)
   end
   
   if chars ~= nil then
      return pos - 1
   end
   
   return len
end

function set_color( color )
	cairo_set_source_rgba (	cr,
							((color / 0x1000000) % 0x100) / 256.,
							((color / 0x10000) % 0x100) / 256.,
							((color / 0x100) % 0x100) / 256.,
							(color % 0x100) / 256.)
	-- cairo_set_source_rgb (cr, 0.0, 0.0, 0.0)
	-- cairo_paint_with_alpha (cr, 0.5)
end

function cp( str )
	return conky_parse("${"..str.."}")
end

function filler( text, size, sym )
	text = tostring(text) 
	n = string.len(size) - string.len(text)
	for i = 1, n do
		text = sym .. text
	end
	return text
end

function draw_text( text, x, y, color, size, font, bold, slant, cut )

 -- default color
	col = nil
	if color ~= nil then
		set_color(color)
	end

 -- default size
	if size ~= nil then	cairo_set_font_size (cr, size)
	else size = font_size_default
	end
	
 -- default font
	if font == nil then font = font_face_default
	end
	
 -- default slant
	slant = CAIRO_FONT_SLANT_NORMAL
    -- slant = CAIRO_FONT_SLANT_ITALIC
    -- slant = CAIRO_FONT_SLANT_OBLIQUE
    
  -- default bold
	if bold == true then weight = CAIRO_FONT_WEIGHT_BOLD
	else weight = CAIRO_FONT_WEIGHT_NORMAL
	end
	
	cairo_select_font_face (cr, font, slant, weight)

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
end

function draw_grid( x, y, width, height, maxTime, maxValue, minValue, color )

 -- count lines
	nv = maxTime / 10 -- every 10 sec
	nh = (maxValue - minValue) / 20 -- every 20%
	
	cairo_set_antialias(cr, CAIRO_ANTIALIAS_NONE)
	set_color(color)
	cairo_set_line_width (cr, 1)
	cairo_set_dash(cr, 2, 1, 0)
	
 -- horizontal
	for i = 0, nh do
		cairo_move_to (cr, x - 5,     y + height/nh*i)
		cairo_line_to (cr, x + width, y + height/nh*i)
		draw_text(filler(20*(nh-i)+minValue, maxValue, " "), x-26, y + height/nh*i - 10, color, 10)
	end
	cairo_stroke (cr)
	
 -- vertical
	for i = 0, nv do
		cairo_move_to (cr, x + width/nv*i, y)
		cairo_line_to (cr, x + width/nv*i, y + height + 5)
		--draw_text(10*(nv-i), x + width/nv*i-7, y + height, color, 10)
		draw_text(filler(10*(nv-i), maxTime, "0"), x + width/nv*i-6, y + height, color, 10)
	end
	cairo_stroke (cr)
	
	cairo_set_dash(cr, 0, 0, 0)
	cairo_set_antialias(cr, CAIRO_ANTIALIAS_DEFAULT)	
end

function draw_graph( var, val, x, y, width, height, maxTime, maxValue, minValue, color, colorFill )
	
	for i = 0, maxTime-1 do
		if var[i+1] == nil then var[i] = 0
		else var[i] = var[i+1]
		end
	end
	
	var[maxTime] = tonumber(val) - minValue
	
	y = y + height
	dx = width / maxTime
	dy = height / (maxValue - minValue)
	
 -- filling under curve
	if colorFill ~= nil then
		set_color(colorFill)
		
		cairo_move_to(cr, x, y)
		for i = 0, maxTime do
			cairo_line_to(cr, x + dx*i, y - var[i]*dy)
		end
		cairo_line_to(cr, x + width, y)
		cairo_close_path(cr)
		cairo_fill (cr)
		cairo_stroke (cr)
	end
	
 -- curve
 	cairo_set_line_join(cr, CAIRO_LINE_JOIN_ROUND);
	cairo_set_line_width (cr, 2)
	set_color(color)

	
	cairo_move_to(cr, x, y - var[0]*dy)
	for i = 1, maxTime do
		cairo_line_to(cr, x + dx*i, y - var[i]*dy)
	end
	cairo_stroke (cr)
	
 -- crit line
 	-- cairo_set_antialias(cr, CAIRO_ANTIALIAS_NONE)
	-- set_color(0xff7777ff)
	-- cairo_set_line_width (cr, 2)
	-- cairo_set_dash(cr, 1, 1, 0)
	-- maxVal = math.max(unpack(var))*dy
	-- cairo_move_to(cr, x, y - maxVal)
	-- cairo_line_to(cr, x + width, y - maxVal)
	-- cairo_stroke (cr)
	-- cairo_set_dash(cr, 0, 0, 0)
	-- cairo_set_antialias(cr, CAIRO_ANTIALIAS_DEFAULT)
	
 -- current value
	-- draw_text(cp("cpu cpu0"), x + width+2, y + height )
end

function draw_line( x, y, length, width, color )
	-- cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND)
	cairo_set_line_width (cr, width)
	set_color(color)
	y = y+width/2
	cairo_move_to(cr, x, y)
	cairo_line_to(cr, x+length, y)
	cairo_stroke(cr)
end

function draw_bar( val, max, x, y, w, h, color, colorBg )

	cairo_set_line_width (cr, h)
	y = y+h/2
	xm = x+val/max*w

	set_color(colorBg)
	cairo_move_to(cr, xm, y)
	cairo_line_to(cr, x+w, y)
	cairo_stroke(cr)

	set_color(color)
	cairo_move_to(cr, x, y)
	cairo_line_to(cr, xm, y)
	cairo_stroke(cr)
end

function draw_arc( val, max, min, x, y, width, radius, angle1, angle2, color, colorBg )
	angle1 = angle1 * 3.14 / 180
	angle2 = angle2 * 3.14 / 180
	angle = val / (max - min)* (angle2 - angle1) + angle1

	cairo_set_line_width(cr, width)

	set_color(colorBg)
	cairo_arc(cr, x, y, radius, angle, angle2)
	cairo_stroke(cr)

	set_color(color)
	cairo_arc(cr, x, y, radius, angle1, angle)
	cairo_stroke(cr)
end

function conky_main()

 -- create surface
	if conky_window == nil then return end
	local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
	cr = cairo_create(cs)

 -- set defaults
	set_color(color_hex_default)
	cairo_set_font_size    (cr, font_size_default)
	cairo_select_font_face (cr, font_face_default, CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
	
	updates=tonumber(conky_parse('${updates}'))
	
 -- debug to see changes in terminal
	-- print(updates)

	if updates == 1 then
		cpu1  = {}
		cpu2  = {}
		mem   = {}
		swap  = {}
		temp1 = {}
		temp2 = {}
	end

	if updates > 5 then
	    -- Left area
		cairo_rectangle(cr, 1, 5, 630, screen_height)
		set_color(0x22222288)
		cairo_fill(cr)
		cairo_stroke(cr)
		draw_text(cp('exec pstree -l'), 5, 5, color_hex_default, 10.5)
		
		-- Draw line
		-- cairo_set_line_width(cr, 1)
		-- set_color(0xaaaaaaaa)
		-- cairo_set_antialias(cr, CAIRO_ANTIALIAS_NONE)
		-- cairo_move_to(cr, screen_width-240, 5)
		-- cairo_line_to(cr, screen_width-240, screen_height+5)
		-- cairo_stroke(cr)
		-- cairo_set_antialias(cr, CAIRO_ANTIALIAS_DEFAULT)

        -- Middle area
		cairo_rectangle(cr, 632, 5, 463, screen_height)
		set_color(0x22222288)
		cairo_fill(cr)
		cairo_stroke(cr)
		
		draw_text(cp("addr eth0"), 1000, 5, color_hex_default)
		draw_text(cp("uptime"), 640, 5)
		draw_text(cp("loadavg"), 800, 5, nil, 11)
		
		-- TOP CPU USAGE
		draw_text(cp("pid_parent ${top pid 1}")..":"..cp("pid_cmdline ${top pid 1}"), 640, 30, color_hex_default, 10, nil, nil, nil, 75)
		draw_text("1: "..cp("top cpu 1} ${top pid 1} ${top name 1} ${top time 1").."\n"..
				  "3: "..cp("top cpu 2} ${top pid 2} ${top name 2} ${top time 2").."\n"..
				  "3: "..cp("top cpu 3} ${top pid 3} ${top name 3} ${top time 3").."\n"..
				  "4: "..cp("top cpu 4} ${top pid 4} ${top name 4} ${top time 4").."\n"..
				  "5: "..cp("top cpu 5} ${top pid 5} ${top name 5} ${top time 5"),
			645, 45, nil, 10)
		
		-- TOP MEM USAGE
		draw_text(cp("pid_parent ${top_mem pid 1}")..":"..cp("pid_cmdline ${top_mem pid 1}"), 640, 115, nil, 10, nil, nil, nil, 75)
		draw_text("M 1: "..cp("top_mem pid 1} ${top_mem name 1} ${top_mem mem 1} ${top_mem mem_res 1").."\n"..
				  "E 2: "..cp("top_mem pid 2} ${top_mem name 2} ${top_mem mem 2} ${top_mem mem_res 2").."\n"..
				  "M 3: "..cp("top_mem pid 3} ${top_mem name 3} ${top_mem mem 3} ${top_mem mem_res 3").."\n"..
				  "  4: "..cp("top_mem pid 4} ${top_mem name 4} ${top_mem mem 4} ${top_mem mem_res 4"),
			645, 130, nil, 11)
			
		-- TOP IO USAGE
		draw_text(cp("pid_parent ${top_io pid 1}")..":"..cp("pid_cmdline ${top_io pid 1}"), 640, 190, nil, 10, nil, nil, nil, 75)
		draw_text("I 1: "..conky_parse("${top_io pid 1} ${top_io name 1} ${top_io io_perc 1} ${top_io io_read 1} ${top_io io_write 1}").."\n"..
				  "O 2: "..conky_parse("${top_io pid 2} ${top_io name 2} ${top_io io_perc 2} ${top_io io_read 2} ${top_io io_write 2}").."\n"..
				  "  3: "..conky_parse("${top_io pid 3} ${top_io name 3} ${top_io io_perc 3} ${top_io io_read 3} ${top_io io_write 3}"),
			645, 204, nil, 11)
			
		-- TOP CPU TIME USAGE
		-- draw_text("T 1: "..cp("top_time pid 1} ${top_time name 1} ${top_time time 1").."\n"..
		--		  "I 2: "..cp("top_time pid 2} ${top_time name 2} ${top_time time 2").."\n"..
		--		  "M 3: "..cp("top_time pid 3} ${top_time name 3} ${top_time time 3").."\n"..
		--		  "E 4: "..cp("top_time pid 4} ${top_time name 4} ${top_time time 4"),
		--	645, 275, nil, 11)

		-- draw_text(cp("pid_openfiles ${top_io pid 1}"), 633, 435, color_hex_default, 11)
		draw_text(cp("exec df -h | mawk '{print $5 \"\t\" $2 \"\t\" $4 \"\t\" $6}' | sort -g | expand"), 645, 270, color_hex_default, 11)
		-- draw_text(" __construct()\n __destruct()\n __call()\n __callStatic()\n __get()\n __set()\n __isset()\n __unset()\n __sleep()\n __wakeup()\n __toString()\n __invoke()\n __set_state()\n __clone()", 645, 490, color_hex_default, 11)
		
		-- draw_text(cp('exec top -n1 > /tmp/topn1.txt; cat /tmp/topn1.txt'), 50, 50)
		-- draw_text(cp('exec service --status-all | grep "+"'), 750, 350)
		
		-- Right area
		cairo_rectangle(cr, 1096, 5, 240, screen_height)
		set_color(0x22222288)
		cairo_fill(cr)
		cairo_stroke(cr)
				
		-- draw_text(cp("user_times"), 800, 535, color_hex_default)
		-- draw_text(cp("exec cal"), 1150, 586, nil, 11)
		-- draw_text("Keep Dreaming!", 910, 140, nil, 17, "Droid Lover Expanded")
		-- draw_text("The Way Of Purity", 910, 160, nil, 14, "Courier New")
		-- draw_text("Видишь крякозябру -\n  - бей её кодировкой", 960, 216, nil, 12, "Arial")
		
		-- x = 1190; y = 410
		-- draw_text("part /\n"..cp("fs_free /"), x-5, y-16, color_hex_default, 11)
 		-- draw_arc(cp("fs_used_perc /"), 100, 0, x, y, 20, 30, 150, 230, 0x00000044, 0xffffaa77)

		-- draw_bar(65, 100, 150, 200, 155, 10, 0x00000077, 0x00ff0077)


		x = 1255; y = 370
		draw_text("Apache "..cp("if_running apache2}ON${else}OFF${endif"), x+12, y+4, color_hex_default)
		
		y = y+15
		draw_text("Mysqld "..cp("if_running mysqld}ON${else}OFF${endif"), x+12, y+4)

		draw_text(cp("time %H : %M : %S %n%a %e %B %G"), x-50, y+50, color_hex_default, 15, "Droid Lover Expanded", true)

	 --[[ CPU graph ]]--

		x = 1150;       y = 45
		maxTime  = 60;

		width  = 160;  height = 90
		curcpu1 = cp("cpu cpu0")
		curcpu2 = cp("cpu cpu1")
		draw_grid(x, y, width, height, maxTime, 100, 0, color_hex_default)
		draw_graph(cpu1, curcpu1, x, y, width, height, maxTime, 100, 0, 0x8888ffff)
		draw_graph(cpu2, curcpu2, x, y, width, height, maxTime, 100, 0, 0xffff11ff)
		
		draw_text(filler(curcpu1, "00", "0"), x+20, y-40, color_hex_default, 26, "Droid Lover Expanded")
		draw_text(filler(curcpu2, "00", "0"), x+70, y-40, nil, 26, "Droid Lover Expanded")
	

		--[[ CPU temperature graph]]--
		x = 1150;       y = 175
		width  = 160;  height = 50
		curtemp1 = cp("exec sensors | grep 'Core 0' | cut -c18-19")
		curtemp2 = cp("exec sensors | grep 'Core 1' | cut -c18-19")

		draw_grid(x, y, width, height, maxTime, 80, 20, color_hex_default)
		draw_graph(temp1, curtemp1, x, y, width, height, maxTime, 80, 20, color_hex_default, 0x00000022)
		draw_graph(temp2, curtemp2, x, y, width, height, maxTime, 80, 20, 0xffff11ff)

		draw_text(curtemp1.."°C", x+10, y-30, color_hex_default, 18, "Droid Lover Expanded")
		draw_text(curtemp2.."°C", x+90, y-30, nil, 18, "Droid Lover Expanded")


	--[[ MEM graph ]]--

		x = 1150;       y = 280
		width  = 160;  height = 70
		maxTime  = 60; maxValue = 100

		draw_grid(x, y, width, height, maxTime, maxValue, 0, color_hex_default)
		draw_graph(swap, cp("swapperc"), x, y, width, height, maxTime, maxValue, 0, 0xaaaaffff)
		draw_graph(mem,  cp("memperc"),  x, y, width, height, maxTime, maxValue, 0, 0xffff11ff)
		
		draw_text(cp("mem"),  x+20, y-40,    color_hex_default, 18, "Droid Lover Expanded")
		draw_text(cp("swap"), x+20, y-25, nil,               13, "Droid Lover Expanded")
		



	 --[[ Player ]]--

		x = 1120; y = screen_height-80;

		artist = cp("if_running deadbeef-main}${exec deadbeef --nowplaying '%l %a'}${else}DeadBeef${endif")
		title  = cp("if_running deadbeef-main}${exec deadbeef --nowplaying '%e %t'}${else}not running${endif")
		
		-- wa = utf8len(artist) * 8  -- 8 - width of 1 symbol
		-- wt = utf8len(title) * 7  -- 7 - width of 1 symbol, 24 - margin
		-- if wa > wt then w = wa else w = wt end
		--[[ Background ]]
		--draw_line(x, y, w+24, 40, colorBg)
		--[[ Background with round corners
		set_color(0x00000077)
		cairo_set_line_join(cr, CAIRO_LINE_JOIN_ROUND)
		cairo_set_line_width(cr, 20)
		cairo_rectangle(cr, x, y+8, w, 20)
		cairo_stroke(cr)
		]]--
		draw_text(artist, x, y,  nil, 13, nil, true)
		draw_text(title,  x, y+15, nil, 11)

	end 
	
 -- destroy surface
	cairo_destroy(cr)
	cairo_surface_destroy(cs)
	cr = nil
end -- main

-- cpu
-- mem
-- io
-- fs
-- note
-- deadbeef
	
-- NB: color = hex2rgba(color) - not work: variable got only 1 number
-- TODO: graphics which show interval of values [min..max]
-- TODO: hex2rgba -> set_color()
-- TODO: right alignment in draw_text()
-- cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND)
-- графики трацеции
-- область увеличения в графиках
-- математические фичи для обработки выборки данных с графиков
-- круглая насадка у графиков
