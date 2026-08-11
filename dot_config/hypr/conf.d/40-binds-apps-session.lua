local vars = dofile((os.getenv("HOME") or "") .. "/.config/hypr/conf.d/00-variables.lua")
local mainMod = vars.mainMod

hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(vars.terminal))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("~/.config/hypr/scripts/apps-launcher.sh"))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd("~/.config/hypr/scripts/apps-launcher.sh true"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(vars.fileManager))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(vars.browser))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("kitty --class yazi -e yazi"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(mainMod .. " + H", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-waybar.sh"))
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only

hl.bind(mainMod .. " + SHIFT + RETURN", hl.dsp.exec_cmd(vars.terminal, {
    float = true,
    center = true,
    size = { 1000, 700 },
}))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(vars.fileManager, {
    float = true,
    center = true,
    size = { 1200, 800 },
}))

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.kill())
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/reload-config.sh"))

hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("~/.config/hypr/scripts/lock-now.sh"))
hl.bind(mainMod .. " + F11", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-caffeine.sh"))
hl.bind(mainMod .. " + Delete", hl.dsp.exec_cmd("~/.config/hypr/scripts/power-menu.sh"))

hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("~/.config/hypr/scripts/cliphist-toggle.sh"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist wipe"))

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-theme.sh"))
