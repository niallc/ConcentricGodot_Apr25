# res://tests/test_card_effects.gd
extends GutTest

# Preload resources
var apprentice_assassin_res = load("res://data/cards/instances/apprentice_assassin.tres") as SummonCardResource
var avenging_tiger_res = load("res://data/cards/instances/avenging_tiger.tres") as SummonCardResource
var disarm_res = load("res://data/cards/instances/disarm.tres") as SpellCardResource
var energy_axe_res = load("res://data/cards/instances/energy_axe.tres") as SpellCardResource
var focus_res = load("res://data/cards/instances/focus.tres") as SpellCardResource
var goblin_chieftain_res = load("res://data/cards/instances/goblin_chieftain.tres") as SummonCardResource
var goblin_expendable_res = load("res://data/cards/instances/goblin_expendable.tres") as SummonCardResource
var goblin_firework_res = load("res://data/cards/instances/goblin_firework.tres") as SummonCardResource
var goblin_rally_res = load("res://data/cards/instances/goblin_rally.tres") as SpellCardResource
var goblin_scout_res = load("res://data/cards/instances/goblin_scout.tres") as SummonCardResource
var goblin_warboss_res = load("res://data/cards/instances/goblin_warboss.tres") as SummonCardResource
var goliath_res = load("res://data/cards/instances/goliath.tres") as SummonCardResource
var healer_res = load("res://data/cards/instances/healer.tres") as SummonCardResource
var inexorable_ooze_res = load("res://data/cards/instances/inexorable_ooze.tres") as SummonCardResource
var knight_res = load("res://data/cards/instances/knight.tres") as SummonCardResource # Needed for target
var charging_bull_res = load("res://data/cards/instances/charging_bull.tres") as SummonCardResource
var portal_mage_res = load("res://data/cards/instances/portal_mage.tres") as SummonCardResource
var reanimate_res = load("res://data/cards/instances/reanimate.tres") as SpellCardResource
var recurring_skeleton_res = load("res://data/cards/instances/recurring_skeleton.tres") as SummonCardResource
var superior_intellect_res = load("res://data/cards/instances/superior_intellect.tres") as SpellCardResource
var thought_acquirer_res = load("res://data/cards/instances/thought_acquirer.tres") as SummonCardResource
var vampire_swordmaster_res = load("res://data/cards/instances/vampire_swordmaster.tres") as SummonCardResource
var wall_of_vines_res = load("res://data/cards/instances/wall_of_vines.tres") as SummonCardResource
var master_of_strategy_res = load("res://data/cards/instances/master_of_strategy.tres") as SummonCardResource
var slayer_res = load("res://data/cards/instances/slayer.tres") as SummonCardResource
var bloodrager_res = load("res://data/cards/instances/bloodrager.tres") as SummonCardResource
var spiteful_fang_res = load("res://data/cards/instances/spiteful_fang.tres") as SummonCardResource
var nap_res = load("res://data/cards/instances/nap.tres") as SpellCardResource
var totem_of_champions_res = load("res://data/cards/instances/totem_of_champions.tres") as SpellCardResource
var amnesia_mage_res = load("res://data/cards/instances/amnesia_mage.tres") as SummonCardResource
var overconcentrate_res = load("res://data/cards/instances/overconcentrate.tres") as SpellCardResource
var goblin_recruiter_res = load("res://data/cards/instances/goblin_recruiter.tres") as SummonCardResource
var vengeful_warlord_res = load("res://data/cards/instances/vengeful_warlord.tres") as SummonCardResource
var corpsecraft_titan_res = load("res://data/cards/instances/corpsecraft_titan.tres") as SummonCardResource
var insatiable_devourer_res = load("res://data/cards/instances/insatiable_devourer.tres") as SummonCardResource
var repentant_samurai_res = load("res://data/cards/instances/repentant_samurai.tres") as SummonCardResource
var cursed_samurai_res = load("res://data/cards/instances/cursed_samurai.tres") as SummonCardResource
var glassgraft_res = load("res://data/cards/instances/glassgraft.tres") as SpellCardResource
var returned_samurai_res = load("res://data/cards/instances/returned_samurai.tres") as SummonCardResource
var unmake_res = load("res://data/cards/instances/unmake.tres") as SpellCardResource
var skeletal_infantry_res = load("res://data/cards/instances/skeletal_infantry.tres") as SummonCardResource
var reassembling_legion_res = load("res://data/cards/instances/reassembling_legion.tres") as SummonCardResource
var ghoul_res = load("res://data/cards/instances/ghoul.tres") as SummonCardResource
var dreadhorde_res = load("res://data/cards/instances/dreadhorde.tres") as SummonCardResource
var bog_giant_res = load("res://data/cards/instances/bog_giant.tres") as SummonCardResource
var knight_of_opposites_res = load("res://data/cards/instances/knight_of_opposites.tres") as SummonCardResource
var malignant_imp_res = load("res://data/cards/instances/malignant_imp.tres") as SummonCardResource
var walking_sarcophagus_res = load("res://data/cards/instances/walking_sarcophagus.tres") as SummonCardResource
var indulged_princeling_res = load("res://data/cards/instances/indulged_princeling.tres") as SummonCardResource

var elsewhere_res = load("res://data/cards/instances/elsewhere.tres") as SpellCardResource
var carnivorous_plant_res = load("res://data/cards/instances/carnivorous_plant.tres") as SummonCardResource
var chanter_of_ashes_res = load("res://data/cards/instances/chanter_of_ashes.tres") as SummonCardResource
var goblin_gladiator_res = load("res://data/cards/instances/goblin_gladiator.tres") as SummonCardResource
var inferno_res = load("res://data/cards/instances/inferno.tres") as SpellCardResource
var flamewielder_res = load("res://data/cards/instances/flamewielder.tres") as SummonCardResource
var rampaging_cyclops_res = load("res://data/cards/instances/rampaging_cyclops.tres") as SummonCardResource

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
	battle.duelist1 = duelist1
	battle.duelist2 = duelist2
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
	var _target_knight = place_summon_for_test(opponent, knight_res, 1, battle) # Lane 2

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
	# var initial_vamp_hp = vampire_instance.current_hp

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

# --- Superior Intellect Tests ---
func test_superior_intellect_moves_grave_to_library_and_clears_opponent():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Setup graveyards by modifying the existing arrays
	player.graveyard.clear() # Ensure it's empty first
	player.graveyard.append(goblin_scout_res)
	player.graveyard.append(knight_res)
	opponent.graveyard.clear()
	opponent.graveyard.append(healer_res)
	var initial_player_lib_size = player.library.size()
	var initial_event_count = battle.battle_events.size() # Track events before action

	# Action: Apply effect
	superior_intellect_res.apply_effect(superior_intellect_res, player, opponent, battle)

	# Assert: Player graveyard is empty
	assert_true(player.graveyard.is_empty(), "Player graveyard should be empty.")
	# Assert: Player library increased and contains moved cards at bottom
	assert_eq(player.library.size(), initial_player_lib_size + 2, "Player library size incorrect.")
	# Check last two cards (order depends on how they were added)
	assert_eq(player.library[-1].id, "Knight", "Knight should be at library bottom.")
	assert_eq(player.library[-2].id, "GoblinScout", "Scout should be second from bottom.")
	# Assert: Opponent graveyard is empty
	assert_true(opponent.graveyard.is_empty(), "Opponent graveyard should be empty.")

	# Assert: Events generated (card_moved for player, card_removed for opponent)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var player_moved_count = 0
	var opponent_removed_count = 0
	for event in events_after:
		if event.get("event_type") == "card_moved" and event.get("player") == player.combatant_name and event.get("to_zone") == "library":
			player_moved_count += 1
		elif event.get("event_type") == "card_removed" and event.get("player") == opponent.combatant_name and event.get("from_zone") == "graveyard":
			opponent_removed_count += 1
	assert_eq(player_moved_count, 2, "Incorrect number of player card_moved events.")
	assert_eq(opponent_removed_count, 1, "Incorrect number of opponent card_removed events.")


# --- Goblin Rally Tests ---
func test_goblin_rally_summons_scouts_in_empty_lanes():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Setup lanes: Lane 0 empty, Lane 1 occupied, Lane 2 empty
	place_summon_for_test(player, knight_res, 1, battle)
	var initial_event_count = battle.battle_events.size()

	# Action: Apply effect
	goblin_rally_res.apply_effect(goblin_rally_res, player, opponent, battle)

	# Assert: Lanes 0 and 2 now have Goblin Scouts
	assert_true(player.lanes[0] is SummonInstance and player.lanes[0].card_resource.id == "GoblinScout", "Lane 1 should have Goblin Scout.")
	assert_true(player.lanes[1] is SummonInstance and player.lanes[1].card_resource.id == "Knight", "Lane 2 should still have Knight.") # Check original occupant
	assert_true(player.lanes[2] is SummonInstance and player.lanes[2].card_resource.id == "GoblinScout", "Lane 3 should have Goblin Scout.")

	# Assert: Events generated (2x summon_arrives)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var summon_arrive_count = 0
	for event in events_after:
		if event.get("event_type") == "summon_arrives" and event.get("card_id") == "GoblinScout":
			summon_arrive_count += 1
	assert_eq(summon_arrive_count, 2, "Goblin Rally should generate 2 summon_arrives events.")


func test_goblin_rally_no_empty_lanes():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Occupy all lanes
	place_summon_for_test(player, knight_res, 0, battle)
	place_summon_for_test(player, knight_res, 1, battle)
	place_summon_for_test(player, knight_res, 2, battle)
	var initial_event_count = battle.battle_events.size()

	# Action: Apply effect
	goblin_rally_res.apply_effect(goblin_rally_res, player, opponent, battle)

	# Assert: Lanes unchanged
	assert_true(player.lanes[0].card_resource.id == "Knight", "Lane 1 unchanged.")
	assert_true(player.lanes[1].card_resource.id == "Knight", "Lane 2 unchanged.")
	assert_true(player.lanes[2].card_resource.id == "Knight", "Lane 3 unchanged.")
	# Assert: No summon_arrives events generated
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var summon_arrive_count = 0
	for event in events_after:
		if event.get("event_type") == "summon_arrives":
			summon_arrive_count += 1
	assert_eq(summon_arrive_count, 0, "Goblin Rally should generate 0 summon_arrives events if no lanes free.")


# --- Thought Acquirer Tests ---
func test_thought_acquirer_steals_card():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Setup opponent library
	opponent.library.clear() # Use clear and append
	opponent.library.append(goblin_scout_res)
	opponent.library.append(knight_res)
	opponent.library.append(healer_res) # Scout top, Healer bottom
	var initial_opp_lib_size = opponent.library.size()
	var initial_player_lib_size = player.library.size()
	var bottom_card_id = opponent.library[-1].id

	# Simulate arrival
	var instance = SummonInstance.new()
	instance.setup(thought_acquirer_res, player, opponent, 0, battle)
	var initial_event_count = battle.battle_events.size()

	# Action: Call arrival effect
	thought_acquirer_res._on_arrival(instance, player, opponent, battle)

	# Assert: Opponent library size decreased
	assert_eq(opponent.library.size(), initial_opp_lib_size - 1, "Opponent library size should decrease.")
	# Assert: Player library size increased
	assert_eq(player.library.size(), initial_player_lib_size + 1, "Player library size should increase.")
	# Assert: Correct card moved to player library bottom
	assert_eq(player.library[-1].id, bottom_card_id, "Incorrect card moved to player library bottom.")

	# Assert: Events generated (2x card_moved)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var moved_from_opp = false
	var moved_to_player = false
	for event in events_after:
		if event.get("event_type") == "card_moved" and event.get("player") == opponent.combatant_name and event.get("from_zone") == "library":
			moved_from_opp = true
		elif event.get("event_type") == "card_moved" and event.get("player") == player.combatant_name and event.get("to_zone") == "library":
			moved_to_player = true
	assert_true(moved_from_opp, "Card moved from opponent library event not found.")
	assert_true(moved_to_player, "Card moved to player library event not found.")


func test_thought_acquirer_opponent_library_empty():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Opponent library empty
	opponent.library.clear() # Use clear
	var initial_player_lib_size = player.library.size()
	var initial_event_count = battle.battle_events.size()

	# Simulate arrival
	var instance = SummonInstance.new()
	instance.setup(thought_acquirer_res, player, opponent, 0, battle)

	# Action: Call arrival effect
	thought_acquirer_res._on_arrival(instance, player, opponent, battle)

	# Assert: Libraries unchanged
	assert_true(opponent.library.is_empty(), "Opponent library should remain empty.")
	assert_eq(player.library.size(), initial_player_lib_size, "Player library size should not change.")
	# Assert: No card_moved events generated
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var moved_event_found = false
	for event in events_after:
		if event.get("event_type") == "card_moved":
			moved_event_found = true
			break
	assert_false(moved_event_found, "No card_moved events should be generated.")

# --- Inexorable Ooze Tests ---
func test_inexorable_ooze_is_relentless():
	# Test the tag sets the flag correctly during setup
	var setup = create_test_battle_setup()
	var ooze_instance = SummonInstance.new()
	ooze_instance.setup(inexorable_ooze_res, setup["player"], setup["opponent"], 0, setup["battle"])
	assert_true(ooze_instance.is_relentless, "Inexorable Ooze instance should be relentless after setup.")
	# Actual relentless behavior (calling _perform_direct_attack) is tested implicitly
	# when simulating turns involving the Ooze.

# --- Reanimate Tests ---
func test_reanimate_summons_from_graveyard():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Setup graveyard and ensure lane 0 is free
	player.graveyard.clear()
	player.graveyard.append(knight_res) # Knight is leftmost
	player.graveyard.append(goblin_scout_res)
	player.lanes[0] = null
	var initial_grave_size = player.graveyard.size()
	var initial_event_count = battle.battle_events.size()

	# Action: Apply effect
	reanimate_res.apply_effect(reanimate_res, player, opponent, battle)

	# Assert: Lane 0 now has Knight
	assert_true(player.lanes[0] is SummonInstance and player.lanes[0].card_resource.id == "Knight", "Lane 1 should have reanimated Knight.")
	# Assert: Knight has Undead tag
	assert_true(player.lanes[0].tags.has(Constants.TAG_UNDEAD), "Reanimated Knight should have Undead tag.")
	# Assert: Graveyard size decreased
	assert_eq(player.graveyard.size(), initial_grave_size - 1, "Graveyard size should decrease.")
	# Assert: Knight is no longer in graveyard
	var knight_in_grave = false
	for card in player.graveyard:
		if card.id == "Knight": knight_in_grave = true; break
	assert_false(knight_in_grave, "Knight should be removed from graveyard.")

	# Assert: Events generated (card_moved grave->limbo, summon_arrives, card_moved limbo->lane)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	assert_gte(events_after.size(), 3, "Reanimate should generate at least 3 events.")
	var moved_from_grave = false
	var arrived = false
	var moved_to_lane = false
	for event in events_after:
		if event.get("event_type") == "card_moved" and event.get("from_zone") == "graveyard": moved_from_grave = true
		elif event.get("event_type") == "summon_arrives" and event.get("card_id") == "Knight": arrived = true
		elif event.get("event_type") == "card_moved" and event.get("from_zone") == "limbo" and event.get("to_zone") == "lane": moved_to_lane = true
	assert_true(moved_from_grave, "Card moved from graveyard event not found.")
	assert_true(arrived, "Summon arrives event not found.")
	assert_true(moved_to_lane, "Card moved to lane event not found.")


func test_reanimate_no_target_in_graveyard():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	player.graveyard.clear() # Empty graveyard
	var initial_event_count = battle.battle_events.size()
	reanimate_res.apply_effect(reanimate_res, player, opponent, battle)
	# Assert no summon arrived
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var arrived = false
	for event in events_after:
		if event.get("event_type") == "summon_arrives": arrived = true; break
	assert_false(arrived, "No summon should arrive if graveyard empty.")


func test_reanimate_no_empty_lane():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	#player.graveyard = [knight_res] # Target in graveyard
	player.graveyard.clear()

	# Fill lanes
	place_summon_for_test(player, goblin_scout_res, 0, battle)
	place_summon_for_test(player, goblin_scout_res, 1, battle)
	place_summon_for_test(player, goblin_scout_res, 2, battle)
	var initial_event_count = battle.battle_events.size()
	reanimate_res.apply_effect(reanimate_res, player, opponent, battle)
	# Assert no summon arrived
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var arrived = false
	for event in events_after:
		if event.get("event_type") == "summon_arrives": arrived = true; break
	assert_false(arrived, "No summon should arrive if lanes full.")


# --- Goblin Chieftain/Warboss Tests ---
func test_goblin_chieftain_adds_warboss_to_deck():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var battle = setup["battle"]
	var initial_lib_size = player.library.size()
	# Simulate arrival
	var instance = SummonInstance.new()
	instance.setup(goblin_chieftain_res, player, player.opponent, 0, battle)
	var initial_event_count = battle.battle_events.size()
	# Action
	goblin_chieftain_res._on_arrival(instance, player, player.opponent, battle)
	# Assert
	assert_eq(player.library.size(), initial_lib_size + 1, "Library size should increase.")
	assert_eq(player.library[-1].id, "GoblinWarboss", "Goblin Warboss should be added to bottom.")
	# Assert event
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var moved_event_found = false
	for event in events_after:
		if event.get("event_type") == "card_moved" and event.get("card_id") == "GoblinWarboss": moved_event_found = true; break
	assert_true(moved_event_found, "Card moved event for Warboss not found.")


func test_goblin_warboss_adds_expendable_to_deck():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var battle = setup["battle"]
	var initial_lib_size = player.library.size()
	# Simulate arrival
	var instance = SummonInstance.new()
	instance.setup(goblin_warboss_res, player, player.opponent, 0, battle)
	var initial_event_count = battle.battle_events.size()
	# Action
	goblin_warboss_res._on_arrival(instance, player, player.opponent, battle)
	# Assert
	assert_eq(player.library.size(), initial_lib_size + 1, "Library size should increase.")
	assert_eq(player.library[-1].id, "GoblinExpendable", "Goblin Expendable should be added to bottom.")
	# Assert event
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var moved_event_found = false
	for event in events_after:
		if event.get("event_type") == "card_moved" and event.get("card_id") == "GoblinExpendable": moved_event_found = true; break
	assert_true(moved_event_found, "Card moved event for Expendable not found.")


# --- Apprentice Assassin Tests ---
func test_apprentice_assassin_gains_power_on_kill():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Place Assassin and a weak target
	var assassin_instance = place_summon_for_test(player, apprentice_assassin_res, 0, battle) # Power 2
	var target_scout = place_summon_for_test(opponent, goblin_scout_res, 0, battle) # HP 2
	var initial_assassin_power = assassin_instance.get_current_power()
	var initial_event_count = battle.battle_events.size()

	# Action: Simulate combat where Assassin kills Scout
	assassin_instance._perform_combat(target_scout)

	# Assert: Scout is dead
	assert_lte(target_scout.current_hp, 0, "Target scout should be dead.")
	# Assert: Assassin power increased
	assert_eq(assassin_instance.get_current_power(), initial_assassin_power + 2, "Assassin power should increase by 2.")
	# Assert: Modifier added
	assert_eq(assassin_instance.power_modifiers.size(), 1, "Assassin should gain a power modifier.")
	assert_eq(assassin_instance.power_modifiers[0]["value"], 2, "Assassin power modifier value incorrect.")

	# Assert: Stat change event generated for Assassin
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var stat_event_found = false
	for event in events_after:
		if event.get("event_type") == "stat_change" and event.get("stat") == "power" and \
		   event.get("player") == player.combatant_name and event.get("lane") == 1:
			stat_event_found = true
			assert_eq(event["new_value"], initial_assassin_power + 2, "Assassin stat change new_value incorrect.")
			break
	assert_true(stat_event_found, "Stat change event for Assassin after kill not found.")


# --- Goblin Expendable Tests ---
func test_goblin_expendable_is_swift():
	# Test the resource property
	assert_true(goblin_expendable_res.is_swift, "Goblin Expendable resource should have is_swift = true.")
	# Test instance setup
	var setup = create_test_battle_setup()
	var instance = SummonInstance.new()
	instance.setup(goblin_expendable_res, setup["player"], setup["opponent"], 0, setup["battle"])
	assert_true(instance.is_swift, "Goblin Expendable instance should inherit is_swift = true.")

# --- Master of Strategy Tests ---
func test_master_of_strategy_buffs_others():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var battle = setup["battle"]
	# Place other creatures
	var scout1 = place_summon_for_test(player, goblin_scout_res, 0, battle)
	var scout2 = place_summon_for_test(player, goblin_scout_res, 2, battle)
	var initial_scout1_power = scout1.get_current_power()
	var initial_scout1_hp = scout1.get_current_max_hp()
	var initial_scout2_power = scout2.get_current_power()
	var initial_scout2_hp = scout2.get_current_max_hp()

	# Simulate Master arrival in lane 1
	var master_instance = SummonInstance.new()
	master_instance.setup(master_of_strategy_res, player, player.opponent, 1, battle)
	player.lanes[1] = master_instance # Manually place for test setup
	var initial_event_count = battle.battle_events.size()

	# Action: Call arrival effect
	master_of_strategy_res._on_arrival(master_instance, player, player.opponent, battle)

	# Assert: Scouts are buffed
	assert_eq(scout1.get_current_power(), initial_scout1_power + 1, "Scout 1 power incorrect.")
	assert_eq(scout1.get_current_max_hp(), initial_scout1_hp + 1, "Scout 1 max HP incorrect.")
	assert_eq(scout2.get_current_power(), initial_scout2_power + 1, "Scout 2 power incorrect.")
	assert_eq(scout2.get_current_max_hp(), initial_scout2_hp + 1, "Scout 2 max HP incorrect.")
	# Assert: Master itself is NOT buffed
	assert_eq(master_instance.get_current_power(), 3, "Master power should be base.")
	assert_eq(master_instance.get_current_max_hp(), 3, "Master max HP should be base.")

	# Assert: Events generated (expect 4 stat_change, 4 hp_change)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var stat_changes = 0
	var hp_changes = 0
	for event in events_after:
		if event.get("event_type") == "stat_change": stat_changes += 1
		elif event.get("event_type") == "creature_hp_change": hp_changes += 1
	assert_eq(stat_changes, 4, "Incorrect number of stat_change events for Master.") # 2 power, 2 max_hp
	assert_eq(hp_changes, 2, "Incorrect number of creature_hp_change events for Master.") # 2 heals


# --- Slayer Tests ---
func test_slayer_kills_undead_opponent():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Place Undead target for opponent
	var _target_skeleton = place_summon_for_test(opponent, recurring_skeleton_res, 0, battle) # Lane 1
	var initial_event_count = battle.battle_events.size()

	# Simulate Slayer arrival opposite target
	var slayer_instance = SummonInstance.new()
	slayer_instance.setup(slayer_res, player, opponent, 0, battle) # Arrives in Lane 1

	# Action: Call arrival effect
	slayer_res._on_arrival(slayer_instance, player, opponent, battle)

	# Assert: Skeleton lane is now empty (it died)
	assert_null(opponent.lanes[0], "Opponent lane 1 should be empty after Slayer kills Skeleton.")
	# Assert: Skeleton went to library (due to its own death effect)
	assert_eq(opponent.library.size(), 1, "Opponent library should contain Skeleton.")
	assert_eq(opponent.library[0].id, "RecurringSkeleton", "Skeleton should be in library.")

	# Assert: Events generated (creature_defeated for skeleton, card_moved for skeleton)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var defeated_event_found = false
	var moved_event_found = false
	for event in events_after:
		if event.get("event_type") == "creature_defeated" and event.get("lane") == 1 and event.get("player") == opponent.combatant_name:
			defeated_event_found = true
		elif event.get("event_type") == "card_moved" and event.get("card_id") == "RecurringSkeleton" and event.get("to_zone") == "library":
			moved_event_found = true
	assert_true(defeated_event_found, "Creature defeated event for Skeleton not found.")
	assert_true(moved_event_found, "Card moved event for Skeleton not found.")


func test_slayer_does_not_kill_non_undead_opponent():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Place non-Undead target
	var _target_knight = place_summon_for_test(opponent, knight_res, 0, battle) # Lane 1
	var initial_event_count = battle.battle_events.size()

	# Simulate Slayer arrival
	var slayer_instance = SummonInstance.new()
	slayer_instance.setup(slayer_res, player, opponent, 0, battle)

	# Action: Call arrival effect
	slayer_res._on_arrival(slayer_instance, player, opponent, battle)

	# Assert: Knight is still in lane
	assert_true(opponent.lanes[0] is SummonInstance and opponent.lanes[0].card_resource.id == "Knight", "Knight should still be in lane 1.")
	# Assert: No creature_defeated event generated for Knight
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var defeated_event_found = false
	for event in events_after:
		if event.get("event_type") == "creature_defeated" and event.get("player") == opponent.combatant_name:
			defeated_event_found = true; break
	assert_false(defeated_event_found, "No creature defeated event should be generated for Knight.")


# --- Bloodrager Tests ---
func test_bloodrager_heals_and_relentless_on_kill():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Place Bloodrager and weak target
	var rager_instance = place_summon_for_test(player, bloodrager_res, 0, battle) # Power 3
	var target_scout = place_summon_for_test(opponent, goblin_scout_res, 0, battle) # HP 2
	# Damage rager
	rager_instance.current_hp = 1
	var initial_event_count = battle.battle_events.size()

	# Action: Simulate combat kill
	rager_instance._perform_combat(target_scout) # Calls _on_kill_target internally

	# Assert: Scout is dead
	assert_lte(target_scout.current_hp, 0, "Target scout should be dead.")
	# Assert: Rager healed to full
	assert_eq(rager_instance.current_hp, rager_instance.get_current_max_hp(), "Bloodrager should heal to full.")
	# Assert: Rager is now relentless
	assert_true(rager_instance.is_relentless, "Bloodrager should become relentless.")

	# Assert: Events generated (heal + status change)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var heal_event_found = false
	var status_event_found = false
	for event in events_after:
		# Check for heal event for the rager
		if event.get("event_type") == "creature_hp_change" and \
		   event.get("player") == player.combatant_name and \
		   event.get("lane") == 1 and event.get("amount") > 0:
			heal_event_found = true
		# Check for relentless status gain event
		elif event.get("event_type") == "status_change" and \
			 event.get("status") == "Relentless" and \
			 event.get("gained") == true and \
			 event.get("lane") == 1:
			status_event_found = true
	assert_true(heal_event_found, "Heal event for Bloodrager not found.")
	assert_true(status_event_found, "Relentless status gain event not found.")


# --- Spiteful Fang Tests ---
func test_spiteful_fang_gets_buff_if_hp_lower():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	player.current_hp = 10
	opponent.current_hp = 15 # Player HP is lower
	var initial_event_count = battle.battle_events.size()

	# Simulate arrival
	var fang_instance = SummonInstance.new()
	fang_instance.setup(spiteful_fang_res, player, opponent, 0, battle)

	# Action: Call arrival effect
	spiteful_fang_res._on_arrival(fang_instance, player, opponent, battle)

	# Assert: Stats increased (+2/+2)
	assert_eq(fang_instance.get_current_power(), 2 + 2, "Fang power should be 4.")
	assert_eq(fang_instance.get_current_max_hp(), 1 + 2, "Fang max HP should be 3.")
	assert_eq(fang_instance.current_hp, 1 + 2, "Fang current HP should be 3.") # Healed by add_hp

	# Assert: Events generated (2x stat_change, 1x hp_change)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var stat_changes = 0
	var hp_changes = 0
	for event in events_after:
		if event.get("event_type") == "stat_change": stat_changes += 1
		elif event.get("event_type") == "creature_hp_change": hp_changes += 1
	assert_eq(stat_changes, 2, "Incorrect number of stat_change events for Spiteful Fang buff.")
	assert_eq(hp_changes, 1, "Incorrect number of creature_hp_change events for Spiteful Fang buff.")


func test_spiteful_fang_no_buff_if_hp_not_lower():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	player.current_hp = 15
	opponent.current_hp = 15 # Player HP not lower
	var initial_event_count = battle.battle_events.size()

	# Simulate arrival
	var fang_instance = SummonInstance.new()
	fang_instance.setup(spiteful_fang_res, player, opponent, 0, battle)

	# Action: Call arrival effect
	spiteful_fang_res._on_arrival(fang_instance, player, opponent, battle)

	# Assert: Stats are base
	assert_eq(fang_instance.get_current_power(), 2, "Fang power should be base 2.")
	assert_eq(fang_instance.get_current_max_hp(), 1, "Fang max HP should be base 1.")

	# Assert: No stat/hp change events generated by arrival effect
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var change_event_found = false
	for event in events_after:
		if event.get("event_type") == "stat_change" or event.get("event_type") == "creature_hp_change":
			change_event_found = true; break
	assert_false(change_event_found, "No stat/hp change events should be generated by Spiteful Fang arrival.")


func test_spiteful_fang_is_relentless():
	# Test instance setup sets flag based on tag
	var setup = create_test_battle_setup()
	var instance = SummonInstance.new()
	instance.setup(spiteful_fang_res, setup["player"], setup["opponent"], 0, setup["battle"])
	assert_true(instance.is_relentless, "Spiteful Fang instance should be relentless after setup.")

# --- Nap Tests ---
func test_nap_heals_player():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var battle = setup["battle"]
	player.current_hp = 15
	var initial_hp = player.current_hp
	var initial_event_count = battle.battle_events.size()

	# Action: Apply effect
	nap_res.apply_effect(nap_res, player, player.opponent, battle)

	# Assert: HP increased
	var expected_hp = min(initial_hp + 2, player.max_hp)
	assert_eq(player.current_hp, expected_hp, "Nap should heal player.")

	# Assert: Event generated
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var hp_event_found = false
	for event in events_after:
		if event.get("event_type") == "hp_change" and event.get("player") == player.combatant_name:
			hp_event_found = true
			assert_eq(event["amount"], expected_hp - initial_hp, "Nap heal amount incorrect.")
			break
	assert_true(hp_event_found, "HP change event for Nap not found.")


# --- Totem of Champions Tests ---
func test_totem_of_champions_buffs_debuffs():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Place creatures
	var player_scout = place_summon_for_test(player, goblin_scout_res, 0, battle) # P:1
	var player_knight = place_summon_for_test(player, knight_res, 1, battle)     # P:3
	var opp_scout = place_summon_for_test(opponent, goblin_scout_res, 0, battle) # P:1
	var opp_knight = place_summon_for_test(opponent, knight_res, 1, battle)     # P:3
	var initial_event_count = battle.battle_events.size()

	# Action: Apply effect
	totem_of_champions_res.apply_effect(totem_of_champions_res, player, opponent, battle)

	# Assert: Player creatures buffed
	assert_eq(player_scout.get_current_power(), 1 + 1, "Player Scout power incorrect.")
	assert_eq(player_knight.get_current_power(), 3 + 1, "Player Knight power incorrect.")
	# Assert: Opponent creatures debuffed
	assert_eq(opp_scout.get_current_power(), 1 - 1, "Opponent Scout power incorrect.") # Becomes 0
	assert_eq(opp_knight.get_current_power(), 3 - 1, "Opponent Knight power incorrect.") # Becomes 2

	# Assert: Events generated (4x stat_change for power)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var stat_changes = 0
	for event in events_after:
		if event.get("event_type") == "stat_change" and event.get("stat") == "power":
			stat_changes += 1
	assert_eq(stat_changes, 4, "Incorrect number of power stat_change events for Totem.")


# --- Amnesia Mage Tests ---
func test_amnesia_mage_drains_mana():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Setup state
	player.graveyard.clear()
	player.graveyard.append(goblin_scout_res) # Knight is leftmost
	player.graveyard.append(knight_res)

	opponent.mana = 5 # Opponent has mana to lose
	var initial_opp_mana = opponent.mana
	var expected_drain = 2 + player.graveyard.size() # 2 + 2 = 4
	var initial_event_count = battle.battle_events.size()

	# Simulate arrival
	var instance = SummonInstance.new()
	instance.setup(amnesia_mage_res, player, opponent, 0, battle)

	# Action: Call arrival effect
	amnesia_mage_res._on_arrival(instance, player, opponent, battle)

	# Assert: Opponent mana reduced
	assert_eq(opponent.mana, initial_opp_mana - expected_drain, "Opponent mana incorrect after drain.")

	# Assert: Event generated (mana_change for opponent)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var mana_event_found = false
	for event in events_after:
		if event.get("event_type") == "mana_change" and event.get("player") == opponent.combatant_name:
			mana_event_found = true
			assert_eq(event["amount"], -expected_drain, "Amnesia mana drain amount incorrect.")
			break
	assert_true(mana_event_found, "Mana change event for Amnesia Mage drain not found.")


func test_amnesia_mage_drain_limited_by_opponent_mana():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	player.graveyard.clear()
	player.graveyard.append(goblin_scout_res)

	opponent.mana = 2 # Opponent has less mana than potential drain (2+1=3)
	var expected_drain = 2 + player.graveyard.size() # Potential drain = 3
	var actual_drain = min(expected_drain, opponent.mana) # Actual drain = 2

	var instance = SummonInstance.new()
	instance.setup(amnesia_mage_res, player, opponent, 0, battle)
	amnesia_mage_res._on_arrival(instance, player, opponent, battle)

	assert_eq(opponent.mana, 0, "Opponent mana should be 0.") # Drained to zero
	# Check event amount reflects actual drain
	var events = battle.battle_events
	var mana_event_found = false
	for event in events:
		if event.get("event_type") == "mana_change" and event.get("player") == opponent.combatant_name:
			mana_event_found = true
			assert_eq(event["amount"], -actual_drain, "Amnesia drain amount should be limited by opponent mana.")
			break
	assert_true(mana_event_found, "Mana change event for limited Amnesia Mage drain not found.")


# --- Overconcentrate Tests ---
func test_overconcentrate_makes_relentless():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Place target creature
	var target_knight = place_summon_for_test(opponent, knight_res, 0, battle) # Lane 1
	assert_false(target_knight.is_relentless, "Knight should not start relentless.")
	var initial_event_count = battle.battle_events.size()

	# Action: Apply effect
	overconcentrate_res.apply_effect(overconcentrate_res, player, opponent, battle)

	# Assert: Target is now relentless
	assert_true(target_knight.is_relentless, "Overconcentrate should make target relentless.")

	# Assert: Event generated (status_change)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var status_event_found = false
	for event in events_after:
		if event.get("event_type") == "status_change" and \
		   event.get("status") == "Relentless" and \
		   event.get("gained") == true and \
		   event.get("lane") == 1: # Knight in lane 1
			status_event_found = true
			break
	assert_true(status_event_found, "Relentless status gain event for Overconcentrate not found.")


func test_overconcentrate_no_target():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Opponent has no creatures
	var initial_event_count = battle.battle_events.size()
	overconcentrate_res.apply_effect(overconcentrate_res, player, opponent, battle)
	# Assert: No status change event generated
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var status_event_found = false
	for event in events_after:
		if event.get("event_type") == "status_change": status_event_found = true; break
	assert_false(status_event_found, "No status change event should be generated if no target.")

# --- Goblin Recruiter Tests ---
func test_goblin_recruiter_summons_if_hp_lower():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	player.current_hp = 10
	opponent.current_hp = 15 # Player HP lower
	# Leave lanes 0 and 2 empty
	place_summon_for_test(player, knight_res, 1, battle)
	var initial_event_count = battle.battle_events.size()
	# Simulate arrival
	var instance = SummonInstance.new()
	instance.setup(goblin_recruiter_res, player, opponent, 1, battle) # Assume it arrives in lane 1 (doesn't matter for effect)
	# Action
	goblin_recruiter_res._on_arrival(instance, player, opponent, battle)
	# Assert: Scouts summoned in lanes 0 and 2
	assert_true(player.lanes[0] is SummonInstance and player.lanes[0].card_resource.id == "GoblinScout", "Lane 1 should have Scout.")
	assert_true(player.lanes[2] is SummonInstance and player.lanes[2].card_resource.id == "GoblinScout", "Lane 3 should have Scout.")
	# Assert Events
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var summon_count = 0
	for event in events_after:
		if event.get("event_type") == "summon_arrives" and event.get("card_id") == "GoblinScout": summon_count += 1
	assert_eq(summon_count, 2, "Should summon 2 scouts.")

func test_goblin_recruiter_no_summon_if_hp_not_lower():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]

	player.current_hp = 15
	opponent.current_hp = 15 # Player HP not lower
	var initial_event_count = battle.battle_events.size()
	var instance = SummonInstance.new()
	instance.setup(goblin_recruiter_res, player, opponent, 1, battle)
	goblin_recruiter_res._on_arrival(instance, player, opponent, battle)
	# Assert no scouts summoned
	assert_null(player.lanes[0], "Lane 1 should be empty.")
	assert_null(player.lanes[2], "Lane 3 should be empty.")
	# Assert events
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var summon_count = 0
	for event in events_after:
		if event.get("event_type") == "summon_arrives": summon_count += 1
	assert_eq(summon_count, 0, "Should summon 0 scouts.")


# --- Vengeful Warlord Tests ---
func test_vengeful_warlord_gets_buff_if_hp_lower():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]

	player.current_hp = 10
	opponent.current_hp = 15
	var instance = SummonInstance.new()
	instance.setup(vengeful_warlord_res, player, opponent, 0, battle)
	var initial_power = instance.get_current_power()
	var initial_hp = instance.get_current_max_hp()
	vengeful_warlord_res._on_arrival(instance, player, opponent, battle)
	assert_eq(instance.get_current_power(), initial_power + 1, "Warlord power incorrect.")
	assert_eq(instance.get_current_max_hp(), initial_hp + 1, "Warlord max HP incorrect.")

func test_vengeful_warlord_no_buff_if_hp_not_lower():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]

	player.current_hp = 15
	opponent.current_hp = 15
	var instance = SummonInstance.new()
	instance.setup(vengeful_warlord_res, player, opponent, 0, battle)
	var initial_power = instance.get_current_power()
	var initial_hp = instance.get_current_max_hp()
	vengeful_warlord_res._on_arrival(instance, player, opponent, battle)
	assert_eq(instance.get_current_power(), initial_power, "Warlord power should be base.")
	assert_eq(instance.get_current_max_hp(), initial_hp, "Warlord max HP should be base.")


# --- Corpsecraft Titan Tests ---
func test_corpsecraft_titan_can_play():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var battle = setup["battle"]

	player.mana = 6 # Enough mana
	player.graveyard.clear()
	
	# Case 1: Not enough summons in grave
	assert_false(corpsecraft_titan_res.can_play(player, player.opponent, 0, battle), "Titan needs 3 summons in grave.")
	player.graveyard.append(healer_res)
	player.graveyard.append(knight_res)
	player.graveyard.append(goblin_scout_res)
	assert_true(corpsecraft_titan_res.can_play(player, player.opponent, 0, battle), "Titan should be playable with 3 summons.")
	# Case 2: Not enough mana
	player.mana = 5
	assert_false(corpsecraft_titan_res.can_play(player, player.opponent, 0, battle), "Titan needs 6 mana.")
	# Case 3: No empty lane (assuming can_play checks this - it should!)
	player.mana = 6
	place_summon_for_test(player, knight_res, 0, battle)
	place_summon_for_test(player, knight_res, 1, battle)
	place_summon_for_test(player, knight_res, 2, battle)
	assert_false(corpsecraft_titan_res.can_play(player, player.opponent, 0, battle), "Titan needs an empty lane.")


func test_corpsecraft_titan_consumes_grave():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var battle = setup["battle"]
	player.graveyard.append(energy_axe_res)
	player.graveyard.append(healer_res)
	player.graveyard.append(knight_res)
	player.graveyard.append(goblin_scout_res)
	var initial_grave_size = player.graveyard.size()
	var instance = SummonInstance.new()
	instance.setup(corpsecraft_titan_res, player, player.opponent, 0, battle)
	var initial_event_count = battle.battle_events.size()
	# Action
	corpsecraft_titan_res._on_arrival(instance, player, player.opponent, battle)
	# Assert: Grave size reduced by 3
	assert_eq(player.graveyard.size(), initial_grave_size - 3, "Graveyard size incorrect.")
	# Assert: Only spell remains
	assert_eq(player.graveyard[0].id, "EnergyAxe", "Only spell should remain in grave.")
	# Assert: Events generated (3x card_removed)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var removed_count = 0
	for event in events_after:
		if event.get("event_type") == "card_removed" and event.get("from_zone") == "graveyard": removed_count += 1
	assert_eq(removed_count, 3, "Incorrect number of card_removed events.")


# --- Insatiable Devourer Tests ---
func test_insatiable_devourer_sacrifices_and_grows():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var battle = setup["battle"]
	# Place creatures to be devoured
	var _scout1 = place_summon_for_test(player, goblin_scout_res, 0, battle)
	var _knight1 = place_summon_for_test(player, knight_res, 2, battle)
	# Simulate Devourer arrival in lane 1
	var instance = SummonInstance.new()
	instance.setup(insatiable_devourer_res, player, player.opponent, 1, battle)
	player.lanes[1] = instance # Manually place
	var initial_event_count = battle.battle_events.size()
	# Action
	insatiable_devourer_res._on_arrival(instance, player, player.opponent, battle)
	# Assert: Other lanes are empty
	assert_null(player.lanes[0], "Lane 1 should be empty.")
	assert_null(player.lanes[2], "Lane 3 should be empty.")
	# Assert: Devourer grew (+2/+2 per creature = +4/+4)
	assert_eq(instance.get_current_power(), 1 + 4, "Devourer power incorrect.")
	assert_eq(instance.get_current_max_hp(), 1 + 4, "Devourer max HP incorrect.")
	# Assert: Events (2x creature_defeated, 2x card_moved grave, 2x stat_change, 1x hp_change)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var defeated_count = 0
	var stat_changes = 0
	var hp_changes = 0
	for event in events_after:
		if event.get("event_type") == "creature_defeated": defeated_count += 1
		elif event.get("event_type") == "stat_change": stat_changes += 1
		elif event.get("event_type") == "creature_hp_change": hp_changes += 1
	assert_eq(defeated_count, 2, "Incorrect defeated count.")
	assert_eq(stat_changes, 2, "Incorrect stat_change count.") # 1 power, 1 max_hp from add_counter
	assert_eq(hp_changes, 1, "Incorrect hp_change count.") # 1 heal from add_counter


# --- Repentant Samurai Tests ---
func test_repentant_samurai_sacrifices_on_second_hit():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Place Samurai
	var samurai_instance = place_summon_for_test(player, repentant_samurai_res, 0, battle)
	# Ensure opponent lane is empty
	opponent.lanes[0] = null

	# Action 1: First direct attack (using override)
	var handled1 = repentant_samurai_res.perform_turn_activity_override(samurai_instance, player, opponent, battle)
	assert_true(handled1, "Samurai override should handle direct attack.")
	assert_true(player.lanes[0] == samurai_instance, "Samurai should still be in lane after first hit.")
	assert_eq(samurai_instance.custom_state.get("hits_dealt"), 1, "Hits dealt should be 1.")

	# Action 2: Second direct attack
	var handled2 = repentant_samurai_res.perform_turn_activity_override(samurai_instance, player, opponent, battle)
	assert_true(handled2, "Samurai override should handle second direct attack.")
	# Assert: Samurai is now gone (sacrificed)
	assert_null(player.lanes[0], "Samurai should be gone after second hit.")
	# Assert: State cleared (optional check)
	# assert_false(samurai_instance.custom_state.has("hits_dealt"), "Hits dealt state should be cleared if instance reused (it shouldn't be).")


# --- Cursed Samurai Tests ---
func test_cursed_samurai_summons_returned_on_death():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var battle = setup["battle"]
	# Place Cursed Samurai
	var cursed_instance = place_summon_for_test(player, cursed_samurai_res, 1, battle) # Lane 2
	var initial_event_count = battle.battle_events.size()

	# Action: Kill Cursed Samurai
	cursed_instance.take_damage(100) # Calls die(), which calls _on_death

	# Assert: Returned Samurai is now in lane 2
	assert_true(player.lanes[1] is SummonInstance and player.lanes[1].card_resource.id == "ReturnedSamurai", "Returned Samurai should be in lane 2.")
	# Assert: Returned Samurai is Undead
	assert_true(player.lanes[1].tags.has(Constants.TAG_UNDEAD), "Returned Samurai should be Undead.")

	# Assert: Events (Cursed defeated, Returned arrives)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var cursed_defeated = false
	var returned_arrived = false
	for event in events_after:
		if event.get("event_type") == "creature_defeated" and event.get("lane") == 2: # Cursed died in lane 2
			cursed_defeated = true
		elif event.get("event_type") == "summon_arrives" and event.get("card_id") == "ReturnedSamurai":
			returned_arrived = true
			assert_eq(event.get("lane"), 2, "Returned Samurai arrived in wrong lane.")
	assert_true(cursed_defeated, "Cursed Samurai defeated event not found.")
	assert_true(returned_arrived, "Returned Samurai summon arrives event not found.")


# --- Glassgraft Tests ---
# Note: Glassgraft requires modifying SummonInstance._perform_direct_attack
# Ensure that modification is present before running this test.
func test_glassgraft_reanimates_and_sacrifices():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Setup graveyard: Scout leftmost, Knight rightmost
	player.graveyard.clear()
	player.graveyard.append(goblin_scout_res)
	player.graveyard.append(knight_res)
	# Empty opponent lane for direct attack
	opponent.lanes[0] = null
	# var initial_event_count = battle.battle_events.size()

	# Action 1: Cast Glassgraft
	glassgraft_res.apply_effect(glassgraft_res, player, opponent, battle)

	# Assert: Knight (rightmost) was reanimated into lane 0 (first empty)
	assert_true(player.lanes[0] is SummonInstance and player.lanes[0].card_resource.id == "Knight", "Knight should be reanimated by Glassgraft.")
	var reanimated_knight = player.lanes[0]
	# Assert: It has the glassgrafted flag
	assert_true(reanimated_knight.custom_state.get("glassgrafted", false), "Reanimated Knight should have glassgrafted flag.")
	# Assert: Graveyard only contains Scout now
	assert_eq(player.graveyard.size(), 1, "Graveyard size incorrect.")
	var graveyard_lane1 = player.graveyard[0].id
	assert_eq(graveyard_lane1, "GoblinScout", "Scout should remain in graveyard.")

	# Action 2: Let the reanimated Knight attack directly
	# Need to simulate a turn or manually call perform_turn_activity -> _perform_direct_attack
	reanimated_knight.is_newly_arrived = false # Allow it to act
	reanimated_knight.perform_turn_activity() # Should call _perform_direct_attack

	# Assert: Knight is now gone (sacrificed after dealing damage)
	assert_null(player.lanes[0], "Reanimated Knight should be gone after attacking.")
	# Assert: Knight is now in graveyard
	assert_eq(player.graveyard[-1].id, "Knight", "Knight should be in graveyard after sacrifice.")

# --- Unmake Tests ---
func test_unmake_destroys_non_undead():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Place targets: Undead (Skeleton) left, Living (Knight) right
	place_summon_for_test(opponent, recurring_skeleton_res, 0, battle) # Lane 1
	place_summon_for_test(opponent, knight_res, 1, battle)             # Lane 2
	var initial_event_count = battle.battle_events.size()

	# Action: Apply effect
	unmake_res.apply_effect(unmake_res, player, opponent, battle)

	# Assert: Skeleton (leftmost, undead) still exists
	assert_true(opponent.lanes[0] is SummonInstance and opponent.lanes[0].card_resource.id == "RecurringSkeleton", "Skeleton should not be Unmade.")
	# Assert: Knight (next leftmost, living) is gone
	assert_null(opponent.lanes[1], "Knight should be Unmade.")
	# Assert: Knight is in graveyard
	assert_true(opponent.graveyard.size() > 0, "Opponent graveyard should not be empty.")
	assert_eq(opponent.graveyard[-1].id, "Knight", "Knight should be in graveyard.")

	# Assert: Events (Knight defeated)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var defeated_event_found = false
	for event in events_after:
		if event.get("event_type") == "creature_defeated" and event.get("lane") == 2 and event.get("player") == opponent.combatant_name:
			defeated_event_found = true; break
	assert_true(defeated_event_found, "Creature defeated event for Knight not found.")


func test_unmake_can_play():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	player.mana = 5 # Enough mana

	# Case 1: No creatures
	assert_false(unmake_res.can_play(player, opponent, 0, battle), "Unmake needs a target.")
	# Case 2: Only Undead creatures
	place_summon_for_test(opponent, recurring_skeleton_res, 0, battle)
	assert_false(unmake_res.can_play(player, opponent, 0, battle), "Unmake needs a non-Undead target.")
	# Case 3: Non-Undead creature exists
	place_summon_for_test(opponent, knight_res, 1, battle)
	assert_true(unmake_res.can_play(player, opponent, 0, battle), "Unmake should be playable with non-Undead target.")
	# Case 4: Not enough mana
	player.mana = 4
	assert_false(unmake_res.can_play(player, opponent, 0, battle), "Unmake needs 5 mana.")


# --- Skeletal Infantry Tests ---
func test_skeletal_infantry_heals_and_relentless_on_kill():
	# Similar to Bloodrager test, just using the Infantry resource
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Place Infantry and weak target
	var infantry_instance = place_summon_for_test(player, skeletal_infantry_res, 0, battle) # Power 2
	var target_scout = place_summon_for_test(opponent, goblin_scout_res, 0, battle) # HP 2
	# Damage infantry
	infantry_instance.current_hp = 1
	var initial_event_count = battle.battle_events.size()

	# Action: Simulate combat kill
	infantry_instance._perform_combat(target_scout) # Calls _on_kill_target

	# Assert: Scout is dead
	assert_lte(target_scout.current_hp, 0, "Target scout should be dead.")
	# Assert: Infantry healed to full
	assert_eq(infantry_instance.current_hp, infantry_instance.get_current_max_hp(), "Infantry should heal to full.")
	# Assert: Infantry is now relentless
	assert_true(infantry_instance.is_relentless, "Infantry should become relentless.")

	# Assert: Events generated (heal + status change)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var heal_event_found = false
	var status_event_found = false
	for event in events_after:
		if event.get("event_type") == "creature_hp_change" and event.get("player") == player.combatant_name and event.get("lane") == 1 and event.get("amount") > 0:
			heal_event_found = true
		elif event.get("event_type") == "status_change" and event.get("status") == "Relentless" and event.get("gained") == true and event.get("lane") == 1:
			status_event_found = true
	assert_true(heal_event_found, "Heal event for Infantry not found.")
	assert_true(status_event_found, "Relentless status gain event not found.")


# --- Reassembling Legion Tests ---
func test_reassembling_legion_returns_to_deck_on_death():
	# Similar to Recurring Skeleton test
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var battle = setup["battle"]
	# Place Legion
	var legion_instance = place_summon_for_test(player, reassembling_legion_res, 0, battle)
	var initial_deck_size = player.library.size()
	var initial_grave_size = player.graveyard.size()
	var initial_event_count = battle.battle_events.size()

	# Action: Kill the legion
	legion_instance.take_damage(100)

	# Assert: Instance removed from lane
	assert_null(player.lanes[0], "Lane should be empty after legion dies.")
	# Assert: Card added to bottom of library
	assert_eq(player.library.size(), initial_deck_size + 1, "Library size should increase by 1.")
	assert_eq(player.library[-1].id, "ReassemblingLegion", "Legion should be at the bottom of the library.")
	# Assert: Card NOT added to graveyard
	assert_eq(player.graveyard.size(), initial_grave_size, "Graveyard size should not increase.")

	# Assert: Events (creature_defeated + card_moved to library)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var defeated_event_found = false
	var moved_event_found = false
	for event in events_after:
		if event.get("event_type") == "creature_defeated" and event.get("lane") == 1:
			defeated_event_found = true
		elif event.get("event_type") == "card_moved" and \
			 event.get("card_id") == "ReassemblingLegion" and \
			 event.get("to_zone") == "library":
			moved_event_found = true
			assert_eq(event.get("to_details", {}).get("position"), "bottom", "Card moved event should specify bottom.")
	assert_true(defeated_event_found, "Creature defeated event not found for Legion.")
	assert_true(moved_event_found, "Card moved to library event not found for Legion.")


# --- Ghoul Tests ---
func test_ghoul_mills_opponent_bottom_card():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Setup opponent library
	opponent.library.clear()
	opponent.library.append(knight_res) # Top
	opponent.library.append(goblin_scout_res) # Bottom
	var initial_opp_lib_size = opponent.library.size()
	var initial_opp_grave_size = opponent.graveyard.size()
	var bottom_card_id = opponent.library[-1].id # Should be GoblinScout

	# Simulate arrival
	var instance = SummonInstance.new()
	instance.setup(ghoul_res, player, opponent, 0, battle)
	var initial_event_count = battle.battle_events.size()

	# Action: Call arrival effect
	ghoul_res._on_arrival(instance, player, opponent, battle)

	# Assert: Opponent library size decreased
	assert_eq(opponent.library.size(), initial_opp_lib_size - 1, "Opponent library size should decrease.")
	# Assert: Opponent graveyard size increased
	assert_eq(opponent.graveyard.size(), initial_opp_grave_size + 1, "Opponent graveyard size should increase.")
	# Assert: Correct card moved to opponent graveyard
	assert_eq(opponent.graveyard[-1].id, bottom_card_id, "Incorrect card milled to graveyard.")

	# Assert: Event generated (card_moved library_bottom -> graveyard)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var moved_event_found = false
	for event in events_after:
		if event.get("event_type") == "card_moved" and \
		   event.get("player") == opponent.combatant_name and \
		   event.get("from_zone") == "library_bottom" and \
		   event.get("to_zone") == "graveyard":
			moved_event_found = true
			assert_eq(event.get("card_id"), bottom_card_id, "Milled card ID incorrect in event.")
			break
	assert_true(moved_event_found, "Card moved event for Ghoul mill not found.")

# --- Knight of Opposites Tests ---
func test_knight_of_opposites_swaps_hp():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	player.current_hp = 5
	opponent.current_hp = 18
	var initial_event_count = battle.battle_events.size()

	# Simulate arrival
	var instance = SummonInstance.new()
	instance.setup(knight_of_opposites_res, player, opponent, 0, battle)
	# Action
	knight_of_opposites_res._on_arrival(instance, player, opponent, battle)

	# Assert HP swapped
	assert_eq(player.current_hp, 18, "Player HP incorrect after swap.")
	assert_eq(opponent.current_hp, 5, "Opponent HP incorrect after swap.")

	# Assert events generated (2x hp_change)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var player_hp_event = false
	var opp_hp_event = false
	for event in events_after:
		if event.get("event_type") == "hp_change":
			if event.get("player") == player.combatant_name:
				player_hp_event = true
				assert_eq(event.get("new_total"), 18)
				assert_eq(event.get("amount"), 13) # 18 - 5
			elif event.get("player") == opponent.combatant_name:
				opp_hp_event = true
				assert_eq(event.get("new_total"), 5)
				assert_eq(event.get("amount"), -13) # 5 - 18
	assert_true(player_hp_event, "Player HP change event missing.")
	assert_true(opp_hp_event, "Opponent HP change event missing.")


func test_knight_of_opposites_no_swap_if_equal_hp():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	player.current_hp = 10
	opponent.current_hp = 10
	var initial_event_count = battle.battle_events.size()
	var instance = SummonInstance.new()
	instance.setup(knight_of_opposites_res, player, opponent, 0, battle)
	knight_of_opposites_res._on_arrival(instance, player, opponent, battle)
	# Assert HP unchanged
	assert_eq(player.current_hp, 10, "Player HP should not change.")
	assert_eq(opponent.current_hp, 10, "Opponent HP should not change.")
	# Assert no hp_change events
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var hp_event_found = false
	for event in events_after:
		if event.get("event_type") == "hp_change": hp_event_found = true; break
	assert_false(hp_event_found, "No HP change events should be generated.")


# --- Malignant Imp Tests ---
func test_malignant_imp_bonus_direct_damage():
	# Test the bonus damage getter directly
	assert_eq(malignant_imp_res._get_direct_attack_bonus_damage(null), 1, "Imp bonus damage getter incorrect.")
	# Test the interaction in _perform_direct_attack
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	var imp_instance = place_summon_for_test(player, malignant_imp_res, 0, battle) # Power 2
	opponent.lanes[0] = null # Ensure direct attack
	var initial_opp_hp = opponent.current_hp
	var expected_damage = imp_instance.get_current_power() + 1 # 2 + 1 = 3

	# Action: Simulate direct attack
	imp_instance._perform_direct_attack()

	# Assert opponent HP reduced by correct amount
	assert_eq(opponent.current_hp, initial_opp_hp - expected_damage, "Opponent HP incorrect after Imp attack.")
	# Assert direct_damage event shows correct total amount
	var events = battle.battle_events
	var direct_damage_event_found = false
	for event in events:
		if event.get("event_type") == "direct_damage" and event.get("attacking_lane") == 1:
			direct_damage_event_found = true
			assert_eq(event.get("amount"), expected_damage, "Direct damage event amount incorrect for Imp.")
			break
	assert_true(direct_damage_event_found, "Direct damage event not found for Imp.")


# --- Walking Sarcophagus Tests ---
func test_walking_sarcophagus_sacrifices_and_reanimates():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Setup: Sarcophagus in lane 0, Knight in grave (leftmost), Scout also in grave
	var sarc_instance = place_summon_for_test(player, walking_sarcophagus_res, 0, battle)
	player.graveyard.clear()
	player.graveyard.append(knight_res)
	player.graveyard.append(goblin_scout_res)
	opponent.lanes[0] = null # Ensure direct attack

	# Action: Simulate direct attack
	sarc_instance.is_newly_arrived = false # Needs to be able to act
	sarc_instance.perform_turn_activity() # Calls _perform_direct_attack -> _on_deal_direct_damage -> die -> reanimate logic

	# Assert: Lane 0 now contains Knight (reanimated leftmost)
	assert_true(player.lanes[0] is SummonInstance and player.lanes[0].card_resource.id == "Knight", "Knight should be reanimated in lane 1.")
	# Assert: Sarcophagus is now in graveyard
	assert_true(player.graveyard.size() > 0, "Graveyard should not be empty.")
	assert_eq(player.graveyard[-1].id, "WalkingSarcophagus", "Sarcophagus should be in graveyard.")
	# Assert: Scout is still in graveyard
	var scout_in_grave = false
	for card in player.graveyard:
		if card.id == "GoblinScout": scout_in_grave = true; break
	assert_true(scout_in_grave, "Scout should still be in graveyard.")


# --- Indulged Princeling Tests ---
func test_indulged_princeling_mills_self():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var battle = setup["battle"]
	# Setup library
	player.library.clear()
	player.library.append(knight_res)
	player.library.append(goblin_scout_res)
	player.library.append(healer_res) # 3 cards
	var initial_lib_size = player.library.size()
	var initial_grave_size = player.graveyard.size()

	# Simulate arrival
	var instance = SummonInstance.new()
	instance.setup(indulged_princeling_res, player, player.opponent, 0, battle)
	player.lanes[0] = instance # Place it

	# Action
	indulged_princeling_res._on_arrival(instance, player, player.opponent, battle)

	# Assert: Library size decreased by 2
	assert_eq(player.library.size(), initial_lib_size - 2, "Library size incorrect.")
	# Assert: Graveyard size increased by 2
	assert_eq(player.graveyard.size(), initial_grave_size + 2, "Graveyard size incorrect.")
	# Assert: Correct cards milled (Knight and Scout were top)
	assert_eq(player.graveyard[-1].id, "GoblinScout", "Scout should be last card milled.")
	assert_eq(player.graveyard[-2].id, "Knight", "Knight should be first card milled.")
	# Assert: Princeling still in lane
	assert_true(player.lanes[0] == instance, "Princeling should remain in lane.")


func test_indulged_princeling_sacrifices_if_cant_mill():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var battle = setup["battle"]
	# Setup library with only 1 card
	player.library.clear()
	player.library.append(knight_res)
	var initial_grave_size = player.graveyard.size()

	# Simulate arrival
	var instance = SummonInstance.new()
	instance.setup(indulged_princeling_res, player, player.opponent, 0, battle)
	player.lanes[0] = instance # Place it
	var initial_event_count = battle.battle_events.size()

	# Action
	indulged_princeling_res._on_arrival(instance, player, player.opponent, battle)

	# Assert: Princeling removed from lane
	assert_null(player.lanes[0], "Princeling should be removed from lane.")
	# Assert: Princeling added to graveyard
	assert_eq(player.graveyard.size(), initial_grave_size + 1, "Graveyard size incorrect.") # Only Princeling added
	assert_eq(player.graveyard[-1].id, "IndulgedPrinceling", "Princeling should be in graveyard.")
	# Assert: Library is empty (the one card was NOT milled)
	assert_true(player.library.size() == 1, "Library should still contain the knight (only).")

	# Assert: Creature defeated event generated
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var defeated_event_found = false
	for event in events_after:
		if event.get("event_type") == "creature_defeated" and event.get("lane") == 1: # Lane 1 (index 0)
			defeated_event_found = true; break
	assert_true(defeated_event_found, "Creature defeated event for Princeling not found.")

# --- Elsewhere Tests ---
func test_elsewhere_bounces_leftmost():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Place opponent creatures
	var _scout = place_summon_for_test(opponent, goblin_scout_res, 0, battle) # Lane 1 - Leftmost
	var knight = place_summon_for_test(opponent, knight_res, 1, battle)     # Lane 2
	opponent.library.clear() # Clear library for easy check
	var initial_event_count = battle.battle_events.size()

	# Action
	elsewhere_res.apply_effect(elsewhere_res, player, opponent, battle)

	# Assert: Scout (leftmost) is gone from lane
	assert_null(opponent.lanes[0], "Lane 1 should be empty after Elsewhere.")
	# Assert: Knight still in lane
	assert_true(opponent.lanes[1] == knight, "Lane 2 should still contain Knight.")
	# Assert: Scout is at bottom of library
	assert_eq(opponent.library.size(), 1, "Opponent library should have 1 card.")
	assert_eq(opponent.library[0].id, "GoblinScout", "Scout should be at library bottom.") # push_back adds to end

	# Assert: Events generated
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var leaves_event = false
	var moved_event = false
	for event in events_after:
		if event.get("event_type") == "summon_leaves_lane" and event.get("lane") == 1: leaves_event = true
		elif event.get("event_type") == "card_moved" and event.get("card_id") == "GoblinScout" and event.get("to_zone") == "library": moved_event = true
	assert_true(leaves_event, "Summon leaves event missing.")
	assert_true(moved_event, "Card moved event missing.")


# --- Carnivorous Plant Tests ---
func test_carnivorous_plant_adds_scout_to_grave():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var battle = setup["battle"]
	player.graveyard.clear()
	var initial_event_count = battle.battle_events.size()
	# Simulate arrival
	var instance = SummonInstance.new()
	instance.setup(carnivorous_plant_res, player, player.opponent, 0, battle)
	# Action
	carnivorous_plant_res._on_arrival(instance, player, player.opponent, battle)
	# Assert: Graveyard contains Goblin Scout
	assert_eq(player.graveyard.size(), 1, "Graveyard should contain 1 card.")
	assert_eq(player.graveyard[0].id, "GoblinScout", "Graveyard should contain Goblin Scout.")
	# Assert: Event generated
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var moved_event = false
	for event in events_after:
		if event.get("event_type") == "card_moved" and event.get("card_id") == "GoblinScout" and event.get("to_zone") == "graveyard":
			moved_event = true; break
	assert_true(moved_event, "Card moved event for Plant adding Scout missing.")


# --- Chanter of Ashes Tests ---
func test_chanter_of_ashes_consumes_and_damages():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Setup graveyard
	player.graveyard.clear()
	player.graveyard.append(goblin_scout_res)
	player.graveyard.append(knight_res) # 2 summons
	player.graveyard.append(energy_axe_res) # 1 spell
	var initial_opp_hp = opponent.current_hp
	var initial_event_count = battle.battle_events.size()
	# Simulate arrival
	var instance = SummonInstance.new()
	instance.setup(chanter_of_ashes_res, player, opponent, 0, battle)
	# Action
	chanter_of_ashes_res._on_arrival(instance, player, opponent, battle)
	# Assert: Graveyard contains only spell
	assert_eq(player.graveyard.size(), 1, "Graveyard size incorrect.")
	assert_eq(player.graveyard[0].id, "EnergyAxe", "Only spell should remain.")
	# Assert: Opponent took damage (2 summons * 2 = 4 damage)
	assert_eq(opponent.current_hp, initial_opp_hp - 4, "Opponent HP incorrect.")
	# Assert: Events generated (2x card_removed, 1x hp_change/effect_damage)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var removed_count = 0
	var damage_event_found = false
	for event in events_after:
		if event.get("event_type") == "card_removed" and event.get("from_zone") == "graveyard": 
			removed_count += 1
		elif event.get("event_type") == "effect_damage" and event.get("source_card_id") == "ChanterOfAshes":
			damage_event_found = true
			assert_eq(event.get("amount"), 4, "Chanter damage amount incorrect.")
	assert_eq(removed_count, 2, "Incorrect removed count.")
	assert_true(damage_event_found, "Effect damage event not found.")


# --- Goblin Gladiator Tests ---
func test_goblin_gladiator_bonus_damage():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Place Gladiator and targets
	var gladiator = place_summon_for_test(player, goblin_gladiator_res, 0, battle) # Power 2
	var weak_target = place_summon_for_test(opponent, goblin_scout_res, 0, battle) # Power 1
	var strong_target = place_summon_for_test(opponent, goliath_res, 1, battle) # Power 7
	var initial_weak_hp = weak_target.current_hp
	var initial_strong_hp = strong_target.current_hp

	# Action 1: Attack weak target
	gladiator.lane_index = 0 # Ensure gladiator knows its lane
	gladiator._perform_combat(weak_target)
	# Assert: Weak target took base damage (2)
	assert_eq(weak_target.current_hp, initial_weak_hp - 2, "Weak target took wrong damage.")

	# Action 2: Attack strong target
	gladiator.lane_index = 1 # Move gladiator conceptually for targeting
	gladiator._perform_combat(strong_target)
	# Assert: Strong target took base + bonus damage (2 + 3 = 5)
	assert_eq(strong_target.current_hp, initial_strong_hp - 5, "Strong target took wrong damage.")


# --- Inferno Tests ---
func test_inferno_damages_all():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Place creatures
	var p_scout = place_summon_for_test(player, goblin_scout_res, 0, battle) # HP 2
	var p_knight = place_summon_for_test(player, knight_res, 1, battle)     # HP 3
	var o_scout = place_summon_for_test(opponent, goblin_scout_res, 0, battle) # HP 2
	var o_knight = place_summon_for_test(opponent, knight_res, 1, battle)     # HP 3
	var initial_event_count = battle.battle_events.size()

	# Action
	inferno_res.apply_effect(inferno_res, player, opponent, battle)

	# Assert: All creatures took 2 damage
	assert_eq(p_scout.current_hp, 2 - 2, "Player Scout HP incorrect.") # Dies
	assert_eq(p_knight.current_hp, 3 - 2, "Player Knight HP incorrect.")
	assert_eq(o_scout.current_hp, 2 - 2, "Opponent Scout HP incorrect.") # Dies
	assert_eq(o_knight.current_hp, 3 - 2, "Opponent Knight HP incorrect.")

	# Assert: Events (4x creature_hp_change, 2x creature_defeated)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var hp_changes = 0
	var defeats = 0
	for event in events_after:
		if event.get("event_type") == "creature_hp_change" and event.get("amount") == -2: hp_changes += 1
		elif event.get("event_type") == "creature_defeated": defeats += 1
	assert_eq(hp_changes, 4, "Incorrect hp_change count.")
	assert_eq(defeats, 2, "Incorrect defeated count.")


# --- Flamewielder Tests ---
func test_flamewielder_damages_opponents():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Place creatures
	var p_knight = place_summon_for_test(player, knight_res, 0, battle)     # HP 3 (Should not be damaged)
	var o_scout = place_summon_for_test(opponent, goblin_scout_res, 0, battle) # HP 2
	var o_knight = place_summon_for_test(opponent, knight_res, 1, battle)     # HP 3
	var initial_event_count = battle.battle_events.size()
	# Simulate arrival
	var instance = SummonInstance.new()
	instance.setup(flamewielder_res, player, opponent, 0, battle)
	# Action
	flamewielder_res._on_arrival(instance, player, opponent, battle)
	# Assert: Opponent creatures took 1 damage
	assert_eq(o_scout.current_hp, 2 - 1, "Opponent Scout HP incorrect.")
	assert_eq(o_knight.current_hp, 3 - 1, "Opponent Knight HP incorrect.")
	# Assert: Player creature unharmed
	assert_eq(p_knight.current_hp, 3, "Player Knight HP should be unchanged.")
	# Assert: Events (2x creature_hp_change for opponent)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var hp_changes = 0
	for event in events_after:
		if event.get("event_type") == "creature_hp_change" and event.get("player") == opponent.combatant_name and event.get("amount") == -1:
			hp_changes += 1
	assert_eq(hp_changes, 2, "Incorrect opponent hp_change count.")


# --- Rampaging Cyclops Tests ---
func test_rampaging_cyclops_damages_all_others():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Place creatures
	var p_scout = place_summon_for_test(player, goblin_scout_res, 0, battle) # HP 2
	var o_knight = place_summon_for_test(opponent, knight_res, 1, battle)     # HP 3
	# Simulate Cyclops arrival in lane 2
	var instance = SummonInstance.new()
	instance.setup(rampaging_cyclops_res, player, opponent, 2, battle)
	player.lanes[2] = instance # Place it
	var initial_event_count = battle.battle_events.size()
	# Action
	rampaging_cyclops_res._on_arrival(instance, player, opponent, battle)
	# Assert: Other creatures took 1 damage
	assert_eq(p_scout.current_hp, 2 - 1, "Player Scout HP incorrect.")
	assert_eq(o_knight.current_hp, 3 - 1, "Opponent Knight HP incorrect.")
	# Assert: Cyclops itself unharmed
	assert_eq(instance.current_hp, 5, "Cyclops HP should be unchanged.")
	# Assert: Events (2x creature_hp_change)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var hp_changes = 0
	for event in events_after:
		if event.get("event_type") == "creature_hp_change" and event.get("amount") == -1:
			hp_changes += 1
	assert_eq(hp_changes, 2, "Incorrect hp_change count.")
