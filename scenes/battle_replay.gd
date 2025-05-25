# res://scenes/battle_replay.gd
extends Control
class_name BattleReplay

# --- Properties ---
var battle_events: Array[Dictionary] = []
var current_event_index: int = -1
var is_playing: bool = false
var playback_speed_scale: float = 8.0
var step_delay: float = 0.5

var active_summon_visuals: Dictionary = {} # instance_id -> SummonVisual node

const SummonVisualScene = preload("res://ui/summon_visual.tscn")

# Store player names to map to Top/Bottom layout
var player1_name: String = "" # Typically "Player"
var player2_name: String = "" # Typically "Opponent"

# --- Node References ---
@onready var turn_label: Label = $MainMarginContainer/MainVBox/TurnAndEvents/TurnLabel
@onready var event_log_label: Label = $MainMarginContainer/MainVBox/TurnAndEvents/EventLogLabel
@onready var bottom_lane_container: HBoxContainer = $MainMarginContainer/MainVBox/GameAreaVBox/BottomPlayerArea/BottomPlayerVBox/LaneContainer
@onready var top_lane_container: HBoxContainer = $MainMarginContainer/MainVBox/GameAreaVBox/TopPlayerArea/TopPlayerVBox/LaneContainer
@onready var playback_timer: Timer = $MainMarginContainer/PlaybackTimer
# --- Player UI References ---
@onready var bottom_player_hp_label: Label = $MainMarginContainer/MainVBox/GameAreaVBox/BottomPlayerArea/BottomPlayerVBox/LifeAndMana/PlayerHPLabel
@onready var bottom_player_mana_label: Label = $MainMarginContainer/MainVBox/GameAreaVBox/BottomPlayerArea/BottomPlayerVBox/LifeAndMana/PlayerManaLabel
@onready var top_player_hp_label: Label = $MainMarginContainer/MainVBox/GameAreaVBox/TopPlayerArea/TopPlayerVBox/LifeAndMana/PlayerHPLabel
@onready var top_player_mana_label: Label = $MainMarginContainer/MainVBox/GameAreaVBox/TopPlayerArea/TopPlayerVBox/LifeAndMana/PlayerManaLabel
# --- Player Graveyard and Library References ---
#@onready var bottom_player_library_hbox: HBoxContainer = $MainMarginContainer/MainVBox/GameAreaVBox/BottomPlayerArea/BottomPlayerVBox/LibraryAndGraveyard/Library
#@onready var bottom_player_graveyard_hbox: HBoxContainer = $MainMarginContainer/MainVBox/GameAreaVBox/BottomPlayerArea/BottomPlayerVBox/LibraryAndGraveyard/Graveyard
#@onready var top_player_library_hbox: HBoxContainer = $MainMarginContainer/MainVBox/GameAreaVBox/TopPlayerArea/TopPlayerVBox/LibraryAndGraveyard/Library
#@onready var top_player_graveyard_hbox: HBoxContainer = $MainMarginContainer/MainVBox/GameAreaVBox/TopPlayerArea/TopPlayerVBox/LibraryAndGraveyard/Graveyard
@onready var bottom_player_library_hbox: HBoxContainer = $MainMarginContainer/MainVBox/GameAreaVBox/BottomPlayerArea/BottomPlayerVBox/LibraryAndGraveyard/Library
@onready var bottom_player_graveyard_hbox: HBoxContainer = $MainMarginContainer/MainVBox/GameAreaVBox/BottomPlayerArea/BottomPlayerVBox/LibraryAndGraveyard/Graveyard
@onready var top_player_library_hbox: HBoxContainer = $MainMarginContainer/MainVBox/GameAreaVBox/TopPlayerArea/TopPlayerVBox/LibraryAndGraveyard/Library
@onready var top_player_graveyard_hbox: HBoxContainer = $MainMarginContainer/MainVBox/GameAreaVBox/TopPlayerArea/TopPlayerVBox/LibraryAndGraveyard/Graveyard
@onready var top_player_library_count_label: Label = $MainMarginContainer/MainVBox/GameAreaVBox/TopPlayerArea/TopPlayerVBox/LibraryAndGraveyard/LibraryCountLabel # Add this node in scene
@onready var top_player_graveyard_count_label: Label = $MainMarginContainer/MainVBox/GameAreaVBox/TopPlayerArea/TopPlayerVBox/LibraryAndGraveyard/GraveyardCountLabel # Add this node in scene
@onready var bottom_player_library_count_label: Label = $MainMarginContainer/MainVBox/GameAreaVBox/BottomPlayerArea/BottomPlayerVBox/LibraryAndGraveyard/LibraryCountLabel # Add this node in scene
@onready var bottom_player_graveyard_count_label: Label = $MainMarginContainer/MainVBox/GameAreaVBox/BottomPlayerArea/BottomPlayerVBox/LibraryAndGraveyard/GraveyardCountLabel # Add this node in scene

# --- Store Graveyard and Library Card Names ---
#var player1_library_cards: Array[String] = []
#var player1_graveyard_cards: Array[String] = []
#var player2_library_cards: Array[String] = []
#var player2_graveyard_cards: Array[String] = []
var player1_library_card_ids: Array[String] = []
var player1_graveyard_card_ids: Array[String] = []
var player2_library_card_ids: Array[String] = []
var player2_graveyard_card_ids: Array[String] = []

# --- Public API & Playback Control ---
func load_and_start_simple_replay(initial_events: Array[Dictionary]):
	print("BattleReplay: Loading %d events." % initial_events.size())
	self.battle_events = initial_events
	current_event_index = -1
	is_playing = false

	# --- Clear graveyards and libraries ----
	player1_library_card_ids.clear()
	player1_graveyard_card_ids.clear()
	player2_library_card_ids.clear()
	player2_graveyard_card_ids.clear()
	# Clear initial display
	_update_zone_display(top_player_library_hbox, player1_library_card_ids, top_player_library_count_label)
	_update_zone_display(top_player_graveyard_hbox, player1_graveyard_card_ids, top_player_graveyard_count_label)
	_update_zone_display(bottom_player_library_hbox, player2_library_card_ids, bottom_player_library_count_label) # Assuming player1 is bottom
	_update_zone_display(bottom_player_graveyard_hbox, player2_graveyard_card_ids, bottom_player_graveyard_count_label)

	# --- Determine Player Names ---
	_determine_player_identities(self.battle_events) # Uses the class member battle_events
	print("Player 1 (Bottom UI): ", player1_name)
	print("Player 2 (Top UI): ", player2_name)

	if not is_node_ready(): await ready
	if turn_label: turn_label.text = "Turn: -"
	if event_log_label: event_log_label.text = "Press Step or Play"

	# Initialize Player UI
	if bottom_player_hp_label: bottom_player_hp_label.text = "HP: %d" % Constants.STARTING_HP
	if bottom_player_mana_label: bottom_player_mana_label.text = "Mana: %d" % Constants.STARTING_MANA
	if top_player_hp_label: top_player_hp_label.text = "HP: %d" % Constants.STARTING_HP
	if top_player_mana_label: top_player_mana_label.text = "Mana: %d" % Constants.STARTING_MANA

	for visual in active_summon_visuals.values():
		if is_instance_valid(visual): visual.queue_free()
	active_summon_visuals.clear()
	if is_instance_valid(bottom_lane_container):
		for lane in bottom_lane_container.get_children():
			for child in lane.get_children(): child.queue_free()
	if is_instance_valid(top_lane_container):
		for lane in top_lane_container.get_children():
			for child in lane.get_children(): child.queue_free()

	# --- Process initial library state events immediately ---
	var initial_events_processed_count = 0
	for i in range(initial_events.size()):
		var event = initial_events[i]
		if event.get("event_type") == "initial_library_state":
			# Call directly, don't wait for timer in this initial setup
			# handle_initial_library_state(event) # This has an await, let's inline a non-await version for setup
			# --- Inlined version of handle_initial_library_state for setup ---
			var target_library_arr_ref: Array = []
			var target_library_display_node: HBoxContainer = null
			var target_library_count_label: Label = null

			if event.player == player1_name:
				target_library_arr_ref = player1_library_card_ids
				target_library_display_node = bottom_player_library_hbox
				target_library_count_label = bottom_player_library_count_label
			elif event.player == player2_name:
				target_library_arr_ref = player2_library_card_ids
				target_library_display_node = top_player_library_hbox
				target_library_count_label = top_player_library_count_label
			
			if target_library_arr_ref != null:
				target_library_arr_ref.clear()
				for card_id_str in event.card_ids:
					target_library_arr_ref.append(card_id_str)
				if target_library_display_node:
					_update_zone_display(target_library_display_node, target_library_arr_ref, target_library_count_label)
			# --- End Inlined version ---
			initial_events_processed_count += 1
		elif event.get("event_type") == "turn_start": # Stop after initial library, before first turn starts
			break 
		else: # Should only be initial_library_state events before first turn_start
			initial_events_processed_count += 1 # Count any other pre-turn_start events too

	current_event_index = initial_events_processed_count - 1 # Start processing from the event AFTER initial ones
	
	if event_log_label: event_log_label.text = "Press Step or Play"
	# call_deferred("_on_step_button_pressed") # Or let user press play/step

	call_deferred("_on_step_button_pressed")

func _on_play_button_pressed():
	print("Replay: Play pressed")
	is_playing = true
	if playback_timer: playback_timer.start(step_delay / playback_speed_scale)

func _on_pause_button_pressed():
	print("Replay: Pause pressed")
	is_playing = false
	if playback_timer: playback_timer.stop()

func _on_step_button_pressed():
	print("Replay: Step pressed")
	if not is_playing: process_next_event()

func _on_playback_timer_timeout():
	if is_playing: process_next_event()
	else:
		if playback_timer: playback_timer.stop()


# --- Core Event Processing ---
func process_next_event():
	current_event_index += 1
	if current_event_index >= battle_events.size():
		print("Replay: End of events reached.")
		is_playing = false
		if playback_timer: playback_timer.stop()
		if event_log_label: event_log_label.text = "--- Battle Ended ---"
		return

	var event = battle_events[current_event_index]
	if event_log_label:
		# DEFENSIVE CHECKING
		if not event is Dictionary:
			event_log_label.text = "Event %d: ERROR - Event is not a Dictionary. Type: %s" % [current_event_index, typeof(event)]
			printerr("Event %d is not a Dictionary: %s" % [current_event_index, event])
		elif not event.has("event_type"):
			event_log_label.text = "Event %d: ERROR - Event missing 'event_type'. Keys: %s" % [current_event_index, event.keys()]
			printerr("Event %d missing 'event_type': %s" % [current_event_index, event])
		else:
			event_log_label.text = "Event %d: %s (%s)" % [current_event_index, event.event_type, event.get("player", "N/A")] # Your original line

	print("\nProcessing Event %d: %s" % [current_event_index, event])

	if event_log_label: event_log_label.text = "Event %d: %s (%s)" % [current_event_index, event.event_type, event.get("player", "N/A")]

	# Temporary debugging code:
	#if event.event_id == 35:
		#print("Checking Goblin Firework going to the graveyard.")

	match event.event_type:
		"initial_library_state": await handle_initial_library_state(event) # Add this
		"turn_start": await handle_turn_start(event)
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

	if is_playing and current_event_index < battle_events.size() -1 :
		if playback_timer and not playback_timer.is_stopped():
			playback_timer.start(step_delay / playback_speed_scale)


# --- Helper Functions ---
func get_player_prefix(player_name_from_event: String) -> String:
	if player_name_from_event == player1_name:
		return "Bottom"
	elif player_name_from_event == player2_name:
		return "Top"
	else:
		if player_name_from_event.contains("Player"):
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
		return container_node.get_child(lane_number_from_event - 1)
	else:
		printerr("Could not find lane node for %s lane %d" % [player_name_from_event, lane_number_from_event])
		return null


# --- Event Handler Functions ---

func handle_turn_start(event):
	print("  -> Turn %d starts for %s" % [event.turn, event.player])
	if turn_label: turn_label.text = "Turn: %d (%s)" % [event.turn, event.player]
	await get_tree().create_timer(0.5 / playback_speed_scale).timeout

# Fix for tags default
func handle_summon_arrives(event):
	print("  -> %s summons %s (ID: %d) in lane %d. Stats P:%d HP:%d/%d Swift:%s Tags:%s" % [
		event.player, event.card_id, event.instance_id, event.lane,
		event.power, event.current_hp, event.max_hp, event.is_swift, str(event.get("tags", PackedStringArray())) # Use PackedStringArray for default
	])

	var target_lane_node = get_lane_node(event.player, event.lane)
	if target_lane_node and SummonVisualScene:
		for child in target_lane_node.get_children():
			child.queue_free()

		var visual_node = SummonVisualScene.instantiate()
		target_lane_node.add_child(visual_node)
		active_summon_visuals[event.instance_id] = visual_node

		var card_res_path = "res://data/cards/instances/%s.tres" % event.card_id.to_snake_case()
		var card_res = load(card_res_path) if ResourceLoader.exists(card_res_path) else null

		if card_res is SummonCardResource:
			if visual_node.has_method("update_display"):
				# Pass the correctly typed default if "tags" is missing
				visual_node.update_display(event.instance_id, card_res, event.power, event.current_hp, event.max_hp, event.get("tags", PackedStringArray()))
				if visual_node.has_method("animate_fade_in"):
					visual_node.animate_fade_in(0.7)
			else:
				printerr("SummonVisual node is missing update_display method.")
		else:
			printerr("Failed to load SummonCardResource for %s at %s" % [event.card_id, card_res_path])

		if visual_node.has_method("play_animation"):
			visual_node.play_animation("arrive")
	else:
		printerr("Could not place summon visual for event: ", event)

	await get_tree().create_timer(0.8 / playback_speed_scale).timeout

# (Ensure is_instance_valid checks)
func handle_creature_defeated(event):
	print("  -> Creature Defeated: %s lane %d (ID: %d, Card: %s)" % [event.player, event.lane, event.instance_id, event.get("card_id", "N/A")])
	if active_summon_visuals.has(event.instance_id):
		var visual_node = active_summon_visuals[event.instance_id]
		if is_instance_valid(visual_node) and visual_node.has_method("play_animation"): # Check valid before calling
			visual_node.play_animation("death")
			if visual_node.animation_player and visual_node.animation_player.is_playing() and visual_node.animation_player.has_animation("death"):
				await visual_node.animation_player.animation_finished
			else: 
				await get_tree().create_timer(0.5 / playback_speed_scale).timeout
		else: 
			await get_tree().create_timer(0.5 / playback_speed_scale).timeout

		active_summon_visuals.erase(event.instance_id)
		if is_instance_valid(visual_node): 
			visual_node.queue_free()
	else:
		printerr("Could not find visual for defeated instance ID %d." % event.instance_id)
	await get_tree().create_timer(0.3 / playback_speed_scale).timeout
# --- MODIFIED BLOCK END ---

# --- MODIFIED BLOCK START ---
# (Ensure is_instance_valid checks)
func handle_summon_leaves_lane(event): 
	print("  -> %s's %s (ID: %d) leaves lane %d (Reason: %s)" % [event.player, event.card_id, event.instance_id, event.lane, event.reason])
	if active_summon_visuals.has(event.instance_id):
		var visual_node = active_summon_visuals[event.instance_id]
		if is_instance_valid(visual_node) and visual_node.has_method("play_animation"): # Check valid
			visual_node.play_animation("leave")
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
	var target_mana_label: Label = null
	if event.player == player1_name: # Bottom player
		target_mana_label = bottom_player_mana_label
	elif event.player == player2_name: # Top player
		target_mana_label = top_player_mana_label
	
	if is_instance_valid(target_mana_label):
		target_mana_label.text = "Mana: %d" % event.new_total
	else:
		printerr("Could not find mana label for player: ", event.player)
	# TODO: Visual update for mana crystals/bar
	await get_tree().create_timer(0.2 / playback_speed_scale).timeout

func handle_card_played(event):
	print("  -> %s played %s (%s). Mana left: %d" % [event.player, event.card_id, event.card_type, event.remaining_mana])
	await get_tree().create_timer(0.8 / playback_speed_scale).timeout

func handle_card_moved(event):
	print("  -> %s's %s moved from %s to %s (Reason: %s)" % [event.player, event.card_id, event.from_zone, event.to_zone, event.get("reason", "N/A")])

	var target_library_arr: Array = []
	var target_graveyard_arr: Array = []
	var target_library_display_node: HBoxContainer = null
	var target_graveyard_display_node: HBoxContainer = null
	var target_library_count_label: Label = null
	var target_graveyard_count_label: Label = null

	var card_id_to_move = event.card_id

	if event.player == player1_name: # Assuming player1_name is bottom player
		target_library_arr = player1_library_card_ids
		target_graveyard_arr = player1_graveyard_card_ids
		target_library_display_node = bottom_player_library_hbox
		target_graveyard_display_node = bottom_player_graveyard_hbox
		# target_library_count_label = bottom_player_library_count_label # Assign if you added these
		# target_graveyard_count_label = bottom_player_graveyard_count_label
	elif event.player == player2_name: # Assuming player2_name is top player
		target_library_arr = player2_library_card_ids
		target_graveyard_arr = player2_graveyard_card_ids
		target_library_display_node = top_player_library_hbox
		target_graveyard_display_node = top_player_graveyard_hbox
		# target_library_count_label = top_player_library_count_label
		# target_graveyard_count_label = top_player_graveyard_count_label
	else:
		printerr("Card Moved: Unknown player %s" % event.player)
		await get_tree().create_timer(0.1 / playback_speed_scale).timeout
		return

	# Remove from 'from_zone'
	match event.from_zone:
		"library":
			var idx = target_library_arr.find(card_id_to_move) # This assumes unique cards, or just removes first found
			if idx != -1:
				target_library_arr.remove_at(idx)
			else: # If not found, it implies the library might not be fully tracked from turn 0.
				print("Card %s not found in %s's library to remove (from_zone)." % [card_id_to_move, event.player])
		"graveyard":
			var idx = target_graveyard_arr.find(card_id_to_move)
			if idx != -1:
				target_graveyard_arr.remove_at(idx)
		"lane":
			pass # Handled by creature_defeated or summon_leaves_lane for visuals
		"play":
			pass # Transient zone, no persistent visual array needed

	# Add to 'to_zone'
	match event.to_zone:
		"library":
			# The event spec has from_details/to_details for top/bottom.
			# For simplicity here, we'll just append. Precise ordering needs more.
			var card_target_position = event.get("to_details", {}).get("position", "top")
			if card_target_position == "bottom":
				target_library_arr.append(card_id_to_move)
			else: # top or unspecified
				target_library_arr.insert(0, card_id_to_move)
		"graveyard":
			target_graveyard_arr.append(card_id_to_move)
		"lane":
			pass # Handled by summon_arrives for visuals
		"play":
			pass # Transient zone

	# Update displays
	if target_library_display_node:
		_update_zone_display(target_library_display_node, target_library_arr, target_library_count_label)
	if target_graveyard_display_node:
		_update_zone_display(target_graveyard_display_node, target_graveyard_arr, target_graveyard_count_label)

	await get_tree().create_timer(0.3 / playback_speed_scale).timeout

func handle_card_removed(event):
	var player_name_from_event = event.player
	var card_id_str = event.card_id
	var from_zone_str = event.from_zone
	var reason_str = event.get("reason", "N/A")

	print("  -> %s's %s removed from %s (Reason: %s)" % [player_name_from_event, card_id_str, from_zone_str, reason_str])

	var target_array_ref: Array
	var target_display_node: HBoxContainer = null
	var target_count_label: Label = null
	#var was_library_event = false

	if player_name_from_event == self.player1_name: # Bottom player
		match from_zone_str:
			"graveyard":
				target_array_ref = player1_graveyard_card_ids
				target_display_node = bottom_player_graveyard_hbox
				target_count_label = bottom_player_graveyard_count_label
			"library":
				target_array_ref = player1_library_card_ids
				target_display_node = bottom_player_library_hbox
				target_count_label = bottom_player_library_count_label
				#was_library_event = true
			_:
				printerr("handle_card_removed: Unknown from_zone '%s' for player %s" % [from_zone_str, player_name_from_event])
				
	elif player_name_from_event == self.player2_name: # Top player
		match from_zone_str:
			"graveyard":
				target_array_ref = player2_graveyard_card_ids
				target_display_node = top_player_graveyard_hbox
				target_count_label = top_player_graveyard_count_label
			"library":
				target_array_ref = player2_library_card_ids
				target_display_node = top_player_library_hbox
				target_count_label = top_player_library_count_label
				#was_library_event = true
			_:
				printerr("handle_card_removed: Unknown from_zone '%s' for player %s" % [from_zone_str, player_name_from_event])
	else:
		printerr("handle_card_removed: Unknown player %s" % player_name_from_event)

	if target_array_ref != null:
		var card_idx = -1
		# For "library", the event might need to specify "top" or "bottom" if it's not always the first match.
		# The spec for card_removed doesn't specify position, so we assume removing any instance of it.
		# If it's "mill from top/bottom", that should ideally be a 'card_moved' to a "limbo" or "removed" zone.
		# If 'card_removed' from library is like "opponent discards random card", then finding is okay.
		# For Superior Intellect clearing opponent's graveyard, this will remove all cards one by one.
		
		card_idx = target_array_ref.find(card_id_str) # Finds first occurrence
		if card_idx != -1:
			target_array_ref.remove_at(card_idx)
			if is_instance_valid(target_display_node):
				_update_zone_display(target_display_node, target_array_ref, target_count_label)
		else:
			printerr("handle_card_removed: Card '%s' not found in %s's %s to remove." % [card_id_str, player_name_from_event, from_zone_str])
	
	await get_tree().create_timer(0.2 / playback_speed_scale).timeout

func handle_summon_turn_activity(event):
	print("  -> %s's summon (ID: %d) in lane %d performs action: %s" % [event.player, event.instance_id, event.lane, event.activity_type])
	if active_summon_visuals.has(event.instance_id):
		var visual_node = active_summon_visuals[event.instance_id]
		if is_instance_valid(visual_node) and visual_node.has_method("play_animation"): # Check valid
			match event.activity_type:
				"attack", "direct_attack": visual_node.play_animation("attack")
				"ability_mana_gen": visual_node.play_animation("ability")
				_: visual_node.play_animation("ability") # Default
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

func handle_hp_change(event): # Player HP
	print("  -> Player HP Change: %s amount %d. New total: %d (Source: %s)" % [event.player, event.amount, event.new_total, event.get("source", "N/A")])
	var target_hp_label: Label = null
	if event.player == player1_name: # Bottom player
		target_hp_label = bottom_player_hp_label
	elif event.player == player2_name: # Top player
		target_hp_label = top_player_hp_label
	
	if is_instance_valid(target_hp_label):
		target_hp_label.text = "HP: %d" % event.new_total
	else:
		printerr("Could not find HP label for player: ", event.player)
	# TODO: Update player HP bar visual
	await get_tree().create_timer(0.3 / playback_speed_scale).timeout

func handle_creature_hp_change(event):
	print("  -> Creature HP Change: %s lane %d (ID: %d) amount %d. New HP: %d/%d (Source: %s)" % [
		event.player, event.lane, event.instance_id, event.amount, event.new_hp, event.new_max_hp, event.get("source", "N/A")
	])
	if active_summon_visuals.has(event.instance_id):
		var visual_node = active_summon_visuals[event.instance_id]
		if is_instance_valid(visual_node):
			if visual_node.has_method("set_max_hp"): visual_node.set_max_hp(event.new_max_hp)
			if visual_node.has_method("set_current_hp"): visual_node.set_current_hp(event.new_hp)
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
		if is_instance_valid(visual_node):
			if event.stat == "power" and visual_node.has_method("set_current_power"):
				visual_node.set_current_power(event.new_value)
			elif event.stat == "max_hp" and visual_node.has_method("set_max_hp"):
				visual_node.set_max_hp(event.new_value)
				# Also update current HP on the visual if max_hp changed, as it might need clamping
				if visual_node.has_method("set_current_hp"):
					visual_node.set_current_hp(min(visual_node.current_hp_val, event.new_value))

			if visual_node.has_method("play_animation"):
				visual_node.play_animation("buff" if event.amount > 0 else "debuff")
	await get_tree().create_timer(0.4 / playback_speed_scale).timeout

func handle_status_change(event):
	print("  -> Status Change: %s lane %d (ID: %d) %s status '%s' (Source: %s)" % [
		event.player, event.lane, event.instance_id, "gained" if event.gained else "lost", event.status, event.get("source", "N/A")
	])
	# TODO: Find SummonVisual node, update status icons visibility
	await get_tree().create_timer(0.2 / playback_speed_scale).timeout

func handle_visual_effect(event):
	print("  -> Visual Effect: ID '%s', Targets: %s, Details: %s" % [event.effect_id, str(event.target_locations), str(event.details)])
	# TODO: Implement specific visual effects based on effect_id
	await get_tree().create_timer(0.5 / playback_speed_scale).timeout # Default delay

func handle_log_message(event):
	print("  -> Log Message: %s" % event.message)
	# Optionally display in a dedicated log UI area
	await get_tree().create_timer(0.1 / playback_speed_scale).timeout

func handle_battle_end(event):
	print("--- Battle End ---")
	print("  -> Outcome: %s, Winner: %s" % [event.outcome, event.winner])
	if event_log_label: event_log_label.text = "Battle End: %s wins!" % event.winner
	is_playing = false
	if playback_timer: playback_timer.stop()

func _update_zone_display(container_node: HBoxContainer, card_ids: Array[String], count_label: Label):
	if not is_instance_valid(container_node):
		printerr("_update_zone_display: Invalid container node.")
		return

	# Clear existing card icons
	for child in container_node.get_children():
		child.queue_free()

	# Add new card icons
	for card_id_str in card_ids:
		if not CardDB:
			printerr("CardDB not available in _update_zone_display")
			continue
		var card_res = CardDB.get_card_resource(card_id_str)
		if card_res and is_instance_valid(card_res):
			var icon = TextureRect.new()
			var tex = load(card_res.artwork_path) if ResourceLoader.exists(card_res.artwork_path) else null
			if tex:
				icon.texture = tex
			else: # Fallback: use a ColorRect if art fails
				icon.texture = null # Or a default "unknown card" texture
				printerr("Missing art for %s at %s" % [card_id_str, card_res.artwork_path])
				var color_rect_fallback = ColorRect.new()
				color_rect_fallback.color = Color.DARK_SLATE_GRAY
				color_rect_fallback.custom_minimum_size = Vector2(20,30) # Match your desired icon size
				icon.add_child(color_rect_fallback)


			icon.custom_minimum_size = Vector2(90, 90) # Adjust size as needed
			icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			container_node.add_child(icon)
		else:
			printerr("Could not get CardResource for ID: ", card_id_str)

	if is_instance_valid(count_label):
		count_label.text = str(card_ids.size())
	# else:
		# print("No count label provided for zone: ", container_node.name)

func handle_initial_library_state(event):
	print("  -> Initial Library for %s: %s cards" % [event.player, event.card_ids.size()])
	var target_library_arr_ref: Array # Use a reference to the array
	var target_library_display_node: HBoxContainer = null
	var target_library_count_label: Label = null # Add if you have count labels

	if event.player == player1_name: # Bottom player (assuming player1 is bottom)
		target_library_arr_ref = player1_library_card_ids
		target_library_display_node = bottom_player_library_hbox
		# target_library_count_label = bottom_player_library_count_label
	elif event.player == player2_name: # Top player
		target_library_arr_ref = player2_library_card_ids
		target_library_display_node = top_player_library_hbox
		# target_library_count_label = top_player_library_count_label
	else:
		printerr("Initial Library: Unknown player %s" % event.player)
		return # Don't await if erroring early

	if target_library_arr_ref != null: # Check if we successfully got a reference
		target_library_arr_ref.clear() # Clear any previous (e.g. hardcoded) state
		for card_id_str in event.card_ids:
			target_library_arr_ref.append(card_id_str)

		if target_library_display_node:
			_update_zone_display(target_library_display_node, target_library_arr_ref, target_library_count_label)

	# No specific await needed here unless _update_zone_display adds one or you want a pause
	await get_tree().create_timer(0.1 / playback_speed_scale).timeout # Small delay for pacing if desired

# (player1_name and player2_name are already class member variables)

func _determine_player_identities(all_events: Array[Dictionary]) -> void:
	# Resets and determines player1_name (bottom) and player2_name (top)
	# Assumes "Player" is the primary/bottom player if present.
	# Otherwise, assigns based on first two distinct players found.

	player1_name = ""
	player2_name = ""

	var distinct_players_found: Array[String] = []

	# First pass: look for "Player" and another distinct player from any event
	for event_peek in all_events:
		var p = event_peek.get("player")
		if p == null:
			continue

		if not p in distinct_players_found:
			distinct_players_found.append(p)

		if p == "Player":
			player1_name = "Player"
		elif p != "Player" and player2_name == "": # Found a candidate for opponent
			player2_name = p
		
		# If we have "Player" and another name, we might be done
		if player1_name == "Player" and player2_name != "" and player2_name != "Player":
			break # Sufficiently identified

	# Consolidate findings if "Player" wasn't explicitly first
	if player1_name == "Player":
		if player2_name == "" or player2_name == "Player": # Opponent not found or wrongly assigned
			for p_name in distinct_players_found:
				if p_name != "Player":
					player2_name = p_name
					break
			if player2_name == "" or player2_name == "Player": # Still no distinct opponent
				player2_name = "Opponent" # Default if only "Player" was found
	elif distinct_players_found.size() > 0: # "Player" not found, use first found as p1
		player1_name = distinct_players_found[0]
		if distinct_players_found.size() > 1:
			player2_name = distinct_players_found[1]
		else:
			player2_name = "Opponent" # Default if only one player type found (not "Player")
	else: # No player names found in events at all (highly unlikely)
		player1_name = "Player"
		player2_name = "Opponent"
	
	# Final ensure they are not the same (should be rare with above logic)
	if player1_name == player2_name:
		if player1_name == "Player": player2_name = "Opponent"
		else: player2_name = "Player" # Fallback if p1 was auto-assigned something else

	# print("Determined Player 1 (Bottom UI): ", player1_name)
	# print("Determined Player 2 (Top UI): ", player2_name)
	

func debug_print_node_layout_info(node: Control, node_description: String = ""):
	if not is_instance_valid(node):
		print("Debug Layout: Node is not valid for ", node_description)
		return

	print("\n--- Layout Info for: %s (%s) ---" % [node.name, node_description])
	print("  Path: ", node.get_path())
	print("  Type: ", node.get_class())
	print("  Visible: ", node.visible)
	print("  Layout Mode: ", node.layout_mode) # 0=Position, 1=Anchors, 2=Container
	print("  Anchors Preset: ", node.anchors_preset) # -1=Custom, other values are presets

	#if node.layout_mode == Control.LAYOUT_MODE_ANCHORS: # Only relevant if mode is Anchors
	print("  Anchor Left: ", node.anchor_left)
	print("  Anchor Top: ", node.anchor_top)
	print("  Anchor Right: ", node.anchor_right)
	print("  Anchor Bottom: ", node.anchor_bottom)
	print("  Offset Left: ", node.offset_left)
	print("  Offset Top: ", node.offset_top)
	print("  Offset Right: ", node.offset_right)
	print("  Offset Bottom: ", node.offset_bottom)

	print("  Grow Horizontal: ", node.grow_horizontal) # How it behaves in some containers
	print("  Grow Vertical: ", node.grow_vertical)   # How it behaves in some containers

	print("  Position: ", node.position)
	print("  Size: ", node.size)
	print("  Scale: ", node.scale)
	print("  Rotation (deg): ", node.rotation_degrees)
	print("  Global Position: ", node.global_position)
	print("  Custom Minimum Size: ", node.custom_minimum_size)

	# Size Flags (relevant if child of a container)
	print("  Size Flags Horizontal: ")
	var h_flags = []
	if node.size_flags_horizontal & Control.SIZE_FILL: h_flags.append("FILL")
	if node.size_flags_horizontal & Control.SIZE_EXPAND: h_flags.append("EXPAND")
	if node.size_flags_horizontal & Control.SIZE_SHRINK_CENTER: h_flags.append("SHRINK_CENTER")
	if node.size_flags_horizontal & Control.SIZE_SHRINK_END: h_flags.append("SHRINK_END")
	var print_val = str(h_flags) if not h_flags.is_empty() else "NONE"
	print("     ", print_val)

	print("  Size Flags Vertical: ")
	var v_flags = []
	if node.size_flags_vertical & Control.SIZE_FILL: v_flags.append("FILL")
	if node.size_flags_vertical & Control.SIZE_EXPAND: v_flags.append("EXPAND")
	if node.size_flags_vertical & Control.SIZE_SHRINK_CENTER: v_flags.append("SHRINK_CENTER")
	if node.size_flags_vertical & Control.SIZE_SHRINK_END: v_flags.append("SHRINK_END")
	print_val = str(v_flags) if not v_flags.is_empty() else "NONE"
	print("    ", print_val)

	print("  Mouse Filter: ", node.mouse_filter)
	print("------------------------------------")

# Optional: Recursive function to print tree upwards
func debug_print_layout_hierarchy(node: Control, description: String = "Start Node"):
	if not is_instance_valid(node):
		return
	var current_node = node
	var current_desc = description
	var depth = 0
	while is_instance_valid(current_node) and current_node != get_tree().get_root():
		debug_print_node_layout_info(current_node, current_desc + (" (Depth %d)" % depth))
		current_node = current_node.get_parent() as Control # Only interested in Control parents for layout
		current_desc = "Parent"
		depth += 1
		if depth > 10: # Safety break
			print("Reached max depth in hierarchy print.")
			break

func _ready():
	await get_tree().process_frame # Ensure autoloads are ready
	if CardDB:
		var test_card = CardDB.get_card_resource("RecurringSkeleton") # Or any valid card ID
		if test_card:
			print("CardDB Test: Found ", test_card.card_name)
		else:
			print("CardDB Test: RecurringSkeleton not found.")
	else:
		print("CardDB not available.")
