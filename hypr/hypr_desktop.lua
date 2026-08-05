hl.monitor({
	output = "HDMI-A-1",
	mode = "1920x1080@60",
	position = "1920x0",
	scale = 1,
})

hl.monitor({
	output = "eDP-1",
	disabled = true,
})

hl.on("hyprland.start", function()
	hl.exec_cmd("waybar -c $HOME/.config/waybar/conf_desktop.jsonc")
end)
