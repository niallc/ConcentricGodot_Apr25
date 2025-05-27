# res://ui/summon_visual.gd
extends Control
class_name SummonVisual

# --- Constants ---
const CARD_FRAME_TEXTURE = preload("res://art/CardFramev11_RoundedCorners_TransparentCentre.png")

# --- Properties ---
var instance_id: int = -1
var card_id: String = ""
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
	self.card_id = new_card_res.id if new_card_res else "UNKNOWN"

	# --- Store stats ---
	self.current_power_val = power
	self.current_hp_val = hp
	self.current_max_hp_val = max_hp
	# --- End Store stats ---

	# Update Artwork
	if card_art_texture and card_resource and not card_resource.artwork_path.is_empty():
		var loaded_texture = load(card_resource.artwork_path)
		if loaded_texture is Texture2D:
			card_art_texture.texture = loaded_texture
			# print("Successfully loaded art for %s from %s" % [card_id, card_resource.artwork_path]) # Less verbose
		else:
			card_art_texture.texture = null
			printerr("Failed to load art for %s. Path: %s. Loaded type: %s" % [card_id, card_resource.artwork_path, typeof(loaded_texture)])
	elif card_art_texture:
		card_art_texture.texture = null
		if card_resource: print("Warning: No artwork path for ", card_id)
		else: print("Warning: Card resource is null for instance ", instance_id)

	# Update Stats Labels
	update_power_label()
	update_hp_label()

	# TODO: Update status icons based on tags array

	print("Updated visual for instance %d (%s): %d HP:%d/%d" % [instance_id, card_id, current_power_val, current_hp_val, current_max_hp_val])

	# --- MODIFIED: Call debug print from here if needed ---
	# if get_tree().get_root().get_node_or_null("Placeholder_Root_Node2D/BattleReplayScene"):
	# 	var battle_replay_node = get_tree().get_root().get_node("Placeholder_Root_Node2D/BattleReplayScene")
	# 	if battle_replay_node.has_method("debug_print_node_layout_info"):
	# 		battle_replay_node.debug_print_node_layout_info(card_art_texture, "CardArtTextureRect (Child of SummonVisual)")
	# 		battle_replay_node.debug_print_node_layout_info(self, "SummonVisual (Self)")
	# 		if get_parent() is Control:
	# 			battle_replay_node.debug_print_node_layout_info(get_parent(), "Parent Lane Panel")

func update_power_label():
	if power_label:
		power_label.text = "" + str(current_power_val)

func update_hp_label():
	if hp_label:
		hp_label.text = "%d/%d" % [current_hp_val, current_max_hp_val]

func set_current_power(new_power: int):
	current_power_val = new_power
	update_power_label()

func set_current_hp(new_hp: int):
	current_hp_val = new_hp
	update_hp_label() # Max HP hasn't changed, just current

func set_max_hp(new_max_hp: int):
	current_max_hp_val = new_max_hp
	# current_hp_val might need clamping if max_hp decreased below current_hp
	current_hp_val = min(current_hp_val, current_max_hp_val)
	update_hp_label()

func animate_fade_in(duration: float, initial_transparency: float = 0.0) -> Tween:
	modulate.a = initial_transparency
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	print("SummonVisual: Starting fade-in animation for instance %d over %s seconds" % [instance_id, duration])
	return tween
	
func play_animation(anim_name: String):
	if animation_player and animation_player.has_animation(anim_name):
		print("Playing animation '%s' for instance %d (%s)" % [anim_name, instance_id, card_id])
		animation_player.play(anim_name)
	else:
		# Don't treat as error if common anims like "arrive" are missing initially
		print("Animation '%s' not found or no AnimationPlayer for instance %d (%s)" % [anim_name, instance_id, card_id])

func animate_scale_pop(peak_scale_factor: float = 1.1, duration_up: float = 0.15, duration_down: float = 0.2) -> Tween:
	# Ensure pivot is centered right before scaling for accuracy
	pivot_offset = size / 2.0
	
	# Optional: Start slightly smaller to make the pop more pronounced
	# scale = Vector2(0.95, 0.95) 

	var tween = create_tween()
	tween.set_parallel(false) # Ensure sequence

	# Scale up
	tween.tween_property(self, "scale", Vector2(peak_scale_factor, peak_scale_factor), duration_up).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	# Scale back to normal
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), duration_down).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	
	print("SummonVisual (%d): Playing scale pop." % instance_id)
	return tween

func animate_shake(strength: float = 4.0, duration_per_half_shake: float = 0.04, num_shakes: int = 2) -> Tween:
	var original_position_x = position.x
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT_IN) # SINE is good for shakes
	tween.set_parallel(false)

	for i in range(num_shakes):
		tween.tween_property(self, "position:x", original_position_x + strength, duration_per_half_shake)
		tween.tween_property(self, "position:x", original_position_x - strength, duration_per_half_shake)
	
	tween.tween_property(self, "position:x", original_position_x, duration_per_half_shake)
	
	print("SummonVisual (%d): Playing subtle, faster shake." % instance_id)
	return tween

func play_full_arrival_sequence_and_await(p_fade_duration: float = 0.9, 
							   p_pop_peak: float = 1.1, p_pop_dur_up: float = 0.08, p_pop_dur_down: float = 0.12,
							   p_shake_strength: float = 2.0, p_shake_dur: float = 0.04, p_shake_count: int = 2) -> void:
	var _fade_tween: Tween = animate_fade_in(p_fade_duration)
	# If you want fade to mostly finish before pop:
	#if fade_tween: await fade_tween.finished 
	# Or, for overlap, remove the await above and maybe add a small delay before pop
	# await get_tree().create_timer(0.1).timeout # Tiny delay example

	var _pop_tween: Tween = animate_scale_pop(p_pop_peak, p_pop_dur_up, p_pop_dur_down)
	#if _pop_tween: await pop_tween.finished

	var shake_tween: Tween = animate_shake(p_shake_strength, p_shake_dur, p_shake_count)
	if shake_tween: await shake_tween.finished

	## Optional: a very brief pause before shake
	## await get_tree().create_timer(0.05).timeout
#
	print("SummonVisual (%d): Full arrival sequence awaited and completed." % instance_id)

func play_attack_animation(is_for_top_lane_card: bool) -> void:
	var anim_name_to_play: String
	if is_for_top_lane_card:
		anim_name_to_play = "Attack_Punch_Top"
	else:
		anim_name_to_play = "Attack_Punch_Bottom"

	if animation_player and animation_player.has_animation(anim_name_to_play):
		# Optional: ensure pivot is correct if animation involves scale/rotation from center
		# pivot_offset = size / 2.0 
		animation_player.play(anim_name_to_play)
		print("SummonVisual (%d): Playing %s" % [instance_id, anim_name_to_play])
	else:
		printerr("SummonVisual (%d): Animation '%s' not found or no AnimationPlayer." % [instance_id, anim_name_to_play])
	
func _ready():
	if card_frame_texture:
		card_frame_texture.texture = CARD_FRAME_TEXTURE
		card_frame_texture.modulate.a = 1 # Make frame semi-transparent
	if card_art_texture:
		card_art_texture.modulate.a = 1   # Make art semi-transparent	# Ensure CardArtTextureRect is drawn under the frame
	# This can also be done by node order in the scene tree.
	# If CardFrameTextureRect is later in the tree, it draws on top.
	# Otherwise, you could explicitly set z_index if they were at the same level
	# in a more complex hierarchy, but tree order is simplest here.
	# e.g., card_art_texture.z_index = 0
	#       card_frame_texture.z_index = 1
