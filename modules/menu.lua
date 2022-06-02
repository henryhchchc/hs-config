local M = {}

local sfSymbol = require("lib.sfsymbol")

local function generateModuleToggleMenu(m)
    return {
        title = m.name,
        image = sfSymbol.loadForMenu(m.icon),
        checked = m.isEnabled(),
        fn = function()
            if m.isEnabled() then
                m.disable()
            else
                m.enable()
            end
        end
    }
end

function M.setup()
    RootMenu = hs.menubar.new()
    local hammerspoonIcon = hs.image.imageFromPath("/Applications/Hammerspoon.app/Contents/Resources/statusicon.pdf")
    RootMenu:setIcon(hammerspoonIcon)
    local subMenus = function()
        local featuresSubMenu = hs.fnutils.map(Modules, generateModuleToggleMenu)
        return {
            {
                title = "Modules",
                image = sfSymbol.loadForMenu("􀥭 "),
                menu = featuresSubMenu
            },
            {
                title = "Terminal",
                image = sfSymbol.loadForMenu("􀩼 "),
                fn = require("modules.terminal").startOrFocusTerminal,
            },
            { title = "-" },
            {
                title = "Generate LSP Annotations",
                image = sfSymbol.loadForMenu("􀡅 "),
                fn = function()
                    local co = coroutine.create(function()
                        hs.spoons.use("EmmyLua")
                        hs.notify.new({
                            title = "LSP Annotations",
                            autoWithdraw = true,
                            informativeText = "Generation Completed",
                            withdrawAfter = 3
                        }):send()
                    end)
                    coroutine.resume(co)
                end
            },
            {
                title = "Hammerspoon Console",
                image = sfSymbol.loadForMenu("􀣚 "),
                fn = hs.openConsole,
            },
        }
    end
    RootMenu:setMenu(subMenus)
end

return M
