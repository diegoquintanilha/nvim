return {
	"sphamba/smear-cursor.nvim",
	opts = {
		-- Do not smear cursor on short movements
		min_horizontal_distance_smear = 1,
		min_vertical_distance_smear = 1,
		
		-- Do not smear cursor in insert mode
		smear_insert_mode = false,

		-- Smears and particles will look less blocky
		legacy_computing_symbols_support = true,
		legacy_computing_symbols_support_vertical_bars = true,
		use_diagonal_blocks = true,

		-- Do not overlap target character until the animation finishes
		never_draw_over_target = true,
		hide_target_hack = true,

		-- Animation
		time_interval           = 7, -- Animation time (ms)
		delay_after_key         = 1, -- Delay before start moving (ms)
		stiffness               = 1, -- The head goes instantly to the target
		trailing_stiffness      = 0.4, -- Tail speed (0: no movement, 1: instantaneous)
		damping                 = 1, -- Stop as soon as it reaches the target (no overshoot)
		distance_stop_animating = 2, -- Stop animating when tail is within this distance (in characters) from the target
	},
}

