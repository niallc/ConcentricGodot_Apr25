# res://ui/card_icon_visual.gd
extends Control
class_name CardIconVisual

const CARD_FRAME_TEXTURE = preload("res://art/CardFramev11_RoundedCorners_TransparentCentre.png")

@onready var card_art_texture: TextureRect = $CardArtTextureRect
@onready var card_frame_texture: TextureRect = $CardFrameTextureRect

func _ready():
	if card_frame_texture:
		card_frame_texture.texture = CARD_FRAME_TEXTURE
		# Node order or z_index ensures frame is on top

func update_display(card_res: CardResource):
	if card_art_texture and card_res and not card_res.artwork_path.is_empty():
		var loaded_texture = load(card_res.artwork_path)
		if loaded_texture is Texture2D:
			card_art_texture.texture = loaded_texture
		else:
			card_art_texture.texture = null
			printerr("CardIconVisual: Failed to load art for %s. Path: %s. Loaded type: %s" % [card_res.id, card_res.artwork_path, typeof(loaded_texture)])
	elif card_art_texture:
		card_art_texture.texture = null
		if card_res: 
			print("CardIconVisual: Warning: No artwork path for card ID '", card_res.id, "'")
		else: 
			print("CardIconVisual: Warning: Card resource is null in update_display")
