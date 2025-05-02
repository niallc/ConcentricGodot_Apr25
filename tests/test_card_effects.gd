# res://tests/test_card_effects.gd
extends GutTest

# Preload resources
var goblin_scout_res = load("res://data/cards/instances/goblin_scout.tres") as SummonCardResource
var energy_axe_res = load("res://data/cards/instances/energy_axe.tres") as SpellCardResource
var healer_res = load("res://data/cards/instances/healer.tres") as SummonCardResource

# --- Test Helper Functions ---
# Creates a basic Battle setup for testing effects
func create_test_battle_setup(deck1: Array[CardResource] = [], deck2: Array[CardResource] = []) -> Dictionary:
	# Rest of the function remains the same...
	var battle = Battle.new()
	var duelist1 = Combatant.new()
	var duelist2 = Combatant.new()
	# Now, deck1 and deck2 are guaranteed to be the correct type when passed
	duelist1.setup(deck1, Constants.STARTING_HP, "PlayerEffectTester", battle, duelist2)
	duelist2.setup(deck2, Constants.STARTING_HP, "OpponentEffectTester", battle, duelist1)
	return {"battle": battle, "player": duelist1, "opponent": duelist2}

# Creates a SummonInstance and places it in a lane for testing
func place_summon_for_test(combatant, card_res: SummonCardResource, lane_idx: int, battle) -> SummonInstance:
	var instance = SummonInstance.new()
	instance.setup(card_res, combatant, combatant.opponent, lane_idx, battle)
	combatant.lanes[lane_idx] = instance
	# Manually add summon_arrives event for consistency if needed by effect
	# battle.add_event({... summon_arrives data ...})
	return instance

# --- Energy Axe Tests ---

# Test Energy Axe applies power correctly
func test_energy_axe_applies_power():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var battle = setup["battle"]
	# Place a target summon
	var scout_instance = place_summon_for_test(player, goblin_scout_res, 0, battle)
	var initial_power = scout_instance.get_current_power()

	# Get the effect script instance
	var effect_script = energy_axe_res.script.new()

	# Action: Apply the effect
	effect_script.apply_effect(energy_axe_res, player, player.opponent, battle)

	# Assert: Target's power increased
	assert_eq(scout_instance.get_current_power(), initial_power + 3, "Energy Axe should increase power by 3.")
	# Assert: Modifier was added
	assert_eq(scout_instance.power_modifiers.size(), 1, "Energy Axe should add one power modifier.")
	assert_eq(scout_instance.power_modifiers[0]["source"], energy_axe_res.id, "Modifier source should be EnergyAxe.")

	# Assert: Events generated (stat_change + visual_effect)
	var events = battle.battle_events
	assert_gte(events.size(), 2, "Energy Axe should generate at least 2 events.")
	# Check last two events (order might vary slightly depending on exact implementation)
	var stat_event_found = false
	var visual_event_found = false
	for event in events.slice(events.size()-2, events.size()): # Check last 2
		if event["event_type"] == "stat_change" and event["stat"] == "power":
			stat_event_found = true
			assert_eq(event["new_value"], initial_power + 3, "Stat change event new_value incorrect.")
		elif event["event_type"] == "visual_effect" and event["effect_id"] == "energy_axe_boost":
			visual_event_found = true
	assert_true(stat_event_found, "Stat change event for power not found.")
	assert_true(visual_event_found, "Visual effect event for boost not found.")


# Test Energy Axe can_play requirements
func test_energy_axe_can_play():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]

	player.mana = 4 # Enough mana

	# Case 1: No creatures in lane
	assert_false(energy_axe_res.can_play(player, opponent, 0, battle), "Energy Axe should not be playable with no creatures.")

	# Case 2: Creature in lane
	place_summon_for_test(player, goblin_scout_res, 1, battle)
	assert_true(energy_axe_res.can_play(player, opponent, 0, battle), "Energy Axe should be playable with a creature.")


	# Case 3: Not enough mana
	player.mana = 3
	assert_false(energy_axe_res.can_play(player, opponent, 0, battle), "Energy Axe should not be playable without enough mana.")



# --- Healer Tests ---

# Test Healer _on_arrival heals the player
func test_healer_on_arrival_heals_player():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var battle = setup["battle"]
	player.current_hp = 10 # Set HP lower to test heal
	var initial_hp = player.current_hp

	# Get the effect script instance
	var effect_script = healer_res.script.new()

	# Simulate arrival (create instance, then call _on_arrival)
	# Note: Normally Battle logic calls this after summon_arrives event
	var healer_instance = SummonInstance.new()
	healer_instance.setup(healer_res, player, player.opponent, 0, battle)

	# Action: Call the arrival effect
	effect_script._on_arrival(healer_instance, player, player.opponent, battle)

	# Assert: Player HP increased (clamped at max HP)
	var expected_hp = min(initial_hp + 8, player.max_hp)
	assert_eq(player.current_hp, expected_hp, "Healer arrival should heal player.")

	# Assert: Events generated (hp_change + visual_effect)
	var events = battle.battle_events
	assert_gte(events.size(), 2, "Healer arrival should generate at least 2 events.")
	# Check last two events
	var hp_event_found = false
	var visual_event_found = false
	for event in events.slice(events.size()-2, events.size()):
		if event["event_type"] == "hp_change" and event["player"] == player.combatant_name:
			hp_event_found = true
			assert_eq(event["new_total"], expected_hp, "HP change event new_total incorrect.")
			assert_eq(event["amount"], expected_hp - initial_hp, "HP change event amount incorrect.")
		elif event["event_type"] == "visual_effect" and event["effect_id"] == "heal_pulse_player":
			visual_event_found = true
	assert_true(hp_event_found, "HP change event for player not found.")
	assert_true(visual_event_found, "Visual effect event for heal pulse not found.")
