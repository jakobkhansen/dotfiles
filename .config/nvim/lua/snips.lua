local snippets = require'snippets'
local U = require'snippets'.u

snippets.snippets = {
    python = {
        ifmain = U.match_indentation "if __name__ == \"__main__\":\n    main()";
        try_except = U.match_indentation "try:\n    $0\nexcept:\n    pass"
    };

    java = {
        main = U.match_indentation "public static void main(String[] args) {\n    $0\n}";
        try_catch = U.match_indentation "try {\n    $0\n} catch (Exception e) {\n    e.printStackTrace();\n}"
    };

    markdown = {
        h1 = U.match_indentation "# $0",
        h2 = U.match_indentation "## $0",
        h3 = U.match_indentation "### $0",
        h4 = U.match_indentation "#### $0",
        h5 = U.match_indentation "##### $0",
        block = U.match_indentation "`$0`",
        code = U.match_indentation "```$1\n$0\n```",
        math = U.match_indentation "\\$$0\\$",
        checkempty = U.match_indentation "[ ]",
        checkfull = U.match_indentation "[x]",

        derivative = U.match_indentation "\\frac{\\partial}{\\partial $0}",

        bra = U.match_indentation "Bra, dette fungerer helt riktig.",
        fint = U.match_indentation "Fint, dette fungerer helt riktig.",
        frivillig = U.match_indentation "Ikke gjort. Anbefaler at du gjør dette som forberedelse til eksamen! :)",
    };

    tex = {
        bullet = U.match_indentation "\\begin{itemize}\n    \\item $0\n\\end{itemize}",
        numlist = U.match_indentation "\\begin{enumerate}\n    \\item $0\n\\end{enumerate}"
    }
}
