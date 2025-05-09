extends Control

# --- Properties ---
var battle_events: Array[Dictionary] = []
var current_event_index: int = -1
var is_playing: bool = false
var playback_speed_scale: float = 1.0 # For later use with timers
var step_delay: float = 0.5 # Seconds between steps when playing

# Dictionary to hold references to active summon visuals on the board
# Key: instance_id, Value: SummonVisual node instance
var active_summon_visuals: Dictionary = {}

# Preload the summon visual scene
const SummonVisualScene = preload("res://ui/summon_visual.tscn")

# --- Node References ---
# Use @onready to ensure nodes are available when script runs
@onready var turn_label: Label = $MainMarginContainer/MainVBox/TurnLabel # Adjust path if needed
@onready var event_log_label: Label = $MainMarginContainer/MainVBox/EventLogLabel # Adjust path if needed
# TODO: Get references to lane container nodes later

# --- Public API ---

# Call this from outside (e.g., GameManager or test script) to start
func load_and_start_simple_replay(events: Array[Dictionary]):
	print("BattleReplay: Loading %d events." % events.size())
	battle_events = events
	current_event_index = -1
	is_playing = false # Start paused
	# Clear any previous state
	turn_label.text = "Turn: -"
	event_log_label.text = "Press Step or Play"
	# TODO: Clear existing summon visuals from lanes
	active_summon_visuals.clear()
	# For now, let's just step once manually to show the first event
	_on_step_button_pressed() # Simulate pressing step


# --- Playback Control Logic (Connect Buttons to these in Editor) ---

func _on_play_button_pressed():
	print("Replay: Play pressed")
	is_playing = true
	# Start processing events using a timer
	$PlaybackTimer.start(step_delay / playback_speed_scale) # Assumes you add a Timer node named PlaybackTimer

func _on_pause_button_pressed():
	print("Replay: Pause pressed")
	is_playing = false
	$PlaybackTimer.stop()

func _on_step_button_pressed():
	print("Replay: Step pressed")
	if not is_playing:
		process_next_event()

func _on_SpeedSlider_value_changed(value): # Example for speed control
	playback_speed_scale = value # Assuming slider value maps appropriately
	if is_playing: # Adjust timer if playing
		$PlaybackTimer.wait_time = step_delay / playback_speed_scale
	print("Replay: Speed changed to ", playback_speed_scale)

# Called by the PlaybackTimer timeout signal
func _on_playback_timer_timeout():
	if is_playing:
		process_next_event()
	else:
		$PlaybackTimer.stop()


# --- Core Event Processing ---

func process_next_event():
	current_event_index += 1
	if current_event_index >= battle_events.size():
		print("Replay: End of events reached.")
		is_playing = false
		$PlaybackTimer.stop()
		event_log_label.text = "--- Battle Ended ---"
		return

	var event = battle_events[current_event_index]
	print("\nProcessing Event %d: %s" % [current_event_index, event]) # Log the raw event

	# Update simple event log label (replace later with better logging/visuals)
	event_log_label.text = "Event %d: %s" % [current_event_index, event.event_type]

	# --- Main Event Matching ---
	# Start with print statements for validation
	match event.event_type:
		"turn_start":
			handle_turn_start(event)
		"mana_change":
			handle_mana_change(event)
		"card_played":
			handle_card_played(event)
		"card_moved":
			handle_card_moved(event)
		"card_removed":
			handle_card_removed(event)
		"summon_arrives":
			handle_summon_arrives(event)
		"summon_leaves_lane":
			handle_summon_leaves_lane(event)
		"summon_turn_activity":
			handle_summon_turn_activity(event)
		"combat_damage":
			handle_combat_damage(event)
		"direct_damage":
			handle_direct_damage(event)
		"effect_damage":
			handle_effect_damage(event)
		"hp_change":
			handle_hp_change(event)
		"creature_hp_change":
			handle_creature_hp_change(event)
		"stat_change":
			handle_stat_change(event)
		"status_change":
			handle_status_change(event)
		"creature_defeated":
			handle_creature_defeated(event)
		"visual_effect":
			handle_visual_effect(event)
		"log_message":
			handle_log_message(event)
		"battle_end":
			handle_battle_end(event)
		_:
			print("  -> Unhandled event type: ", event.event_type)

	# If playing automatically, restart timer for next step (unless battle ended)
	if is_playing and current_event_index < battle_events.size() -1 :
		$PlaybackTimer.start(step_delay / playback_speed_scale)


# --- Event Handler Functions (Implement with print statements first) ---

func handle_turn_start(event):
	print("  -> Turn %d starts for %s" % [event.turn, event.player])
	turn_label.text = "Turn: %d (%s)" % [event.turn, event.player]
	# await get_tree().create_timer(0.5 * playback_speed_scale).timeout # Add delays later

func handle_mana_change(event):
	print("  -> %s mana changes by %d. New total: %d (Source: %s)" % [event.player, event.amount, event.new_total, event.get("source", "N/A")])
	# TODO: Update Mana UI

func handle_card_played(event):
	print("  -> %s played %s (%s). Mana left: %d" % [event.player, event.card_id, event.card_type, event.remaining_mana])
	# TODO: Show card briefly? Update mana UI?

func handle_card_moved(event):
	print("  -> %s's %s moved from %s to %s (Reason: %s)" % [event.player, event.card_id, event.from_zone, event.to_zone, event.get("reason", "N/A")])
	# TODO: Update Deck/Grave counts/visuals? Animate card?

func handle_card_removed(event):
	print("  -> %s's %s removed from %s (Reason: %s)" % [event.player, event.card_id, event.from_zone, event.get("reason", "N/A")])
	# TODO: Update Deck/Grave counts/visuals?

func handle_summon_arrives(event):
	print("  -> %s summons %s (ID: %d) in lane %d. Stats P:%d HP:%d/%d Swift:%s Tags:%s" % [
		event.player, event.card_id, event.instance_id, event.lane,
		event.power, event.current_hp, event.max_hp, event.is_swift, str(event.get("tags", []))
	])
	# TODO: Instantiate SummonVisualScene, add to lane, store in active_summon_visuals, update display

func handle_summon_leaves_lane(event):
	print("  -> %s's %s (ID: %d) leaves lane %d (Reason: %s)" % [event.player, event.card_id, event.instance_id, event.lane, event.reason])
	# TODO: Find visual in active_summon_visuals, play leave animation, remove node & reference

func handle_summon_turn_activity(event):
	print("  -> %s's summon (ID: %d) in lane %d performs action: %s" % [event.player, event.instance_id, event.lane, event.activity_type])
	# TODO: Trigger attack/ability animation on the corresponding SummonVisual node

func handle_combat_damage(event):
	print("  -> Attack: %s lane %d (ID: %d) -> %s lane %d (ID: %d). Damage: %d. Defender HP left: %d" % [
		event.attacking_player, event.attacking_lane, event.attacking_instance_id,
		event.defending_player, event.defending_lane, event.defending_instance_id,
		event.amount, event.defender_remaining_hp
	])
	# TODO: Trigger attack anim on attacker, damage anim on defender

func handle_direct_damage(event):
	print("  -> Direct Attack: %s lane %d (ID: %d) -> %s. Damage: %d. Target HP left: %d" % [
		event.attacking_player, event.attacking_lane, event.attacking_instance_id,
		event.target_player, event.amount, event.target_player_remaining_hp
	])
	# TODO: Trigger attack anim on attacker, damage anim on target player UI

func handle_effect_damage(event):
	print("  -> Effect Damage: %s (%s) -> %s. Damage: %d. Target HP left: %d" % [
		event.source_card_id, event.source_player,
		event.target_player, event.amount, event.target_player_remaining_hp
	])
	# TODO: Trigger effect anim (e.g., spell hitting player), damage anim on target player UI

func handle_hp_change(event):
	print("  -> Player HP Change: %s amount %d. New total: %d (Source: %s)" % [event.player, event.amount, event.new_total, event.get("source", "N/A")])
	# TODO: Update player HP bar/label

func handle_creature_hp_change(event):
	print("  -> Creature HP Change: %s lane %d (ID: %d) amount %d. New HP: %d/%d (Source: %s)" % [
		event.player, event.lane, event.instance_id, event.amount, event.new_hp, event.new_max_hp, event.get("source", "N/A")
	])
	# TODO: Find SummonVisual node by instance_id, update HP label, play damage/heal anim

func handle_stat_change(event):
	print("  -> Stat Change: %s lane %d (ID: %d) stat '%s' changes by %d. New value: %d (Source: %s)" % [
		event.player, event.lane, event.instance_id, event.stat, event.amount, event.new_value, event.get("source", "N/A")
	])
	# TODO: Find SummonVisual node, update Power/MaxHP label, play buff/debuff anim

func handle_status_change(event):
	print("  -> Status Change: %s lane %d (ID: %d) %s status '%s' (Source: %s)" % [
		event.player, event.lane, event.instance_id, "gained" if event.gained else "lost", event.status, event.get("source", "N/A")
	])
	# TODO: Find SummonVisual node, update status icons

func handle_creature_defeated(event):
	print("  -> Creature Defeated: %s lane %d (ID: %d, Card: %s)" % [event.player, event.lane, event.instance_id, event.get("card_id", "N/A")])
	# TODO: Find SummonVisual node, play death anim, remove node & reference

func handle_visual_effect(event):
	print("  -> Visual Effect: ID '%s', Targets: %s, Details: %s" % [event.effect_id, str(event.target_locations), str(event.details)])
	# TODO: Trigger specific particle effects, overlays, shakes, etc. based on effect_id

func handle_log_message(event):
	print("  -> Log Message: %s" % event.message)
	# Optionally display in a dedicated log UI area

func handle_battle_end(event):
	print("--- Battle End ---")
	print("  -> Outcome: %s, Winner: %s" % [event.outcome, event.winner])
	event_log_label.text = "Battle End: %s wins!" % event.winner
	is_playing = false # Stop playback
	$PlaybackTimer.stop()
	# TODO: Display prominent Victory/Defeat message

#func _on_play_button_pressed() -> void:
	#pass # Replace with function body.
#
#func _on_pause_button_pressed() -> void:
	#pass # Replace with function body.
#
#func _on_step_button_pressed() -> void:
	#pass # Replace with function body.
