# res://ui/card_icon_visual.gd
extends Control
class_name CardIconVisual

const CARD_FRAME_TEXTURE = preload("res://art/CardFramev11_RoundedCorners_TransparentCentre.png")

@onready var card_art_texture: TextureRect = $CardArtTextureRect
@onready var card_frame_texture: TextureRect = $CardFrameTextureRect

# Define margin percentages as export variables or constants if you prefer
const CARD_MARGIN_WIDTH = 0.05
@export var art_margin_percent_left: float = CARD_MARGIN_WIDTH 
@export var art_margin_percent_top: float = CARD_MARGIN_WIDTH 
@export var art_margin_percent_right: float = CARD_MARGIN_WIDTH
@export var art_margin_percent_bottom: float = CARD_MARGIN_WIDTH

func _ready():
	if is_instance_valid(card_frame_texture):
		card_frame_texture.texture = CARD_FRAME_TEXTURE
	
	# Ensure CardArtTextureRect is set to full rect initially so margin calculations are correct
	if is_instance_valid(card_art_texture):
		card_art_texture.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	# Apply initial margins based on current size (which might be its custom_minimum_size)
	_apply_proportional_margins()


func _notification(what):
	if what == NOTIFICATION_RESIZED:
		# This notification is called whenever this control's size changes.
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
	
	# The CardFrameTextureRect should generally always be full rect (no margins)
	if is_instance_valid(card_frame_texture):
		card_frame_texture.set_anchors_preset(Control.PRESET_FULL_RECT)

# New function to set alphas of components
func set_component_modulation(p_frame_modulate: Color = Color(1,1,1,1), p_art_modulate: Color = Color(1,1,1,1)):
	if is_instance_valid(card_frame_texture):
		card_frame_texture.modulate = p_frame_modulate
	if is_instance_valid(card_art_texture):
		card_art_texture.modulate = p_art_modulate

func update_display(card_res: CardResource, verbose: int = 0):
	if verbose > 0:
		print("CardIconVisual update_display: Called for card_res: ", card_res.id if card_res else "null_card_res") #
		print("CardIconVisual update_display: self.name is '", name, "', card_art_texture is valid? ", is_instance_valid(card_art_texture)) #
	if is_instance_valid(card_art_texture) and card_res and not card_res.artwork_path.is_empty():
		var loaded_texture = load(card_res.artwork_path)
		# Print("CardIconVisual update_display: Loaded texture from '", card_res.artwork_path, "'. Result: ", loaded_texture)
		if loaded_texture is Texture2D:
			card_art_texture.texture = loaded_texture
			# Print("CardIconVisual update_display: Texture ASSIGNED to card_art_texture.")
		else:
			card_art_texture.texture = null
			printerr("CardIconVisual: Failed to load art for %s. Path: %s. Loaded type: %s" % [card_res.id, card_res.artwork_path, typeof(loaded_texture)])
	elif is_instance_valid(card_art_texture):
		card_art_texture.texture = null
		if card_res: 
			print("CardIconVisual: Warning: No artwork path for card ID '", card_res.id, "'")
		else: 
			print("CardIconVisual: Warning: Card resource is null in update_display")

	# Ensure default full opacity if not otherwise set by a subsequent call
	# Or, expect the caller to use set_component_modulation if specific alphas are needed.
	# For now, let's assume they start opaque unless set_component_modulation is called.
