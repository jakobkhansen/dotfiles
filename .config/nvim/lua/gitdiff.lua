local git_diff_buf = nil
local git_diff_win = nil
local git_diff_left_buf = nil

vim.api.nvim_create_user_command("GitDiffHead", function()
    local file = vim.api.nvim_buf_get_name(0)

    if file == "" then
        vim.notify("No file", vim.log.levels.ERROR)
        return
    end

    git_diff_left_buf = vim.api.nvim_get_current_buf()

    -- Find Git root
    local root_result = vim.system({
        "git", "-C", vim.fn.fnamemodify(file, ":h"),
        "rev-parse", "--show-toplevel",
    }, { text = true }):wait()

    if root_result.code ~= 0 then
        vim.notify(root_result.stderr, vim.log.levels.ERROR)
        return
    end

    local root = root_result.stdout:gsub("%s+$", "")

    -- Get repo-relative path
    local abs_file = vim.fn.fnamemodify(file, ":p")
    local abs_root = vim.fn.fnamemodify(root, ":p")

    local rel = abs_file:sub(#abs_root + 1)
        :gsub("^[/\\]", "")
        :gsub("\\", "/")

    -- Create right-side split
    vim.cmd("rightbelow vsplit")

    git_diff_win = vim.api.nvim_get_current_win()
    git_diff_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(git_diff_win, git_diff_buf)

    -- Get HEAD version
    local result = vim.system({
        "git", "-C", root,
        "show", "HEAD:" .. rel,
    }, { text = true }):wait()

    if result.code ~= 0 then
        vim.api.nvim_win_close(git_diff_win, true)
        git_diff_win = nil
        git_diff_buf = nil
        vim.notify(result.stderr, vim.log.levels.ERROR)
        return
    end

    vim.api.nvim_buf_set_lines(
        git_diff_buf,
        0,
        -1,
        false,
        vim.split(result.stdout, "\n", { trimempty = false })
    )

    vim.bo[git_diff_buf].buftype = "nofile"
    vim.bo[git_diff_buf].bufhidden = "wipe"
    vim.bo[git_diff_buf].modifiable = false
    vim.bo[git_diff_buf].readonly = true

    -- Diff HEAD on right
    vim.cmd("diffthis")

    -- Go back to the original buffer on the left
    vim.cmd("wincmd p")
    vim.cmd("diffthis")
end, {})


-- Close the HEAD pane when the LEFT buffer changes.
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(args)
        if not git_diff_buf or not git_diff_win then
            return
        end

        -- Ignore entering the scratch/HEAD buffer.
        if args.buf == git_diff_buf then
            return
        end

        -- Still on the original left buffer.
        if args.buf == git_diff_left_buf then
            return
        end

        -- Left side changed to another buffer -> close Git pane.
        if vim.api.nvim_win_is_valid(git_diff_win) then
            vim.api.nvim_win_close(git_diff_win, true)
        end

        git_diff_win = nil
        git_diff_buf = nil
        git_diff_left_buf = nil
    end,
})
