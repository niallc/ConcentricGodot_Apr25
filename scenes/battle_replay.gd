# res://scenes/battle_replay.gd
extends Control

# --- Properties ---
var battle_events: Array[Dictionary] = []
var current_event_index: int = -1
var is_playing: bool = false
var playback_speed_scale: float = 1.0
var step_delay: float = 0.5

var active_summon_visuals: Dictionary = {} # instance_id -> SummonVisual node

const SummonVisualScene = preload("res://ui/summon_visual.tscn")

# Store player names to map to Top/Bottom layout
var player1_name: String = "" # Typically "Player"
var player2_name: String = "" # Typically "Opponent"

# --- Node References ---
@onready var turn_label: Label = $MainMarginContainer/MainVBox/TurnLabel
@onready var event_log_label: Label = $MainMarginContainer/MainVBox/EventLogLabel
@onready var bottom_lane_container: HBoxContainer = $MainMarginContainer/MainVBox/GameAreaVBox/BottomPlayerArea/LaneContainer
@onready var top_lane_container: HBoxContainer = $MainMarginContainer/MainVBox/GameAreaVBox/TopPlayerArea/LaneContainer
@onready var playback_timer: Timer = $MainMarginContainer/PlaybackTimer


# --- Public API ---
func load_and_start_simple_replay(events: Array[Dictionary]):
	print("BattleReplay: Loading %d events." % events.size())
	battle_events = events
	current_event_index = -1
	is_playing = false

	# --- Determine Player Layout ---
	player1_name = "" # Reset for new replay
	player2_name = ""
	var player_names_found = []
	for event in battle_events:
		if event.event_type == "turn_start":
			if not event.player in player_names_found:
				player_names_found.append(event.player)
				if player1_name == "":
					player1_name = event.player
				elif player2_name == "" and event.player != player1_name:
					player2_name = event.player
					break # Found both distinct players
	# Fallback if only one player found (e.g., very short battle)
	if player1_name != "" and player2_name == "":
		# This logic might need adjustment based on how your player names are set in Battle.gd
		# For now, assume if "Player" is found, it's player1_name.
		if player1_name == "Player" and events.size() > 0 and events[0].has("player") and events[0].player != "Player":
			player2_name = events[0].player # A bit of a guess
		elif player1_name != "Opponent": # Generic opponent name
			player2_name = "Opponent"
		else:
			player2_name = "Player" # Default if player1 was "Opponent"

	print("Player 1 (Bottom assumed): ", player1_name)
	print("Player 2 (Top assumed): ", player2_name)


	if not is_node_ready(): await ready

	# Clear previous state
	if turn_label: turn_label.text = "Turn: -"
	if event_log_label: event_log_label.text = "Press Step or Play"

	# Clear existing summon visuals from lanes
	for visual in active_summon_visuals.values():
		if is_instance_valid(visual): visual.queue_free()
	active_summon_visuals.clear()
	# Clear lanes directly too
	if is_instance_valid(bottom_lane_container):
		for lane in bottom_lane_container.get_children():
			for child in lane.get_children(): child.queue_free()
	if is_instance_valid(top_lane_container):
		for lane in top_lane_container.get_children():
			for child in lane.get_children(): child.queue_free()


	call_deferred("_on_step_button_pressed")


# --- Playback Control Logic ---
# ... (as before, ensure signal connections match these snake_case names) ...
func _on_play_button_pressed():
	print("Replay: Play pressed")
	is_playing = true
	if playback_timer: playback_timer.start(step_delay / playback_speed_scale)

func _on_pause_button_pressed():
	print("Replay: Pause pressed")
	is_playing = false
	if playback_timer: playback_timer.stop()

func _on_step_button_pressed():
	print("Replay: Step pressed") # Ensure this prints
	if not is_playing:
		process_next_event()

func _on_playback_timer_timeout():
	if is_playing:
		process_next_event()
	else:
		if playback_timer: playback_timer.stop()


# --- Core Event Processing ---
# ... (process_next_event and match statement as before) ...
func process_next_event():
	current_event_index += 1
	if current_event_index >= battle_events.size():
		print("Replay: End of events reached.")
		is_playing = false
		if playback_timer: playback_timer.stop()
		if event_log_label: event_log_label.text = "--- Battle Ended ---"
		return

	var event = battle_events[current_event_index]
	print("\nProcessing Event %d: %s" % [current_event_index, event])

	if event_log_label: event_log_label.text = "Event %d: %s (%s)" % [current_event_index, event.event_type, event.get("player", "N/A")]


	match event.event_type:
		"turn_start": await handle_turn_start(event)
		"mana_change": await handle_mana_change(event)
		"card_played": await handle_card_played(event)
		"card_moved": await handle_card_moved(event)
		"card_removed": await handle_card_removed(event)
		"summon_arrives": await handle_summon_arrives(event)
		"summon_leaves_lane": await handle_summon_leaves_lane(event)
		"summon_turn_activity": await handle_summon_turn_activity(event)
		"combat_damage": await handle_combat_damage(event)
		"direct_damage": await handle_direct_damage(event)
		"effect_damage": await handle_effect_damage(event)
		"hp_change": await handle_hp_change(event)
		"creature_hp_change": await handle_creature_hp_change(event)
		"stat_change": await handle_stat_change(event)
		"status_change": await handle_status_change(event)
		"creature_defeated": await handle_creature_defeated(event)
		"visual_effect": await handle_visual_effect(event)
		"log_message": await handle_log_message(event)
		"battle_end": await handle_battle_end(event)
		_:
			print("  -> Unhandled event type: ", event.event_type)
			if is_playing: await get_tree().create_timer(0.1 / playback_speed_scale).timeout

	if is_playing and current_event_index < battle_events.size() -1 : # Check if battle ended
		if playback_timer and not playback_timer.is_stopped(): # Check if timer is already running
			playback_timer.start(step_delay / playback_speed_scale)


# --- Helper Functions ---
func get_player_prefix(player_name_from_event: String) -> String:
	if player_name_from_event == player1_name:
		return "Bottom"
	elif player_name_from_event == player2_name:
		return "Top"
	else:
		# Fallback if names don't match (e.g., "Player" vs "PlayerEffectTester")
		# This might happen if test names differ from actual simulation names
		if player_name_from_event.contains("Player"): # Crude check
			return "Bottom"
		elif player_name_from_event.contains("Opponent"):
			return "Top"
		printerr("Unknown player name '%s' for layout. Defaulting to Bottom." % player_name_from_event)
		return "Bottom"

func get_lane_node(player_name_from_event: String, lane_number_from_event: int) -> Node: # lane_number is 1-based
	var prefix = get_player_prefix(player_name_from_event)
	var container_node = null
	if prefix == "Bottom":
		container_node = bottom_lane_container
	elif prefix == "Top":
		container_node = top_lane_container

	if container_node and lane_number_from_event >= 1 and lane_number_from_event <= container_node.get_child_count():
		return container_node.get_child(lane_number_from_event - 1) # Children are 0-indexed
	else:
		printerr("Could not find lane node for %s lane %d" % [player_name_from_event, lane_number_from_event])
		return null


# --- Event Handler Functions ---

func handle_turn_start(event):
	print("  -> Turn %d starts for %s" % [event.turn, event.player])
	if turn_label: turn_label.text = "Turn: %d (%s)" % [event.turn, event.player]
	await get_tree().create_timer(0.5 / playback_speed_scale).timeout

# --- MODIFIED BLOCK START ---
func handle_summon_arrives(event):
	print("  -> %s summons %s (ID: %d) in lane %d. Stats P:%d HP:%d/%d Swift:%s Tags:%s" % [
		event.player, event.card_id, event.instance_id, event.lane,
		event.power, event.current_hp, event.max_hp, event.is_swift, str(event.get("tags", []))
	])

	var target_lane_node = get_lane_node(event.player, event.lane)
	if target_lane_node and SummonVisualScene:
		# Clear any existing visual in that lane first
		for child in target_lane_node.get_children():
			child.queue_free()

		var visual_node = SummonVisualScene.instantiate()
		target_lane_node.add_child(visual_node)
		active_summon_visuals[event.instance_id] = visual_node

		var card_res_path = "res://data/cards/instances/%s.tres" % event.card_id.to_snake_case()
		var card_res = load(card_res_path) if ResourceLoader.exists(card_res_path) else null

		if card_res is SummonCardResource:
			if visual_node.has_method("update_display"):
				var string_array = PackedStringArray()
				visual_node.update_display(event.instance_id, card_res, event.power, event.current_hp, event.max_hp, event.get("tags", string_array))
			else:
				printerr("SummonVisual node is missing update_display method.")
		else:
			printerr("Failed to load SummonCardResource for %s at %s" % [event.card_id, card_res_path])

		if visual_node.has_method("play_animation"):
			visual_node.play_animation("arrive") # Assume "arrive" animation exists
			# if visual_node.animation_player and visual_node.animation_player.has_animation("arrive"):
			# 	await visual_node.animation_player.animation_finished
	else:
		printerr("Could not place summon visual for event: ", event)

	await get_tree().create_timer(0.8 / playback_speed_scale).timeout
# --- MODIFIED BLOCK END ---

# --- MODIFIED BLOCK START ---
func handle_creature_defeated(event):
	print("  -> Creature Defeated: %s lane %d (ID: %d, Card: %s)" % [event.player, event.lane, event.instance_id, event.get("card_id", "N/A")])
	if active_summon_visuals.has(event.instance_id):
		var visual_node = active_summon_visuals[event.instance_id]
		if visual_node.has_method("play_animation"):
			visual_node.play_animation("death")
			# Wait for animation if it exists and is playing
			if visual_node.animation_player and visual_node.animation_player.is_playing() and visual_node.animation_player.has_animation("death"):
				await visual_node.animation_player.animation_finished
			else: # Default delay if no death animation or not playing
				await get_tree().create_timer(0.5 / playback_speed_scale).timeout
		else: # Default delay if no play_animation method
			await get_tree().create_timer(0.5 / playback_speed_scale).timeout

		active_summon_visuals.erase(event.instance_id)
		if is_instance_valid(visual_node): # Check before queue_free
			visual_node.queue_free()
	else:
		printerr("Could not find visual for defeated instance ID %d." % event.instance_id)
	await get_tree().create_timer(0.3 / playback_speed_scale).timeout
# --- MODIFIED BLOCK END ---

# --- MODIFIED BLOCK START ---
func handle_summon_leaves_lane(event): # For bounces etc.
	print("  -> %s's %s (ID: %d) leaves lane %d (Reason: %s)" % [event.player, event.card_id, event.instance_id, event.lane, event.reason])
	if active_summon_visuals.has(event.instance_id):
		var visual_node = active_summon_visuals[event.instance_id]
		if visual_node.has_method("play_animation"):
			visual_node.play_animation("leave") # Assume "leave" animation
			# Similar animation waiting logic as creature_defeated if needed
			if visual_node.animation_player and visual_node.animation_player.is_playing() and visual_node.animation_player.has_animation("leave"):
				await visual_node.animation_player.animation_finished
			else:
				await get_tree().create_timer(0.5 / playback_speed_scale).timeout
		else:
			await get_tree().create_timer(0.5 / playback_speed_scale).timeout

		active_summon_visuals.erase(event.instance_id)
		if is_instance_valid(visual_node): visual_node.queue_free()
	else:
		printerr("Could not find visual for instance ID %d to remove from lane (leaves)." % event.instance_id)
	await get_tree().create_timer(0.3 / playback_speed_scale).timeout
# --- MODIFIED BLOCK END ---


# --- Other handlers (mostly print for now, with await for pacing) ---
func handle_mana_change(event):
	print("  -> %s mana changes by %d. New total: %d (Source: %s)" % [event.player, event.amount, event.new_total, event.get("source", "N/A")])
	await get_tree().create_timer(0.2 / playback_speed_scale).timeout

func handle_card_played(event):
	print("  -> %s played %s (%s). Mana left: %d" % [event.player, event.card_id, event.card_type, event.remaining_mana])
	await get_tree().create_timer(0.8 / playback_speed_scale).timeout

func handle_card_moved(event):
	print("  -> %s's %s moved from %s to %s (Reason: %s)" % [event.player, event.card_id, event.from_zone, event.to_zone, event.get("reason", "N/A")])
	await get_tree().create_timer(0.3 / playback_speed_scale).timeout

func handle_card_removed(event):
	print("  -> %s's %s removed from %s (Reason: %s)" % [event.player, event.card_id, event.from_zone, event.get("reason", "N/A")])
	await get_tree().create_timer(0.2 / playback_speed_scale).timeout

func handle_summon_turn_activity(event):
	print("  -> %s's summon (ID: %d) in lane %d performs action: %s" % [event.player, event.instance_id, event.lane, event.activity_type])
	if active_summon_visuals.has(event.instance_id):
		var visual_node = active_summon_visuals[event.instance_id]
		if visual_node.has_method("play_animation"):
			match event.activity_type:
				"attack", "direct_attack": visual_node.play_animation("attack")
				"ability_mana_gen": visual_node.play_animation("ability")
				_: visual_node.play_animation("ability") # Default
			# if visual_node.animation_player and visual_node.animation_player.is_playing():
			# 	await visual_node.animation_player.animation_finished
	await get_tree().create_timer(0.5 / playback_speed_scale).timeout

func handle_combat_damage(event):
	print("  -> Attack: %s lane %d (ID: %d) -> %s lane %d (ID: %d). Damage: %d. Defender HP left: %d" % [
		event.attacking_player, event.attacking_lane, event.attacking_instance_id,
		event.defending_player, event.defending_lane, event.defending_instance_id,
		event.amount, event.defender_remaining_hp
	])
	await get_tree().create_timer(0.5 / playback_speed_scale).timeout

func handle_direct_damage(event):
	print("  -> Direct Attack: %s lane %d (ID: %d) -> %s. Damage: %d. Target HP left: %d" % [
		event.attacking_player, event.attacking_lane, event.attacking_instance_id,
		event.target_player, event.amount, event.target_player_remaining_hp
	])
	await get_tree().create_timer(0.5 / playback_speed_scale).timeout

func handle_effect_damage(event):
	print("  -> Effect Damage: %s (%s) -> %s. Damage: %d. Target HP left: %d" % [
		event.source_card_id, event.source_player,
		event.target_player, event.amount, event.target_player_remaining_hp
	])
	await get_tree().create_timer(0.5 / playback_speed_scale).timeout

func handle_hp_change(event):
	print("  -> Player HP Change: %s amount %d. New total: %d (Source: %s)" % [event.player, event.amount, event.new_total, event.get("source", "N/A")])
	await get_tree().create_timer(0.3 / playback_speed_scale).timeout

func handle_creature_hp_change(event):
	print("  -> Creature HP Change: %s lane %d (ID: %d) amount %d. New HP: %d/%d (Source: %s)" % [
		event.player, event.lane, event.instance_id, event.amount, event.new_hp, event.new_max_hp, event.get("source", "N/A")
	])
	if active_summon_visuals.has(event.instance_id):
		var visual_node = active_summon_visuals[event.instance_id]
		if visual_node.hp_label: visual_node.hp_label.text = "%d/%d" % [event.new_hp, event.new_max_hp]
		if visual_node.has_method("play_animation"):
			if event.amount > 0: visual_node.play_animation("heal")
			elif event.amount < 0: visual_node.play_animation("damage")
	await get_tree().create_timer(0.4 / playback_speed_scale).timeout

func handle_stat_change(event):
	print("  -> Stat Change: %s lane %d (ID: %d) stat '%s' changes by %d. New value: %d (Source: %s)" % [
		event.player, event.lane, event.instance_id, event.stat, event.amount, event.new_value, event.get("source", "N/A")
	])
	if active_summon_visuals.has(event.instance_id):
		var visual_node = active_summon_visuals[event.instance_id]
		if event.stat == "power" and visual_node.power_label:
			visual_node.power_label.text = str(event.new_value)
		elif event.stat == "max_hp" and visual_node.hp_label:
			var hp_parts = visual_node.hp_label.text.split("/")
			if hp_parts.size() == 2: visual_node.hp_label.text = "%s/%d" % [hp_parts[0], event.new_value]
		if visual_node.has_method("play_animation"):
			visual_node.play_animation("buff" if event.amount > 0 else "debuff")
	await get_tree().create_timer(0.4 / playback_speed_scale).timeout

func handle_status_change(event):
	print("  -> Status Change: %s lane %d (ID: %d) %s status '%s' (Source: %s)" % [
		event.player, event.lane, event.instance_id, "gained" if event.gained else "lost", event.status, event.get("source", "N/A")
	])
	await get_tree().create_timer(0.2 / playback_speed_scale).timeout

func handle_visual_effect(event):
	print("  -> Visual Effect: ID '%s', Targets: %s, Details: %s" % [event.effect_id, str(event.target_locations), str(event.details)])
	await get_tree().create_timer(0.5 / playback_speed_scale).timeout

func handle_log_message(event):
	print("  -> Log Message: %s" % event.message)
	await get_tree().create_timer(0.1 / playback_speed_scale).timeout

func handle_battle_end(event):
	print("--- Battle End ---")
	print("  -> Outcome: %s, Winner: %s" % [event.outcome, event.winner])
	if event_log_label: event_log_label.text = "Battle End: %s wins!" % event.winner
	is_playing = false
	if playback_timer: playback_timer.stop()
