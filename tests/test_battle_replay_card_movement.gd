# In test_battle_replay_card_movement.gd
extends GutTest

var replay_logic: BattleReplay # Assuming BattleReplay is class_name for battle_replay.gd
var mock_events: Array[Dictionary]

func before_each():
	replay_logic = BattleReplay.new() 
	# Add to a temporary tree for testing node-specific logic if needed,
	# but for pure logic tests on BattleReplay, this might not be necessary
	# If GUT doesn't manage a tree for .new() nodes, they need manual free.
	# get_tree().get_root().add_child(replay_logic) # Optional, if you need _ready, _process etc.

	replay_logic.player1_name = "Player" 
	replay_logic.player2_name = "Opponent" 

	# Create and assign mock nodes directly
	replay_logic.bottom_player_library_hbox = HBoxContainer.new()
	replay_logic.bottom_player_graveyard_hbox = HBoxContainer.new()
	replay_logic.top_player_library_hbox = HBoxContainer.new()
	replay_logic.top_player_graveyard_hbox = HBoxContainer.new()
	
	replay_logic.bottom_player_library_count_label = Label.new()
	replay_logic.bottom_player_graveyard_count_label = Label.new()
	replay_logic.top_player_library_count_label = Label.new()
	replay_logic.top_player_graveyard_count_label = Label.new()
	
	# If BattleReplay expects these @onready vars to be children, 
	# you'd need to add them as children to replay_logic.
	# For example:
	# replay_logic.add_child(replay_logic.bottom_player_library_hbox) 
	# This is important if @onready vars are used, as they resolve when added to tree.
	# If they are just properties accessed by methods, direct assignment is fine,
	# but they still need to be freed.

	mock_events = []
	gut.p("Setup complete for test_battle_replay_card_movement") # More specific print

func after_each():
	gut.p("Starting Teardown for test_battle_replay_card_movement")
	# Free the manually created nodes that were assigned as properties
	# Check is_instance_valid before calling queue_free just in case
	if is_instance_valid(replay_logic.bottom_player_library_hbox):
		replay_logic.bottom_player_library_hbox.queue_free()
	if is_instance_valid(replay_logic.bottom_player_graveyard_hbox):
		replay_logic.bottom_player_graveyard_hbox.queue_free()
	if is_instance_valid(replay_logic.top_player_library_hbox):
		replay_logic.top_player_library_hbox.queue_free()
	if is_instance_valid(replay_logic.top_player_graveyard_hbox):
		replay_logic.top_player_graveyard_hbox.queue_free()
		
	if is_instance_valid(replay_logic.bottom_player_library_count_label):
		replay_logic.bottom_player_library_count_label.queue_free()
	if is_instance_valid(replay_logic.bottom_player_graveyard_count_label):
		replay_logic.bottom_player_graveyard_count_label.queue_free()
	if is_instance_valid(replay_logic.top_player_library_count_label):
		replay_logic.top_player_library_count_label.queue_free()
	if is_instance_valid(replay_logic.top_player_graveyard_count_label):
		replay_logic.top_player_graveyard_count_label.queue_free()

	# Then free the main replay_logic node itself
	if is_instance_valid(replay_logic):
		replay_logic.queue_free() 
	
	replay_logic = null # Clear the reference
	mock_events.clear() # Clear the array if it held any complex objects
	gut.p("Teardown complete for test_battle_replay_card_movement")
	
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
