# res://ui/summon_visual.gd
extends Control
class_name SummonVisual

# --- Constants ---
const DEFAULT_ART_TEXTURE = preload("res://art/DefaultArt_Small.png")
const CARD_FRAME_LOW_RES_PATH = "res://art/cardFrame_lowRes.png" 
# CARD_FRAME_TEXTURE is preloaded in _ready now to ensure it uses the updated path from the .tscn if changed,
# or this path if instantiated from script before being added to scene.
var CARD_FRAME_TEXTURE = preload(CARD_FRAME_LOW_RES_PATH)


# --- Properties ---
@export_group("Summon Properties")
@export var instance_id: int = -1
@export var card_id: String = ""
var card_resource: SummonCardResource = null
var current_power_val: int = 0
var current_hp_val: int = 0
var current_max_hp_val: int = 0

# --- Node References ---
@onready var card_art_texture: TextureRect = $CardArtTextureRect
@onready var power_label: Label = $StatsContainer/PowerLabel
@onready var hp_label: Label = $StatsContainer/HPLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var card_frame_texture: TextureRect = $CardFrameTextureRect


# Called by BattleReplay to initialize/update the visual display
func update_display(new_instance_id: int, new_card_res: SummonCardResource, power: int, hp: int, max_hp: int, _tags: Array[String]):
	self.instance_id = new_instance_id
	self.card_resource = new_card_res
	self.card_id = new_card_res.id if new_card_res else "UNKNOWN_SUMMON_ID"

	# --- Store stats ---
	self.current_power_val = power
	self.current_hp_val = hp
	self.current_max_hp_val = max_hp
	# --- End Store stats ---

	# Update Artwork
	if not is_instance_valid(card_art_texture):
		printerr("SummonVisual: card_art_texture is NOT VALID in update_display for card: ", self.card_id)
		return

	var loaded_specific_art_texture: Texture2D = null
	var attempted_art_path: String = "N/A"

	if card_resource and card_resource.artwork_path != null and not card_resource.artwork_path.is_empty():
		attempted_art_path = card_resource.artwork_path
		if ResourceLoader.exists(attempted_art_path):
			var res = load(attempted_art_path)
			if res is Texture2D:
				loaded_specific_art_texture = res
			else:
				printerr("SummonVisual: Loaded resource from card art path '%s' is not Texture2D, type: %s" % [attempted_art_path, typeof(res)])
		# else: # Path doesn't exist, will fallback
			# print("SummonVisual: Card art path does not exist: ", attempted_art_path) # Optional debug
			
	if loaded_specific_art_texture is Texture2D:
		card_art_texture.texture = loaded_specific_art_texture
		# print("SummonVisual: Successfully loaded art for %s from %s" % [card_id, attempted_art_path]) # Optional debug
	else:
		var reason_for_fallback = "specific art path not found or failed to load"
		if not card_resource:
			reason_for_fallback = "card_resource was null"
		elif card_resource.artwork_path == null or card_resource.artwork_path.is_empty():
			reason_for_fallback = "artwork_path was empty in CardResource"
		
		# Only print an error if a card_resource was provided and specific art was expected but failed.
		# Don't print an error if card_resource was null from the start (that's a different issue).
		if card_resource: 
			printerr("SummonVisual: Failed to load art for %s. Path: '%s' (%s). Using fallback." % [card_id, attempted_art_path, reason_for_fallback])
		
		card_art_texture.texture = DEFAULT_ART_TEXTURE # Assign the preloaded fallback
		
		if not is_instance_valid(card_art_texture.texture): # Should not happen if DEFAULT_ART_TEXTURE is valid
			printerr("SummonVisual: CRITICAL - FALLBACK_CARD_ART_TEXTURE also failed to apply for card %s." % card_id)

	# Update Stats Labels
	update_power_label()
	update_hp_label()

func update_power_label():
	if power_label:
		power_label.text = str(current_power_val)

func update_hp_label():
	if hp_label:
		hp_label.text = "%d/%d" % [current_hp_val, current_max_hp_val]

func set_current_power(new_power: int):
	current_power_val = new_power
	update_power_label()

func set_current_hp(new_hp: int):
	current_hp_val = new_hp
	update_hp_label()

func set_max_hp(new_max_hp: int):
	current_max_hp_val = new_max_hp
	current_hp_val = min(current_hp_val, current_max_hp_val)
	update_hp_label()

func animate_fade_in(duration: float, initial_transparency: float = 0.0) -> Tween:
	modulate.a = initial_transparency
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	return tween
	
func play_animation(anim_name: String):
	if animation_player and animation_player.has_animation(anim_name):
		animation_player.play(anim_name)
	else:
		print("Animation '%s' not found or no AnimationPlayer for instance %d (%s)" % [anim_name, instance_id, card_id])

func animate_scale_pop(peak_scale_factor: float = 1.1, duration_up: float = 0.15, duration_down: float = 0.2) -> Tween:
	pivot_offset = size / 2.0
	var tween = create_tween()
	tween.set_parallel(false)
	tween.tween_property(self, "scale", Vector2(peak_scale_factor, peak_scale_factor), duration_up).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), duration_down).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	return tween

func animate_shake(strength: float = 4.0, duration_per_half_shake: float = 0.04, num_shakes: int = 2) -> Tween:
	var original_position_x = position.x
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT_IN)
	tween.set_parallel(false)
	for i in range(num_shakes):
		tween.tween_property(self, "position:x", original_position_x + strength, duration_per_half_shake)
		tween.tween_property(self, "position:x", original_position_x - strength, duration_per_half_shake)
	tween.tween_property(self, "position:x", original_position_x, duration_per_half_shake)
	return tween

func play_full_arrival_sequence_and_await(p_fade_duration: float = 0.9, 
							   p_pop_peak: float = 1.1, p_pop_dur_up: float = 0.08, p_pop_dur_down: float = 0.12,
							   p_shake_strength: float = 2.0, p_shake_dur: float = 0.04, p_shake_count: int = 2) -> void:
	var _fade_tween: Tween = animate_fade_in(p_fade_duration)
	var _pop_tween: Tween = animate_scale_pop(p_pop_peak, p_pop_dur_up, p_pop_dur_down)
	var shake_tween: Tween = animate_shake(p_shake_strength, p_shake_dur, p_shake_count)
	if shake_tween: await shake_tween.finished
	print("SummonVisual (%d): Full arrival sequence awaited and completed." % instance_id)

func play_attack_animation(is_for_top_lane_card: bool) -> void:
	var anim_name_to_play: String
	if is_for_top_lane_card:
		anim_name_to_play = "Attack_Punch_Top"
	else:
		anim_name_to_play = "Attack_Punch_Bottom"

	if animation_player and animation_player.has_animation(anim_name_to_play):
		animation_player.play(anim_name_to_play)
		print("SummonVisual (%d): Playing %s" % [instance_id, anim_name_to_play])
	else:
		printerr("SummonVisual (%d): Animation '%s' not found or no AnimationPlayer." % [instance_id, anim_name_to_play])
	
func _ready():
	if not is_instance_valid(card_frame_texture):
		printerr("SummonVisual _ready: card_frame_texture node is not valid!")
		return

	# CARD_FRAME_TEXTURE is preloaded. If the .tscn file has a different texture set in the inspector,
	# that one will take precedence for instances created from the scene.
	# For instances created purely from script, this preloaded texture will be used.
	if card_frame_texture.texture == null: # Only set if not already set by the scene
		card_frame_texture.texture = CARD_FRAME_TEXTURE
	
	# Ensure CardArtTextureRect is drawn under the frame by node order in scene or Z-index.
	# Node order is: CardArtTextureRect, then CardFrameTextureRect, then StatsContainer.
	# This means CardFrameTextureRect will draw on top of CardArtTextureRect.
	# StatsContainer will draw on top of both.
