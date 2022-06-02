return {
    sumneko_lua = {
        settings = {
            Lua = {
                runtime = {
                    version = "Lua 5.4",
                },
                diagnostics = {
                    globals = { "hs" },
                },
                workspace = {
                    library = {
                        vim.fn.expand("~/.hammerspoon/Spoons/EmmyLua.spoon/annotations")
                    }
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                    enable = false,
                },
            },
        }
    }
}
