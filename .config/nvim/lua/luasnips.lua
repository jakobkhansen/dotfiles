local ls = require'luasnip'


-- Every unspecified option will be set to the default.
ls.config.set_config({
	history = true,
	-- Update more often, :h events for more info.
	updateevents = 'TextChanged,TextChangedI'
})


ls.snippets = {
    java = {
        ls.parser.parse_snippet(
            {trig="main"},
            "public static void main(String[] args) {\n    $0\n}"
        ),
        ls.parser.parse_snippet(
            {trig="try_catch"},
            "try {\n    $0\n} catch (Exception e) {\n    e.printStackTrace();\n}"
        ),
    },

    python = {
        ls.parser.parse_snippet(
            {trig="ifmain"},
            "if __name__ == \"__main__\":\n    main()"
        ),
        ls.parser.parse_snippet(
            {trig="try_except"},
            "try:\n    $0\nexcept:\n    pass"
        ),
    },

    markdown = {
        ls.parser.parse_snippet({trig="h1"}, "# $0"),
        ls.parser.parse_snippet({trig="h2"}, "## $0"),
        ls.parser.parse_snippet({trig="h3"}, "### $0"),
        ls.parser.parse_snippet({trig="h4"}, "#### $0"),
        ls.parser.parse_snippet({trig="h5"}, "##### $0"),

        ls.parser.parse_snippet({trig="block"}, "`$0`"),
        ls.parser.parse_snippet({trig="code"}, "```${1:java}\n$0\n```"),
        ls.parser.parse_snippet({trig="math"}, "\\$$0\\$"),
        ls.parser.parse_snippet({trig="checkempty"}, "[ ]"),
        ls.parser.parse_snippet({trig="checkfull"}, "[x]"),
    }
}


