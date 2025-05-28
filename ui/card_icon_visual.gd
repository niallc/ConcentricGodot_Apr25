# res://ui/card_icon_visual.gd
extends Control
class_name CardIconVisual

const CARD_FRAME_TEXTURE = preload("res://art/CardFramev11_RoundedCorners_TransparentCentre.png")

@onready var card_art_texture: TextureRect = $CardArtTextureRect
@onready var card_frame_texture: TextureRect = $CardFrameTextureRect

func _ready():
	if is_instance_valid(card_frame_texture): # Check validity
		card_frame_texture.texture = CARD_FRAME_TEXTURE
	# Default modulation is (1,1,1,1) - fully opaque

# New function to set alphas of components
func set_component_modulation(p_frame_modulate: Color = Color(1,1,1,1), p_art_modulate: Color = Color(1,1,1,1)):
	if is_instance_valid(card_frame_texture):
		card_frame_texture.modulate = p_frame_modulate
	if is_instance_valid(card_art_texture):
		card_art_texture.modulate = p_art_modulate

func update_display(card_res: CardResource): # Removed optional alpha args for simplicity here
	print("CardIconVisual update_display: Called for card_res: ", card_res.id if card_res else "null_card_res") #
	print("CardIconVisual update_display: self.name is '", name, "', card_art_texture is valid? ", is_instance_valid(card_art_texture)) #
	if is_instance_valid(card_art_texture) and card_res and not card_res.artwork_path.is_empty():
		var loaded_texture = load(card_res.artwork_path)
		print("CardIconVisual update_display: Loaded texture from '", card_res.artwork_path, "'. Result: ", loaded_texture) #
		if loaded_texture is Texture2D:
			card_art_texture.texture = loaded_texture
			print("CardIconVisual update_display: Texture ASSIGNED to card_art_texture.") #
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
