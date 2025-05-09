# res://ui/summon_visual.gd
extends Control

# --- Properties ---
var instance_id: int = -1
var card_id: String = ""
var card_resource: SummonCardResource = null

# --- Node References ---
@onready var card_art_texture: TextureRect = $CardArtTextureRect
@onready var power_label: Label = $StatsContainer/PowerLabel
@onready var hp_label: Label = $StatsContainer/HPLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer


# --- Public Methods ---
func update_display(new_instance_id: int, new_card_res: SummonCardResource, power: int, hp: int, max_hp: int, _tags: Array[String]): # Added underscore to tags
	self.instance_id = new_instance_id
	self.card_resource = new_card_res
	self.card_id = new_card_res.id if new_card_res else "UNKNOWN" # Handle null card_res

	# --- MODIFIED BLOCK START ---
	# Update Artwork (Simplified loading)
	if card_art_texture and card_resource and not card_resource.artwork_path.is_empty():
		var test_location = "res://art/recurringSkeleton.webp"
		var TEST_TEXTURE = load(test_location)
		if TEST_TEXTURE is Texture2D: # Check if TEST load was successful and is a texture
			print("Successfully loaded TEST art for %s from %s" % ["TEST", test_location])
		else:
			printerr("Failed to load TEST art at: %s" % [test_location])
		var filename_check = test_location == card_resource.artwork_path
		if filename_check:
			print("Filenames apparently match.")
		else:
			print("Filenames do not match.")
			print("test: ", test_location)
			print("card: ", card_resource.artwork_path)

		var loaded_texture = load(card_resource.artwork_path)
		if loaded_texture is Texture2D: # Check if load was successful and is a texture
			card_art_texture.texture = loaded_texture
			print("Successfully loaded art for %s from %s" % [card_id, card_resource.artwork_path])
		else:
			card_art_texture.texture = null # Clear if load failed
			printerr("Failed to load art for %s. Path: %s. Loaded type: %s" % [card_id, card_resource.artwork_path, typeof(loaded_texture)])
	elif card_art_texture:
		card_art_texture.texture = null # Clear if no path or resource
		if card_resource:
			print("Warning: No artwork path for ", card_id)
		else:
			print("Warning: Card resource is null for instance ", instance_id)
	# --- MODIFIED BLOCK END ---

	# Update Stats Labels
	if power_label:
		power_label.text = "P: " + str(power) # Added "P: " prefix
	if hp_label:
		hp_label.text = "%d/%d" % [hp, max_hp] # Format "Current/Max"

	# TODO: Update status icons based on tags array

	print("Updated visual for instance %d (%s): P:%d HP:%d/%d" % [instance_id, card_id, power, hp, max_hp])


func play_animation(anim_name: String):
	if animation_player and animation_player.has_animation(anim_name):
		print("Playing animation '%s' for instance %d (%s)" % [anim_name, instance_id, card_id])
		animation_player.play(anim_name)
	else:
		# Don't treat as error if common anims like "arrive" are missing initially
		print("Animation '%s' not found or no AnimationPlayer for instance %d (%s)" % [anim_name, instance_id, card_id])


func _ready():
	pass
