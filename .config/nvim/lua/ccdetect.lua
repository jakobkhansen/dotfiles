local lspconfig = require("lspconfig")
local util = lspconfig.util
local sysname = vim.loop.os_uname().sysname
local autocmd = vim.api.nvim_create_autocmd

local command = vim.api.nvim_command

local JAVA_HOME = os.getenv("JAVA_HOME")

local function get_java_executable()
    local executable = JAVA_HOME and util.path.join(JAVA_HOME, "bin", "java") or "java"

    return sysname:match("Windows") and executable .. ".exe" or executable
end

local jar = vim.env.HOME .. "/Documents/OpenSource/CCDetect-lsp/app/build/libs/app-all.jar"

local cmd = { get_java_executable(), "-Xmx16G", "-jar", jar }

local function on_show_document(err, result, ctx, config, params)
    local uri = result.uri
    command("e +" .. result.selection.start.line + 1 .. " " .. uri)

    return result
end

local cap = vim.lsp.protocol.make_client_capabilities()
cap.workspace.didChangeWatchedFiles.dynamicRegistration = true

local function start_ccdetect()
    vim.lsp.start({
        cmd = cmd,
        name = "CCDetect",
        root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1]),
        handlers = {
            ["window/showDocument"] = on_show_document,
        },
        capabilities = cap,
        init_options = {
            language = "tsx",
            -- fragment_query = "(function_item) @function",
            fragment_query = "(function_declaration) @function (arrow_function) @arrow",
            clone_token_threshold = 100,
            extra_nodes = {},
            ignore_nodes = {},
            blind_nodes = {
                "identifier",
                "string",
                "number",
                "type_annotation",
            },
            dynamic_detection = false,
            update_on_save = true,
        },
    })
end

autocmd("FileType", { pattern = "typescriptreact", callback = start_ccdetect })
