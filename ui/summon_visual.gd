# 1. Save this script as res://ui/summon_visual.gd

extends Control # Use Control for UI layout, or Node2D if you need transforms

# --- Properties ---
# These will be set by the BattleReplay script when instantiating
var instance_id: int = -1
var card_id: String = ""
var card_resource: SummonCardResource = null # Optional: Store the resource for easy access

# --- Node References (Set these up in the scene tree) ---
# Use @onready if getting nodes in _ready, or export NodePath if setting in Inspector
@onready var card_art_texture: TextureRect = $CardArtTextureRect # Example path
@onready var power_label: Label = $StatsContainer/PowerLabel # Example path
@onready var hp_label: Label = $StatsContainer/HPLabel # Example path
# @onready var status_icon_container = $StatusIcons # Example path
@onready var animation_player: AnimationPlayer = $AnimationPlayer # Example path


# --- Public Methods ---

# Called by BattleReplay to initialize/update the visual display
func update_display(new_instance_id: int, new_card_res: SummonCardResource, power: int, hp: int, max_hp: int, _tags: Array[String]):
	self.instance_id = new_instance_id
	self.card_resource = new_card_res
	self.card_id = new_card_res.id

	# Update Artwork
	if card_art_texture and card_resource and FileAccess.file_exists(card_resource.artwork_path):
		card_art_texture.texture = load(card_resource.artwork_path)
	elif card_art_texture:
		# Load a default/error texture?
		card_art_texture.texture = null # Or load("res://art/default_summon.png")
		print("Warning: Could not load art for ", card_id)

	# Update Stats Labels
	if power_label:
		power_label.text = str(power) # Just the number for power? Or add icon?
	if hp_label:
		hp_label.text = "%d/%d" % [hp, max_hp] # Format "Current/Max"

	# TODO: Update status icons based on tags array (e.g., show/hide nodes)
	# if status_icon_container:
	#	 var relentless_icon = status_icon_container.get_node("RelentlessIcon")
	#	 if relentless_icon: relentless_icon.visible = tags.has("Relentless")
	#	 var undead_icon = status_icon_container.get_node("UndeadIcon")
	#	 if undead_icon: undead_icon.visible = tags.has(Constants.TAG_UNDEAD)
	#	 # ... etc for other statuses

	print("Updated visual for instance %d (%s): P:%d HP:%d/%d" % [instance_id, card_id, power, hp, max_hp])


# Called by BattleReplay to trigger animations
func play_animation(anim_name: String):
	if animation_player and animation_player.has_animation(anim_name):
		print("Playing animation '%s' for instance %d (%s)" % [anim_name, instance_id, card_id])
		animation_player.play(anim_name)
		# Consider returning the animation player or using await animation_finished
		# return animation_player # Allow caller to await signal
	else:
		printerr("Animation '%s' not found for instance %d (%s)" % [anim_name, instance_id, card_id])


# --- Godot Lifecycle Methods ---

func _ready():
	# Initial setup if needed, e.g., hide status icons by default
	pass
