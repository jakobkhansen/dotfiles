local parsers = require("nvim-treesitter.parsers")

local Query = {}

function Query.get_root(bufnr, filetype)
    local parser = parsers.get_parser(bufnr or 0, filetype)
    if not parser then
        error("No treesitter parser found. Install one using :TSInstall <language>")
    end
    return parser:parse()[1]:root()
end

function Query.find_occurrences(scope, sexpr, bufnr)
    local filetype = vim.bo[bufnr].filetype

    if not sexpr:find("@") then
        sexpr = sexpr .. " @tmp_capture"
    end

    local ok, sexpr_query = pcall(vim.treesitter.parse_query, filetype, sexpr)
    if not ok then
        error(string.format("Invalid query: '%s'\n error: %s", sexpr, sexpr_query))
    end

    local occurrences = {}
    for _, n in sexpr_query:iter_captures(scope, bufnr, 0, -1) do
        table.insert(occurrences, n)
    end

    return occurrences
end

function Query.find_errors(node, bufnr)
    return Query.find_occurrences(node, "(ERROR)", bufnr)
end

function Query.test()
    local bufnr = 0
    local filetype = "lua"

    local root = Query.get_root(bufnr, filetype)
    local nodes = Query.find_errors(root, 0)
    print(#nodes)

    for _, node in ipairs(nodes) do
        print(node:sexpr())
        print(vim.treesitter.query.get_node_text(node, 0))
    end
end

return Query
