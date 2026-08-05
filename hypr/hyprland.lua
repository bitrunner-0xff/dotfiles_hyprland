----------------------
---- ENVIRONMENTS ----
----------------------

-- Default

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = 1.5,
})

-- Specific

--require("hypr_desktop")
require("hypr_laptop")

-------------------
---- AUTOSTART ----
-------------------

local startup_routes = {}
local startup_route_deadline = 0

hl.on("window.open", function(w)
	if w == nil then
		return
	end

	-- Prevent a failed startup launch from leaving a route armed forever.
	if os.time() > startup_route_deadline then
		startup_routes = {}
		return
	end

	local workspace = startup_routes[w.class]
	if workspace == nil then
		return
	end

	-- Consume the route. Later instances will open normally.
	startup_routes[w.class] = nil

	hl.dispatch(hl.dsp.window.move({
		workspace = workspace,
		follow = false,
		window = w,
	}))
end)

hl.on("hyprland.start", function()
	startup_routes = {
		["org.mozilla.firefox"] = "1",
		["md.Obsidian"] = "2",
		["org.telegram.desktop"] = "3",
	}

	-- Startup routing expires after 45 seconds.
	startup_route_deadline = os.time() + 45

	hl.exec_cmd("uwsm app -- flatpak run org.mozilla.firefox")
	hl.exec_cmd("uwsm app -- flatpak run md.obsidian.Obsidian")
	hl.exec_cmd("uwsm app -- flatpak run org.telegram.desktop")

	hl.exec_cmd([[
        uwsm app -- sh -lc 'sleep 10; exec "$HOME/.config/dotfiles/scripts/battery_status.sh"'
    ]])
end)

----------------------------
---      CONFIG         ---
----------------------------

hl.config({
	general = {
		border_size = 1,

		gaps_in = 3,
		gaps_out = 4,

		float_gaps = 0,

		gaps_workspaces = 1,

		col = {
			active_border = "rgba(33ccffee)",
			inactive_border = "rgba(595959aa)",

			nogroup_border = "rgba(595959aa)",
			nogroup_border_active = "rgba(33ccffee)",
		},

		layout = "dwindle",

		no_focus_fallback = false,
		resize_on_border = true,
		extend_border_grab_area = 15,
		hover_icon_on_border = true,

		allow_tearing = false,

		resize_corner = 0,
		modal_parent_blocking = true,

		snap = {
			enabled = false,
			window_gap = 10,
			monitor_gap = 10,
			border_overlap = false,
			respect_gaps = false,
		},
	},
	dwindle = {
		preserve_split = true,
	},
})

hl.config({
	decoration = {
		rounding = 0,

		active_opacity = 1.0,
		inactive_opacity = 1.0,
		fullscreen_opacity = 1.0,

		dim_modal = false,
		dim_inactive = false,
		dim_strength = 0.0,
		dim_special = 0,
		dim_around = 0,

		screen_shader = "",

		shadow = {
			enabled = false,
		},

		blur = {
			enabled = false,
		},

		glow = {
			enabled = false,
		},
	},
})

--- ANIMATIONS

hl.config({
	animations = {
		enabled = true,
		workspace_wraparound = true,
	},
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Default springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 4, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

--- INPUT

hl.config({
	input = {
		kb_layout = "us,ru",
		kb_variant = "",
		kb_model = "",
		kb_options = "grp:alt_shift_toggle",
		kb_rules = "",

		numlock_by_default = false,
		resolve_binds_by_sym = false,

		sensitivity = 0,
		accel_profile = "adaptive",
		force_no_accel = false,
		rotation = 0,
		left_handed = false,

		--scroll_points = "1 5",
		scroll_method = "",
		scroll_button = 0,
		scroll_button_lock = false,
		scroll_factor = 1.0,
		natural_scroll = false,

		follow_mouse = 1,
		follow_mouse_shrink = 0,
		follow_mouse_threshold = 0.0,
		focus_on_close = 1,
		mouse_refocus = true,
		float_switch_override_focus = 1,
		special_fallthrough = false,
		off_window_axis_events = 1,
		emulate_discrete_scroll = 1,

		touchpad = {
			disable_while_typing = true,
			natural_scroll = true,
			scroll_factor = 1.0,
			middle_button_emulation = false,
			tap_button_map = "",
			clickfinger_behavior = false,
			drag_lock = 0,
			tap_to_click = true,
			tap_and_drag = true,
			flip_x = false,
			flip_y = false,
		},
	},
})

hl.config({
	gestures = {
		workspace_swipe_distance = 300,
		workspace_swipe_touch = true,
		workspace_swipe_invert = true,
		workspace_swipe_touch_invert = false,
		workspace_swipe_min_speed_to_force = 10,
		workspace_swipe_cancel_ratio = 0.5,
		workspace_swipe_create_new = true,
		workspace_swipe_direction_lock = true,
		workspace_swipe_direction_lock_threshold = 10,
		workspace_swipe_forever = false,
		workspace_swipe_use_r = false,
		close_max_timeout = 1000,
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

hl.config({
	group = {
		auto_group = false,
		insert_after_current = true,
		focus_removed_window = true,
		drag_into_group = 1,
		merge_groups_on_drag = true,
		merge_groups_on_groupbar = true,
		merge_floated_into_tiled_on_groupbar = false,
		group_on_movetoworkspace = false,

		col = {
			border_active = 0x66ffff00,
			border_inactive = 0x66777700,
			border_locked_active = 0x66ff5500,
			border_locked_inactive = 0x66775500,
		},
		groupbar = {
			enabled = true,
			font_family = "JetBrainsMonoNL Nerd Font Mono",
			font_size = 8,
			gradients = false,
			height = 14,
			indicator_height = 3,
			stacked = false,
			priority = 3,
			render_titles = true,
			scrolling = true,
			rounding = 0,
			gradient_rounding = 2,
			round_only_edges = false,
			gradient_round_only_edges = false,
			text_color = 0xffffffff,
			gaps_in = 2,
			gaps_out = 2,
			keep_upper_gap = true,
			middle_click_close = true,

			col = {
				active = 0x66ffff00,
				inactive = 0x66777700,
				locked_active = 0x66ff5500,
				locked_inactive = 0x66775500,
			},
		},
	},
})

hl.config({
	misc = {
		disable_hyprland_logo = true,
		disable_scale_notification = false,
		background_color = 0x111111,
		disable_splash_rendering = false,

		font_family = "JetBrainsMonoNL Nerd Font Mono",
		splash_font_family = "JetBrainsMonoNL Nerd Font Mono",
		col = {
			splash = 0xffffffff,
		},

		force_default_wallpaper = 1,
		vrr = 2,
		mouse_move_enables_dpms = false,
		always_follow_on_dnd = true,
		layers_hog_keyboard_focus = true,
		disable_autoreload = false,

		animate_manual_resizes = false,
		animate_mouse_windowdragging = false,

		enable_swallow = false,
		swallow_regex = "",
		swallow_exception_regex = "",

		focus_on_activate = false,
		mouse_move_focuses_monitor = true,

		allow_session_lock_restore = false,
		close_special_on_empty = true,

		exit_window_retains_fullscreen = false,

		initial_workspace_tracking = 1,
		middle_click_paste = true,
		render_unfocused_fps = 20,
		disable_xdg_env_checks = false,
		disable_hyprland_guiutils_check = false,
		lockdead_screen_delay = 1000,
		enable_anr_dialog = true,
	},
})

hl.config({
	layout = {
		single_window_aspect_ratio = { 0, 0 },
		single_window_aspect_ratio_tolerance = 0.1,
	},
})

hl.config({
	binds = {
		pass_mouse_when_bound = false,
		scroll_event_delay = 300,
		workspace_back_and_forth = false,
		hide_special_on_workspace_change = false,
		allow_workspace_cycles = true,
		workspace_center_on = 0,
		focus_preferred_method = 0,
		ignore_group_lock = false,
		movefocus_cycles_fullscreen = false,
		movefocus_cycles_groupfirst = false,
		window_direction_monitor_fallback = true,
		disable_keybind_grabbing = false,
		allow_pin_fullscreen = false,
		drag_threshold = 0,
	},
})

hl.config({
	xwayland = {
		enabled = true,
		use_nearest_neighbor = true,
		force_zero_scaling = true,
		create_abstract_socket = false,
	},
})
hl.config({
	opengl = {
		nvidia_anti_flicker = true,
	},
})

hl.config({
	render = {
		direct_scanout = 2,
		expand_undersized_textures = true,
		xp_mode = false,
		ctm_animation = 2,
		cm_enabled = true,
		send_content_type = true, -- NOTE: disable if black screen
		cm_auto_hdr = 1,
		new_render_scheduling = true,
		non_shader_cm = 2,
		non_shader_cm_interop = 2,
		cm_sdr_eotf = "default",
		commit_timing_enabled = true,
		use_fp16 = 2,
		keep_unmodified_copy = 2,
		use_shader_blur_blend = false,
	},
})

hl.config({
	cursor = {
		invisible = false,
		enable_hyprcursor = true,

		default_monitor = "",

		sync_gsettings_theme = true,
		no_hardware_cursors = 2,
		no_break_fs_vrr = 2,
		min_refresh_rate = 30,
		hotspot_padding = 1,
		inactive_timeout = 0,

		no_warps = false,
		persistent_warps = false,
		warp_on_change_workspace = 0,
		warp_on_toggle_special = 0,

		zoom_factor = 1.0,
		zoom_rigid = false,
		zoom_detached_camera = true,

		hide_on_key_press = false,
		hide_on_touch = true,
		hide_on_tablet = true,

		use_cpu_buffer = 2,
		warp_back_after_non_mouse_input = false,
		zoom_disable_aa = false,
	},
})

hl.config({
	ecosystem = {
		no_update_news = false,
		no_donation_nag = true,
	},
	quirks = {
		prefer_hdr = 2,
	},
})

--------------------
--- WINDOW RULES ---
--------------------

hl.window_rule({
	name = "Veracrypt",
	match = {
		initial_class = "^veracrypt$",
	},
	float = true,
	pin = true,
	center = true,
})

hl.window_rule({
	name = "Bluetooth",
	match = {
		initial_class = "^bluetooth$",
	},
	float = true,
	pin = true,
	size = { 667, 648 },
	move = "1235 53",
})

hl.window_rule({
	name = "WiFi",
	match = {
		class = "wifi",
	},
	float = true,
	size = "744 718",
	move = "1160 53",
})

hl.window_rule({
	name = "Thunar",
	match = {
		class = "thunar",
		title = "Rename.*",
	},
	pseudo = true,
	float = true,
})

---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal = "alacritty"
local fileManager = "thunar"
local menu = "wofi"

---------------------
--- BINDINGS ---
---------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))

-- VPN
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("~/.local/bin/vpn_toggle.sh"))
-- Color picker
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("hyprpicker -a"))
-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd("~/.local/bin/screenshot.sh"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("~/.local/bin/screenshot.sh --region"))
-- Lockscreen
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("hyprlock"))

-- Hyprland bindings
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.kill())
hl.bind(mainMod .. " + W", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + V", hl.dsp.layout("togglesplit")) -- dwindle only

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Move focus
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Switch to workspace
hl.bind(mainMod .. " + B", hl.dsp.focus({ workspace = "r-1" }))
hl.bind(mainMod .. " + N", hl.dsp.focus({ workspace = "r+1" }))

-- Move window to workspace
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.window.move({ workspace = "r-1" }))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.window.move({ workspace = "r+1" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x = 30, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = 30, relative = true }), { repeating = true })

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
