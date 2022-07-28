local autocmd = vim.api.nvim_create_autocmd

require("null-ls").setup({
    sources = {
        require("null-ls").builtins.formatting.prettierd.with({
            extra_filetypes = {"lua"}
        }),
        require("null-ls").builtins.code_actions.gitsigns,
        require("null-ls").builtins.formatting.stylua,
    },
    on_attach = function(client, bufnr)
        autocmd({ "BufWritePre" }, { callback = function() vim.lsp.buf.formatting_sync() end, pattern = "*.tsx,*.ts,*.jsx,*.js,*.lua" })
    end
})
