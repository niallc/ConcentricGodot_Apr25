# res://tests/test_summon_instance_modifiers.gd
extends GutTest

# Preload resources needed for tests
var goblin_scout_res = load("res://data/cards/instances/goblin_scout.tres") as SummonCardResource
var energy_axe_res = load("res://data/cards/instances/energy_axe.tres") as SpellCardResource

# Test Helper: Creates a basic SummonInstance for testing
# Note: This uses partial mocks/stubs for dependencies, which is okay for focused tests
# A more advanced setup might use full mocking frameworks if available/needed.
func create_test_summon_instance(card_res: SummonCardResource) -> SummonInstance:
	# Create stub objects for dependencies
	var mock_battle = Battle.new() # Use real Battle to get event adding
	var mock_owner = Combatant.new()
	var mock_opponent = Combatant.new()
	# Minimal setup for combatants
	mock_owner.setup([], Constants.STARTING_HP, "MockOwner", mock_battle, mock_opponent)
	mock_opponent.setup([], Constants.STARTING_HP, "MockOpponent", mock_battle, mock_owner)

	var instance = SummonInstance.new()
	var new_id = mock_battle.get_new_instance_id()
	instance.setup(card_res, mock_owner, mock_opponent, 0, mock_battle, new_id) # Assume lane 0
	return instance

# Test initial power and HP calculation
func test_summon_initial_stats():
	var scout_instance = create_test_summon_instance(goblin_scout_res)
	assert_eq(scout_instance.get_current_power(), 1, "Goblin Scout initial power should be 1.")
	assert_eq(scout_instance.get_current_max_hp(), 2, "Goblin Scout initial max HP should be 2.")
	assert_eq(scout_instance.current_hp, 2, "Goblin Scout initial current HP should be 2.")

# Test adding a permanent power modifier
func test_add_permanent_power_modifier():
	var scout_instance = create_test_summon_instance(goblin_scout_res)
	var initial_power = scout_instance.get_current_power()
	var boost_amount = 3
	var source_id = "TestBoost"

	# Action: Add the power modifier
	scout_instance.add_power(boost_amount, source_id, -1) # Duration -1 for permanent

	# Assert: Modifier list should contain the new modifier
	assert_eq(scout_instance.power_modifiers.size(), 1, "Power modifiers list should have 1 entry.")
	assert_eq(scout_instance.power_modifiers[0]["value"], boost_amount, "Modifier value incorrect.")
	assert_eq(scout_instance.power_modifiers[0]["source"], source_id, "Modifier source incorrect.")

	# Assert: Calculated power should increase
	assert_eq(scout_instance.get_current_power(), initial_power + boost_amount, "Calculated power after boost is incorrect.")

	# Assert: Event should have been generated
	var events = scout_instance.battle_instance.battle_events
	assert_false(events.is_empty(), "Events should have been generated.")
	var last_event = events[-1] # Get the last event added
	assert_eq(last_event["event_type"], "stat_change", "Last event should be stat_change.")
	assert_eq(last_event["stat"], "power", "Stat change should be for power.")
	assert_eq(last_event["amount"], boost_amount, "Stat change amount incorrect.")
	assert_eq(last_event["new_value"], initial_power + boost_amount, "Stat change new_value incorrect.")
	assert_eq(last_event["player"], scout_instance.owner_combatant.combatant_name, "Stat change player incorrect.")

# Test adding a permanent max HP modifier (and current HP heal)
func test_add_permanent_hp_modifier():
	var scout_instance = create_test_summon_instance(goblin_scout_res)
	var initial_max_hp = scout_instance.get_current_max_hp()
	var initial_hp = scout_instance.current_hp
	var boost_amount = 4
	var source_id = "TestHPBoost"

	# Action: Add the HP modifier
	scout_instance.add_hp(boost_amount, source_id, -1)

	# Assert: Modifier list
	assert_eq(scout_instance.max_hp_modifiers.size(), 1, "Max HP modifiers list should have 1 entry.")
	assert_eq(scout_instance.max_hp_modifiers[0]["value"], boost_amount, "HP Modifier value incorrect.")

	# Assert: Calculated max HP
	var new_max_hp = initial_max_hp + boost_amount
	assert_eq(scout_instance.get_current_max_hp(), new_max_hp, "Calculated max HP after boost is incorrect.")

	# Assert: Current HP should also increase (heal effect) and be capped
	assert_eq(scout_instance.current_hp, min(initial_hp + boost_amount, new_max_hp), "Current HP after boost/heal is incorrect.")

	# Assert: Events (stat_change for max_hp AND creature_hp_change for current_hp)
	var events = scout_instance.battle_instance.battle_events
	assert_gte(events.size(), 2, "Should have generated at least 2 events (stat_change + hp_change).")

	var stat_event = events[-2] # Assuming stat_change comes before hp_change from heal
	var hp_event = events[-1]

	# Check stat_change event
	assert_eq(stat_event["event_type"], "stat_change", "Second to last event should be stat_change.")
	assert_eq(stat_event["stat"], "max_hp", "Stat change should be for max_hp.")
	assert_eq(stat_event["amount"], boost_amount, "Max HP change amount incorrect.")
	assert_eq(stat_event["new_value"], new_max_hp, "Max HP change new_value incorrect.")

	# Check creature_hp_change event
	assert_eq(hp_event["event_type"], "creature_hp_change", "Last event should be creature_hp_change.")
	# Amount healed might be less than boost_amount if it hit max HP cap
	assert_eq(hp_event["amount"], scout_instance.current_hp - initial_hp, "HP change amount incorrect.")
	assert_eq(hp_event["new_hp"], scout_instance.current_hp, "HP change new_hp incorrect.")
	assert_eq(hp_event["new_max_hp"], new_max_hp, "HP change new_max_hp incorrect.")


# TODO: Add tests for timed modifier expiration once _end_of_turn_upkeep is fully implemented
# func test_timed_modifier_expires():
#	 var scout_instance = create_test_summon_instance(goblin_scout_res)
#	 scout_instance.add_power(5, "TemporaryBoost", 1) # Duration 1 turn
#	 assert_eq(scout_instance.get_current_power(), 1 + 5)
#	 scout_instance._end_of_turn_upkeep() # Simulate end of turn
#	 assert_eq(scout_instance.power_modifiers.size(), 0, "Modifier should have expired.")
#	 assert_eq(scout_instance.get_current_power(), 1, "Power should return to base after expiration.")
#	 # Assert that stat_change event was generated by upkeep
