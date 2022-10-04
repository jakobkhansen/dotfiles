local keymap = vim.api.nvim_set_keymap

local P = {}

function P.smoothScroll(lines, scroll_cursor, interval)
    interval = interval or 10
    scroll_cursor = scroll_cursor or false
    local timer = vim.loop.new_timer()
    local num_lines = math.abs(lines)
    local direction = lines / math.abs(lines)
    local scroll_command
    if scroll_cursor then
        local down = vim.o.wrap and "gj" or "j"
        local up = vim.o.wrap and "gk" or "k"
        scroll_command = (direction == 1) and "\\<c-e>" .. down or "\\<c-y>" .. up
    else
        scroll_command = (direction == 1) and "\\<c-e>" or "\\<c-y>"
    end

    local timesRan = 0
    timer:start(
        0,
        interval,
        vim.schedule_wrap(function()
            vim.cmd('execute "normal! ' .. scroll_command .. '"')
            timesRan = timesRan + 1
            if timesRan >= num_lines then
                timer:stop()
            end
        end)
    )
end

function P.smoothScrollCenterCursor()
    local window_height = vim.api.nvim_win_get_height(0)
    local delta = vim.fn.winline() - math.ceil(window_height / 2)
    P.smoothScroll(delta)
end

function P.smoothScrollBottomCursor()
    local window_height = vim.api.nvim_win_get_height(0)
    local delta = -(math.ceil(window_height) - vim.fn.winline() - vim.o.scrolloff)
    P.smoothScroll(delta, false, 10)
end

function P.smoothScrollTopCursor()
    local delta = (vim.fn.winline() - vim.o.scrolloff)
    P.smoothScroll(delta, false, 10)
end

-- Smooth scroll
keymap("", "<C-d>", "", {
    callback = function()
        P.smoothScroll(vim.o.scroll, true)
    end,
    noremap = true,
})
keymap("", "<C-u>", "", {
    callback = function()
        P.smoothScroll(-vim.o.scroll, true)
    end,
    noremap = true,
})

keymap("", "zz", "", {
    callback = function()
        P.smoothScrollCenterCursor()
    end,
    noremap = true,
})
keymap("", "zb", "", {
    callback = function()
        P.smoothScrollBottomCursor()
    end,
    noremap = true,
})
keymap("", "zt", "", {
    callback = function()
        P.smoothScrollTopCursor()
    end,
    noremap = true,
})

return P
