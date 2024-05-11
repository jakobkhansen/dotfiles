require("journal").setup({
    journal = {
        format = '%Y/%m-%B/daily/%d-%A',
        template = '# %A %B %d %Y\n',
        frequency = { day = 1 },

        -- Nested configurations for `:Journal <type> <type> ... <date-modifier>`
        entries = {
            day = {
                format = '%Y/%m-%B/daily/%d-%A', -- Format of the journal entry in the filesystem.
                template = '# %A %B %d %Y\n',    -- Optional. Template used when creating a new journal entry
                frequency = { day = 1 },         -- Optional. The frequency of the journal entry. Used for `:Journal next`, `:Journal -2` etc
            },
            week = {
                format = '%Y/%m-%B/weekly/week-%W',
                template = "# Week %W %B %Y\n",
                frequency = { day = 7 },
                date_modifier = "monday" -- Date modifier applied before other date modifier given to `:Journal`
            },
            month = {
                format = '%Y/%m-%B/%B',
                template = "# %B %Y\n",
                frequency = { month = 1 }
            },
            year = {
                format = '%Y/%Y',
                template = "# %Y\n",
                frequency = { year = 1 }
            },
            quarter = {
                -- strftime doesn't supply a quarter variable, so we compute it manually
                format = function(date)
                    local quarter = math.ceil(tonumber(os.date("%m", os.time(date.date))) / 3)
                    return "%Y/quarter/" .. quarter
                end,
                template = function(date)
                    local quarter = math.ceil(os.date("%m", os.time(date.date)) / 3)
                    return "# %Y Quarter " .. quarter .. "\n"
                end,
                frequency = { month = 3 },
            },
            groupA = {
                format = 'groupA/%Y/%m-%B/daily/%d-%A',
                template = "# Group A %A %B %d %Y\n",
                frequency = { day = 1 },

                entries = {
                    day = {
                        format = 'groupA/%Y/%m-%B/daily/%d-%A',
                        template = "# Group A %A %B %d %Y\n",
                        frequency = { day = 1 },
                    },
                    week = {
                        format = 'groupA/%Y/%m-%B/weekly/week-%W',
                        template = "# Group A Week %W %B %Y\n",
                        frequency = { day = 7 },
                        date_modifier = "monday"
                    },
                }
            },
            groupB = {
                format = 'groupB/%Y/%m-%B/daily/%d-%A',
                template = "# Group B %A %B %d %Y\n",
                frequency = { day = 1 },

                entries = {
                    day = {
                        format = 'groupB/%Y/%m-%B/daily/%d-%A',
                        template = "# Group B %A %B %d %Y\n",
                        frequency = { day = 1 },
                    },
                    week = {
                        format = 'groupB/%Y/%m-%B/weekly/week-%W',
                        template = "# Group B Week %W %B %Y\n",
                        frequency = { day = 7 },
                        date_modifier = "monday"
                    },
                }
            },
        },
    }
})
