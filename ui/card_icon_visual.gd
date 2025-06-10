# res://ui/card_icon_visual.gd
extends Control
class_name CardIconVisual

# Guaranteed to be in the repo for basic functionality
const CARD_FRAME_LOW_RES_PATH = "res://art/card_frame_low_res.png"
# Optional, higher quality version from the art pack
const CARD_FRAME_HIGH_RES_PATH = "res://art/card_frame_high_res.png"

# Guaranteed to be in the repo as a fallback for missing individual card art
const FALLBACK_CARD_ART_TEXTURE = preload("res://art/default_card_art_low_res.png")

var card_data: CardResource = null # Store the card resource

@onready var card_art_texture: TextureRect = $CardArtTextureRect
@onready var card_frame_texture: TextureRect = $CardFrameTextureRect

# Define margin percentages
const CARD_MARGIN_WIDTH = 0.05 # 5% margin
@export var art_margin_percent_left: float = CARD_MARGIN_WIDTH 
@export var art_margin_percent_top: float = CARD_MARGIN_WIDTH 
@export var art_margin_percent_right: float = CARD_MARGIN_WIDTH
@export var art_margin_percent_bottom: float = CARD_MARGIN_WIDTH

func _on_mouse_entered() -> void:
	print(Time.get_ticks_msec(), "ms: MOUSE ENTERED on CardIconVisual ", self.get_instance_id())
	if is_instance_valid(card_data) and card_data.description_template != "":
		TooltipManager.request_show_tooltip(card_data.get_formatted_description(), self)
	#TooltipManager.request_show_tooltip("Test Hover", self)


func _on_mouse_exited() -> void:
	print(Time.get_ticks_msec(), "ms: MOUSE EXITED from CardIconVisual ", self.get_instance_id())
	TooltipManager.request_hide_tooltip(self)


func _notification(what):
	if what == NOTIFICATION_RESIZED:
		_apply_proportional_margins()

func _apply_proportional_margins():
	if not is_instance_valid(card_art_texture):
		return

	var current_root_size = self.size # Size of this CardIconVisual node
	
	# Prevent issues if called before size is meaningful
	if current_root_size.x <= 0 or current_root_size.y <= 0:
		return

	card_art_texture.offset_left = current_root_size.x * art_margin_percent_left
	card_art_texture.offset_top = current_root_size.y * art_margin_percent_top
	card_art_texture.offset_right = -(current_root_size.x * art_margin_percent_right)  # Negative for right offset
	card_art_texture.offset_bottom = -(current_root_size.y * art_margin_percent_bottom) # Negative for bottom offset
	
	# The CardFrameTextureRect should generally always be full rect (no margins for the frame itself)
	if is_instance_valid(card_frame_texture):
		card_frame_texture.set_anchors_preset(Control.PRESET_FULL_RECT)

func set_component_modulation(p_frame_modulate: Color = Color(1,1,1,1), p_art_modulate: Color = Color(1,1,1,1)):
	if is_instance_valid(card_frame_texture):
		card_frame_texture.modulate = p_frame_modulate
	if is_instance_valid(card_art_texture):
		card_art_texture.modulate = p_art_modulate

func print_layout_info_debug():
	# Ensure this is called after the node is in the tree and layout has settled
	print("CardIconVisual ('%s') - Size: %s, MinSize: %s, GlobalPos: %s" % [name, size, custom_minimum_size, global_position])
	if get_parent():
		print("    Parent ('%s') - Type: %s, Size: %s" % [get_parent().name, get_parent().get_class(), get_parent().size if get_parent().has_method("get_size") else "N/A"])
		if get_parent() is GridContainer:
			var gc: GridContainer = get_parent()
			# Approximate cell width, actual cell size isn't directly exposed easily
			var approx_cell_width = (gc.size.x - (gc.columns - 1) * gc.get_theme_constant("h_separation", "GridContainer")) / float(gc.columns)
			print("    Parent GridContainer approx cell width: ", approx_cell_width)

func update_display(card_res: CardResource, verbose: int = 0):
	self.card_data = card_res
	if verbose > 0:
		print("CardIconVisual update_display: Called for card_res: ", card_res.id if card_res else "null_card_res")
		print("CardIconVisual update_display: self.name is '", name, "', card_art_texture is valid? ", is_instance_valid(card_art_texture))
	
	if not is_instance_valid(card_art_texture):
		printerr("CardIconVisual: card_art_texture is NOT VALID in update_display for card: ", card_res.id if card_res else "null_card_res")
		return

	var loaded_card_art_texture: Texture2D = null
	var attempted_art_path: String = "N/A"

	if card_res and card_res.artwork_path != null and not card_res.artwork_path.is_empty():
		attempted_art_path = card_res.artwork_path
		if ResourceLoader.exists(attempted_art_path):
			var res = load(attempted_art_path)
			if res is Texture2D:
				loaded_card_art_texture = res
			elif verbose > 0:
				printerr("CardIconVisual: Loaded resource from card art path '%s' is not Texture2D, type: %s" % [attempted_art_path, typeof(res)])
		# No error print here if path doesn't exist; fallback will handle it.
		# else:
			# if verbose > 0: print("CardIconVisual: Card art path does not exist: ", attempted_art_path)
			
	if loaded_card_art_texture is Texture2D:
		card_art_texture.texture = loaded_card_art_texture
	else:
		# This block executes if specific card art failed to load or was never attempted (no path)
		var reason_for_fallback = "specific art path not found or failed to load"
		if not card_res:
			reason_for_fallback = "card_res was null"
		elif card_res.artwork_path == null or card_res.artwork_path.is_empty():
			reason_for_fallback = "artwork_path was empty"
		
		if card_res : # Only print error if a card_res was provided and specific art was expected
			printerr("CardIconVisual: Failed to load art for %s. Path: '%s' (%s). Using fallback." % [card_res.id, attempted_art_path, reason_for_fallback])
		elif verbose > 0: # If card_res was null but verbose, still log the fallback action
			print("CardIconVisual: %s. Using fallback." % reason_for_fallback)
		
		card_art_texture.texture = FALLBACK_CARD_ART_TEXTURE # Assign the preloaded fallback
		
		if not is_instance_valid(card_art_texture.texture): # Should not happen if FALLBACK_CARD_ART_TEXTURE is valid and preloaded
			var card_id_for_error = card_res.id if card_res else "UnknownCard"
			printerr("CardIconVisual: CRITICAL - FALLBACK_CARD_ART_TEXTURE also failed to apply for card %s." % card_id_for_error)

	# Ensure default full opacity, caller can modulate later if needed.
	set_component_modulation()

func _ready():
	# Load card frame: attempt high-res if available, otherwise use low-res default
	var frame_texture_to_load_path = CARD_FRAME_LOW_RES_PATH # Default to low-res

	if ResourceLoader.exists(CARD_FRAME_HIGH_RES_PATH):
		var high_res_tex_attempt = load(CARD_FRAME_HIGH_RES_PATH)
		if high_res_tex_attempt is Texture2D:
			frame_texture_to_load_path = CARD_FRAME_HIGH_RES_PATH
			
			#print("CardIconVisual: Using high-resolution card frame.") # Optional debug
		else:
			printerr("CardIconVisual: Found high-res frame path '%s', but failed to load it as Texture2D. Using low-res." % CARD_FRAME_HIGH_RES_PATH)
	# else: # Optional debug if high-res not found
		# print("CardIconVisual: High-resolution card frame not found at '%s'. Using low-res." % CARD_FRAME_HIGH_RES_PATH)

	if is_instance_valid(card_frame_texture):
		var loaded_frame_tex = load(frame_texture_to_load_path)
		if loaded_frame_tex is Texture2D:
			card_frame_texture.texture = loaded_frame_tex
		else:
			printerr("CardIconVisual: CRITICAL - Failed to load even the low-resolution card frame from: ", frame_texture_to_load_path)
			# UI might look unstyled for the frame, but the project loads.
	
	# Ensure CardArtTextureRect is set to full rect initially so margin calculations are correct
	if is_instance_valid(card_art_texture):
		card_art_texture.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	# Apply initial margins based on current size (which might be its custom_minimum_size)
	_apply_proportional_margins()

	# Connect signals for tooltip
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
