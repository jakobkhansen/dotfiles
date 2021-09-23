vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = {
          severity_limit = "Error",
      },

      signs = true,

      update_in_insert = false,
  }
)

--local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }

--for type, icon in pairs(signs) do
  --local hl = "LspDiagnosticsSign" .. type
  --vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
--end
