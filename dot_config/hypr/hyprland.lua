-- Hyprland Lua configuration.
-- Converted from the original hyprlang configuration without intentional
-- behavioral changes. Keep this order: it mirrors conf.d/*.conf lexical order.

require("./conf.d/00-variables")
require("./conf.d/01-monitors")
require("./conf.d/02-environment")
require("./conf.d/03-autostart")
require("./conf.d/04-theme")
require("./conf.d/05-permissions")
require("./conf.d/10-input")
require("./conf.d/20-layout")
require("./conf.d/25-groups")
require("./conf.d/30-windowrules")
require("./conf.d/40-binds-apps-session")
require("./conf.d/41-binds-window")
require("./conf.d/42-binds-workspaces")
require("./conf.d/43-binds-screenshots")
require("./conf.d/46-binds-media")
require("./conf.d/90-misc")
