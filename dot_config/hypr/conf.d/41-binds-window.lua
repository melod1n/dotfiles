local vars = dofile((os.getenv("HOME") or "") .. "/.config/hypr/conf.d/00-variables.lua")
local mainMod = vars.mainMod
local scriptsDir = vars.scriptsDir

hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd(scriptsDir .. "/toggle-tab-smart.sh"))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))

hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + CTRL + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.window.pin({ action = "toggle" }))

hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(scriptsDir .. "/toggle-window-scratch.sh"))
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("scratch"))

hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.window.cycle_next())
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.window.move({ out_of_group = true }))
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.window.deny_from_group({ action = "toggle" }))

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))

hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.swap({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.swap({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.swap({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.swap({ direction = "d" }))

hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.move({ direction = "d" }))

hl.bind(mainMod .. " + ALT + left", hl.dsp.layout("preselect l"))
hl.bind(mainMod .. " + ALT + right", hl.dsp.layout("preselect r"))
hl.bind(mainMod .. " + ALT + up", hl.dsp.layout("preselect u"))
hl.bind(mainMod .. " + ALT + down", hl.dsp.layout("preselect d"))

hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ monitor = "-1", follow = true }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ monitor = "+1", follow = true }))
