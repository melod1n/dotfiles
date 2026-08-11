hl.bind("Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot-area.sh"))
hl.bind("SUPER + Print", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | swappy -f -]]))

-- TODO: add separate binds for full screen and part of the screen
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/record-region.sh"))

-- TODO: add copying to clipboard
hl.bind("SUPER + SHIFT + Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/record-screen.sh"))
