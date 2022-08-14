function get_screen()
    local raw_text = memory.readbyterange(RAM_TEXT, 360)
    local raw_attr = {}
    if RAM_ATTR ~= nil then
        raw_attr = memory.readbyterange(RAM_ATTR, 360)
    end
    local lines = {}
    local tile_lines = {}
    local attr_lines = {}
    local line = ""
    local tile_line = ""
    local attr_line = ""
    local menu_position = nil
    local text_over_menu = false
    local line_number = 0
    local printable = is_printable_screen()
    for i = 1, 360, 20 do
        line_number = line_number + 1
        for j = 0, 19 do
            local char = raw_text[i + j]
            local attr = 0
            if RAM_ATTR ~= nil and AND(raw_attr[i + j], 0x08) ~= 0 then
                attr = 1
            end
            tile_line = tile_line .. string.char(char)
            attr_line = attr_line .. string.char(attr)
            if attr == 0 then
                if char == 0xed or char == 0xeb then
                    menu_position = { ((i - 1) / 20) + 1, j + 1 }
                elseif char == 0xec then
                    text_over_menu = true
                end
                if i + j == SCROLL_INDICATOR_POSITION and char == 0xee then
                    char = 0x7f
                elseif i + j == 339 and char == 0xee then
                    char = 0x7f
                end
            end
            if printable then
                local wchar = char + SHIFT(attr, -8)
                if cache_tb == nil then
                    char = translate(char)
                elseif wchar >= 0xe8 and wchar <= 0xff or wchar <= 0x7f then
                    char = translate(wchar)
                elseif cache_tb[wchar] then
                    char = translate(cache_tb[wchar])
                else
                    char = ""
                end
            else
                char = " "
            end
            line = line .. char
        end
        table.insert(lines, line)
        table.insert(tile_lines, tile_line)
        table.insert(attr_lines, attr_line)
        line = ""
        tile_line = ""
        attr_line = ""
    end -- i
    -- mart fix
    if menu_position == nil then
        if tile_lines[11]:match("\x7c\xf1") then
            local mart_pos = tile_lines[11]:find("\x7c\xf1") + 1
            if attr_lines[11][mart_pos] == 0 then
                menu_position = { 11, mart_pos }
            end
        end
    end
    return { lines = lines, menu_position = menu_position, text_over_menu = text_over_menu, tile_lines = tile_lines,
        attr_lines = attr_lines,
        keyboard_showing = keyboard_showing,
        get_textbox = get_textbox }
end


function generate_menu_header()
    local screen = get_screen()
    local results = {}
    local tile_lines = screen.tile_lines
    local attr_lines = screen.attr_lines
    results.start_y = 1
    results.start_x = 1
    results.end_y = 18
    results.end_x = 20
    results.has_left_border = false
    results.has_right_border = false
    local y = screen.menu_position[LINE]
    local x = screen.menu_position[COLUMN]
    local byte = tile_lines[y]:sub(x, x):byte() + SHIFT(attr_lines[y]:sub(x, x):byte(), -8)
    while x > 1 and byte ~= 0x7c do
        x = x - 1
        byte = tile_lines[y]:sub(x, x):byte() + SHIFT(attr_lines[y]:sub(x, x):byte(), -8)
    end
    if byte == 0x7c then
        results.has_left_border = true
        while y > 1 and byte ~= 0x79 and byte ~= 0x7a do
            y = y - 1
            byte = tile_lines[y]:sub(x, x):byte() + SHIFT(attr_lines[y]:sub(x, x):byte(), -8)
        end
        if byte == 0x79 or byte == 0x7a then
            results.start_y = y
            results.start_x = x
        end
    end
    y = screen.menu_position[LINE]
    x = screen.menu_position[COLUMN]
    byte = tile_lines[y]:sub(x, x):byte() + SHIFT(attr_lines[y]:sub(x, x):byte(), -8)
    while x < 20 and byte ~= 0x7c do
        x = x + 1
        byte = tile_lines[y]:sub(x, x):byte() + SHIFT(attr_lines[y]:sub(x, x):byte(), -8)
    end
    if byte == 0x7c then
        results.has_right_border = true
        while y < 18 and byte ~= 0x7e and byte ~= 0x7a do
            y = y + 1
            byte = tile_lines[y]:sub(x, x):byte() + SHIFT(attr_lines[y]:sub(x, x):byte(), -8)
        end
        if byte == 0x7e or byte == 0x7a then
            results.end_y = y
            results.end_x = x
        end
    end
    return results
end

function read_menu_item()
    local results = generate_menu_header()
    -- we use tile_lines and not lines because of character encoding variable length
    -- however starting and ending  bytes should be removed if menu has lateral borders
    local startpos = results.start_x
    local endpos = results.end_x
    if results.has_left_border then
        startpos = startpos + 1
    end
    if results.has_right_border then
        endpos = endpos - 1
    end
    -- Battle menu fix
    if screen.tile_lines[3]:match(HEALTH_BAR) then
        local correctpos = nil
        if screen.tile_lines[15]:match("\xe1\xe2\x7f") then
            correctpos = screen.tile_lines[15]:find("\xe1\xe2\x7f") - 1
        elseif screen.tile_lines[15]:match("\xf1") then
            correctpos = 14
        end
        if correctpos ~= nil then
            if screen.menu_position[COLUMN] < correctpos then
                endpos = correctpos
            else
                startpos = correctpos
            end
        end
    end
    audio.play(scriptpath .. "sounds\\gb\\menusel.wav", 0,
        (200 * (screen.menu_position[LINE] - 1) / #screen.tile_lines) - 100, 30)
    local tile_line = get_menu_item(screen.tile_lines[screen.menu_position[LINE]], startpos, endpos)
    local attr_line = get_menu_item(screen.attr_lines[screen.menu_position[LINE]], startpos, endpos)
    -- Choose Pokémon menu fix
    if screen.menu_position[LINE] > results.start_y then
        local add_tileline = get_menu_item(screen.tile_lines[screen.menu_position[LINE] - 1], startpos, endpos)
        local add_attrline = get_menu_item(screen.attr_lines[screen.menu_position[LINE] - 1], startpos, endpos)
        if add_tileline:match("\x6e") and
            get_menu_item(screen.tile_lines[results.start_y], startpos, endpos):match("\x6e") then
            tolk.output(translate_tileline(add_tileline, add_attrline))
        end
    end
    tolk.output(translate_tileline(tile_line, attr_line))
    -- Items and PC menu fix
    if screen.menu_position[LINE] < results.end_y then
        local add_tileline = get_menu_item(screen.tile_lines[screen.menu_position[LINE] + 1], startpos, endpos)
        local add_attrline = get_menu_item(screen.attr_lines[screen.menu_position[LINE] + 1], startpos, endpos)
        if (add_tileline:match("\xf1"))
            or (add_tileline:match("\xf0"))
            or
            (
            add_tileline:match("\x6e") and
                not get_menu_item(screen.tile_lines[results.start_y], startpos, endpos):match("\x6e"))
            or (add_tileline:match("\x9c"))
            or (add_tileline:match("\x9e") and add_tileline:match("\x9f")) then
            tolk.output(translate_tileline(add_tileline, add_attrline))
        end
    end
end

cache_tb = { }

function cache_cn_hook()
    if memory.readbyte(HRAM_ROM_BANK) ~= 0x1 then
        return
    end
    local hl = memory.getregister("hl")
    local de = memory.getregister("de")
    local bc = memory.getregister("bc")
    local tileno = SHIFT((hl - 0xd300), 1)
    if tileno < 0x80 then tileno = tileno + 0x180 end

    -- print(string.format("%04x %04x %04x",hl, de, bc))
    -- print(string.format("%04x",tileno))
    cache_tb[tileno] = -1
    if bc <= 0x2eff then
        -- print(string.format("ccn %04x = %04x",tileno + 1, bc))
        cache_tb[tileno + 1] = bc
    elseif de <= 0x2eff then
        -- print(string.format("ccn %04x = %04x",tileno + 1, de))
        cache_tb[tileno + 1] = de
    else
        cache_tb[tileno + 1] = -1
    end
end

function cache_en_hook()
    if memory.readbyte(HRAM_ROM_BANK) ~= 0x1 then
        return
    end
    local hl = memory.getregister("hl")
    local b = memory.getregister("b")
    local tileno = SHIFT((hl - 0xd300), 1)
    if tileno < 0x80 then tileno = tileno + 0x180 end
    cache_tb[tileno] = b
    -- print(string.format("cen %04x = %04x",tileno, b))
end

function cache_cl_hook()
    -- print("ccl")
    cache_tb = { }
end

function extra_hook()
    memory.registerexec(0x7aae, cache_cn_hook)
    memory.registerexec(0x7b12, cache_en_hook)
    memory.registerexec(0x7b2a, cache_en_hook)
    memory.registerexec(0x781b, cache_cl_hook)
end

-- function translate(char)
--     if char >= 0xe8 and char <= 0xff then
--         return chars[char]
--     elseif cache_tb[char] then
--         if chars[cache_tb[char]] then
--             return chars[cache_tb[char]]
--         else
--             return " "
--         end
--     else
--         return " "
--     end
-- end

function translate_tileline(tileline, attrline)
    local l = ""
    local wchar
    if is_printable_screen() then
        if attrline == nil then
            for i = 1, #tileline do
                l = l .. translate(tileline:sub(i, i):byte())
            end
        else
            for i = 1, #tileline do
                wchar = tileline:sub(i, i):byte() + SHIFT(attrline:sub(i, i):byte(), -8)
                if wchar >= 0xe8 and wchar <= 0xff or wchar <= 0x7f then
                    l = l .. translate(wchar)
                elseif cache_tb[wchar]  then
                    -- print(string.format("int %04x %04x", wchar, cache_tb[wchar]))
                    l = l .. translate(cache_tb[wchar])
                -- else
                --     print(string.format("unk %04x", wchar))
                end
            end
        end
    end
    return l
end


function is_printable_screen()
    local s = ""
    for i = 0, 15 do
        s = s .. string.char(memory.readbyte(RAM_SCREEN + 0x7f0 + i))
    end
    if fonts_9[s] then
        return true
    else
        return false
    end
end

function get_custom_name(name_offset)
    local name = ""
    local i = 0
    local charh = -1
    local char = memory.readbyte(name_offset + i)
    while char ~= CHAR_NAME_END do
        if char <= 0x2e and charh == -1 then
            charh = char
        elseif charh ~= -1 then
            name = name .. translate(char + SHIFT(charh, -8))
            charh = -1
        else
            name = name .. translate(char)
        end
        i = i + 1
        char = memory.readbyte(name_offset + i)
    end
    return name
end

function read_special_variable_text()
    -- hour set fix
    if screen.tile_lines[8]:find("\x7a\x01\x7a") then
        tolk.output(translate_tileline(screen.tile_lines[10], screen.attr_lines[10]))
    end
    -- day set fix
    if screen.tile_lines[8]:find("\x7a\xef\x7a") then
        tolk.output(translate_tileline(screen.tile_lines[10], screen.attr_lines[10]))
    end
    -- Fly destination fix
    if screen.tile_lines[2]:find("\x7f\x34\x16") then
        tolk.output(translate_tileline(screen.tile_lines[2], screen.attr_lines[2]))
    end
    -- pc boxes fix
    local textbox_top, textbox_bottom = get_textbox_border(8)
    if screen.menu_position == nil
        and screen.tile_lines[1]:find(textbox_top)
        and screen.tile_lines[4]:find(textbox_bottom)
        and screen.tile_lines[14]:find(textbox_bottom) then
        local result = trim(translate_tileline(get_menu_item(screen.tile_lines[13], 1, 9), get_menu_item(screen.attr_lines[13], 1, 9)) ..
            translate_tileline(get_menu_item(screen.tile_lines[11], 1, 9), get_menu_item(screen.attr_lines[11], 1, 9)))
        local i = 14
        while result == "" do
            result = trim(translate_tileline(get_menu_item(screen.tile_lines[i], 10, 20), get_menu_item(screen.attr_lines[i], 10, 20)))
            i = i - 1
        end
        tolk.output(result)
    end
end

MAPNAME_PATTERN_CN = "\x61\x63\x63\x62\x62\x63\x63\x62\x62\x63\x63\x62\x62\x63\x63\x62\x62\x63\x63\x64"
function read_mapname_if_needed()
    if screen.tile_lines[1] == MAPNAME_PATTERN_CN then
        tolk.output(translate_tileline(screen.tile_lines[3], screen.attr_lines[3]))
    end
end

