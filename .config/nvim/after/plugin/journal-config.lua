require("journal").setup({
    filetype = 'md',                    -- Filetype to use for new journal entries
    root = '~/journal',                 -- String or () => String. Root directory for journal entries
    date_format = '%d/%m/%Y',           -- Date format for `:Journal <date-modifier>`
    autocomplete_date_modifier = "end", -- "always"|"never"|"end". Enable date modifier autocompletion
})
