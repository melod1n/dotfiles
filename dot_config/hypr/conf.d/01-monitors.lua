hl.monitor({
    output = "",
    mode = "highrr",
    position = "auto",
    scale = 1,
})

hl.config({
    misc = {
        vrr = 0,
    },
    render = {
        cm_enabled = true,
        cm_auto_hdr = 1,
        cm_sdr_eotf = "srgb",
    },
})
