local M = {}
-------------------------------------------------
---------------- popup functions ----------------
-------------------------------------------------
local Win_id

function show_popup(opts, cb)
    local popup = require("plenary.popup")
    local height = 10
    local width = 20
    local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

    Win_id = popup.create(opts, {
        title = "Binary",
        highlight = "BinaryWindow",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
        callback = cb,
    })
    local bufnr = vim.api.nvim_win_get_buf(Win_id)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>lua close_popup()<CR>", { silent=false })
end

function close_popup()
    vim.api.nvim_win_close(Win_id, true)
end

-------------------------------------------------
---------------- plugin functions ---------------
-------------------------------------------------
function _hex_char_to_bin(hex)
    local hex_to_bin_map = {
        ['0'] = "0000 ", ['1'] = "0001 ", ['2'] = "0010 ", ['3'] = "0011 ",
        ['4'] = "0100 ", ['5'] = "0101 ", ['6'] = "0110 ", ['7'] = "0111 ",
        ['8'] = "1000 ", ['9'] = "1001 ", ['A'] = "1010 ", ['a'] = "1010 ",
        ['B'] = "1011 ", ['b'] = "1011 ", ['C'] = "1100 ", ['c'] = "1100 ",
        ['D'] = "1101 ", ['d'] = "1101 ", ['E'] = "1110 ", ['e'] = "1110 ",
        ['F'] = "1111 ", ['f'] = "1111 "
    }

    return hex_to_bin_map[hex] or "INVALID_VALUE"
end

function _hex_char_to_dec(hex)
    local hex_to_bin_map = {
        ['0'] = 0,  ['1'] = 1,  ['2'] = 2,  ['3'] = 3,
        ['4'] = 4,  ['5'] = 5,  ['6'] = 6,  ['7'] = 7,
        ['8'] = 8,  ['9'] = 9,  ['A'] = 10, ['a'] = 10,
        ['B'] = 11, ['b'] = 11, ['C'] = 12, ['c'] = 12,
        ['D'] = 13, ['d'] = 13, ['E'] = 14, ['e'] = 14,
        ['F'] = 15, ['f'] = 15
    }

    return hex_to_bin_map[hex] or "INVALID_VALUE"
end

-- Function to convert a hexadecimal string to its binary representation
function _hex_to_bin(hex)
    if hex == nil or #hex == 0 then
        return "INVALID_VALUE"
    end

    for _,v in pairs(hex) do
       if vim.fn.str2nr(v) > 9 then
            
        end 
    end

    -- Check if the string starts with "0x" or "0X" and remove it
    if hex:sub(1, 2):lower() == "0x" then
        hex = hex:sub(3) -- Discard the first two characters
    end

    local bin = {}

    for i = 1, #hex do
        local char = hex:sub(i, i)
        local bin_value = _hex_char_to_bin(char)
        if bin_value == "INVALID_VALUE" then
            return "INVALID_VALUE"
        end
        table.insert(bin, bin_value)
    end

    return table.concat(bin)
end

function _hex_to_dec(hex)
    if hex == nil or #hex == 0 then
        return "INVALID_VALUE"
    end

    -- Check if the string starts with "0x" or "0X" and remove it
    if hex:sub(1, 2):lower() == "0x" then
        hex = hex:sub(3) -- Discard the first two characters
    end

    local dec = {}
    local decimal = 0

    for i = 1, #hex do
        local char = hex:sub(i, i)
        local dec_value = _hex_char_to_dec(char)
        if dec_value == "INVALID_VALUE" then
            return "INVALID_VALUE"
        end

        -- Calculate the positional value using bit shifts
        local position = #hex - i -- Position from the right (0-based)
        decimal = decimal + dec_value * (16 ^ position) -- Multiply by 16^position
    end

    table.insert(dec, decimal)
    return table.concat(dec)
end

M.get_number = function(block)

    local binary_flag = true
    local digit = 0

    if block == nil or #block == 0 then
        return "INVALID_VALUE"
    end

    if block:sub(1, 2):lower() == "0x" then
        return vim.fn.str2nr(block, 16)
    else
        for _,v in pairs(block) do
            digit = vim.fn.str2nr(v)
            if digit > 9 then
                return vim.fn.str2nr(block, 16)
            elseif digit > 1 then
                binary_flag = false
            end 
        end
    end

    if binary_flag then
        return vim.fn.str2nr(block, 2)
    else
        return vim.fn.str2nr(block, 10)
    end
end

-------------------------------------------------
---------------- plugin setup -------------------
-------------------------------------------------
M.setup = function(opts)
    opts = opts or {}

    vim.keymap.set("v", "<Leader>b", function()

        -- Get text selected in visual mode
        local start_pos = vim.fn.getpos("v")
        local end_pos = vim.fn.getpos(".")

        local start_line = start_pos[2] - 1
        local start_col = start_pos[3] - 1
        local end_line = end_pos[2] - 1
        local end_col = end_pos[3]

        local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line + 1, false)
        -- Selection only possible for one line
        if #lines == 1 then
           lines[1] = string.sub(lines[1], start_col + 1, end_col)
        else
            lines[1] = "Multiple line selection not possible"
        end
        local tbl = {
            lines[1],
        }
        local cb = function(_, sel)
            if sel ~= nil and #sel > 0 then
                vim.fn.setreg('"', sel)
            end
        end
-- 0xff
        if lines[1]:sub(1, 2):lower() == "0x" then -- Hexadecimal value
            table.insert(tbl,_hex_to_bin(lines[1]))
            table.insert(tbl,_hex_to_dec(lines[1]))
        end
        show_popup(tbl, cb)

        -- Send esc to leave visual mode
        local esc = vim.api.nvim_replace_termcodes('<esc>', true, false, true)
        vim.api.nvim_feedkeys(esc, 'x', false)
    end)
end

return M

