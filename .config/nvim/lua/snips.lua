local snippets = require'snippets'
local U = require'snippets'.u

snippets.snippets = {
    python = {
        ifmain = U.match_indentation "if __name__ == \"__main__\":\n    main()";
        try_except = U.match_indentation "try:\n    $0\nexcept:\n    pass"
    };

    java = {
        main = U.match_indentation "public static void main(String[] args) {\n    $0\n}";
        try_catch = U.match_indentation "try {\n    $0\n} catch (exception e) {\n    e.printstacktrace();\n}"
    };
}
