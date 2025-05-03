# res://tests/test_card_effects.gd
extends GutTest

# Preload resources
var avenging_tiger_res = load("res://data/cards/instances/avenging_tiger.tres") as SummonCardResource
var disarm_res = load("res://data/cards/instances/disarm.tres") as SpellCardResource
var energy_axe_res = load("res://data/cards/instances/energy_axe.tres") as SpellCardResource
var focus_res = load("res://data/cards/instances/focus.tres") as SpellCardResource
var goblin_firework_res = load("res://data/cards/instances/goblin_firework.tres") as SummonCardResource
var goblin_scout_res = load("res://data/cards/instances/goblin_scout.tres") as SummonCardResource
var healer_res = load("res://data/cards/instances/healer.tres") as SummonCardResource
var knight_res = load("res://data/cards/instances/knight.tres") as SummonCardResource # Needed for target
var charging_bull_res = load("res://data/cards/instances/charging_bull.tres") as SummonCardResource
var portal_mage_res = load("res://data/cards/instances/portal_mage.tres") as SummonCardResource
var recurring_skeleton_res = load("res://data/cards/instances/recurring_skeleton.tres") as SummonCardResource
var vampire_swordmaster_res = load("res://data/cards/instances/vampire_swordmaster.tres") as SummonCardResource
var wall_of_vines_res = load("res://data/cards/instances/wall_of_vines.tres") as SummonCardResource


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


# --- Disarm Tests ---
func test_disarm_reduces_highest_power():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Setup opponent creatures
	var weak_scout = place_summon_for_test(opponent, goblin_scout_res, 0, battle) # Power 1, Lane 1
	var strong_knight = place_summon_for_test(opponent, knight_res, 1, battle) # Power 3, Lane 2
	var initial_knight_power = strong_knight.get_current_power()

	# Action: Apply Disarm effect
	# Call directly on the loaded resource
	disarm_res.apply_effect(disarm_res, player, opponent, battle)

	# Assert: Knight's power reduced, Scout's unchanged
	assert_eq(strong_knight.get_current_power(), initial_knight_power - 2, "Disarm should reduce Knight's power by 2.")
	assert_eq(weak_scout.get_current_power(), 1, "Disarm should not affect Scout's power.")
	# Assert: Modifier added to Knight
	assert_eq(strong_knight.power_modifiers.size(), 1, "Disarm should add power modifier to Knight.")
	assert_eq(strong_knight.power_modifiers[0]["value"], -2, "Disarm modifier value should be -2.")
	assert_eq(strong_knight.power_modifiers[0]["source"], "Disarm", "Disarm modifier source incorrect.")

	# Assert: Event generated
	var events = battle.battle_events
	assert_false(events.is_empty(), "Disarm should generate events.")
	var stat_event_found = false
	for event in events: # Check all events as order might vary
		if event.get("event_type") == "stat_change" and event.get("stat") == "power" and event.get("lane") == 2: # Knight is in lane 1 (index 1 -> lane 2)
			stat_event_found = true
			assert_eq(event["new_value"], initial_knight_power - 2, "Disarm stat_change event new_value incorrect.")
			assert_eq(event["amount"], -2, "Disarm stat_change event amount incorrect.")
			break
	assert_true(stat_event_found, "Stat change event for Disarm target not found.")


func test_disarm_can_play():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	player.mana = 3 # Enough mana

	# Case 1: Opponent has no creatures
	assert_false(disarm_res.can_play(player, opponent, 0, battle), "Disarm should not be playable if opponent has no creatures.")

	# Case 2: Opponent has creatures
	place_summon_for_test(opponent, goblin_scout_res, 0, battle)
	assert_true(disarm_res.can_play(player, opponent, 0, battle), "Disarm should be playable if opponent has creatures.")

	# Case 3: Not enough mana
	player.mana = 2
	assert_false(disarm_res.can_play(player, opponent, 0, battle), "Disarm should not be playable without enough mana.")


# --- Goblin Firework Tests ---
func test_goblin_firework_death_deals_damage():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Place Firework and an opposing target
	var firework_instance = place_summon_for_test(player, goblin_firework_res, 1, battle) # Lane 2
	var target_knight = place_summon_for_test(opponent, knight_res, 1, battle) # Lane 2
	var initial_knight_hp = target_knight.current_hp
	var initial_event_count = battle.battle_events.size() # Count events before action

	# Action: Trigger the death effect manually (normally called by die())
	# Call directly on the loaded resource
	goblin_firework_res._on_death(firework_instance, player, opponent, battle)

	# Assert: Knight took damage
	assert_eq(target_knight.current_hp, initial_knight_hp - 1, "Goblin Firework death should damage opposing Knight.")

	# Assert: Event generated (creature_hp_change for Knight)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	assert_false(events_after.is_empty(), "Firework death should generate events.")
	var hp_event_found = false
	for event in events_after:
		if event.get("event_type") == "creature_hp_change" and event.get("lane") == 2 and event.get("player") == opponent.combatant_name:
			hp_event_found = true
			assert_eq(event["amount"], -1, "Firework damage event amount incorrect.")
			assert_eq(event["new_hp"], initial_knight_hp - 1, "Firework damage event new_hp incorrect.")
			break # Found the relevant event
	assert_true(hp_event_found, "Creature HP change event for Firework target not found.")


func test_goblin_firework_death_no_target():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Place Firework with no opposing target
	var firework_instance = place_summon_for_test(player, goblin_firework_res, 1, battle) # Lane 2
	var initial_event_count = battle.battle_events.size()

	# Action: Trigger the death effect
	# Call directly on the loaded resource
	goblin_firework_res._on_death(firework_instance, player, opponent, battle)

	# Assert: No extra damage events generated
	var damage_event_found = false
	for event in battle.battle_events.slice(initial_event_count, battle.battle_events.size()):
		if event.get("event_type") == "creature_hp_change":
			damage_event_found = true
			break
	assert_false(damage_event_found, "Firework death should not generate damage event if no target.")

# --- Wall Of Vines Tests ---
func test_wall_of_vines_generates_mana():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var battle = setup["battle"]
	player.mana = 2 # Start with some mana
	var initial_mana = player.mana
	# Place Wall of Vines
	var wall_instance = place_summon_for_test(player, wall_of_vines_res, 0, battle)
	var initial_event_count = battle.battle_events.size()

	# Action: Simulate its turn activity (normally called by Battle)
	# We call the override directly on the resource
	var handled = wall_of_vines_res.perform_turn_activity_override(wall_instance, player, player.opponent, battle)

	# Assert: Handled should be true
	assert_true(handled, "Wall of Vines override should return true.")
	# Assert: Player mana increased
	assert_eq(player.mana, initial_mana + 1, "Wall of Vines should increase player mana by 1.")

	# Assert: Events generated (mana_change + ability activation)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	assert_gte(events_after.size(), 2, "Wall of Vines activity should generate at least 2 events.")
	var mana_event_found = false
	var ability_event_found = false
	for event in events_after:
		if event.get("event_type") == "mana_change" and event.get("player") == player.combatant_name:
			mana_event_found = true
			assert_eq(event["amount"], 1, "Mana change event amount incorrect.")
		elif event.get("event_type") == "summon_turn_activity" and event.get("activity_type") == "ability_mana_gen":
			ability_event_found = true
	assert_true(mana_event_found, "Mana change event not found for Wall of Vines.")
	assert_true(ability_event_found, "Ability activation event not found for Wall of Vines.")


# --- Charging Bull Tests ---
# Note: Swiftness is tested implicitly by checking if it attacks on turn 2 in simulation
# We can test the resource property directly here.
func test_charging_bull_is_swift():
	assert_true(charging_bull_res.is_swift, "Charging Bull resource should have is_swift = true.")
	# Test that SummonInstance gets the flag
	var setup = create_test_battle_setup()
	var bull_instance = SummonInstance.new()
	bull_instance.setup(charging_bull_res, setup["player"], setup["opponent"], 0, setup["battle"])
	assert_true(bull_instance.is_swift, "Charging Bull instance should inherit is_swift = true.")
	# The actual check for is_newly_arrived vs is_swift happens in Battle.conduct_turn


# --- Portal Mage Tests ---
func test_portal_mage_bounces_opponent():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Place a target for the opponent
	var target_knight = place_summon_for_test(opponent, knight_res, 1, battle) # Lane 2

	# Ensure opponent library is empty to easily check the bounced card
	opponent.library.clear()

	# Simulate Portal Mage arrival
	var mage_instance = SummonInstance.new()
	mage_instance.setup(portal_mage_res, player, opponent, 1, battle) # Arrives in Lane 2 opposite Knight
	var initial_event_count = battle.battle_events.size()

	# Action: Call the arrival effect
	portal_mage_res._on_arrival(mage_instance, player, opponent, battle)

	# Assert: Opponent's lane is now empty
	assert_null(opponent.lanes[1], "Opponent's lane 2 should be empty after bounce.")
	# Assert: Opponent's library now contains the Knight resource
	assert_eq(opponent.library.size(), 1, "Opponent's library should have 1 card.")
	assert_eq(opponent.library[0].id, "Knight", "Opponent's library top card should be Knight.") # Check ID

	# Assert: Events generated (summon_leaves_lane + card_moved)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	assert_gte(events_after.size(), 2, "Portal Mage bounce should generate at least 2 events.")
	var leaves_event_found = false
	var moved_event_found = false
	for event in events_after:
		if event.get("event_type") == "summon_leaves_lane" and event.get("lane") == 2:
			leaves_event_found = true
			assert_eq(event["card_id"], "Knight", "Summon leaves event card ID incorrect.")
		elif event.get("event_type") == "card_moved" and event.get("to_zone") == "library":
			moved_event_found = true
			assert_eq(event["card_id"], "Knight", "Card moved event card ID incorrect.")
	assert_true(leaves_event_found, "Summon leaves lane event not found.")
	assert_true(moved_event_found, "Card moved to library event not found.")


func test_portal_mage_arrival_no_target():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Opponent has no creature in lane 1
	var initial_event_count = battle.battle_events.size()
	var initial_lib_size = opponent.library.size()

	# Simulate Portal Mage arrival
	var mage_instance = SummonInstance.new()
	mage_instance.setup(portal_mage_res, player, opponent, 1, battle) # Arrives in Lane 2

	# Action: Call the arrival effect
	portal_mage_res._on_arrival(mage_instance, player, opponent, battle)

	# Assert: Opponent's lane is still empty
	assert_null(opponent.lanes[1], "Opponent's lane 2 should remain empty.")
	# Assert: Opponent's library size unchanged
	assert_eq(opponent.library.size(), initial_lib_size, "Opponent's library size should not change.")
	# Assert: No bounce-related events generated
	var bounce_events_found = false
	for event in battle.battle_events.slice(initial_event_count, battle.battle_events.size()):
		if event.get("event_type") == "summon_leaves_lane" or \
		   (event.get("event_type") == "card_moved" and event.get("to_zone") == "library"):
			bounce_events_found = true
			break
	assert_false(bounce_events_found, "No bounce events should be generated if no target.")

# --- Vampire Swordmaster Tests ---
func test_vampire_swordmaster_heals_on_kill():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Place Vampire and a weak target
	var vampire_instance = place_summon_for_test(player, vampire_swordmaster_res, 0, battle)
	var target_scout = place_summon_for_test(opponent, goblin_scout_res, 0, battle) # 2 HP

	# Damage Vampire so it needs healing
	vampire_instance.current_hp = 1
	var initial_vamp_hp = vampire_instance.current_hp

	# Action: Simulate combat where Vampire kills Scout (Vamp power 3 vs Scout HP 2)
	vampire_instance._perform_combat(target_scout) # This calls take_damage, die, and _on_kill_target

	# Assert: Scout is dead (or at least has <= 0 HP)
	assert_lte(target_scout.current_hp, 0, "Target scout should have 0 or less HP.")
	# Assert: Vampire healed to full
	assert_eq(vampire_instance.current_hp, vampire_instance.get_current_max_hp(), "Vampire should heal to full HP after kill.")

	# Assert: Heal event generated for Vampire
	var events = battle.battle_events
	var heal_event_found = false
	for event in events:
		if event.get("event_type") == "creature_hp_change" and \
		   event.get("lane") == 1 and \
		   event.get("player") == player.combatant_name and \
		   event.get("amount") > 0: # Check for positive amount (heal)
			heal_event_found = true
			assert_eq(event["new_hp"], vampire_instance.get_current_max_hp(), "Heal event new_hp incorrect.")
			break
	assert_true(heal_event_found, "Heal event for Vampire after kill not found.")

# --- Recurring Skeleton Tests ---
func test_recurring_skeleton_returns_to_deck_on_death():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var battle = setup["battle"]
	# Place Skeleton
	var skeleton_instance = place_summon_for_test(player, recurring_skeleton_res, 0, battle)
	var initial_deck_size = player.library.size()
	var initial_grave_size = player.graveyard.size()

	# Action: Kill the skeleton
	skeleton_instance.take_damage(100) # Overkill to ensure death

	# Assert: Skeleton instance removed from lane
	assert_null(player.lanes[0], "Lane should be empty after skeleton dies.")
	# Assert: Card added to bottom of library
	assert_eq(player.library.size(), initial_deck_size + 1, "Library size should increase by 1.")
	assert_eq(player.library[-1].id, "RecurringSkeleton", "Recurring Skeleton should be at the bottom of the library.")
	# Assert: Card NOT added to graveyard
	assert_eq(player.graveyard.size(), initial_grave_size, "Graveyard size should not increase.")

	# Assert: Events (creature_defeated + card_moved to library)
	var events = battle.battle_events
	var defeated_event_found = false
	var moved_event_found = false
	for event in events:
		if event.get("event_type") == "creature_defeated" and event.get("lane") == 1:
			defeated_event_found = true
		elif event.get("event_type") == "card_moved" and \
			 event.get("card_id") == "RecurringSkeleton" and \
			 event.get("to_zone") == "library":
			moved_event_found = true
			assert_eq(event.get("to_details", {}).get("position"), "bottom", "Card moved event should specify bottom.")
	assert_true(defeated_event_found, "Creature defeated event not found.")
	assert_true(moved_event_found, "Card moved to library event not found.")


# --- Focus Tests ---
func test_focus_grants_mana():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var battle = setup["battle"]
	player.mana = 1
	var initial_mana = player.mana
	var initial_event_count = battle.battle_events.size()

	# Action: Apply Focus effect
	focus_res.apply_effect(focus_res, player, player.opponent, battle)

	# Assert: Mana increased correctly (up to cap)
	var expected_mana = min(initial_mana + 8, Constants.MAX_MANA)
	assert_eq(player.mana, expected_mana, "Focus should grant correct mana.")

	# Assert: Event generated (mana_change)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	assert_false(events_after.is_empty(), "Focus should generate events.")
	var mana_event_found = false
	for event in events_after:
		if event.get("event_type") == "mana_change" and event.get("player") == player.combatant_name:
			mana_event_found = true
			assert_eq(event["amount"], expected_mana - initial_mana, "Focus mana change amount incorrect.")
			assert_eq(event["new_total"], expected_mana, "Focus mana change new_total incorrect.")
			break
	assert_true(mana_event_found, "Mana change event for Focus not found.")


# --- Avenging Tiger Tests ---
func test_avenging_tiger_gains_swift_if_hp_lower():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Set player HP lower than opponent
	player.current_hp = 10
	opponent.current_hp = 15

	# Simulate Tiger arrival
	var tiger_instance = SummonInstance.new()
	tiger_instance.setup(avenging_tiger_res, player, opponent, 0, battle)
	var initial_event_count = battle.battle_events.size()

	# Action: Call arrival effect
	avenging_tiger_res._on_arrival(tiger_instance, player, opponent, battle)

	# Assert: Instance is now swift
	assert_true(tiger_instance.is_swift, "Avenging Tiger should gain swift when player HP is lower.")

	# Assert: Event generated (status_change)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var status_event_found = false
	for event in events_after:
		if event.get("event_type") == "status_change" and event.get("status") == "Swift":
			status_event_found = true
			assert_true(event.get("gained"), "Swift status change event should indicate gained.")
			break
	assert_true(status_event_found, "Status change event for Swift not found.")


func test_avenging_tiger_does_not_gain_swift_if_hp_not_lower():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Set player HP equal or higher
	player.current_hp = 15
	opponent.current_hp = 15
	var initial_event_count = battle.battle_events.size()

	# Simulate Tiger arrival
	var tiger_instance = SummonInstance.new()
	tiger_instance.setup(avenging_tiger_res, player, opponent, 0, battle)

	# Action: Call arrival effect
	avenging_tiger_res._on_arrival(tiger_instance, player, opponent, battle)

	# Assert: Instance is NOT swift
	assert_false(tiger_instance.is_swift, "Avenging Tiger should not gain swift when player HP is not lower.")

	# Assert: No Swift status change event generated
	var status_event_found = false
	for event in battle.battle_events.slice(initial_event_count, battle.battle_events.size()):
		if event.get("event_type") == "status_change" and event.get("status") == "Swift":
			status_event_found = true
			break
	assert_false(status_event_found, "No Swift status change event should be generated.")
