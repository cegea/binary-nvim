local popup = require("plenary.popup")

local function setup(opts)
    opts = opts or {}

    vim.keymap.set("n", "<Leader>h", function()
        if opts.name then
            print("hello, " .. opts.name)
        else
            print("hello")
        end
    end)

    vim.keymap.set("v", "<C-j>", function()

        -- Get text selected in visual mode
        local start_pos = vim.fn.getpos("v") -- Inicio de la selección
        local end_pos = vim.fn.getpos(".")   -- Fin de la selección

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
            print("it works")
        end
        show_popup(tbl, cb)

        -- Send esc to leave visual mode
        local esc = vim.api.nvim_replace_termcodes('<esc>', true, false, true)
        vim.api.nvim_feedkeys(esc, 'x', false)
    end)

    local Win_id

    function show_popup(opts, cb)
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
end

return {setup = setup}

