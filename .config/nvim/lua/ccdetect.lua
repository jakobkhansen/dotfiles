local lspconfig = require("lspconfig")
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

local cap = vim.lsp.protocol.make_client_capabilities()
cap.workspace.didChangeWatchedFiles.dynamicRegistration = true

local function start_ccdetect()
    if vim.g.javaserveroff ~= nil then
        vim.lsp.start({
            cmd = cmd,
            name = "CCDetect",
            root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1]),
            handlers = {
                ["window/showDocument"] = on_show_document,
            },
            capabilities = cap,
            init_options = {
                language = "java",
                fragment_query = "(method_declaration) @method (constructor_declaration) @constructor",
                clone_token_threshold = 100,
                extra_nodes = {},
                ignore_nodes = {},
                dynamic_detection = false,
                update_on_save = true,
                evaluate = false,
                excludeContainedClones = true,
            },
            -- init_options = {
            --     language = "c",
            --     fragment_query = "(function_definition) @function",
            --     clone_token_threshold = 100,
            --     extra_nodes = { "string_literal" },
            --     ignore_nodes = { "comment" },
            --     dynamic_detection = true,
            --     update_on_save = true,
            -- },
        })
    end
end

autocmd("FileType", { pattern = "java", callback = start_ccdetect })
