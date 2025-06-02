extends Node2D

# Preload the replay scene
const BattleReplayScene = preload("res://scenes/battle_replay_scene.tscn")

var player_deck_to_load: Array[CardResource]
var opponent_deck_to_load: Array[CardResource]

func initialize_decks(p_player_deck: Array[CardResource], p_opponent_deck: Array[CardResource]):
	player_deck_to_load = p_player_deck
	opponent_deck_to_load = p_opponent_deck

func _ready():
	print("BattleLauncher: _ready() has started.") # For debugging

	if GameSessionData:
		print("BattleLauncher: GameSessionData.player_deck (raw): ", GameSessionData.player_deck)
		print("BattleLauncher: GameSessionData.opponent_deck (raw): ", GameSessionData.opponent_deck)

		# Important: Ensure you are assigning from GameSessionData to local vars if you use them
		if GameSessionData.player_deck.is_empty() or GameSessionData.opponent_deck.is_empty():
			printerr("BattleLauncher: Decks from GameSessionData are empty! Check DeckPicker.")
			# Handle this case - maybe load defaults or go back to deck picker
			# For now, let's try to load defaults if empty, just for testing continuity
			# but ideally, this should be a more robust error handling.
			_load_default_decks_for_testing() # A hypothetical function for default decks
		else	:
			player_deck_to_load = GameSessionData.player_deck
			opponent_deck_to_load = GameSessionData.opponent_deck
	else:
		printerr("BattleLauncher: GameSessionData autoload NOT FOUND! Loading default decks for testing.")
		_load_default_decks_for_testing() # A hypothetical function for default decks
		# return # Or exit if GameSessionData is critical

	print("BattleLauncher: Using PLAYER deck for battle: ", player_deck_to_load)
	print("BattleLauncher: Using OPPONENT deck for battle: ", opponent_deck_to_load)

	var battle_sim = Battle.new()
	var events = battle_sim.run_battle(player_deck_to_load, opponent_deck_to_load, "Player", "Opponent") 
	print("--- Battle Simulation Finished (%d events) ---" % events.size())

	# --- Start Replay ---
	if events.is_empty():
		printerr("No events generated, cannot start replay.")
		return
		
	if battle_sim:
		#var events = battle_sim.run_battle(pla_deck, opp_deck, "Player", "Opponent")

		var event_count = events.size()
		print("run_battle finished. Events list (%d events):" % event_count)

		var max_events_to_show = 40 # Show all if fewer than this
		var head_count = 10
		var tail_count = 10
		# Middle count can be derived or fixed
		if event_count <= max_events_to_show:
			# Print all events
			for i in range(event_count):
				print("  [%d] %s" % [i, events[i]])
		else:
			# Print head
			print("  --- First %d Events ---" % head_count)
			for i in range(head_count):
				print("  [%d] %s" % [i, events[i]])

			# Print middle (optional, can be complex to choose wisely)
			# var middle_start = event_count / 2 - 2
			# print("  --- Middle Events ---")
			# for i in range(middle_start, middle_start + 5):
			#     if i >= head_count and i < event_count - tail_count: # Avoid overlap
			#         print("  [%d] %s" % [i, events[i]])

			# Print tail
			print("  --- Last %d Events ---" % tail_count)
			var tail_start = event_count - tail_count
			for i in range(tail_start, event_count):
				print("  [%d] %s" % [i, events[i]])

		print("------------------------------------")
		# --- End New Printing Logic ---
	else:
		printerr("Failed to create Battle instance!")

	# --- Start Replay ---
	if events.is_empty():
		printerr("No events generated, cannot start replay.")
		return

	# Instantiate the replay scene
	var replay_instance = BattleReplayScene.instantiate()
	# Add it to this scene so it becomes visible
	add_child(replay_instance)

	# Get the script and load events
	# Use call_deferred to ensure the replay scene's _ready() has run
	replay_instance.call_deferred("load_and_start_simple_replay", events)
	print("--- Battle Replay Initiated ---")

# Hypothetical function to load your old default decks for fallback during testing
func _load_default_decks_for_testing():
	printerr("BattleLauncher: LOADING DEFAULT DECKS as a fallback.")
	# Re-add your old hardcoded deck loading here, e.g.:
	var _unmake_res = CardDB.get_card_resource("Unmake") 
	var _taunting_elf_res = CardDB.get_card_resource("TauntingElf")
	opponent_deck_to_load = [_unmake_res, _taunting_elf_res] 
	player_deck_to_load = [_taunting_elf_res]
	pass # Replace with actual default deck loading if needed for fallback
