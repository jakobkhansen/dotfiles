require("journal").setup()



-- Jekyll setup
-- local template = [[
--     ---
--     layout: post
--     title: "%s"
--     categories: Blog
--     ---
--     ]]
-- require("journal").setup({
--     root = '~/Documents/blog/_posts', -- Replace with your blog path
--     journal = {
--         format = '%Y/%m/%Y-%m-%d-post',
--         frequency = { day = 1 },
--         template = function()
--             local title = nil
--             vim.ui.input({ prompt = 'Title: ' }, function(input) title = input end)
--             return string.format("# %%Y %%B %%d: %s", title)
--         end
--     }
-- })
