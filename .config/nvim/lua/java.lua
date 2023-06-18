-- Java
local function start_jdt()
    local root = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" })
    local project_name = vim.fn.fnamemodify(root, ":t")
    local workspace_dir = vim.env.HOME .. "/.workspaces/" .. project_name
    local config = {
        init_options = {
            extendedClientCapabilities = require("jdtls").extendedClientCapabilities,
        },
        root_dir = root,
        capabilities = capabilities,
        cmd = {
            "/usr/lib/jvm/java-17-openjdk/bin/java",
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-Xms1g",
            "-Xmx2G",
            "--add-modules=ALL-SYSTEM",
            "--add-opens",
            "java.base/java.util=ALL-UNNAMED",
            "--add-opens",
            "java.base/java.lang=ALL-UNNAMED",
            "-jar",
            vim.env.HOME
            ..
            "/.langservers/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar",
            "-configuration",
            vim.env.HOME .. "/.langservers/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/config_linux",
            "-data",
            workspace_dir,
        },
        settings = {
            java = {
                configuration = {
                    runtimes = {
                        {
                            name = "JavaSE-1.8",
                            path = "/usr/lib/jvm/java-8-openjdk/",
                        },
                        {
                            name = "JavaSE-11",
                            path = "/usr/lib/jvm/java-11-openjdk/",
                            default = true,
                        },
                    },
                },
            },
        },
    }
    require("jdtls").start_or_attach(config)
end

-- autocmd("FileType", { pattern = "java", callback = start_jdt })
