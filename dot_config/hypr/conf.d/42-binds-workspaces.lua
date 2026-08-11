local vars = dofile((os.getenv("HOME") or "") .. "/.config/hypr/conf.d/00-variables.lua")
local mainMod = vars.mainMod

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i, follow = true }))
end
