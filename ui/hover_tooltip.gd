# res://ui/hover_tooltip.gd
extends Control

@onready var background_panel: Panel = $BackgroundPanel
@onready var content_label: RichTextLabel = $ContentLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const FADE_DURATION: float = 0.25
var _is_animating: bool = false

# Called when the node is added to the scene tree for the first time.
func _ready() -> void:
	# Create a StyleBox for the panel programmatically for now
	# Later, you could load this from a .tres file or a theme
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = Color(0.1, 0.1, 0.1, 0.85) # Dark semi-transparent
	style_box.corner_radius_top_left = 8
	style_box.corner_radius_top_right = 8
	style_box.corner_radius_bottom_left = 8
	style_box.corner_radius_bottom_right = 8
	style_box.content_margin_left = 10
	style_box.content_margin_top = 5
	style_box.content_margin_right = 10
	style_box.content_margin_bottom = 5
	background_panel.add_theme_stylebox_override("panel", style_box)

	# Set font for RichTextLabel programmatically for now
	# Later, move this to a theme applied to the RichTextLabel or HoverTooltip
	var font = load("res://data/fonts/LibreBaskerville-Bold.ttf")
	if font is FontFile:
		content_label.add_theme_font_override("normal_font", font)
		content_label.add_theme_font_size_override("normal_font_size", 18) # Adjust as needed
		content_label.add_theme_color_override("default_color", Color(0.9, 0.9, 0.9, 1.0)) # Light text

	# Ensure it starts invisible and fully transparent
	modulate.a = 0.0
	visible = false

	#self.modulate = Color(1, 1, 1, 0.3) # Full alpha
	#self.visible = true
	#update_content("DEBUG: Tooltip Visible?") # Call update_content with test text
	self.global_position = Vector2(100, 100) # Position it somewhere obvious
	print("HoverTooltip _ready: FORCED partially VISIBLE at ", global_position, " with size ", size, " and modulate ", modulate)

	_setup_animations()


func _setup_animations() -> void:
	var anim_library: AnimationLibrary
	
	# Check if the AnimationPlayer already has a default library.
	# If not, create one and assign it.
	# The default library is accessed with an empty string key "".
	if animation_player.has_animation_library(""):
		anim_library = animation_player.get_animation_library("")
	else:
		anim_library = AnimationLibrary.new()
		animation_player.add_animation_library("", anim_library) # Assign it as the default library

	# Remove existing animations from the library if they exist, to avoid duplication on re-runs (e.g., in tool scripts)
	if anim_library.has_animation("fade_in"):
		anim_library.remove_animation("fade_in")
	if anim_library.has_animation("fade_out"):
		anim_library.remove_animation("fade_out")

	var anim_fade_in = Animation.new()
	anim_fade_in.length = FADE_DURATION
	anim_fade_in.add_track(Animation.TYPE_VALUE)
	# Assuming HoverTooltip (self) is the node whose modulate.a is being tweened.
	# If you want to tween a child, adjust the path. For the root 'HoverTooltip' control:
	anim_fade_in.track_set_path(0, ".:modulate:a") 
	anim_fade_in.track_insert_key(0, 0.0, 0.0) # Start at current alpha or 0
	anim_fade_in.track_insert_key(0, FADE_DURATION, 1.0) # End at full alpha
	anim_library.add_animation("fade_in", anim_fade_in)

	var anim_fade_out = Animation.new()
	anim_fade_out.length = FADE_DURATION
	anim_fade_out.add_track(Animation.TYPE_VALUE)
	anim_fade_out.track_set_path(0, ".:modulate:a") # Targeting the root control's modulate
	anim_fade_out.track_insert_key(0, 0.0, 1.0) # Start at current alpha or 1
	anim_fade_out.track_insert_key(0, FADE_DURATION, 0.0) # End at zero alpha
	anim_library.add_animation("fade_out", anim_fade_out)

	# Connect the fade_out animation finished signal to actually hide the control
	# This connection should ideally only happen once, e.g., in _ready or ensure it's not duplicated.
	# If _setup_animations can be called multiple times, manage this connection carefully.
	# For now, assuming _ready calls _setup_animations once.
	if not animation_player.animation_finished.is_connected(_on_animation_player_animation_finished):
		animation_player.animation_finished.connect(_on_animation_player_animation_finished)


func update_content(bbcode_text: String) -> void:
	# Define a maximum width for the tooltip. Adjust as you see fit.
	var max_width = 350.0

	# 1. Set the tooltip container's width FIRST.
	#    This gives the RichTextLabel a bounding box to calculate its word wrapping.
	self.size.x = max_width

	# 2. Now, set the text on the label. Because it is a child of `self` and
	#    is anchored to the full rect, it will use self.size.x as its wrapping width.
	content_label.text = bbcode_text
	
	# 3. Get the required height for the content at the specified width.
	var content_height = content_label.get_content_height()
	
	# 4. Get the vertical padding from our stylebox.
	var style_box: StyleBox = background_panel.get_theme_stylebox("panel")
	var padding_vertical = 0.0
	if style_box:
		padding_vertical = style_box.get_minimum_size().y

	# 5. Set the final height of the tooltip.
	self.size.y = content_height + padding_vertical
	
func display_at(target_position: Vector2) -> void:
	print("TOOLTIP: display_at() called at ", Time.get_ticks_msec(), "ms. target_position: ", target_position, ", modulate.a: ", modulate.a, ", visible: ", visible)
	global_position = target_position
	visible = true
	_is_animating = true
	#modulate.a = 0.0 # Ensure we're fully transparent before fading in
	animation_player.stop()
	animation_player.play("fade_in")
	
func hide_tooltip() -> void:
	print("TOOLTIP: hide_tooltip() called at ", Time.get_ticks_msec(), "ms. modulate.a: ", modulate.a, ", visible: ", visible)
	if visible and modulate.a > 0.0:
		animation_player.stop()
		_is_animating = true
		animation_player.play("fade_out")
	else:
		modulate.a = 0.0
		visible = false
		_is_animating = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print("TOOLTIP: animation finished: ", anim_name, " at ", Time.get_ticks_msec(), "ms")
	_is_animating = false
	if anim_name == "fade_out":
		visible = false
		update_content("")
