local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")

local util = lspconfig.util
local sysname = vim.loop.os_uname().sysname
local autocmd = vim.api.nvim_create_autocmd

local command = vim.api.nvim_command

-- Sets filetype to ccdetect
autocmd("BufRead,BufNewFile", {
    pattern = { "*.ccdetect" },
    command = "setlocal ft=ccdetect",
})

local JAVA_HOME = os.getenv("JAVA_HOME")

local function get_java_executable()
    local executable = JAVA_HOME and util.path.join(JAVA_HOME, "bin", "java") or "java"

    return sysname:match("Windows") and executable .. ".exe" or executable
end

local jar = vim.env.HOME .. "/Documents/Dev/LSP/CCDetect-lsp/app/build/libs/app-all.jar"

local cmd = { get_java_executable(), "-Xmx8G", "-jar", jar }

local function on_show_document(err, result, ctx, config, params)
    local uri = result.uri
    command("e +" .. result.selection.start.line + 1 .. " " .. uri)

    return result
end

configs["ccdetect"] = {
    default_config = {
        cmd = cmd,
        filetypes = { "java" },
        root_dir = function(fname)
            return util.root_pattern(".git")(fname)
        end,
        handlers = {
            ["window/showDocument"] = on_show_document,
        },
        init_options = {
            language = "java",
            fragment_query = "(method_declaration) @method",
            clone_token_threshold = 75,
            extra_nodes = {},
            ignore_nodes = {},
        },
        -- init_options = {
        --     language = "c",
        --     fragment_query = "(function_definition) @method",
        --     clone_token_threshold = 75,
        --     ignore_nodes = { "comment" },
        --     extra_nodes = { "string_literal" },
        -- },
    },
}

lspconfig["ccdetect"].setup({})
