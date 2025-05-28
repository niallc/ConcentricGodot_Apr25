# res://scenes/battle_replay.gd
extends Control
class_name BattleReplay

# --- Properties ---
var battle_events: Array[Dictionary] = []
var current_event_index: int = -1
var is_playing: bool = false
var playback_speed_scale: float = 3.0
var step_delay: float = 0.5
var spell_display_size = Vector2(500,500)
var spell_display_alpha: float = 0.7
#var spell_card_hold_duration: float = 0.4


var active_summon_visuals: Dictionary = {} # instance_id -> SummonVisual node

const SummonVisualScene = preload("res://ui/summon_visual.tscn")
const CardIconVisualScene = preload("res://ui/card_icon_visual.tscn")

# Store player names to map to Top/Bottom layout
var player1_name: String = "" # Typically "Player"
var player2_name: String = "" # Typically "Opponent"

# --- Node References ---
@onready var turn_label: Label = $MainMarginContainer/MainVBox/TurnAndEvents/TurnLabel
@onready var event_log_label: Label = $MainMarginContainer/MainVBox/TurnAndEvents/EventLogLabel
@onready var bottom_lane_container: HBoxContainer = $MainMarginContainer/MainVBox/GameAreaVBox/BottomPlayerArea/BottomPlayerVBox/LaneContainer
@onready var top_lane_container: HBoxContainer = $MainMarginContainer/MainVBox/GameAreaVBox/TopPlayerArea/TopPlayerVBox/LaneContainer
@onready var playback_timer: Timer = $MainMarginContainer/PlaybackTimer
@onready var game_area_vbox: VBoxContainer = $MainMarginContainer/MainVBox/GameAreaVBox # Used if top_effects_canvas_layer fails

# --- Player UI References ---
@onready var bottom_player_hp_pips_container: HBoxContainer = $MainMarginContainer/MainVBox/GameAreaVBox/BottomPlayerArea/BottomPlayerVBox/LifeAndMana/HPPipsContainer 
@onready var bottom_player_mana_pips_container: HBoxContainer = $MainMarginContainer/MainVBox/GameAreaVBox/BottomPlayerArea/BottomPlayerVBox/LifeAndMana/ManaPipsContainer
@onready var top_player_hp_pips_container: HBoxContainer = $MainMarginContainer/MainVBox/GameAreaVBox/TopPlayerArea/TopPlayerVBox/LifeAndMana/HPPipsContainer 
@onready var top_player_mana_pips_container: HBoxContainer = $MainMarginContainer/MainVBox/GameAreaVBox/TopPlayerArea/TopPlayerVBox/LifeAndMana/ManaPipsContainer
const HP_PIP_EMPTY_STYLE = preload("res://ui/styles/hp_pip_empty_style.tres") # Adjust path
const HP_PIP_FULL_STYLE = preload("res://ui/styles/hp_pip_full_style.tres")
const MANA_PIP_EMPTY_STYLE = preload("res://ui/styles/mana_pip_empty_style.tres")
const MANA_PIP_FULL_STYLE = preload("res://ui/styles/mana_pip_full_style.tres")

# --- Player Graveyard and Library References ---
@onready var bottom_player_library_hbox: HBoxContainer = $MainMarginContainer/MainVBox/GameAreaVBox/BottomPlayerArea/BottomPlayerVBox/LibraryAndGraveyard/Library
@onready var bottom_player_graveyard_hbox: HBoxContainer = $MainMarginContainer/MainVBox/GameAreaVBox/BottomPlayerArea/BottomPlayerVBox/LibraryAndGraveyard/Graveyard
@onready var top_player_library_hbox: HBoxContainer = $MainMarginContainer/MainVBox/GameAreaVBox/TopPlayerArea/TopPlayerVBox/LibraryAndGraveyard/Library
@onready var top_player_graveyard_hbox: HBoxContainer = $MainMarginContainer/MainVBox/GameAreaVBox/TopPlayerArea/TopPlayerVBox/LibraryAndGraveyard/Graveyard

# --- Spell Animation layer -----
@onready var top_effects_canvas_layer: CanvasLayer = $TopEffectsCanvasLayer
@onready var spell_popup_anchor: Control = $TopEffectsCanvasLayer/SpellPopupAnchor

# --- Spell Animation Effects ---
const UnmakeImpactEffectScene = preload("res://effects/spell_impact_effect.tscn") # Adjust path


# --- Store Graveyard and Library Card Names ---
var player1_library_card_ids: Array[String] = []
var player1_graveyard_card_ids: Array[String] = []
var player2_library_card_ids: Array[String] = []
var player2_graveyard_card_ids: Array[String] = []

func load_and_start_simple_replay(initial_events: Array[Dictionary]):
	print("BattleReplay: Loading %d events." % initial_events.size())
	self.battle_events = initial_events

	_reset_internal_battle_state()
	_clear_all_visuals_for_new_replay()
	#_initialize_ui_labels_and_player_stats()
	_initialize_card_zones_display() # For library/graveyard counts & visuals

	_determine_player_identities(initial_events)
	
	_process_initial_setup_events(initial_events)

	if event_log_label: event_log_label.text = "Press Step or Play"
	call_deferred("_on_step_button_pressed") # Or let user press play/step

# --- Private Helper Functions for Setup ---
func _reset_internal_battle_state() -> void:
	current_event_index = -1
	is_playing = false
	# playback_speed_scale = 3.0 # Or keep existing value
	# step_delay = 0.5           # Or keep existing value

	active_summon_visuals.clear() # Clear the dictionary

	# Clear card ID arrays for zones
	player1_library_card_ids.clear()
	player1_graveyard_card_ids.clear()
	player2_library_card_ids.clear()
	player2_graveyard_card_ids.clear()
	
	_initialize_player_stat_bars()
	print("Internal battle state reset.")

func _clear_all_visuals_for_new_replay() -> void:
	# Clear any visuals that might be direct children of active_summon_visuals' values
	# (This loop is a bit redundant if _clear_lane_visuals clears them AND they are removed from dict)
	# Consider if active_summon_visuals should only store visuals currently in lanes.
	# For now, ensuring they are freed if the dictionary still holds references from a previous run:
	for visual_node_path_or_instance in active_summon_visuals.values():
		if visual_node_path_or_instance is Node and is_instance_valid(visual_node_path_or_instance):
			visual_node_path_or_instance.queue_free() 
	active_summon_visuals.clear() # Defensive clear again after freeing

	_clear_lane_visuals() # Your existing refactored function
	print("All visuals cleared for new replay.")

func _clear_lane_visuals() -> void:
	var lane_containers_to_process: Array[HBoxContainer] = []
	if is_instance_valid(top_lane_container):
		lane_containers_to_process.append(top_lane_container)
	if is_instance_valid(bottom_lane_container):
		lane_containers_to_process.append(bottom_lane_container)

	for lane_hbox in lane_containers_to_process:
		for lane_panel in lane_hbox.get_children():
			if lane_panel is Panel:
				var card_slot = lane_panel.get_node_or_null("CardSlotSquare")
				if card_slot is AspectRatioContainer: # Check type
					for child_node in card_slot.get_children():
						if child_node == SummonVisual:
							child_node.queue_free()

func _initialize_player_stat_bars() -> void:
	if not is_node_ready(): await ready

	# Assuming Constants.STARTING_HP and Constants.MAX_MANA represent the total number of pips created for HP and Mana respectively.
	# And Constants.STARTING_MANA is the initial filled mana.
	# HP starts full by default in Constants.

	if bottom_player_hp_pips_container:
		_update_pip_bar(bottom_player_hp_pips_container, Constants.STARTING_HP, Constants.STARTING_HP, HP_PIP_FULL_STYLE, HP_PIP_EMPTY_STYLE)
	if bottom_player_mana_pips_container:
		_update_pip_bar(bottom_player_mana_pips_container, Constants.STARTING_MANA, Constants.MAX_MANA, MANA_PIP_FULL_STYLE, MANA_PIP_EMPTY_STYLE)

	if top_player_hp_pips_container:
		_update_pip_bar(top_player_hp_pips_container, Constants.STARTING_HP, Constants.STARTING_HP, HP_PIP_FULL_STYLE, HP_PIP_EMPTY_STYLE)
	if top_player_mana_pips_container:
		_update_pip_bar(top_player_mana_pips_container, Constants.STARTING_MANA, Constants.MAX_MANA, MANA_PIP_FULL_STYLE, MANA_PIP_EMPTY_STYLE)

	print("Player stat bars initialized.")

func _initialize_card_zones_display() -> void:
	# Clear initial display of library/graveyard counts and visuals
	_update_zone_display(top_player_library_hbox, player1_library_card_ids)
	_update_zone_display(top_player_graveyard_hbox, player1_graveyard_card_ids)
	_update_zone_display(bottom_player_library_hbox, player2_library_card_ids)
	_update_zone_display(bottom_player_graveyard_hbox, player2_graveyard_card_ids)
	print("Card zones display initialized (empty).")

func _process_initial_setup_events(initial_events: Array[Dictionary]) -> void:
	var initial_events_processed_count = 0
	for i in range(initial_events.size()):
		var event = initial_events[i]
		if event.get("event_type") == "initial_library_state":
			# Inlined version of handle_initial_library_state for setup (as you had)
			var target_library_arr_ref: Array = []
			var target_library_display_node: HBoxContainer = null
			#var target_library_count_label: Label = null

			if event.player == player1_name:
				target_library_arr_ref = player1_library_card_ids
				target_library_display_node = bottom_player_library_hbox
				#target_library_count_label = bottom_player_library_count_label
			elif event.player == player2_name:
				target_library_arr_ref = player2_library_card_ids
				target_library_display_node = top_player_library_hbox
				#target_library_count_label = top_player_library_count_label
			
			if target_library_arr_ref != null: # Should always be true if player name matched
				target_library_arr_ref.clear() # Should already be clear from _reset_internal_battle_state
				for card_id_str in event.card_ids:
					target_library_arr_ref.append(card_id_str)
				if target_library_display_node: # Should be valid
					_update_zone_display(target_library_display_node, target_library_arr_ref)
			initial_events_processed_count += 1
		elif event.get("event_type") == "turn_start": # Stop after initial library, before first turn starts
			break 
		else: # Should only be initial_library_state events before first turn_start
			initial_events_processed_count += 1 # Count any other pre-turn_start events too
	
	current_event_index = initial_events_processed_count - 1 
	print("Initial setup events processed. current_event_index set to: %d" % current_event_index)

func _update_pip_bar(pips_container: HBoxContainer, current_value: int, _max_value: int, full_style: StyleBox, empty_style: StyleBox):
	if not is_instance_valid(pips_container):
		printerr("Invalid pips container provided to _update_pip_bar")
		return

	var num_pips = pips_container.get_child_count()
	# Ensure we don't try to update more pips than exist (e.g., if max_value from event differs from setup)
	# Or, ensure pips_container always has 'max_value' pips from the scene setup.

	for i in range(num_pips):
		var pip_node = pips_container.get_child(i) as Panel
		if not is_instance_valid(pip_node): # Should not happen if setup correctly
			printerr("Failed to find a valid node when updating mana visual display.")
			continue 

		if i < current_value:
			pip_node.set("theme_override_styles/panel", full_style)
		else:
			pip_node.set("theme_override_styles/panel", empty_style)

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
			event_log_label.text = "      Event %d: %s (%s)" % [current_event_index, event.event_type, event.get("player", "N/A")] # Your original line

	print("\nProcessing Event %d: %s" % [current_event_index, event])

	if event_log_label: event_log_label.text = "      Event %d: %s (%s)" % [current_event_index, event.event_type, event.get("player", "N/A")]

	# Temporary debugging code:
	if event.event_id == 34:
		print("Checking Instance IDs")

	match event.event_type:
		"initial_library_state": await handle_initial_library_state(event)
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

func get_lane_node(player_name_from_event: String, lane_number_from_event: int) -> AspectRatioContainer:
	var prefix = get_player_prefix(player_name_from_event)
	var lane_hbox_container: HBoxContainer = null
	if prefix == "Bottom":
		lane_hbox_container = bottom_lane_container
	elif prefix == "Top":
		lane_hbox_container = top_lane_container

	if not is_instance_valid(lane_hbox_container):
		printerr("get_lane_node: Invalid HBoxContainer for player prefix '%s'" % prefix)
		return null

	var target_lane_panel_name = "Lane" + str(lane_number_from_event)
	var lane_panel_node = lane_hbox_container.get_node_or_null(target_lane_panel_name) # Gets the Panel [cite: 20]

	if not is_instance_valid(lane_panel_node):
		printerr("get_lane_node: Panel node named '%s' not found under '%s'." % [target_lane_panel_name, lane_hbox_container.name]) # [cite: 20]
		return null
	
	if not lane_panel_node is Panel:
		printerr("get_lane_node: Node '%s' was found, but it's not a Panel. It's a '%s'." % [target_lane_panel_name, lane_panel_node.get_class()]) # [cite: 21, 22]
		return null
	
	var aspect_ratio_container_node = lane_panel_node.get_node_or_null("CardSlotSquare") 

	if not is_instance_valid(aspect_ratio_container_node):
		printerr("get_lane_node: AspectRatioContainer named 'CardSlotSquare' not found under '%s'." % lane_panel_node.get_path())
		return null

	if not aspect_ratio_container_node is AspectRatioContainer:
		printerr("get_lane_node: Node 'CardSlotSquare' under '%s' is not an AspectRatioContainer. It's a '%s'." % [lane_panel_node.get_path(), aspect_ratio_container_node.get_class()])
		return null
		
	# TODO: Consider a more  specific check using a custom type for summon lanes.
	# if not found_node.is_in_group("game_lane_panel"): # Requires adding "game_lane_panel" to your LaneX nodes' groups
	# 	printerr("get_lane_node: Node '%s' is not in the 'game_lane_panel' group." % target_lane_name)
	# 	return null
	return aspect_ratio_container_node as AspectRatioContainer

# --- Event Handler Functions ---
func handle_turn_start(event):
	print("  -> Turn %d starts for %s" % [event.turn, event.player])
	if turn_label: turn_label.text = "     Turn: %d (%s)" % [event.turn, event.player]
	await get_tree().create_timer(0.5 / playback_speed_scale).timeout

# Fix for tags default
func handle_summon_arrives(event):
	print("  -> %s summons %s (ID: %d) in lane %d. Stats P:%d HP:%d/%d Swift:%s Tags:%s" % [
		event.player, event.card_id, event.instance_id, event.lane,
		event.power, event.current_hp, event.max_hp, event.is_swift, str(event.get("tags", PackedStringArray())) # Use PackedStringArray for default
	])

	var target_lane_node = get_lane_node(event.player, event.lane)
	if not is_instance_valid(target_lane_node):
		printerr("Summon Arrives (Event %d): target_lane_node is NOT VALID. Player: %s, Lane: %d. Event data: %s" % [current_event_index, event.player, event.lane, event])
	else:
		print("Summon Arrives (Event %d): target_lane_node is valid: %s. Name: %s" % [current_event_index, target_lane_node.get_path(), target_lane_node.name])
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

				await visual_node.play_full_arrival_sequence_and_await() 

			else:
				printerr("SummonVisual node is missing update_display method.")
		else:
			printerr("Failed to load SummonCardResource for %s at %s" % [event.card_id, card_res_path])

			print("\n--- SummonVisual Layout Debug (Event %d, Instance %d, Card %s) ---" % [current_event_index, event.instance_id, event.card_id])
			print("  Target Lane Path: %s, Name: %s, Size: %s" % [target_lane_node.get_path(), target_lane_node.name, target_lane_node.size])
			
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


func handle_mana_change(event):
	print("  -> %s mana changes by %d. New total: %d (Source: %s)" % [event.player, event.amount, event.new_total, event.get("source", "N/A")]) # [cite: 36]

	var target_mana_pips_container: HBoxContainer = null
	# Assuming Constants.MAX_MANA represents the total number of pips for Mana.
	var max_mana_for_bar = Constants.MAX_MANA

	if event.player == player1_name: # Bottom player
		target_mana_pips_container = bottom_player_mana_pips_container
	elif event.player == player2_name: # Top player
		target_mana_pips_container = top_player_mana_pips_container

	if is_instance_valid(target_mana_pips_container):
		_update_pip_bar(target_mana_pips_container, event.new_total, max_mana_for_bar, MANA_PIP_FULL_STYLE, MANA_PIP_EMPTY_STYLE)
	else:
		printerr("Could not find mana pips container for player: ", event.player)

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
	#var target_library_count_label: Label = null
	#var target_graveyard_count_label: Label = null

	var card_id_to_move = event.card_id

	if event.player == player1_name: # Assuming player1_name is bottom player
		target_library_arr = player1_library_card_ids
		target_graveyard_arr = player1_graveyard_card_ids
		target_library_display_node = bottom_player_library_hbox
		target_graveyard_display_node = bottom_player_graveyard_hbox
	elif event.player == player2_name: # Assuming player2_name is top player
		target_library_arr = player2_library_card_ids
		target_graveyard_arr = player2_graveyard_card_ids
		target_library_display_node = top_player_library_hbox
		target_graveyard_display_node = top_player_graveyard_hbox
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
		_update_zone_display(target_library_display_node, target_library_arr)
	if target_graveyard_display_node:
		_update_zone_display(target_graveyard_display_node, target_graveyard_arr)

	await get_tree().create_timer(0.3 / playback_speed_scale).timeout

func handle_card_removed(event):
	var player_name_from_event = event.player
	var card_id_str = event.card_id
	var from_zone_str = event.from_zone
	var reason_str = event.get("reason", "N/A")

	print("  -> %s's %s removed from %s (Reason: %s)" % [player_name_from_event, card_id_str, from_zone_str, reason_str])

	var target_array_ref: Array
	var target_display_node: HBoxContainer = null
	#var target_count_label: Label = null
	#var was_library_event = false

	if player_name_from_event == self.player1_name: # Bottom player
		match from_zone_str:
			"graveyard":
				target_array_ref = player1_graveyard_card_ids
				target_display_node = bottom_player_graveyard_hbox
				#target_count_label = bottom_player_graveyard_count_label
			"library":
				target_array_ref = player1_library_card_ids
				target_display_node = bottom_player_library_hbox
				#target_count_label = bottom_player_library_count_label
				#was_library_event = true
			_:
				printerr("handle_card_removed: Unknown from_zone '%s' for player %s" % [from_zone_str, player_name_from_event])
				
	elif player_name_from_event == self.player2_name: # Top player
		match from_zone_str:
			"graveyard":
				target_array_ref = player2_graveyard_card_ids
				target_display_node = top_player_graveyard_hbox
				#target_count_label = top_player_graveyard_count_label
			"library":
				target_array_ref = player2_library_card_ids
				target_display_node = top_player_library_hbox
				#target_count_label = top_player_library_count_label
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
				_update_zone_display(target_display_node, target_array_ref)
		else:
			printerr("handle_card_removed: Card '%s' not found in %s's %s to remove." % [card_id_str, player_name_from_event, from_zone_str])
	
	await get_tree().create_timer(0.2 / playback_speed_scale).timeout

func handle_summon_turn_activity(event):
	print("  -> %s's summon (ID: %d) in lane %d performs action: %s" % [event.player, event.instance_id, event.lane, event.activity_type])
	if active_summon_visuals.has(event.instance_id):
		var visual_node = active_summon_visuals[event.instance_id]
		if is_instance_valid(visual_node) and visual_node.has_method("play_animation"): # Check valid
			match event.activity_type:
				"attack", "direct_attack":
					if visual_node.has_method("play_attack_animation"):
						var player_prefix = get_player_prefix(event.player) # "Top" or "Bottom" [cite: 20, 93]
						var is_top_card = (player_prefix == "Top")

						visual_node.play_attack_animation(is_top_card) # Pass directionality

						if visual_node.animation_player and visual_node.animation_player.is_playing():
							await visual_node.animation_player.animation_finished
				"ability_mana_gen":
					visual_node.play_animation("ability")
				_:
					visual_node.play_animation("ability") # Default	else:
	else:
		printerr("Couldn't find an instance_id for this animation event.")
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
	print("  -> Player HP Change: %s amount %d. New total: %d (Source: %s)" % [event.player, event.amount, event.new_total, event.get("source", "N/A")]) # [cite: 49]

	var target_hp_pips_container: HBoxContainer = null
	var max_hp_for_bar = Constants.STARTING_HP # Assuming HP bar max is fixed at starting HP

	if event.player == player1_name: # Bottom player
		target_hp_pips_container = bottom_player_hp_pips_container
	elif event.player == player2_name: # Top player
		target_hp_pips_container = top_player_hp_pips_container

	if is_instance_valid(target_hp_pips_container):
		_update_pip_bar(target_hp_pips_container, event.new_total, max_hp_for_bar, HP_PIP_FULL_STYLE, HP_PIP_EMPTY_STYLE)
	else:
		printerr("Could not find HP pips container for player: ", event.player)

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

# In battle_replay.gd
func handle_visual_effect(event):
	print("  -> Visual Effect: ID '%s', Targets: %s, Details: %s" % [event.effect_id, str(event.target_locations), str(event.details)]) # [cite: 87]

	# Hacky workaround for String instance_id cases.
	var temp_ins_id = event.get("instance_id")
	var target_instance_id: int = -1
	match typeof(temp_ins_id):
		TYPE_INT:
			target_instance_id = temp_ins_id
		TYPE_STRING:
			print("Deprecated: Got instance_id of type String: \"", temp_ins_id, "\"")
		_:
			print("Warning: Unexpected instance_id type: ", temp_ins_id)

	var effect_handled = true # Assume we'll handle it
	match event.effect_id:
		"unmake_targeting_visual":
			print("--- Handling Unmake Visual (now using generic) ---") #

			await _play_generic_spell_effect_visual(event, 
												spell_display_size, 
												spell_display_alpha, 
												true,
												target_instance_id, # Burst on the creature
												target_instance_id) # Also fade this creature
			print("--- Finished Unmake Visual (generic call) ---") #			
		# --- Placeholder for other effects we discussed ---
		"energy_axe_boost":
			print("Visual for Energy Axe boost on target...")
			await _play_generic_spell_effect_visual(event, spell_display_size, spell_display_alpha, true, target_instance_id, target_instance_id)
			# Specific: could also add a temporary "+POW" visual to target_visual_node
		"focus_mana_gain":
			print("Visual for Focus mana gain on player...")
			await _play_generic_spell_effect_visual(event, spell_display_size, spell_display_alpha, false, target_instance_id, -1)
			# Specific: could add a glow to player's mana bar area
		"inferno_spell_cast":
			print("Visual for Inferno spell cast (AOE)")
			await _play_generic_spell_effect_visual(event, spell_display_size, spell_display_alpha, false, target_instance_id, -1)
		"disarm_debuff_applied":
			print("Visual for Disarm debuff on target")
			await _play_generic_spell_effect_visual(event, spell_display_size, spell_display_alpha, false, target_instance_id, -1)
		_:
			print("Visual for ", event.effect_id)
			await _play_generic_spell_effect_visual(event, spell_display_size, spell_display_alpha, false, target_instance_id, -1)

	if not effect_handled:
		print("  -> Unhandled or error in visual_effect ID: ", event.effect_id)
		await get_tree().create_timer(0.1 / playback_speed_scale).timeout # Minimal delay if not handled

func _play_generic_spell_effect_visual(event: Dictionary, 
									popup_size: Vector2,
									spell_art_alpha: float,
									show_burst_effect: bool = true, # Note: default was false in your snippet
									burst_target_instance_id: int = -1,
									creature_to_fade_instance_id: int = -1
									):
	print("--- GENERIC SPELL VISUAL START for: '", event.get("effect_id"), "' ---")
	var spell_card_icon_node: Control = null
	var spell_card_fade_duration = 0.3 / playback_speed_scale
	# How long the card stays at full (or target) alpha after fading in,
	# before it starts to fade out. This needs to be long enough for other effects.
	var spell_card_visible_duration = 1.0 / playback_speed_scale 
	
	var burst_animation_duration = 2.0 / playback_speed_scale # From SpellImpactEffect's lifecycle
	var creature_fade_anim_duration = 0.7 / playback_speed_scale
	var creature_fade_anim_delay = 0.2 / playback_speed_scale

	# This will collect tweens that can run in parallel for the main effect phase
	var parallel_tweens_finished_signals: Array[Signal] = []

	# --- Phase 1: Prepare and Start Fade In Spell Card ---
	var spell_card_id = event.get("source_card_id")
	print("Generic: Got spell_card_id: '", spell_card_id, "'")
	if spell_card_id and is_instance_valid(spell_popup_anchor): # spell_popup_anchor is @onready 
		var spell_card_res = CardDB.get_card_resource(spell_card_id)
		if spell_card_res:
			spell_card_icon_node = CardIconVisualScene.instantiate() # 
			spell_popup_anchor.add_child(spell_card_icon_node)
			await get_tree().process_frame # Ensure _ready called on icon
			
			spell_card_icon_node.update_display(spell_card_res)
			
			spell_popup_anchor.size = popup_size
			spell_popup_anchor.position = (get_viewport_rect().size / 2.0) - (popup_size / 2.0)
			spell_card_icon_node.set_anchors_preset(Control.PRESET_FULL_RECT)
			
			if spell_card_icon_node.has_method("set_component_modulation"):
				spell_card_icon_node.set_component_modulation(Color(1,1,1,0.95), Color(1,1,1,spell_art_alpha))
			
			spell_popup_anchor.visible = true
			spell_card_icon_node.modulate.a = 0.0 # Start transparent
			
			var fade_in_tween = create_tween()
			fade_in_tween.tween_property(spell_card_icon_node, "modulate:a", 1.0, spell_card_fade_duration)
			print("Generic: Spell card fade-in tween started.")
			parallel_tweens_finished_signals.append(fade_in_tween.finished) # Add its finished signal
	else:
		printerr("Generic: Skipped spell card display. spell_card_id: %s, spell_popup_anchor valid: %s" % [spell_card_id, is_instance_valid(spell_popup_anchor)])

	# --- Phase 2a: Play Burst (if applicable) ---
	var actual_burst_duration_to_wait = 0.0
	if show_burst_effect:
		print("Generic: show_burst_effect is TRUE. Burst target_id: ", burst_target_instance_id)
		var burst_target_pos: Vector2
		var burst_target_found = false
		if burst_target_instance_id != -1 and active_summon_visuals.has(burst_target_instance_id):
			var target_visual = active_summon_visuals[burst_target_instance_id]
			if is_instance_valid(target_visual):
				burst_target_pos = target_visual.global_position + (target_visual.size / 2.0)
				burst_target_found = true
		elif is_instance_valid(spell_card_icon_node): # Fallback burst from spell card if no specific target
			burst_target_pos = spell_popup_anchor.global_position + (spell_popup_anchor.size / 2.0)
			burst_target_found = true
		
		if burst_target_found:
			var burst_node = UnmakeImpactEffectScene.instantiate() # 
			add_child(burst_node) 
			burst_node.global_position = burst_target_pos
			if burst_node.has_method("play_effect"):
				print("Generic: Playing burst effect at: ", burst_target_pos)
				burst_node.play_effect() # Burst scene self-destructs
				actual_burst_duration_to_wait = burst_animation_duration # We'll wait for this long
			else:
				if is_instance_valid(burst_node): burst_node.queue_free()
		else:
			print("Generic: Burst target NOT found.")
	
	# --- Phase 2b: Fade Creature (if applicable) ---
	var actual_creature_fade_duration_to_wait = 0.0
	if creature_to_fade_instance_id != -1 and active_summon_visuals.has(creature_to_fade_instance_id):
		var creature_visual = active_summon_visuals[creature_to_fade_instance_id]
		if is_instance_valid(creature_visual):
			print("Generic: Fading creature: ", creature_visual.name if creature_visual else "N/A")
			var creature_fade_tween = create_tween()
			creature_fade_tween.tween_property(creature_visual, "modulate:a", 0.0, creature_fade_anim_duration).set_delay(creature_fade_anim_delay)
			parallel_tweens_finished_signals.append(creature_fade_tween.finished) # Add its signal
			actual_creature_fade_duration_to_wait = creature_fade_anim_delay + creature_fade_anim_duration
			
	# --- Phase 3: Wait for all started parallel effects OR the longest expected duration ---
	if not parallel_tweens_finished_signals.is_empty():
		print("Generic: Awaiting parallel tweens/effects...")
		# This await will wait for ALL signals in the array to be emitted
		# However, this is complex if tweens are not part of the same sequence.
		# Simpler for now: wait for the longest calculated duration of the effects we started.
		var longest_concurrent_effect = max(actual_burst_duration_to_wait, actual_creature_fade_duration_to_wait)
		if is_instance_valid(spell_card_icon_node): # If card is showing, ensure its fade-in is also covered
			longest_concurrent_effect = max(longest_concurrent_effect, spell_card_fade_duration)

		if longest_concurrent_effect > 0:
			await get_tree().create_timer(longest_concurrent_effect).timeout
		print("Generic: Parallel effects phase finished.")
	
	# --- Phase 3b: Hold Spell Card (if it was shown) ---
	if is_instance_valid(spell_card_icon_node):
		# Check if it actually became visible (alpha > 0.5 after fade-in)
		if spell_card_icon_node.modulate.a > 0.5: # Ensure it actually faded in before holding
			print("Generic: Starting spell card hold duration: ", spell_card_visible_duration)
			await get_tree().create_timer(spell_card_visible_duration).timeout
			print("Generic: Hold duration FINISHED.")
		else:
			print("Generic: Spell card icon was not sufficiently visible, skipping hold.")

	# --- Phase 4: Fade Out and Remove Spell Card Icon ---
	print("Generic: Attempting fade-out. spell_card_icon_node valid? ", is_instance_valid(spell_card_icon_node))
	if is_instance_valid(spell_card_icon_node):
		var fade_out_tween = create_tween()
		fade_out_tween.tween_property(spell_card_icon_node, "modulate:a", 0.0, spell_card_fade_duration)
		await fade_out_tween.finished
		print("Generic: Fade-out tween FINISHED. Freeing spell_card_icon_node.")
		spell_card_icon_node.queue_free()
	
	if is_instance_valid(spell_popup_anchor):
		spell_popup_anchor.visible = false
		print("Generic: SpellPopupAnchor made INVISIBLE.")
		
	if not spell_card_id and not show_burst_effect and creature_to_fade_instance_id == -1: # If nothing was done
		print("Generic: No actions taken, minimal await.")
		await get_tree().create_timer(0.1 / playback_speed_scale).timeout

	print("--- GENERIC SPELL VISUAL END for: '", event.get("effect_id"), "' ---")
	
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

func _update_zone_display(container_node: HBoxContainer, card_ids: Array[String]):
	if not is_instance_valid(container_node):
		printerr("_update_zone_display: Invalid container node.")
		return

	for child in container_node.get_children():
		child.queue_free()

	for card_id_str in card_ids:
		if not CardDB: 
			printerr("CardDB not available in _update_zone_display")
			continue
		var card_res = CardDB.get_card_resource(card_id_str)
		if card_res and is_instance_valid(card_res):
			var icon_visual = CardIconVisualScene.instantiate()
			
			# Add the visual to the tree FIRST
			container_node.add_child(icon_visual)
			
			# Now that it's in the tree, _ready() will be called on it.
			icon_visual.call_deferred("update_display", card_res) # Call update_display on the next idle frame

			icon_visual.custom_minimum_size = Vector2(60, 80) 
			
		else:
			printerr("Could not get CardResource for ID: ", card_id_str)

func handle_initial_library_state(event):
	print("  -> Initial Library for %s: %s cards" % [event.player, event.card_ids.size()])
	var target_library_arr_ref: Array # Use a reference to the array
	var target_library_display_node: HBoxContainer = null
	#var target_library_count_label: Label = null # Add if you have count labels

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
			_update_zone_display(target_library_display_node, target_library_arr_ref)

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

	if is_instance_valid(spell_popup_anchor):
		var desired_popup_container_size = Vector2(400, 400) 
		spell_popup_anchor.size = desired_popup_container_size
		var viewport_rect_size = get_viewport_rect().size 
		spell_popup_anchor.position = (viewport_rect_size / 2.0) - (desired_popup_container_size / 2.0)
		spell_popup_anchor.visible = false # Start hidden
		print("BattleReplay _ready: SpellPopupAnchor configured. Size: ", spell_popup_anchor.size, " Pos: ", spell_popup_anchor.position)
	else:
		var errMsg = "BattleReplay _ready: SpellPopupAnchor node NOT FOUND or invalid. Path was: "
		if spell_popup_anchor:
			errMsg += spell_popup_anchor.get_path()  
		else:
			errMsg+= "Path not available"
		printerr(errMsg)

	print("BattleReplay _ready: Finished.") # General ready confirmation
