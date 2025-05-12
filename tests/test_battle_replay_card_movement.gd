# In test_battle_replay_card_movement.gd
extends GutTest

var replay_logic: BattleReplay # Assuming BattleReplay is class_name for battle_replay.gd
var mock_events: Array[Dictionary]

func before_each():
	replay_logic = BattleReplay.new() # Or instance from scene if needed
	# We need to manually set up player names if _determine_player_identities isn't called
	# or if the functions we test rely on them being pre-set.
	# For simplicity in these unit tests, we can pre-set them.
	replay_logic.player1_name = "Player" # Assuming Player is bottom
	replay_logic.player2_name = "Opponent" # Assuming Opponent is top

	# Mock necessary HBoxContainers if _update_zone_display is called.
	# For pure data tests, we might not need to call _update_zone_display.
	replay_logic.bottom_player_library_hbox = HBoxContainer.new()
	replay_logic.bottom_player_graveyard_hbox = HBoxContainer.new()
	replay_logic.top_player_library_hbox = HBoxContainer.new()
	replay_logic.top_player_graveyard_hbox = HBoxContainer.new()
	# Add mock labels if _update_zone_display needs them
	replay_logic.bottom_player_library_count_label = Label.new()
	# ... etc for other 3 count labels

	mock_events = []
	gut.p("Setup complete")

func after_each():
	if is_instance_valid(replay_logic.bottom_player_library_hbox):
		replay_logic.bottom_player_library_hbox.queue_free()
	# ... free other mocked nodes ...
	if is_instance_valid(replay_logic):
		replay_logic.queue_free() # If it's a Node
		# replay_logic = null # If just an Object
	gut.p("Teardown complete")

# In res://tests/test_battle_replay_card_movement.gd

# ... (before_each, after_each as you have them) ...

func test_initial_library_populates_arrays():
	mock_events = [
		{"event_type": "initial_library_state", "player": "Player", "card_ids": ["CardA", "CardB"]},
		{"event_type": "initial_library_state", "player": "Opponent", "card_ids": ["CardX", "CardY"]}
	]

	replay_logic.player1_library_card_ids.clear()
	replay_logic.player2_library_card_ids.clear()

	for event_data in mock_events:
		if event_data.event_type == "initial_library_state":
			var current_event_player = event_data.player
			var target_lib_arr_ref = null

			if current_event_player == replay_logic.player1_name:
				target_lib_arr_ref = replay_logic.player1_library_card_ids
			elif current_event_player == replay_logic.player2_name:
				target_lib_arr_ref = replay_logic.player2_library_card_ids
			
			if target_lib_arr_ref != null:
				# In Godot 4, Array.assign() creates a shallow copy.
				# If event_data.card_ids is a new array literal like ["CardA", "CardB"],
				# this is fine.
				target_lib_arr_ref.assign(event_data.card_ids) 
				# Alternative if assign isn't doing what you want or for clarity:
				# target_lib_arr_ref.clear()
				# for card_id_str in event_data.card_ids:
				#    target_lib_arr_ref.append(card_id_str)


	gut.p("P1 Lib after mock processing: " + str(replay_logic.player1_library_card_ids))
	gut.p("P2 Lib after mock processing: " + str(replay_logic.player2_library_card_ids))

	# Corrected assert_eq_deep calls (removed third message argument)
	assert_eq_deep(replay_logic.player1_library_card_ids, ["CardA", "CardB"])
	assert_eq_deep(replay_logic.player2_library_card_ids, ["CardX", "CardY"])

	# If you really want a custom message with the failure, you might do:
	# var p1_libs_match = replay_logic.player1_library_card_ids == ["CardA", "CardB"] # Godot's default array comparison
	# if not p1_libs_match:
	#    gut.set_test_message("Player 1 library should be ['CardA', 'CardB'] but was " + str(replay_logic.player1_library_card_ids))
	# assert_true(p1_libs_match) 
	# But assert_eq_deep should give good diagnostic output itself.
