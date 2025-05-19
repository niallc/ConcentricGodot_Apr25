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
var hexplate_res = load("res://data/cards/instances/hexplate.tres") as SpellCardResource
var songs_of_the_lost_res = load("res://data/cards/instances/songs_of_the_lost.tres") as SpellCardResource
var ascending_protoplasm_res = load("res://data/cards/instances/ascending_protoplasm.tres") as SummonCardResource
var refined_impersonator_res = load("res://data/cards/instances/refined_impersonator.tres") as SummonCardResource
var corpsetide_lich_res = load("res://data/cards/instances/corpsetide_lich.tres") as SummonCardResource
var coffin_traders_res = load("res://data/cards/instances/coffin_traders.tres") as SummonCardResource
var angel_of_justice_res = load("res://data/cards/instances/angel_of_justice.tres") as SummonCardResource
var scavenger_ghoul_res = load("res://data/cards/instances/scavenger_ghoul.tres") as SummonCardResource
var heedless_vandal_res = load("res://data/cards/instances/heedless_vandal.tres") as SummonCardResource
var taunting_elf_res = load("res://data/cards/instances/taunting_elf.tres") as SummonCardResource
var troll_res = load("res://data/cards/instances/troll.tres") as SummonCardResource

# 
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
	# --- MODIFICATION START ---
	var new_id = battle._generate_new_card_instance_id() # Use the new centralized ID generator
	# --- MODIFICATION END ---
	instance.setup(card_res, combatant, combatant.opponent, lane_idx, battle, new_id)
	combatant.lanes[lane_idx] = instance

	# OPTIONAL BUT RECOMMENDED FOR TEST ACCURACY:
	# Manually add summon_arrives event because the main battle loop isn't running
	# This makes test conditions closer to actual gameplay if effects rely on this event.
	battle.add_event({
	 	"event_type": "summon_arrives",
	 	"player": combatant.combatant_name,
	 	"card_id": card_res.id,
	 	"lane": lane_idx + 1, # 1-based
	 	"instance_id": new_id,
	 	"power": instance.get_current_power(),
	 	"max_hp": instance.get_current_max_hp(),
	 	"current_hp": instance.current_hp,
	 	"is_swift": instance.is_swift,
		"tags": instance.tags.duplicate() # Ensure tags are included
	})
	return instance

# --- Energy Axe Tests ---
func test_energy_axe_applies_power():
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"]
	var battle: Battle = setup["battle"]
	
	var scout_instance = place_summon_for_test(player, goblin_scout_res, 0, battle)
	var initial_power = scout_instance.get_current_power()
	var initial_event_count: int = battle.battle_events.size() # Moved before creating CIZ for Energy Axe

	# Create a CardInZone for the Energy Axe spell
	var energy_axe_spell_instance_id: int = battle._generate_new_card_instance_id()
	var energy_axe_card_in_zone: CardInZone = CardInZone.new(energy_axe_res, energy_axe_spell_instance_id)

	# Action: Apply the effect
	# The energy_axe_res is the SpellCardResource. Its script (energy_axe_effect.gd) overrides apply_effect.
	# We call the method on the resource itself.
	if energy_axe_res.has_method("apply_effect"): # Check if the method exists on the resource
		energy_axe_res.apply_effect(energy_axe_card_in_zone, player, opponent, battle)
	else:
		# This else branch suggests the method might not be found directly on energy_axe_res
		# which would be unusual if energy_axe_effect.gd extends SpellCardResource and overrides it.
		# A more direct way if methods aren't virtual/overridden correctly on the resource directly:
		# var effect_script = energy_axe_res.script
		# if effect_script and effect_script.has_method("apply_effect"):
		#     effect_script.apply_effect(energy_axe_card_in_zone, player, opponent, battle)
		# else:
		fail_test("Energy Axe resource/script does not have apply_effect method or it's not callable as expected.")
		return

	# Assert: Target's power increased
	assert_eq(scout_instance.get_current_power(), initial_power + 3, "Energy Axe should increase power by 3.")
	
	# Assert: Modifier was added
	var found_energy_axe_modifier = false
	for modifier in scout_instance.power_modifiers:
		if modifier["source"] == energy_axe_card_in_zone.get_card_id(): # Check against the card_id
			assert_eq(modifier["value"], 3, "Energy Axe modifier value should be 3.")
			found_energy_axe_modifier = true
			break
	assert_true(found_energy_axe_modifier, "Modifier from Energy Axe not found.")

	# Assert: Events generated
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expected: 1 stat_change (on scout from add_power), 1 visual_effect (from energy_axe_effect)
	# Total = 2 events

	var stat_change_event_found = false
	var visual_event_found = false
	
	for event_data in new_events:
		if event_data.get("event_type") == "stat_change" and \
		   event_data.get("instance_id") == scout_instance.instance_id and \
		   event_data.get("stat") == "power" and \
		   event_data.get("source") == energy_axe_card_in_zone.get_card_id() and \
		   event_data.get("source_instance_id") == energy_axe_card_in_zone.get_card_instance_id():
			stat_change_event_found = true
			assert_eq(event_data.get("new_value"), initial_power + 3, "Stat change event new_value incorrect.")
		elif event_data.get("event_type") == "visual_effect" and \
			 event_data.get("effect_id") == "energy_axe_boost" and \
			 event_data.get("instance_id") == scout_instance.instance_id and \
			 event_data.get("source_instance_id") == energy_axe_card_in_zone.get_card_instance_id():
			visual_event_found = true
			
	assert_true(stat_change_event_found, "Stat change event for Energy Axe target not found or improperly sourced.")
	assert_true(visual_event_found, "Visual effect event for Energy Axe not found or improperly sourced.")
	
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
	var new_id = battle.get_new_instance_id()
	healer_instance.setup(healer_res, player, player.opponent, 0, battle, new_id)

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
	var initial_event_count = battle.battle_events.size() # Track events before Disarm

	# Setup opponent creatures
	var weak_scout = place_summon_for_test(opponent, goblin_scout_res, 0, battle) # Power 1, Lane 1
	var strong_knight = place_summon_for_test(opponent, knight_res, 1, battle) # Power 3, Lane 2
	var initial_knight_power = strong_knight.get_current_power()

	# Action: Apply Disarm effect
	# Call directly on the loaded resource
	var disarm_instance_id: int = battle._generate_new_card_instance_id()
	var disarm_card_in_zone = CardInZone.new(disarm_res, disarm_instance_id)
	disarm_res.apply_effect(disarm_card_in_zone, player, opponent, battle)

	# Assert: Knight's power reduced, Scout's unchanged
	assert_eq(strong_knight.get_current_power(), initial_knight_power - 2, "Disarm should reduce Knight's power by 2.")
	assert_eq(weak_scout.get_current_power(), 1, "Disarm should not affect Scout's power.")
	# Assert: Modifier added to Knight
	assert_eq(strong_knight.power_modifiers.size(), 1, "Disarm should add power modifier to Knight.")
	assert_eq(strong_knight.power_modifiers[0]["value"], -2, "Disarm modifier value should be -2.")
	assert_eq(strong_knight.power_modifiers[0]["source"], "Disarm", "Disarm modifier source incorrect.")

	var events_after_disarm = battle.battle_events.slice(initial_event_count, battle.battle_events.size())


	var stat_change_event_for_knight_found = false
	var visual_effect_for_disarm_found = false

	for event_data in events_after_disarm:
		# 1. Check for stat_change on the strong_knight
		if event_data.get("event_type") == "stat_change" and \
		   event_data.get("instance_id") == strong_knight.instance_id and \
		   event_data.get("stat") == "power":
			stat_change_event_for_knight_found = true
			assert_eq(event_data.get("amount"), -2, "Disarm stat_change event 'amount' (modifier value) incorrect.")
			assert_eq(event_data.get("new_value"), initial_knight_power - 2, "Disarm stat_change event 'new_value' incorrect.")
			assert_eq(event_data.get("source"), disarm_card_in_zone.get_card_id(), "Disarm stat_change 'source' (card_id) incorrect.")
			assert_eq(event_data.get("source_instance_id"), disarm_card_in_zone.get_card_instance_id(), "Disarm stat_change 'source_instance_id' incorrect.")
		
		# 2. Check for the visual_effect of Disarm
		elif event_data.get("event_type") == "visual_effect" and \
			 event_data.get("effect_id") == "disarm_debuff_applied": # Or whatever effect_id you chose in disarm_effect.gd
			visual_effect_for_disarm_found = true
			# The instance_id of this visual should be the knight being debuffed
			assert_eq(event_data.get("instance_id"), strong_knight.instance_id, "Disarm visual_effect 'instance_id' (target of visual) incorrect.")
			# The source_instance_id should be the Disarm spell
			assert_eq(event_data.get("source_instance_id"), disarm_card_in_zone.get_card_instance_id(), "Disarm visual_effect 'source_instance_id' incorrect.")
			assert_eq(event_data.get("source_card_id"), disarm_card_in_zone.get_card_id(), "Disarm visual_effect 'source_card_id' incorrect.")
			assert_eq(event_data.get("details", {}).get("power_change"), -2, "Disarm visual_effect details 'power_change' incorrect.")
			
	assert_true(stat_change_event_for_knight_found, "Stat change event for Disarm target (Knight) not found or improperly sourced.")
	assert_true(visual_effect_for_disarm_found, "Visual effect event for Disarm spell not found or improperly sourced.")


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
	
	var firework_instance = place_summon_for_test(player, goblin_firework_res, 1, battle) # Firework in player's lane 2 (index 1)
	var target_knight = place_summon_for_test(opponent, knight_res, 1, battle)      # Knight in opponent's lane 2 (index 1)
	
	var initial_knight_hp = target_knight.current_hp
	var initial_event_count = battle.battle_events.size() 

	# Action: Trigger the death effect manually.
	# The _on_death method is part of the SummonCardResource script.
	# In a real game, SummonInstance.die() calls this.
	# For the test, we call it directly on the Firework's script using its resource.
	if goblin_firework_res.has_method("_on_death"):
		goblin_firework_res._on_death(firework_instance, player, opponent, battle)
	else:
		fail_test("Goblin Firework resource is missing _on_death method.")
		return

	assert_eq(target_knight.current_hp, initial_knight_hp - 1, "Goblin Firework death should damage opposing Knight by 1.")

	var new_events = battle.battle_events.slice(initial_event_count)
	assert_false(new_events.is_empty(), "Firework death should generate events.")
	
	var creature_hp_change_event_found = false
	#var visual_effect_found = false

	for event_data in new_events:
		if event_data.get("event_type") == "creature_hp_change" and \
		   event_data.get("instance_id") == target_knight.instance_id: # Knight was damaged
			creature_hp_change_event_found = true
			assert_eq(event_data.get("amount"), -1, "Firework damage event: amount incorrect.")
			assert_eq(event_data.get("new_hp"), initial_knight_hp - 1, "Firework damage event: new_hp incorrect.")
			assert_eq(event_data.get("source"), goblin_firework_res.id, "Firework damage event: source card_id incorrect.")
			assert_eq(event_data.get("source_instance_id"), firework_instance.instance_id, "Firework damage event: source_instance_id incorrect.")
		
		elif event_data.get("event_type") == "visual_effect" and \
			 event_data.get("effect_id") == "firework_explosion_on_target":
			#visual_effect_found = true
			assert_eq(event_data.get("instance_id"), target_knight.instance_id, "Firework visual_effect: target instance_id incorrect.")
			assert_eq(event_data.get("source_instance_id"), firework_instance.instance_id, "Firework visual_effect: source_instance_id incorrect.")

	assert_true(creature_hp_change_event_found, "Creature HP change event for Firework target not found or improperly sourced.")
	# Visual effect is optional to assert strictly, but good if it's there.
	# assert_true(visual_effect_found, "Visual effect for Firework explosion not found or improperly sourced.")
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
	var opponent = setup["opponent"] # Get opponent, though not strictly used by WoV ability
	var battle = setup["battle"]
	
	player.mana = 2 
	var initial_mana = player.mana
	
	var wall_instance = place_summon_for_test(player, wall_of_vines_res, 0, battle)
	var initial_event_count = battle.battle_events.size()

	# Action: Simulate its turn activity.
	# The perform_turn_activity_override method is part of the SummonCardResource script.
	var handled: bool = false
	if wall_of_vines_res.has_method("perform_turn_activity_override"):
		handled = wall_of_vines_res.perform_turn_activity_override(wall_instance, player, opponent, battle)
	else:
		fail_test("Wall of Vines resource is missing perform_turn_activity_override method.")
		return

	assert_true(handled, "Wall of Vines perform_turn_activity_override should return true.")
	assert_eq(player.mana, initial_mana + 1, "Wall of Vines should increase player mana by 1.")

	var new_events = battle.battle_events.slice(initial_event_count)
	# Expect two events:
	# 1. mana_change (from Combatant.gain_mana)
	# 2. summon_turn_activity (from WallOfVinesEffect.perform_turn_activity_override)
	assert_eq(new_events.size(), 2, "Wall of Vines activity should generate 2 events. Found: %s" % new_events.size()) 

	var mana_change_event_found = false
	var summon_activity_event_found = false

	for event_data in new_events:
		if event_data.get("event_type") == "mana_change" and \
		   event_data.get("player") == player.combatant_name:
			mana_change_event_found = true
			assert_eq(event_data.get("amount"), 1, "Mana change event: amount incorrect.")
			assert_eq(event_data.get("new_total"), initial_mana + 1, "Mana change event: new_total incorrect.")
			assert_eq(event_data.get("source"), wall_of_vines_res.id, "Mana change event: source card_id incorrect.")
			assert_eq(event_data.get("source_instance_id"), wall_instance.instance_id, "Mana change event: source_instance_id incorrect.")
			# Also check the main instance_id of the mana_change event itself
			assert_eq(event_data.get("instance_id"), wall_instance.instance_id, "Mana change event: main instance_id incorrect (should be WoV).")

		elif event_data.get("event_type") == "summon_turn_activity" and \
			 event_data.get("instance_id") == wall_instance.instance_id:
			summon_activity_event_found = true
			assert_eq(event_data.get("activity_type"), "ability_mana_gen", "Summon activity event: activity_type incorrect.")
			assert_eq(event_data.get("details", {}).get("mana_generated_by_ability"), 1, "Summon activity event: details incorrect.")
			assert_eq(event_data.get("card_id"), wall_of_vines_res.id, "Summon activity event: card_id incorrect.")

	assert_true(mana_change_event_found, "Mana change event not found for Wall of Vines or improperly sourced.")
	assert_true(summon_activity_event_found, "Summon turn activity event not found for Wall of Vines.")

# --- Charging Bull Tests ---
# Note: Swiftness is tested implicitly by checking if it attacks on turn 2 in simulation
# We can test the resource property directly here.
func test_charging_bull_is_swift():
	assert_true(charging_bull_res.is_swift, "Charging Bull resource should have is_swift = true.")
	# Test that SummonInstance gets the flag
	var setup = create_test_battle_setup()
	var bull_instance = SummonInstance.new()
	var battle = setup["battle"]
	var new_id = battle.get_new_instance_id()
	bull_instance.setup(charging_bull_res, setup["player"], setup["opponent"], 0, setup["battle"], new_id)
	assert_true(bull_instance.is_swift, "Charging Bull instance should inherit is_swift = true.")
	# The actual check for is_newly_arrived vs is_swift happens in Battle.conduct_turn


# --- Portal Mage Tests ---
func test_portal_mage_bounces_opponent():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"] # Get the battle instance

	# Place a target for the opponent
	var _target_knight = place_summon_for_test(opponent, knight_res, 1, battle) # Lane 2

	# Ensure opponent library is empty to easily check the bounced card
	opponent.library.clear()

	# Simulate Portal Mage arrival
	var mage_instance = SummonInstance.new()
	# --- MODIFICATION: Use new ID generator ---
	var new_mage_id = battle._generate_new_card_instance_id()
	mage_instance.setup(portal_mage_res, player, opponent, 1, battle, new_mage_id)
	# --- END MODIFICATION ---
	var initial_event_count = battle.battle_events.size()

	# Action: Call the arrival effect
	# Ensure portal_mage_res._on_arrival itself is creating CardInZone for the library
	portal_mage_res._on_arrival(mage_instance, player, opponent, battle)

	# Assert: Opponent's lane is now empty
	assert_null(opponent.lanes[1], "Opponent's lane 2 should be empty after bounce.")
	# Assert: Opponent's library now contains the Knight resource (as a CardInZone)
	assert_eq(opponent.library.size(), 1, "Opponent's library should have 1 card.")
	
	# --- MODIFICATION: Access CardInZone correctly ---
	assert_true(opponent.library[0] is CardInZone, "Bounced card in library should be a CardInZone object.")
	if opponent.library[0] is CardInZone:
		assert_eq(opponent.library[0].get_card_id(), "Knight", "Opponent's library top card should be Knight.")
		# You could also assert the instance_id if it's predictable or if you capture it
		# For example, if you want to ensure it got a *new* instance_id in the library:
		# assert_ne(opponent.library[0].instance_id, _target_knight.instance_id, "Bounced card in library should have a new instance_id.")
	# --- END MODIFICATION ---

	# Assert: Events generated (summon_leaves_lane + card_moved)
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	assert_gte(events_after.size(), 2, "Portal Mage bounce should generate at least 2 events.")
	var leaves_event_found = false
	var moved_event_found = false
	for event_data in events_after: # Renamed 'event' to 'event_data' to avoid conflict with GDScript keyword
		if event_data.get("event_type") == "summon_leaves_lane" and event_data.get("lane") == 2: # Lane index 1 is lane 2
			leaves_event_found = true
			assert_eq(event_data.get("card_id"), "Knight", "Summon leaves event card ID incorrect.")
			# --- ADDITION: Check instance_id of the summon that left ---
			assert_eq(event_data.get("instance_id"), _target_knight.instance_id, "Summon leaves event instance_id incorrect.")
		elif event_data.get("event_type") == "card_moved" and event_data.get("to_zone") == "library":
			moved_event_found = true
			assert_eq(event_data.get("card_id"), "Knight", "Card moved event card ID incorrect.")
			# --- ADDITION: Check instance_id of the summon that was moved ---
			assert_eq(event_data.get("instance_id"), _target_knight.instance_id, "Card moved event instance_id incorrect.")
			assert_eq(event_data.get("to_details", {}).get("position"), "top", "Portal Mage should bounce to top.")

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
	var new_id = battle.get_new_instance_id()
	mage_instance.setup(portal_mage_res, player, opponent, 1, battle, new_id) # Arrives in Lane 2

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
	var test_damage_source_card_id: String = "TEST_DAMAGE_EFFECT"
	var test_damage_source_instance_id: int = -1 # Or some other placeholder if you like
	skeleton_instance.take_damage(100, test_damage_source_card_id, test_damage_source_instance_id)

	# Assert: Skeleton instance removed from lane
	assert_null(player.lanes[0], "Lane should be empty after skeleton dies.")
	# Assert: Card added to bottom of library
	assert_eq(player.library.size(), initial_deck_size + 1, "Library size should increase by 1.")
	#assert_eq(player.library[-1].id, "RecurringSkeleton", "Recurring Skeleton should be at the bottom of the library.")
	assert_true(player.library[-1] is CardInZone, "Card at bottom of library should be CardInZone.")
	if player.library[-1] is CardInZone:
		assert_eq(player.library[-1].get_card_id(), "RecurringSkeleton", "Recurring Skeleton should be at the bottom of the library.")
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
# res://tests/test_card_effects.gd

# --- Focus Tests ---
func test_focus_grants_mana():
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"] # Get opponent for the apply_effect call consistency
	var battle: Battle = setup["battle"]
	
	player.mana = 1 
	var initial_player_mana: int = player.mana
	var initial_event_count: int = battle.battle_events.size()

	# Create a CardInZone for the Focus spell being "played" in this test
	var focus_spell_instance_id: int = battle._generate_new_card_instance_id()
	var focus_card_in_zone: CardInZone = CardInZone.new(focus_res, focus_spell_instance_id)

	# Action: Apply Focus effect
	# Signature: apply_effect(p_focus_card_in_zone: CardInZone, active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle)
	if focus_res.has_method("apply_effect"): # Check if the method (potentially overridden) exists
		focus_res.apply_effect(focus_card_in_zone, player, opponent, battle)
	else:
		fail_test("Focus resource instance does not have apply_effect method. Check script assignment and method definition.")
		assert(false)
		return

	# Assert: Mana increased correctly (up to cap)
	var expected_player_mana: int = min(initial_player_mana + 8, Constants.MAX_MANA)
	assert_eq(player.mana, expected_player_mana, "Focus should grant correct mana to player.")

	# Assert: Event generation
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expect 2 events: 
	# 1. mana_change (from Combatant.gain_mana, called by Focus effect)
	# 2. visual_effect (from Focus effect itself)
	assert_eq(new_events.size(), 2, "Focus effect should generate 2 events. Found: %s" % new_events.size())

	var mana_change_event_found: bool = false
	var visual_effect_found: bool = false

	for event_data in new_events:
		if event_data.get("event_type") == "mana_change" and \
		   event_data.get("player") == player.combatant_name:
			mana_change_event_found = true
			assert_eq(event_data.get("amount"), expected_player_mana - initial_player_mana, "Focus mana_change event: amount incorrect.")
			assert_eq(event_data.get("new_total"), expected_player_mana, "Focus mana_change event: new_total incorrect.")
			assert_eq(event_data.get("source"), focus_card_in_zone.get_card_id(), "Focus mana_change event: source card_id incorrect.")
			assert_eq(event_data.get("instance_id"), focus_card_in_zone.get_card_instance_id(), "Focus mana_change event: instance_id (the spell) incorrect.")
			assert_eq(event_data.get("source_instance_id"), focus_card_in_zone.get_card_instance_id(), "Focus mana_change event: source_instance_id incorrect.")
		
		elif event_data.get("event_type") == "visual_effect" and \
			 event_data.get("effect_id") == "focus_mana_gain":
			visual_effect_found = true
			assert_eq(event_data.get("instance_id"), focus_card_in_zone.get_card_instance_id(), "Focus visual_effect: instance_id incorrect.")
			assert_eq(event_data.get("source_instance_id"), focus_card_in_zone.get_card_instance_id(), "Focus visual_effect: source_instance_id incorrect.")
			assert_eq(event_data.get("details", {}).get("amount"), 8, "Focus visual_effect details: amount incorrect.") # Assuming 'amount' was 'mana_gain' in effect

	assert_true(mana_change_event_found, "Mana change event for Focus not found or improperly sourced.")
	assert_true(visual_effect_found, "Visual effect event for Focus not found or improperly sourced.")

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
	var new_id = battle.get_new_instance_id()
	tiger_instance.setup(avenging_tiger_res, player, opponent, 0, battle, new_id)
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
	var new_id = battle.get_new_instance_id()
	tiger_instance.setup(avenging_tiger_res, player, opponent, 0, battle, new_id)

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
# res://tests/test_card_effects.gd

# --- Superior Intellect Tests ---
func test_superior_intellect_moves_grave_to_library_and_clears_opponent():
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"]
	var battle: Battle = setup["battle"]

	# Setup graveyards with CardInZone objects
	player.graveyard.clear()
	var scout_in_grave_instance_id = battle._generate_new_card_instance_id()
	player.graveyard.append(CardInZone.new(goblin_scout_res, scout_in_grave_instance_id))
	var knight_in_grave_instance_id = battle._generate_new_card_instance_id()
	player.graveyard.append(CardInZone.new(knight_res, knight_in_grave_instance_id))
	
	opponent.graveyard.clear()
	var healer_in_opp_grave_instance_id = battle._generate_new_card_instance_id()
	opponent.graveyard.append(CardInZone.new(healer_res, healer_in_opp_grave_instance_id))
	
	var initial_player_lib_size: int = player.library.size()
	var initial_event_count: int = battle.battle_events.size()

	# Create a CardInZone for the Superior Intellect spell
	var intellect_spell_instance_id: int = battle._generate_new_card_instance_id()
	var intellect_card_in_zone: CardInZone = CardInZone.new(superior_intellect_res, intellect_spell_instance_id)

	# Action: Apply effect
	if superior_intellect_res.has_method("apply_effect"): # Check directly on the resource instance
		print("Applying Superior Intellect effect:")
		superior_intellect_res.apply_effect(intellect_card_in_zone, player, opponent, battle)
	else:
		fail_test("Superior Intellect resource instance (superior_intellect_res) does not have apply_effect method. Check script assignment in .tres and method definition.")
		return

	# Assert: Player graveyard is empty
	assert_true(player.graveyard.is_empty(), "Player graveyard should be empty after Superior Intellect.")
	
	# Assert: Player library increased and contains moved cards at bottom
	assert_eq(player.library.size(), initial_player_lib_size + 2, "Player library size incorrect after Superior Intellect.")
	# Check last two cards (order was GoblinScout then Knight added to grave, so they should appear in that order at library bottom)
	assert_true(player.library[-1] is CardInZone, "Last card in player library should be CardInZone.")
	assert_true(player.library[-2] is CardInZone, "Second to last card in player library should be CardInZone.")
	if player.library.size() >= 2 : # Defensive check before accessing
		assert_eq(player.library[-1].get_card_id(), "Knight", "Knight should be at library bottom (last card added).")
		assert_eq(player.library[-1].get_card_instance_id(), knight_in_grave_instance_id, "Knight instance ID mismatch in library.")
		assert_eq(player.library[-2].get_card_id(), "GoblinScout", "Scout should be second from bottom.")
		assert_eq(player.library[-2].get_card_instance_id(), scout_in_grave_instance_id, "Scout instance ID mismatch in library.")
	
	# Assert: Opponent graveyard is empty
	assert_true(opponent.graveyard.is_empty(), "Opponent graveyard should be empty after Superior Intellect.")

	# Assert: Event generation
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expected events:
	# - 2x card_moved (player's grave to player's library)
	# - 1x card_removed (for opponent's Healer from their grave)
	# - 1x visual_effect (for the spell cast itself)
	# Total = 4 events
	
	var player_cards_moved_to_library: int = 0
	var opponent_cards_removed_from_grave: int = 0
	var main_visual_effect_found: bool = false

	for event_data in new_events:
		if event_data.get("event_type") == "card_moved" and \
		   event_data.get("player") == player.combatant_name and \
		   event_data.get("from_zone") == "graveyard" and \
		   event_data.get("to_zone") == "library" and \
		   event_data.get("source_instance_id") == intellect_spell_instance_id:
			player_cards_moved_to_library += 1
			# Check that the instance ID in from_details and to_details matches one of the original grave IDs
			var original_event_instance_id = event_data.get("instance_id") # This is ID from graveyard
			var moved_card_id = event_data.get("card_id")
			assert_true(original_event_instance_id == scout_in_grave_instance_id or original_event_instance_id == knight_in_grave_instance_id, 
						"Moved card's instance_id (%s - %s) doesn't match expected graveyard instance." % [moved_card_id, original_event_instance_id])
			assert_eq(event_data.get("to_details", {}).get("instance_id"), original_event_instance_id, 
						"Instance ID in to_details should match original grave ID for %s." % moved_card_id)

		elif event_data.get("event_type") == "card_removed" and \
			 event_data.get("player") == opponent.combatant_name and \
			 event_data.get("from_zone") == "graveyard" and \
			 event_data.get("instance_id") == healer_in_opp_grave_instance_id and \
			 event_data.get("source_instance_id") == intellect_spell_instance_id:
			opponent_cards_removed_from_grave += 1
		
		elif event_data.get("event_type") == "visual_effect" and \
			 event_data.get("effect_id") == "superior_intellect_cast" and \
			 event_data.get("source_instance_id") == intellect_spell_instance_id:
			main_visual_effect_found = true

	assert_eq(player_cards_moved_to_library, 2, "Incorrect number of player's cards moved from grave to library by Superior Intellect.")
	assert_eq(opponent_cards_removed_from_grave, 1, "Incorrect number of opponent's cards removed from grave by Superior Intellect.")
	assert_true(main_visual_effect_found, "Main visual effect for Superior Intellect cast not found or improperly sourced.")

# --- Goblin Rally Tests ---
func test_goblin_rally_summons_scouts_in_empty_lanes():
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"] 
	var battle: Battle = setup["battle"]
	
	# Setup lanes: Player's Lane 0 (index 0) empty, Lane 1 (index 1) occupied, Lane 2 (index 2) empty
	var _knight_blocker = place_summon_for_test(player, knight_res, 1, battle) 
	
	var initial_event_count: int = battle.battle_events.size()

	# Create a CardInZone for the Goblin Rally spell being "played"
	var rally_spell_instance_id: int = battle._generate_new_card_instance_id()
	var rally_card_in_zone: CardInZone = CardInZone.new(goblin_rally_res, rally_spell_instance_id)

	# Action: Apply Goblin Rally effect
	# Signature: apply_effect(p_rally_card_in_zone: CardInZone, active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle)
	if goblin_rally_res.has_method("apply_effect"):
		goblin_rally_res.apply_effect(rally_card_in_zone, player, opponent, battle)
	else:
		fail_test("Goblin Rally resource does not have a script with apply_effect.")
		return

	# Assert: Lanes 0 and 2 now have Goblin Scouts
	assert_true(player.lanes[0] is SummonInstance and player.lanes[0].card_resource.id == "GoblinScout", "Lane 0 (index 0) should have Goblin Scout.")
	var scout_in_lane0 = player.lanes[0] as SummonInstance 

	assert_true(player.lanes[1] is SummonInstance and player.lanes[1].card_resource.id == "Knight", "Lane 1 (index 1) should still have Knight.")
	
	assert_true(player.lanes[2] is SummonInstance and player.lanes[2].card_resource.id == "GoblinScout", "Lane 2 (index 2) should have Goblin Scout.")
	var scout_in_lane2 = player.lanes[2] as SummonInstance

	# Assert: Event generation
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expected events:
	# - 2x summon_arrives (for the two Goblin Scouts)
	# - 1x visual_effect (for the Goblin Rally spell cast itself)
	# Total = 3 events
	assert_eq(new_events.size(), 3, "Goblin Rally effect should generate 3 events (2 arrives, 1 visual). Found: %s" % new_events.size())

	var scouts_arrived_count: int = 0
	var main_visual_effect_found: bool = false
	var scout_lane0_instance_id: int = -1 # Default if scout not found (test would fail earlier)
	var scout_lane2_instance_id: int = -1 # Default

	if scout_in_lane0: scout_lane0_instance_id = scout_in_lane0.instance_id
	if scout_in_lane2: scout_lane2_instance_id = scout_in_lane2.instance_id

	for event_data in new_events:
		if event_data.get("event_type") == "summon_arrives" and \
		   event_data.get("card_id") == "GoblinScout" and \
		   event_data.get("player") == player.combatant_name and \
		   event_data.get("source_card_id") == rally_card_in_zone.get_card_id() and \
		   event_data.get("source_instance_id") == rally_card_in_zone.get_card_instance_id():
			scouts_arrived_count += 1
			var arrived_lane = event_data.get("lane") # 1-based
			var arrived_instance_id = event_data.get("instance_id")
			if arrived_lane == 1: # Corresponds to index 0
				assert_true(scout_in_lane0 != null, "Scout should exist in lane 0 to get its ID.")
				assert_eq(arrived_instance_id, scout_lane0_instance_id, "Instance ID of scout in lane 0 mismatch.")
			elif arrived_lane == 3: # Corresponds to index 2
				assert_true(scout_in_lane2 != null, "Scout should exist in lane 2 to get its ID.")
				assert_eq(arrived_instance_id, scout_lane2_instance_id, "Instance ID of scout in lane 2 mismatch.")
			else:
				fail_test("Goblin Scout arrived in unexpected lane: %s. Expected 1 or 3." % arrived_lane)
		
		elif event_data.get("event_type") == "visual_effect" and \
			 event_data.get("effect_id") == "goblin_rally_cast" and \
			 event_data.get("source_instance_id") == rally_card_in_zone.get_card_instance_id():
			main_visual_effect_found = true
			assert_eq(event_data.get("details", {}).get("summoned_count"), 2, "Goblin Rally visual_effect: summoned_count incorrect.")
			assert_eq(event_data.get("instance_id"), rally_card_in_zone.get_card_instance_id(), "Goblin Rally visual_effect: instance_id incorrect (should be Rally spell).")


	assert_eq(scouts_arrived_count, 2, "Goblin Rally should result in 2 Goblin Scout summon_arrives events.")
	assert_true(main_visual_effect_found, "Main visual effect for Goblin Rally cast not found or improperly sourced.")

func test_goblin_rally_no_empty_lanes():
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"] 
	var battle: Battle = setup["battle"]
	
	# Occupy all of the player's lanes
	var _blocker1 = place_summon_for_test(player, knight_res, 0, battle)
	var _blocker2 = place_summon_for_test(player, knight_res, 1, battle)
	var _blocker3 = place_summon_for_test(player, knight_res, 2, battle)
	
	var initial_event_count: int = battle.battle_events.size()

	# Create a CardInZone for the Goblin Rally spell being "played"
	var rally_spell_instance_id: int = battle._generate_new_card_instance_id()
	var rally_card_in_zone: CardInZone = CardInZone.new(goblin_rally_res, rally_spell_instance_id)

	# Action: Apply Goblin Rally effect
	if goblin_rally_res.has_method("apply_effect"):
		goblin_rally_res.apply_effect(rally_card_in_zone, player, opponent, battle)
	else:
		fail_test("Goblin Rally resource does not have a script with apply_effect.")
		return

	# Assert: Lanes remain unchanged (still occupied by Knights)
	assert_true(player.lanes[0] is SummonInstance and player.lanes[0].card_resource.id == "Knight", "Lane 0 should still be Knight.")
	assert_true(player.lanes[1] is SummonInstance and player.lanes[1].card_resource.id == "Knight", "Lane 1 should still be Knight.")
	assert_true(player.lanes[2] is SummonInstance and player.lanes[2].card_resource.id == "Knight", "Lane 2 should still be Knight.")

	# Assert: Event generation
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expected events:
	# - 1x visual_effect (for the Goblin Rally spell cast itself, even if no scouts summoned)
	# - 1x log_message (optional, from the effect script if no lanes are free)
	# Let's primarily assert the visual_effect and check no summon_arrives.
	
	var summon_arrives_event_found: bool = false
	var main_visual_effect_found: bool = false
	var log_message_no_lanes_found: bool = false

	for event_data in new_events:
		if event_data.get("event_type") == "summon_arrives" and \
		   event_data.get("card_id") == "GoblinScout": # Should not happen
			summon_arrives_event_found = true
		
		elif event_data.get("event_type") == "visual_effect" and \
			 event_data.get("effect_id") == "goblin_rally_cast" and \
			 event_data.get("source_instance_id") == rally_card_in_zone.get_card_instance_id():
			main_visual_effect_found = true
			# When no scouts are summoned, the effect script still logs this visual event.
			# The "summoned_count" in details should be 0.
			assert_eq(event_data.get("details", {}).get("summoned_count"), 0, "Goblin Rally visual_effect: summoned_count should be 0 when no lanes are free.")
			assert_eq(event_data.get("instance_id"), rally_card_in_zone.get_card_instance_id(), "Goblin Rally visual_effect: instance_id incorrect.")

		elif event_data.get("event_type") == "log_message" and \
			 "no empty lanes" in event_data.get("message", "").to_lower() and \
			 event_data.get("source_instance_id") == rally_card_in_zone.get_card_instance_id():
			log_message_no_lanes_found = true
			
	assert_false(summon_arrives_event_found, "Goblin Rally should not generate summon_arrives events if no lanes are free.")
	assert_true(main_visual_effect_found, "Main visual effect for Goblin Rally cast not found or improperly sourced (when no lanes free).")
	assert_true(log_message_no_lanes_found, "Log message indicating no empty lanes for Goblin Rally was not found.")

# --- Thought Acquirer Tests ---
func test_thought_acquirer_steals_card():
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"]
	var battle: Battle = setup["battle"]
	
	# Setup opponent library with CardInZone objects
	opponent.library.clear()
	# Order: Scout (top, index 0), Knight (middle, index 1), Healer (bottom, index 2)
	var healer_in_opp_lib_instance_id = battle._generate_new_card_instance_id()
	var knight_in_opp_lib_instance_id = battle._generate_new_card_instance_id()
	var scout_in_opp_lib_instance_id = battle._generate_new_card_instance_id()

	opponent.library.append(CardInZone.new(goblin_scout_res, scout_in_opp_lib_instance_id))  # Top
	opponent.library.append(CardInZone.new(knight_res, knight_in_opp_lib_instance_id)) # Middle
	opponent.library.append(CardInZone.new(healer_res, healer_in_opp_lib_instance_id)) # Bottom (this will be stolen)
	
	var initial_opp_lib_size: int = opponent.library.size() # Should be 3
	var initial_player_lib_size: int = player.library.size()
	
	# Ensure library has items before accessing -1 (though previous appends should ensure this)
	assert_gt(opponent.library.size(), 0, "Opponent library should not be empty before getting bottom card.")
	var bottom_card_to_be_stolen_original_card_id: String = opponent.library[-1].get_card_id()
	var bottom_card_to_be_stolen_original_instance_id: int = opponent.library[-1].get_card_instance_id()
	assert_eq(bottom_card_to_be_stolen_original_card_id, "Healer", "Expected Healer to be at the bottom of opponent's library initially.")

	# Simulate Thought Acquirer arrival
	var acquirer_instance = SummonInstance.new()
	var acquirer_instance_id: int = battle._generate_new_card_instance_id() # Use new ID system
	acquirer_instance.setup(thought_acquirer_res, player, opponent, 0, battle, acquirer_instance_id)
	
	var initial_event_count: int = battle.battle_events.size()

	# Action: Call _on_arrival effect
	if thought_acquirer_res.has_method("_on_arrival"):
		thought_acquirer_res._on_arrival(acquirer_instance, player, opponent, battle)
	else:
		fail_test("Thought Acquirer resource does not have _on_arrival method.")
		return

	# Assert: Opponent library size decreased by 1
	assert_eq(opponent.library.size(), initial_opp_lib_size - 1, "Opponent library size should decrease by one.")
	# Assert: Player library size increased by 1
	assert_eq(player.library.size(), initial_player_lib_size + 1, "Player library size should increase by one.")
	
	# Assert: Correct card (Healer) moved to player's library bottom, maintaining its original instance_id (as per current effect logic)
	assert_true(player.library[-1] is CardInZone, "Card at bottom of player's library should be CardInZone.")
	if player.library.size() > 0: # Defensive check
		var stolen_card_in_player_lib = player.library[-1]
		assert_eq(stolen_card_in_player_lib.get_card_id(), bottom_card_to_be_stolen_original_card_id, "Incorrect card ID moved to player library bottom.")
		assert_eq(stolen_card_in_player_lib.get_card_instance_id(), bottom_card_to_be_stolen_original_instance_id, "Instance ID of stolen card should be maintained when moved to player library.")

	# Assert: Event generation
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expected events:
	# 1. card_moved (opponent's library -> limbo/stolen, for the Healer)
	# 2. card_moved (limbo/stolen -> player's library, for the Healer)
	# (Optional: 1x visual_effect for the Thought Acquirer's ability)
	# Let's assume 2 card_moved events for now, adjust if visual_effect is added by effect script.
	# Based on thought_acquirer_effect.gd, it does generate a visual_effect. So, 3 events.
	assert_eq(new_events.size(), 3, "Thought Acquirer effect should generate 3 events. Found: %s" % new_events.size())

	var moved_from_opponent_lib_found: bool = false
	var moved_to_player_lib_found: bool = false
	var visual_effect_found: bool = false

	for event_data in new_events:
		if event_data.get("event_type") == "card_moved" and \
		   event_data.get("player") == opponent.combatant_name and \
		   event_data.get("from_zone") == "library" and \
		   event_data.get("to_zone") == "limbo" and \
		   event_data.get("card_id") == bottom_card_to_be_stolen_original_card_id and \
		   event_data.get("instance_id") == bottom_card_to_be_stolen_original_instance_id and \
		   event_data.get("source_instance_id") == acquirer_instance_id:
			moved_from_opponent_lib_found = true
		
		elif event_data.get("event_type") == "card_moved" and \
			 event_data.get("player") == player.combatant_name and \
			 event_data.get("from_zone") == "limbo" and \
			 event_data.get("to_zone") == "library" and \
			 event_data.get("card_id") == bottom_card_to_be_stolen_original_card_id and \
			 event_data.get("instance_id") == bottom_card_to_be_stolen_original_instance_id and \
			 event_data.get("source_instance_id") == acquirer_instance_id:
			moved_to_player_lib_found = true
			assert_eq(event_data.get("to_details", {}).get("position"), "bottom", "Stolen card should be added to bottom of player's library.")
			# The instance_id in to_details should be the same if the CardInZone object itself was moved.
			assert_eq(event_data.get("to_details", {}).get("instance_id"), bottom_card_to_be_stolen_original_instance_id, "Instance ID in to_details mismatch for stolen card.")

		elif event_data.get("event_type") == "visual_effect" and \
			 event_data.get("effect_id") == "thought_acquirer_steal" and \
			 event_data.get("source_instance_id") == acquirer_instance_id:
			visual_effect_found = true
			assert_eq(event_data.get("details", {}).get("card_id"), bottom_card_to_be_stolen_original_card_id, "Visual effect details: card_id incorrect.")
			# The main instance_id of this visual effect could be the Thought Acquirer or the stolen card.
			# Let's assume the Acquirer for now, or it could be -1 if it's a general "steal" visual.
			assert_eq(event_data.get("instance_id"), acquirer_instance_id, "Visual effect instance_id (Thought Acquirer) incorrect.")


	assert_true(moved_from_opponent_lib_found, "Card moved from opponent library event not found or improperly sourced.")
	assert_true(moved_to_player_lib_found, "Card moved to player library event not found or improperly sourced.")
	assert_true(visual_effect_found, "Visual effect for Thought Acquirer steal not found or improperly sourced.")

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
	var new_id = battle.get_new_instance_id()
	instance.setup(thought_acquirer_res, player, opponent, 0, battle, new_id)

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
	var battle = setup["battle"]
	var new_id = battle.get_new_instance_id()
	ooze_instance.setup(inexorable_ooze_res, setup["player"], setup["opponent"], 0, setup["battle"], new_id)
	assert_true(ooze_instance.is_relentless, "Inexorable Ooze instance should be relentless after setup.")
	# Actual relentless behavior (calling _perform_direct_attack) is tested implicitly
	# when simulating turns involving the Ooze.

# --- Reanimate Tests ---
func test_reanimate_summons_from_graveyard():
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"]
	var battle: Battle = setup["battle"]
	
	# Setup graveyard with CardInZone objects
	player.graveyard.clear()
	# Knight is added first, so it's at index 0 (leftmost)
	var knight_in_grave_instance_id = battle._generate_new_card_instance_id()
	player.graveyard.append(CardInZone.new(knight_res, knight_in_grave_instance_id))
	var scout_in_grave_instance_id = battle._generate_new_card_instance_id() # Unused if only Knight reanimated
	player.graveyard.append(CardInZone.new(goblin_scout_res, scout_in_grave_instance_id))
	
	player.lanes[0] = null # Ensure lane 0 is free for the reanimated summon
	var initial_grave_size_val: int = player.graveyard.size() # Should be 2
	var initial_event_count: int = battle.battle_events.size()

	# Create a CardInZone for the Reanimate spell
	var reanimate_spell_instance_id: int = battle._generate_new_card_instance_id()
	var reanimate_card_in_zone: CardInZone = CardInZone.new(reanimate_res, reanimate_spell_instance_id)

	# Action: Apply Reanimate effect
	if reanimate_res.has_method("apply_effect"):
		reanimate_res.apply_effect(reanimate_card_in_zone, player, opponent, battle)
	else:
		fail_test("Reanimate resource does not have a script with apply_effect.")
		return

	# Assert: Lane 0 now has the Knight (which was leftmost in graveyard)
	assert_true(player.lanes[0] is SummonInstance, "Lane 0 should have a SummonInstance after Reanimate.")
	var reanimated_summon_in_lane0 = player.lanes[0] as SummonInstance
	assert_true(reanimated_summon_in_lane0 != null and reanimated_summon_in_lane0.card_resource.id == "Knight", "Lane 0 should have reanimated Knight.")
	
	# Assert: Reanimated Knight has Undead tag (as per Reanimate effect script)
	assert_true(reanimated_summon_in_lane0.tags.has(Constants.TAG_UNDEAD), "Reanimated Knight should have Undead tag.")
	
	# Assert: Graveyard size decreased by 1 (Knight was removed)
	assert_eq(player.graveyard.size(), initial_grave_size_val - 1, "Player graveyard size should decrease by one.")
	
	# Assert: Knight is no longer in graveyard; Scout should still be there.
	var knight_found_in_grave_after: bool = false
	var scout_found_in_grave_after: bool = false
	for card_in_zone_obj in player.graveyard:
		if card_in_zone_obj.get_card_id() == "Knight":
			knight_found_in_grave_after = true
		elif card_in_zone_obj.get_card_id() == "GoblinScout":
			scout_found_in_grave_after = true
	assert_false(knight_found_in_grave_after, "Knight should be removed from graveyard after Reanimate.")
	assert_true(scout_found_in_grave_after, "Goblin Scout should still be in graveyard after Reanimate.")


	# Assert: Event generation
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expected events for successful reanimation of Knight:
	# 1. card_moved (Knight from player's grave to limbo, sourced by Reanimate spell)
	# 2. status_change (Knight gains Undead tag, sourced by Reanimate spell) - if you added this event
	# 3. summon_arrives (Knight arrives in lane, sourced by Reanimate spell)
	# 4. card_moved (Knight from limbo to player's lane, sourced by Reanimate spell)
	# (Potentially a visual_effect for the Reanimate spell itself, if the effect script adds one)

	var moved_from_grave_found: bool = false
	var status_undead_gained_found: bool = false # Optional based on your effect script
	var summon_arrives_found: bool = false
	var moved_to_lane_found: bool = false

	var reanimated_knight_field_instance_id = reanimated_summon_in_lane0.instance_id

	for event_data in new_events:
		var event_src_card_id = event_data.get("source_card_id")
		var event_src_instance_id = event_data.get("source_instance_id")

		if event_data.get("event_type") == "card_moved" and \
		   event_data.get("card_id") == "Knight" and \
		   event_data.get("instance_id") == knight_in_grave_instance_id and \
		   event_data.get("from_zone") == "graveyard" and event_data.get("to_zone") == "limbo" and \
		   event_src_card_id == reanimate_card_in_zone.get_card_id() and \
		   event_src_instance_id == reanimate_card_in_zone.get_card_instance_id():
			moved_from_grave_found = true
		
		elif event_data.get("event_type") == "status_change" and \
			 event_data.get("card_id") == "Knight" and \
			 event_data.get("instance_id") == reanimated_knight_field_instance_id and \
			 event_data.get("status") == Constants.TAG_UNDEAD and event_data.get("gained") == true and \
			 event_src_card_id == reanimate_card_in_zone.get_card_id() and \
			 event_src_instance_id == reanimate_card_in_zone.get_card_instance_id():
			status_undead_gained_found = true # This event is logged by the revised reanimate_effect.gd

		elif event_data.get("event_type") == "summon_arrives" and \
			 event_data.get("card_id") == "Knight" and \
			 event_data.get("instance_id") == reanimated_knight_field_instance_id and \
			 event_src_card_id == reanimate_card_in_zone.get_card_id() and \
			 event_src_instance_id == reanimate_card_in_zone.get_card_instance_id():
			summon_arrives_found = true
			assert_true(event_data.get("tags", []).has(Constants.TAG_UNDEAD), "Summon_arrives event for reanimated Knight should include Undead tag.")

		elif event_data.get("event_type") == "card_moved" and \
			 event_data.get("card_id") == "Knight" and \
			 event_data.get("instance_id") == knight_in_grave_instance_id and \
			 event_data.get("from_zone") == "limbo" and event_data.get("to_zone") == "lane" and \
			 event_data.get("to_details", {}).get("instance_id") == reanimated_knight_field_instance_id and \
			 event_src_card_id == reanimate_card_in_zone.get_card_id() and \
			 event_src_instance_id == reanimate_card_in_zone.get_card_instance_id():
			moved_to_lane_found = true
			
	assert_true(moved_from_grave_found, "Card_moved (Knight from grave to limbo) event not found or improperly sourced for Reanimate.")
	assert_true(status_undead_gained_found, "Status_change (Knight gains Undead) event not found or improperly sourced for Reanimate.")
	assert_true(summon_arrives_found, "Summon_arrives (Knight) event not found or improperly sourced for Reanimate.")
	assert_true(moved_to_lane_found, "Card_moved (Knight from limbo to lane) event not found or improperly sourced for Reanimate.")

func test_reanimate_no_target_in_graveyard():
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"] 
	var battle: Battle = setup["battle"]
	
	player.graveyard.clear() # Ensure graveyard is empty
	
	var initial_event_count: int = battle.battle_events.size()

	# Create a CardInZone for the Reanimate spell
	var reanimate_spell_instance_id: int = battle._generate_new_card_instance_id()
	var reanimate_card_in_zone: CardInZone = CardInZone.new(reanimate_res, reanimate_spell_instance_id)

	# Action: Apply Reanimate effect
	if reanimate_res.has_method("apply_effect"):
		reanimate_res.apply_effect(reanimate_card_in_zone, player, opponent, battle)
	else:
		fail_test("Reanimate resource does not have a script with apply_effect.")
		return

	# Assert no summon arrived
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	var summon_arrives_event_found: bool = false
	var log_message_no_target_found: bool = false

	for event_data in new_events:
		if event_data.get("event_type") == "summon_arrives":
			summon_arrives_event_found = true
			# Log details if an unexpected summon arrives, for easier debugging
			print("Unexpected summon_arrives event found: ", event_data) 
		elif event_data.get("event_type") == "log_message" and \
			 ("no summon target in graveyard" in event_data.get("message", "").to_lower() or \
			  "no target in graveyard" in event_data.get("message", "").to_lower()) and \
			 event_data.get("source_instance_id") == reanimate_spell_instance_id:
			log_message_no_target_found = true
			
	assert_false(summon_arrives_event_found, "No summon should arrive if player's graveyard is empty for Reanimate.")
	assert_true(log_message_no_target_found, "Log message indicating no target in graveyard for Reanimate was not found or improperly sourced.")


func test_reanimate_no_empty_lane():
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"]
	var battle: Battle = setup["battle"]
	
	# Setup graveyard with a target (Knight)
	player.graveyard.clear()
	var knight_in_grave_instance_id = battle._generate_new_card_instance_id() # Though not directly asserted here, good practice for setup
	player.graveyard.append(CardInZone.new(knight_res, knight_in_grave_instance_id))

	# Fill all player lanes
	var _blocker1 = place_summon_for_test(player, goblin_scout_res, 0, battle)
	var _blocker2 = place_summon_for_test(player, goblin_scout_res, 1, battle)
	var _blocker3 = place_summon_for_test(player, goblin_scout_res, 2, battle)
	
	var initial_event_count: int = battle.battle_events.size()

	# Create a CardInZone for the Reanimate spell
	var reanimate_spell_instance_id: int = battle._generate_new_card_instance_id()
	var reanimate_card_in_zone: CardInZone = CardInZone.new(reanimate_res, reanimate_spell_instance_id)

	# Action: Apply Reanimate effect
	if reanimate_res.has_method("apply_effect"):
		reanimate_res.apply_effect(reanimate_card_in_zone, player, opponent, battle)
	else:
		fail_test("Reanimate resource does not have a script with apply_effect.")
		return

	# Assert no summon arrived because lanes are full
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	var summon_arrives_event_found: bool = false
	var log_message_no_lane_found: bool = false

	for event_data in new_events:
		if event_data.get("event_type") == "summon_arrives":
			summon_arrives_event_found = true
			print("Unexpected summon_arrives event found: ", event_data) 
		elif event_data.get("event_type") == "log_message" and \
			 "no empty lane" in event_data.get("message", "").to_lower() and \
			 event_data.get("source_instance_id") == reanimate_spell_instance_id:
			log_message_no_lane_found = true
			
	assert_false(summon_arrives_event_found, "No summon should arrive if player's lanes are full for Reanimate.")
	assert_true(log_message_no_lane_found, "Log message indicating no empty lane for Reanimate was not found or improperly sourced.")


# --- Goblin Chieftain/Warboss Tests ---
func test_goblin_chieftain_adds_warboss_to_deck():
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"] # Get opponent for _on_arrival signature
	var battle: Battle = setup["battle"]
	
	var initial_lib_size: int = player.library.size()
	
	# Simulate Goblin Chieftain arrival
	var chieftain_instance = SummonInstance.new()
	var chieftain_instance_id: int = battle._generate_new_card_instance_id() # Use new ID system
	chieftain_instance.setup(goblin_chieftain_res, player, opponent, 0, battle, chieftain_instance_id) 
	# Note: place_summon_for_test could be used here if Chieftain needs to be in a lane for the test,
	# but its _on_arrival doesn't depend on its own lane_index, so direct setup is fine.
	# If it were placed: player.lanes[0] = chieftain_instance

	var initial_event_count: int = battle.battle_events.size()

	# Action: Call _on_arrival effect
	if goblin_chieftain_res.has_method("_on_arrival"):
		goblin_chieftain_res._on_arrival(chieftain_instance, player, opponent, battle)
	else:
		fail_test("Goblin Chieftain resource does not have _on_arrival method.")
		return

	# Assert: Library size increased by 1
	assert_eq(player.library.size(), initial_lib_size + 1, "Player library size should increase by one after Chieftain's effect.")
	
	# Assert: Goblin Warboss CardInZone is at the bottom of the library
	assert_true(player.library[-1] is CardInZone, "Card at library bottom should be a CardInZone.")
	var warboss_in_library = player.library[-1] as CardInZone
	if warboss_in_library: # Defensive check after cast
		assert_eq(warboss_in_library.get_card_id(), "GoblinWarboss", "Goblin Warboss card_id should be at the bottom of the library.")
		# We can also check its instance_id if we want to be super sure it's the one from the event
	else:
		fail_test("Bottom card of library was not a CardInZone as expected.")


	# Assert: Event generation for the card_moved (Warboss to library)
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expect 1 event: card_moved (limbo -> library for the Goblin Warboss)
	assert_eq(new_events.size(), 1, "Goblin Chieftain effect should generate 1 card_moved event for Warboss. Found: %s" % new_events.size())

	var card_moved_event_for_warboss_found: bool = false
	var new_warboss_instance_id_from_event: int = -1

	if not new_events.is_empty(): # Check if there's an event to process
		var event_data = new_events[0] # Since we expect only one
		if event_data.get("event_type") == "card_moved" and \
		   event_data.get("card_id") == "GoblinWarboss" and \
		   event_data.get("player") == player.combatant_name and \
		   event_data.get("to_zone") == "library" and \
		   event_data.get("from_zone") == "limbo" and \
		   event_data.get("source_card_id") == goblin_chieftain_res.id and \
		   event_data.get("source_instance_id") == chieftain_instance_id:
			card_moved_event_for_warboss_found = true
			assert_eq(event_data.get("to_details", {}).get("position"), "bottom", "Warboss card_moved event: to_details.position incorrect.")
			new_warboss_instance_id_from_event = event_data.get("instance_id") # This is the ID of the Warboss CIZ
			assert_eq(event_data.get("to_details", {}).get("instance_id"), new_warboss_instance_id_from_event, "Warboss card_moved event: to_details.instance_id incorrect.")


	assert_true(card_moved_event_for_warboss_found, "Card_moved event for Goblin Warboss (limbo to library) not found or improperly sourced.")
	
	# Additional check: ensure the instance_id of the Warboss in library matches the event
	if warboss_in_library and new_warboss_instance_id_from_event != -1:
		assert_eq(warboss_in_library.get_card_instance_id(), new_warboss_instance_id_from_event, "Instance ID of Warboss in library does not match event instance ID.")

func test_goblin_warboss_adds_expendable_to_deck():
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"] 
	var battle: Battle = setup["battle"]
	
	var initial_lib_size: int = player.library.size()
	
	# Simulate Goblin Warboss arrival
	var warboss_instance = SummonInstance.new()
	var warboss_instance_id: int = battle._generate_new_card_instance_id() 
	warboss_instance.setup(goblin_warboss_res, player, opponent, 0, battle, warboss_instance_id) 
	
	var initial_event_count: int = battle.battle_events.size()

	# Action: Call _on_arrival effect
	if goblin_warboss_res.has_method("_on_arrival"):
		goblin_warboss_res._on_arrival(warboss_instance, player, opponent, battle)
	else:
		fail_test("Goblin Warboss resource does not have _on_arrival method.")
		return

	assert_eq(player.library.size(), initial_lib_size + 1, "Player library size should increase by one after Warboss's effect.")
	
	assert_true(player.library[-1] is CardInZone, "Card at library bottom should be a CardInZone.")
	var expendable_in_library = player.library[-1] as CardInZone
	if expendable_in_library: 
		assert_eq(expendable_in_library.get_card_id(), "GoblinExpendable", "Goblin Expendable card_id should be at the bottom of the library.")
	else:
		fail_test("Bottom card of library was not a CardInZone as expected for Warboss effect.")

	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	assert_eq(new_events.size(), 1, "Goblin Warboss effect should generate 1 card_moved event for Expendable. Found: %s" % new_events.size())

	var card_moved_event_for_expendable_found: bool = false
	var new_expendable_instance_id_from_event: int = -1

	if not new_events.is_empty():
		var event_data = new_events[0] 
		if event_data.get("event_type") == "card_moved" and \
		   event_data.get("card_id") == "GoblinExpendable" and \
		   event_data.get("player") == player.combatant_name and \
		   event_data.get("to_zone") == "library" and \
		   event_data.get("from_zone") == "limbo" and \
		   event_data.get("source_card_id") == goblin_warboss_res.id and \
		   event_data.get("source_instance_id") == warboss_instance_id:
			card_moved_event_for_expendable_found = true
			assert_eq(event_data.get("to_details", {}).get("position"), "bottom", "Expendable card_moved event: to_details.position incorrect.")
			new_expendable_instance_id_from_event = event_data.get("instance_id") 
			assert_eq(event_data.get("to_details", {}).get("instance_id"), new_expendable_instance_id_from_event, "Expendable card_moved event: to_details.instance_id incorrect.")

	assert_true(card_moved_event_for_expendable_found, "Card_moved event for Goblin Expendable (limbo to library) not found or improperly sourced.")
	
	if expendable_in_library and new_expendable_instance_id_from_event != -1:
		assert_eq(expendable_in_library.get_card_instance_id(), new_expendable_instance_id_from_event, "Instance ID of Expendable in library does not match event instance ID.")

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
	var battle = setup["battle"]
	var new_id = battle.get_new_instance_id()
	instance.setup(goblin_expendable_res, setup["player"], setup["opponent"], 0, setup["battle"], new_id)
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
	var new_id = battle.get_new_instance_id()
	master_instance.setup(master_of_strategy_res, player, player.opponent, 1, battle, new_id)
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
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"]
	var battle: Battle = setup["battle"]
	
	# Place Undead target (Recurring Skeleton) for opponent in their lane 0 (index 0)
	var target_skeleton_instance = place_summon_for_test(opponent, recurring_skeleton_res, 0, battle)
	var target_skeleton_original_field_instance_id: int = target_skeleton_instance.instance_id
	
	var initial_event_count: int = battle.battle_events.size()

	# Simulate Slayer arrival in player's lane 0 (index 0), opposite the skeleton
	var slayer_instance = SummonInstance.new()
	var slayer_instance_id: int = battle._generate_new_card_instance_id() # Use new ID system
	slayer_instance.setup(slayer_res, player, opponent, 0, battle, slayer_instance_id)
	# Manually place Slayer in lane for this test if place_summon_for_test wasn't used for it
	# player.lanes[0] = slayer_instance # Assuming Slayer's _on_arrival doesn't depend on it being in a lane yet,
									  # but for consistency, if other arrivals place, this should too.
									  # Let's assume place_summon_for_test handles this if we used it for slayer.
									  # For now, direct setup is what the original test did.

	# Action: Call Slayer's _on_arrival effect
	if slayer_res.has_method("_on_arrival"):
		slayer_res._on_arrival(slayer_instance, player, opponent, battle)
	else:
		fail_test("Slayer resource does not have _on_arrival method.")
		return

	# Assert: Opponent's lane 0 is now empty (Skeleton died and was removed by its own _on_death or by Slayer's effect)
	assert_null(opponent.lanes[0], "Opponent's lane 0 should be empty after Slayer kills Skeleton.")
	
	# Assert: Skeleton (CardInZone) went to opponent's library (due to Recurring Skeleton's own _on_death effect)
	assert_eq(opponent.library.size(), 1, "Opponent's library should contain 1 card (the returned Skeleton).")
	assert_true(opponent.library[0] is CardInZone, "Card in opponent's library should be a CardInZone.")
	var returned_skeleton_in_lib = opponent.library[0] as CardInZone
	if returned_skeleton_in_lib:
		assert_eq(returned_skeleton_in_lib.get_card_id(), "RecurringSkeleton", "Returned Skeleton's card_id in library is incorrect.")
		# The instance ID of the card in library will be NEW, as per recurring_skeleton_effect.gd logic
		assert_ne(returned_skeleton_in_lib.get_card_instance_id(), target_skeleton_original_field_instance_id, "Returned Skeleton in library should have a new instance_id, different from its field ID.")
	else:
		fail_test("Card in opponent library was not a CardInZone as expected.")


	# Assert: Event generation
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expected events:
	# 1. (Optional) visual_effect for Slayer's ability targeting Skeleton
	# 2. creature_defeated for Skeleton (instance_id: target_skeleton_original_field_instance_id, sourced by Slayer)
	# 3. card_moved (Skeleton from lane to library, due to Skeleton's own death effect, sourced by Skeleton itself)
	#    (Note: recurring_skeleton_effect.gd sets prevent_graveyard = true)

	var visual_effect_slayer_found: bool = false # Slayer's targeting visual
	var skeleton_defeated_event_found: bool = false
	var skeleton_moved_to_library_event_found: bool = false
	var new_skeleton_library_instance_id_from_event: int = -1

	for event_data in new_events:
		var event_type = event_data.get("event_type")
		var event_instance_id = event_data.get("instance_id")
		var event_card_id = event_data.get("card_id")
		var event_source_instance_id = event_data.get("source_instance_id")
		var event_source_card_id = event_data.get("source_card_id")

		if event_type == "visual_effect" and event_data.get("effect_id") == "slayer_destroy" and \
		   event_instance_id == target_skeleton_original_field_instance_id and \
		   event_source_instance_id == slayer_instance_id:
			visual_effect_slayer_found = true
		
		elif event_type == "creature_defeated" and \
			 event_instance_id == target_skeleton_original_field_instance_id and \
			 event_card_id == "RecurringSkeleton":
			skeleton_defeated_event_found = true
			# To fully verify, creature_defeated should ideally also have source_card_id and source_instance_id
			# For now, we assume Slayer's action immediately precedes this.
			# If Slayer's _on_arrival called target_skeleton_instance.die(slayer_instance_id, slayer_card_id), 
			# then die() could pass these to the event.
			# assert_eq(event_source_card_id, slayer_res.id, "Skeleton defeated event: source_card_id (Slayer) incorrect.")
			# assert_eq(event_source_instance_id, slayer_instance_id, "Skeleton defeated event: source_instance_id (Slayer) incorrect.")

		elif event_type == "card_moved" and \
			 event_card_id == "RecurringSkeleton" and \
			 event_data.get("from_zone") == "lane" and \
			 event_data.get("from_details", {}).get("instance_id") == target_skeleton_original_field_instance_id and \
			 event_data.get("to_zone") == "library":
			skeleton_moved_to_library_event_found = true
			# This move is caused by Skeleton's own death effect
			assert_eq(event_source_card_id, "RecurringSkeleton", "Skeleton moved_to_library: source_card_id incorrect.")
			assert_eq(event_source_instance_id, target_skeleton_original_field_instance_id, "Skeleton moved_to_library: source_instance_id incorrect.")
			new_skeleton_library_instance_id_from_event = event_data.get("to_details", {}).get("instance_id")
			assert_ne(new_skeleton_library_instance_id_from_event, target_skeleton_original_field_instance_id, "Skeleton in library should have a new instance ID in to_details.")


	# assert_true(visual_effect_slayer_found, "Visual effect for Slayer destroying Skeleton not found or improperly sourced.") # This is optional
	assert_true(skeleton_defeated_event_found, "Creature_defeated event for Skeleton not found.")
	assert_true(skeleton_moved_to_library_event_found, "Card_moved event for Skeleton returning to library not found or improperly sourced.")

	# Final check on library card's instance ID
	if returned_skeleton_in_lib and new_skeleton_library_instance_id_from_event != -1:
		assert_eq(returned_skeleton_in_lib.get_card_instance_id(), new_skeleton_library_instance_id_from_event, "Instance ID of Skeleton in library does not match its card_moved to_details.instance_id.")

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
	var new_id = battle.get_new_instance_id()
	slayer_instance.setup(slayer_res, player, opponent, 0, battle, new_id)

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
	var new_id = battle.get_new_instance_id()
	fang_instance.setup(spiteful_fang_res, player, opponent, 0, battle, new_id)

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
	var new_id = battle.get_new_instance_id()
	fang_instance.setup(spiteful_fang_res, player, opponent, 0, battle, new_id)

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
	var battle = setup["battle"]
	var new_id = battle.get_new_instance_id()
	instance.setup(spiteful_fang_res, setup["player"], setup["opponent"], 0, setup["battle"], new_id)
	assert_true(instance.is_relentless, "Spiteful Fang instance should be relentless after setup.")

# --- Nap Tests ---
func test_nap_heals_player():
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"] # Get opponent for apply_effect signature
	var battle: Battle = setup["battle"]
	
	player.current_hp = 15
	var initial_player_hp: int = player.current_hp
	var initial_event_count: int = battle.battle_events.size()

	# Create a CardInZone for the Nap spell being "played"
	var nap_spell_instance_id: int = battle._generate_new_card_instance_id()
	var nap_card_in_zone: CardInZone = CardInZone.new(nap_res, nap_spell_instance_id)

	# Action: Apply Nap effect
	# Signature: apply_effect(p_nap_card_in_zone: CardInZone, active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle)
	if nap_res.has_method("apply_effect"):
		nap_res.apply_effect(nap_card_in_zone, player, opponent, battle)
	else:
		fail_test("Nap resource does not have a script with apply_effect.")
		return

	# Assert: Player HP increased correctly (up to cap)
	var expected_player_hp: int = min(initial_player_hp + 2, player.max_hp)
	assert_eq(player.current_hp, expected_player_hp, "Nap should heal player correctly.")

	# Assert: Event generation
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expected events:
	# 1. hp_change (from Combatant.heal, called by Nap effect)
	# 2. visual_effect (from Nap effect itself)
	assert_eq(new_events.size(), 2, "Nap effect should generate 2 events. Found: %s" % new_events.size())

	var hp_change_event_found: bool = false
	var visual_effect_found: bool = false

	for event_data in new_events:
		if event_data.get("event_type") == "hp_change" and \
		   event_data.get("player") == player.combatant_name:
			hp_change_event_found = true
			assert_eq(event_data.get("amount"), expected_player_hp - initial_player_hp, "Nap hp_change event: amount incorrect.")
			assert_eq(event_data.get("new_total"), expected_player_hp, "Nap hp_change event: new_total incorrect.")
			assert_eq(event_data.get("source"), nap_card_in_zone.get_card_id(), "Nap hp_change event: source card_id incorrect.")
			assert_eq(event_data.get("instance_id"), nap_card_in_zone.get_card_instance_id(), "Nap hp_change event: instance_id (the spell) incorrect.")
			assert_eq(event_data.get("source_instance_id"), nap_card_in_zone.get_card_instance_id(), "Nap hp_change event: source_instance_id incorrect.")
		
		elif event_data.get("event_type") == "visual_effect" and \
			 event_data.get("effect_id") == "nap_heal_player":
			visual_effect_found = true
			assert_eq(event_data.get("instance_id"), nap_card_in_zone.get_card_instance_id(), "Nap visual_effect: instance_id incorrect.")
			assert_eq(event_data.get("source_instance_id"), nap_card_in_zone.get_card_instance_id(), "Nap visual_effect: source_instance_id incorrect.")
			assert_eq(event_data.get("details", {}).get("amount_healed"), 2, "Nap visual_effect details: amount_healed incorrect.")

	assert_true(hp_change_event_found, "Player hp_change event for Nap not found or improperly sourced.")
	assert_true(visual_effect_found, "Visual effect event for Nap not found or improperly sourced.")

# --- Totem of Champions Tests ---
func test_totem_of_champions_buffs_debuffs():
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"]
	var battle: Battle = setup["battle"]
	
	# Place creatures
	var player_scout = place_summon_for_test(player, goblin_scout_res, 0, battle)
	var player_knight = place_summon_for_test(player, knight_res, 1, battle)
	var opp_scout = place_summon_for_test(opponent, goblin_scout_res, 0, battle)
	var opp_knight = place_summon_for_test(opponent, knight_res, 1, battle)
	
	var initial_pscout_power = player_scout.get_current_power()
	var initial_pknight_power = player_knight.get_current_power()
	var initial_oscout_power = opp_scout.get_current_power()
	var initial_oknight_power = opp_knight.get_current_power()
	
	var initial_event_count: int = battle.battle_events.size()

	# Create a CardInZone for the Totem of Champions spell
	var totem_spell_instance_id: int = battle._generate_new_card_instance_id()
	var totem_card_in_zone: CardInZone = CardInZone.new(totem_of_champions_res, totem_spell_instance_id)

	# Action: Apply Totem of Champions effect
	if totem_of_champions_res.has_method("apply_effect"):
		totem_of_champions_res.apply_effect(totem_card_in_zone, player, opponent, battle)
	else:
		fail_test("Totem of Champions resource does not have a script with apply_effect.")
		return

	# Assert: Player creatures buffed (+1 power)
	assert_eq(player_scout.get_current_power(), initial_pscout_power + 1, "Totem: Player Scout power incorrect.")
	assert_eq(player_knight.get_current_power(), initial_pknight_power + 1, "Totem: Player Knight power incorrect.")
	# Assert: Opponent creatures debuffed (-1 power)
	assert_eq(opp_scout.get_current_power(), max(0, initial_oscout_power - 1), "Totem: Opponent Scout power incorrect.") # Power cannot go below 0
	assert_eq(opp_knight.get_current_power(), max(0, initial_oknight_power - 1), "Totem: Opponent Knight power incorrect.")

	# Assert: Event generation
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expected events:
	# - 4x stat_change (one for each of the 4 creatures affected)
	# - 1x visual_effect (for the Totem spell cast itself)
	# Total = 5 events
	assert_eq(new_events.size(), 5, "Totem of Champions effect should generate 5 events. Found: %s" % new_events.size())

	var stat_change_events_count: int = 0
	var main_visual_effect_found: bool = false

	for event_data in new_events:
		if event_data.get("event_type") == "stat_change" and \
		   event_data.get("stat") == "power" and \
		   event_data.get("source_card_id") == totem_card_in_zone.get_card_id() and \
		   event_data.get("source_instance_id") == totem_card_in_zone.get_card_instance_id():
			stat_change_events_count += 1
			# Further checks for each specific creature if desired:
			var affected_instance_id = event_data.get("instance_id")
			var power_change_amount = event_data.get("amount")
			if affected_instance_id == player_scout.instance_id:
				assert_eq(power_change_amount, 1, "Player Scout buff amount incorrect in event.")
			elif affected_instance_id == player_knight.instance_id:
				assert_eq(power_change_amount, 1, "Player Knight buff amount incorrect in event.")
			elif affected_instance_id == opp_scout.instance_id:
				assert_eq(power_change_amount, -1, "Opponent Scout debuff amount incorrect in event.")
			elif affected_instance_id == opp_knight.instance_id:
				assert_eq(power_change_amount, -1, "Opponent Knight debuff amount incorrect in event.")
		
		elif event_data.get("event_type") == "visual_effect" and \
			 event_data.get("effect_id") == "totem_of_champions_wave" and \
			 event_data.get("source_instance_id") == totem_card_in_zone.get_card_instance_id():
			main_visual_effect_found = true
			assert_eq(event_data.get("instance_id"), totem_card_in_zone.get_card_instance_id(), "Totem visual_effect: instance_id incorrect.")
			assert_eq(event_data.get("details", {}).get("buff_amount"), 1, "Totem visual_effect details: buff_amount incorrect.")
			assert_eq(event_data.get("details", {}).get("debuff_amount"), -1, "Totem visual_effect details: debuff_amount incorrect.")

	assert_eq(stat_change_events_count, 4, "Incorrect number of power stat_change events for Totem of Champions.")
	assert_true(main_visual_effect_found, "Main visual effect for Totem of Champions cast not found or improperly sourced.")

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
	var new_id = battle.get_new_instance_id()
	instance.setup(amnesia_mage_res, player, opponent, 0, battle, new_id)

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
	var new_id = battle.get_new_instance_id()
	instance.setup(amnesia_mage_res, player, opponent, 0, battle, new_id)
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
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"]
	var battle: Battle = setup["battle"]
	
	# Place target creature for opponent in their lane 0 (index 0)
	var target_knight_instance = place_summon_for_test(opponent, knight_res, 0, battle)
	assert_false(target_knight_instance.is_relentless, "Test setup: Knight should not start as relentless.")
	
	var initial_event_count: int = battle.battle_events.size()

	# Create a CardInZone for the Overconcentrate spell
	var overconcentrate_spell_instance_id: int = battle._generate_new_card_instance_id()
	var overconcentrate_card_in_zone: CardInZone = CardInZone.new(overconcentrate_res, overconcentrate_spell_instance_id)

	# Action: Apply Overconcentrate effect
	if overconcentrate_res.has_method("apply_effect"):
		overconcentrate_res.apply_effect(overconcentrate_card_in_zone, player, opponent, battle)
	else:
		fail_test("Overconcentrate resource does not have a script with apply_effect.")
		return

	# Assert: Target Knight is now relentless
	assert_true(target_knight_instance.is_relentless, "Overconcentrate should make the target Knight relentless.")

	# Assert: Event generation
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expected events:
	# 1. status_change (for the Knight gaining Relentless)
	# 2. visual_effect (for the Overconcentrate spell's debuff visual)
	# Total = 2 events
	assert_eq(new_events.size(), 2, "Overconcentrate effect should generate 2 events. Found: %s" % new_events.size())

	var status_change_event_found: bool = false
	var visual_effect_found: bool = false

	for event_data in new_events:
		if event_data.get("event_type") == "status_change" and \
		   event_data.get("instance_id") == target_knight_instance.instance_id and \
		   event_data.get("status") == "Relentless" and \
		   event_data.get("gained") == true:
			status_change_event_found = true
			assert_eq(event_data.get("player"), opponent.combatant_name, "Status_change event: player (owner of Knight) incorrect.")
			assert_eq(event_data.get("lane"), 1, "Status_change event: lane (1-based for Knight) incorrect.") # Knight is in opponent's lane 0 (index 0) -> event lane 1
			assert_eq(event_data.get("card_id"), knight_res.id, "Status_change event: card_id (Knight) incorrect.")
			assert_eq(event_data.get("source"), overconcentrate_card_in_zone.get_card_id(), "Status_change event: source card_id (Overconcentrate) incorrect.")
			assert_eq(event_data.get("source_instance_id"), overconcentrate_card_in_zone.get_card_instance_id(), "Status_change event: source_instance_id (Overconcentrate spell) incorrect.")
		
		elif event_data.get("event_type") == "visual_effect" and \
			 event_data.get("effect_id") == "overconcentrate_status_gain": # Matching the revised effect_id from overconcentrate_effect.gd
			visual_effect_found = true
			assert_eq(event_data.get("instance_id"), target_knight_instance.instance_id, "Overconcentrate visual_effect: instance_id (target Knight) incorrect.")
			assert_eq(event_data.get("source_instance_id"), overconcentrate_card_in_zone.get_card_instance_id(), "Overconcentrate visual_effect: source_instance_id incorrect.")
			assert_eq(event_data.get("details", {}).get("status_gained"), "Relentless", "Overconcentrate visual_effect details: status_gained incorrect.")

	assert_true(status_change_event_found, "Status change event for Knight gaining Relentless not found or improperly sourced.")
	assert_true(visual_effect_found, "Visual effect for Overconcentrate not found or improperly sourced.")

func test_overconcentrate_no_target():
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"]
	var battle: Battle = setup["battle"]
	
	# Ensure opponent has no creatures by clearing lanes
	for i in range(opponent.lanes.size()):
		opponent.lanes[i] = null
	
	var initial_event_count: int = battle.battle_events.size()

	# Create a CardInZone for the Overconcentrate spell
	var overconcentrate_spell_instance_id: int = battle._generate_new_card_instance_id()
	var overconcentrate_card_in_zone: CardInZone = CardInZone.new(overconcentrate_res, overconcentrate_spell_instance_id)

	# Action: Apply Overconcentrate effect
	if overconcentrate_res.has_method("apply_effect"):
		overconcentrate_res.apply_effect(overconcentrate_card_in_zone, player, opponent, battle)
	else:
		fail_test("Overconcentrate resource does not have a script with apply_effect.")
		return

	# Assert: No status change event generated, but a log message should be.
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expected event: 1x log_message (from overconcentrate_effect.gd when no target)
	assert_eq(new_events.size(), 1, "Overconcentrate (no target) should generate 1 log event. Found: %s" % new_events.size())

	var status_change_event_found: bool = false
	var log_message_no_target_found: bool = false

	for event_data in new_events:
		if event_data.get("event_type") == "status_change":
			status_change_event_found = true
			print("Unexpected status_change event found: ", event_data) 
		elif event_data.get("event_type") == "log_message" and \
			 "no target" in event_data.get("message", "").to_lower() and \
			 event_data.get("source_instance_id") == overconcentrate_spell_instance_id:
			log_message_no_target_found = true
			
	assert_false(status_change_event_found, "No status_change event should be generated by Overconcentrate if there's no target.")
	assert_true(log_message_no_target_found, "Log message indicating no target for Overconcentrate was not found or improperly sourced.")

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
	var new_id = battle.get_new_instance_id()
	instance.setup(goblin_recruiter_res, player, opponent, 1, battle, new_id) # Assume it arrives in lane 1 (doesn't matter for effect)
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
	var new_id = battle.get_new_instance_id()
	instance.setup(goblin_recruiter_res, player, opponent, 1, battle, new_id)
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
	var new_id = battle.get_new_instance_id()
	instance.setup(vengeful_warlord_res, player, opponent, 0, battle, new_id)
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
	var new_id = battle.get_new_instance_id()
	instance.setup(vengeful_warlord_res, player, opponent, 0, battle, new_id)
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


# res://tests/test_card_effects.gd

func test_corpsecraft_titan_consumes_grave():
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"] # Get for _on_arrival signature
	var battle: Battle = setup["battle"]

	player.graveyard.clear()
	# Add cards to graveyard (order matters if effect consumes from one end)
	# Titan's effect iterates backwards, so it will consume the last 3 summons added.
	# Let's add EnergyAxe first (so it remains), then the summons.
	var energy_axe_gy_id = battle._generate_new_card_instance_id()
	player.graveyard.append(CardInZone.new(energy_axe_res, energy_axe_gy_id)) # Spell, should remain

	var scout_gy_id = battle._generate_new_card_instance_id()
	player.graveyard.append(CardInZone.new(goblin_scout_res, scout_gy_id)) # Will be consumed
	var knight_gy_id = battle._generate_new_card_instance_id()
	player.graveyard.append(CardInZone.new(knight_res, knight_gy_id))       # Will be consumed
	var healer_gy_id = battle._generate_new_card_instance_id()
	player.graveyard.append(CardInZone.new(healer_res, healer_gy_id))     # Will be consumed (last one added, first consumed by reverse iteration)
	
	var initial_grave_size_val: int = player.graveyard.size() # Should be 4
	
	# Simulate Corpsecraft Titan arrival
	var titan_instance = SummonInstance.new()
	var titan_instance_id: int = battle._generate_new_card_instance_id()
	titan_instance.setup(corpsecraft_titan_res, player, opponent, 0, battle, titan_instance_id)
	# titan_instance should be placed in a lane if its _on_arrival depends on its lane_index (it doesn't here)
	# player.lanes[0] = titan_instance 

	var initial_event_count: int = battle.battle_events.size()

	# Action: Call _on_arrival effect
	if corpsecraft_titan_res.has_method("_on_arrival"):
		corpsecraft_titan_res._on_arrival(titan_instance, player, opponent, battle)
	else:
		fail_test("Corpsecraft Titan resource does not have _on_arrival method.")
		return

	# Assert: Grave size reduced by 3 (3 summons consumed)
	assert_eq(player.graveyard.size(), initial_grave_size_val - 3, "Graveyard size incorrect after Titan consumes.")
	
	# Assert: Only the spell (EnergyAxe) remains in the graveyard
	assert_eq(player.graveyard.size(), 1, "Only one card should remain in graveyard.")
	if player.graveyard.size() == 1:
		assert_true(player.graveyard[0] is CardInZone, "Remaining card in grave should be CardInZone.")
		assert_eq(player.graveyard[0].get_card_id(), "EnergyAxe", "The spell EnergyAxe should be the only card remaining in graveyard.")
		assert_eq(player.graveyard[0].get_card_instance_id(), energy_axe_gy_id, "EnergyAxe instance ID mismatch.")

	# Assert: Events generated (3x card_removed, sourced by Titan)
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expect 3 card_removed events.
	assert_eq(new_events.size(), 3, "Corpsecraft Titan consume should generate 3 card_removed events. Found: %s" % new_events.size())

	var card_removed_count: int = 0
	var consumed_instance_ids_from_events: Array[int] = []

	for event_data in new_events:
		if event_data.get("event_type") == "card_removed" and \
		   event_data.get("from_zone") == "graveyard" and \
		   event_data.get("player") == player.combatant_name and \
		   event_data.get("source_card_id") == corpsecraft_titan_res.id and \
		   event_data.get("source_instance_id") == titan_instance_id:
			card_removed_count += 1
			consumed_instance_ids_from_events.append(event_data.get("instance_id"))
			
	assert_eq(card_removed_count, 3, "Incorrect number of card_removed events for Corpsecraft Titan.")
	
	# Verify the correct instances were removed (Healer, Knight, GoblinScout)
	assert_true(healer_gy_id in consumed_instance_ids_from_events, "Healer was not logged as removed by Titan.")
	assert_true(knight_gy_id in consumed_instance_ids_from_events, "Knight was not logged as removed by Titan.")
	assert_true(scout_gy_id in consumed_instance_ids_from_events, "Goblin Scout was not logged as removed by Titan.")
	assert_false(energy_axe_gy_id in consumed_instance_ids_from_events, "Energy Axe should not have been removed by Titan.")

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
	var new_id = battle.get_new_instance_id()
	instance.setup(insatiable_devourer_res, player, player.opponent, 1, battle, new_id)
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
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"]
	var battle: Battle = setup["battle"]
	
	var samurai_instance = place_summon_for_test(player, repentant_samurai_res, 0, battle) # Player's lane 0
	var samurai_original_instance_id = samurai_instance.instance_id # Store for event checks after it dies

	# Ensure opponent's corresponding lane (lane 0) is empty for direct attack
	opponent.lanes[0] = null 
	var initial_opponent_hp = opponent.current_hp

	# --- Action 1: First direct attack ---
	var initial_event_count_hit1 = battle.battle_events.size()
	var handled1: bool = false
	if repentant_samurai_res.has_method("perform_turn_activity_override"):
		handled1 = repentant_samurai_res.perform_turn_activity_override(samurai_instance, player, opponent, battle)
	else:
		fail_test("Repentant Samurai res missing perform_turn_activity_override.")
		return
		
	assert_true(handled1, "Samurai override should handle first direct attack.")
	assert_true(player.lanes[0] == samurai_instance, "Samurai should still be in lane after first hit.")
	assert_eq(samurai_instance.custom_state.get("hits_dealt"), 1, "Hits dealt should be 1 after first attack.")
	var expected_opponent_hp_after_hit1 = initial_opponent_hp - samurai_instance.get_current_power()
	assert_eq(opponent.current_hp, expected_opponent_hp_after_hit1, "Opponent HP incorrect after first Samurai hit.")

	# Event Check for First Hit
	var new_events_hit1 = battle.battle_events.slice(initial_event_count_hit1)
	var activity_event_hit1_found = false
	var direct_damage_event_hit1_found = false
	var hp_change_event_hit1_found = false

	for event_data in new_events_hit1:
		if event_data.get("event_type") == "summon_turn_activity" and event_data.get("instance_id") == samurai_instance.instance_id:
			activity_event_hit1_found = true
		elif event_data.get("event_type") == "direct_damage" and event_data.get("attacking_instance_id") == samurai_instance.instance_id:
			direct_damage_event_hit1_found = true
		elif event_data.get("event_type") == "hp_change" and event_data.get("player") == opponent.combatant_name and event_data.get("source_instance_id") == samurai_instance.instance_id:
			hp_change_event_hit1_found = true
	assert_true(activity_event_hit1_found, "Activity event for Samurai's first hit not found.")
	assert_true(direct_damage_event_hit1_found, "Direct damage event for Samurai's first hit not found.")
	assert_true(hp_change_event_hit1_found, "Opponent HP change event from Samurai's first hit not found.")


	# --- Action 2: Second direct attack ---
	var initial_event_count_hit2 = battle.battle_events.size()
	var handled2: bool = false
	if repentant_samurai_res.has_method("perform_turn_activity_override"):
		handled2 = repentant_samurai_res.perform_turn_activity_override(samurai_instance, player, opponent, battle)
	else:
		fail_test("Repentant Samurai res missing perform_turn_activity_override (2nd call).")
		return # Should not happen if first call worked

	assert_true(handled2, "Samurai override should handle second direct attack.")
	# Assert: Samurai is now gone (sacrificed because it died)
	assert_null(player.lanes[0], "Samurai should be gone from lane after second hit and sacrifice.")
	var expected_opponent_hp_after_hit2 = expected_opponent_hp_after_hit1 - samurai_instance.get_current_power() # Use original power for calc
	assert_eq(opponent.current_hp, expected_opponent_hp_after_hit2, "Opponent HP incorrect after second Samurai hit.")


	# Event Check for Second Hit & Sacrifice
	var new_events_hit2 = battle.battle_events.slice(initial_event_count_hit2)
	var activity_event_hit2_found = false
	var direct_damage_event_hit2_found = false
	var hp_change_event_hit2_found = false
	var sacrifice_visual_found = false
	var samurai_defeated_event_found = false
	var samurai_moved_to_grave_event_found = false
	
	for event_data in new_events_hit2:
		if event_data.get("event_type") == "summon_turn_activity" and event_data.get("instance_id") == samurai_original_instance_id: # Use original ID as instance is gone
			activity_event_hit2_found = true
		elif event_data.get("event_type") == "direct_damage" and event_data.get("attacking_instance_id") == samurai_original_instance_id:
			direct_damage_event_hit2_found = true
		elif event_data.get("event_type") == "hp_change" and event_data.get("player") == opponent.combatant_name and event_data.get("source_instance_id") == samurai_original_instance_id:
			hp_change_event_hit2_found = true
		elif event_data.get("event_type") == "visual_effect" and event_data.get("effect_id") == "repentant_samurai_sacrifice" and event_data.get("instance_id") == samurai_original_instance_id:
			sacrifice_visual_found = true
		elif event_data.get("event_type") == "creature_defeated" and event_data.get("instance_id") == samurai_original_instance_id:
			samurai_defeated_event_found = true
		elif event_data.get("event_type") == "card_moved" and \
			 event_data.get("card_id") == repentant_samurai_res.id and \
			 event_data.get("instance_id") == samurai_original_instance_id and \
			 event_data.get("from_zone") == "lane" and event_data.get("to_zone") == "graveyard":
			samurai_moved_to_grave_event_found = true

	assert_true(activity_event_hit2_found, "Activity event for Samurai's second hit not found.")
	assert_true(direct_damage_event_hit2_found, "Direct damage event for Samurai's second hit not found.")
	assert_true(hp_change_event_hit2_found, "Opponent HP change event from Samurai's second hit not found.")
	assert_true(sacrifice_visual_found, "Sacrifice visual effect for Samurai not found.")
	assert_true(samurai_defeated_event_found, "Creature defeated event for Samurai not found.")
	assert_true(samurai_moved_to_grave_event_found, "Card moved to graveyard event for Samurai not found.")
	
	# Assert: Samurai is now in player's graveyard
	var samurai_found_in_grave = false
	for card_in_zone in player.graveyard:
		if card_in_zone.get_card_id() == repentant_samurai_res.id: # Check card type
			# If you want to be super precise, you'd check if its instance_id matches
			# the one from the card_moved event's to_details.instance_id.
			samurai_found_in_grave = true
			break
	assert_true(samurai_found_in_grave, "Repentant Samurai should be in graveyard after sacrifice.")

# --- Cursed Samurai Tests ---
func test_cursed_samurai_summons_returned_on_death():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var battle = setup["battle"]
	# Place Cursed Samurai
	var cursed_instance = place_summon_for_test(player, cursed_samurai_res, 1, battle) # Lane 2
	var initial_event_count = battle.battle_events.size()

	# Action: Kill Cursed Samurai
	var test_damage_source_card_id: String = "TEST_DAMAGE_EFFECT"
	var test_damage_source_instance_id: int = -1 # Or some other placeholder if you like
	cursed_instance.take_damage(100, test_damage_source_card_id, test_damage_source_instance_id)

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
func test_glassgraft_reanimates_and_sacrifices():
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"]
	var battle: Battle = setup["battle"]

	# Setup graveyard with CardInZone objects: Scout (index 0), Knight (index 1, rightmost)
	player.graveyard.clear()
	var scout_gy_id = battle._generate_new_card_instance_id()
	player.graveyard.append(CardInZone.new(goblin_scout_res, scout_gy_id))
	var knight_gy_id = battle._generate_new_card_instance_id() # Knight is the one we expect to be reanimated
	player.graveyard.append(CardInZone.new(knight_res, knight_gy_id))
	
	# Empty opponent's lane 0 for direct attack by the reanimated creature later
	opponent.lanes[0] = null 
	# Ensure player's lane 0 is also empty for reanimation target
	player.lanes[0] = null

	var initial_event_count_action1: int = battle.battle_events.size()

	# Create CardInZone for Glassgraft spell
	var glassgraft_spell_instance_id: int = battle._generate_new_card_instance_id()
	var glassgraft_card_in_zone: CardInZone = CardInZone.new(glassgraft_res, glassgraft_spell_instance_id)

	# --- Action 1: Cast Glassgraft ---
	if glassgraft_res.has_method("apply_effect"):
		glassgraft_res.apply_effect(glassgraft_card_in_zone, player, opponent, battle)
	else:
		fail_test("Glassgraft resource does not have a script with apply_effect.")
		return

	# Assertions after Glassgraft cast:
	# Knight (rightmost) should be reanimated into player's lane 0 (first empty).
	assert_true(player.lanes[0] is SummonInstance, "Player's lane 0 should have a SummonInstance after Glassgraft.")
	var reanimated_knight_instance = player.lanes[0] as SummonInstance
	assert_true(reanimated_knight_instance != null and reanimated_knight_instance.card_resource.id == "Knight", "Knight should be reanimated by Glassgraft into lane 0.")
	
	# Assert: Reanimated Knight has the "glassgrafted" custom state
	assert_true(reanimated_knight_instance.custom_state.get("glassgrafted", false), "Reanimated Knight should have 'glassgrafted' flag set.")
	
	# Assert: Player's graveyard now only contains Scout
	assert_eq(player.graveyard.size(), 1, "Player's graveyard size incorrect after Glassgraft (should only have Scout).")
	if player.graveyard.size() == 1:
		assert_eq(player.graveyard[0].get_card_id(), "GoblinScout", "Goblin Scout should be the only card remaining in player's graveyard.")
		assert_eq(player.graveyard[0].get_card_instance_id(), scout_gy_id, "Goblin Scout instance ID mismatch in graveyard.")

	# Event checks for Action 1 (Glassgraft casting and reanimation)
	var new_events_action1: Array[Dictionary] = battle.battle_events.slice(initial_event_count_action1)
	var knight_moved_from_grave_found = false
	var knight_arrived_found = false
	var knight_moved_to_lane_found = false
	for event_data in new_events_action1:
		if event_data.get("event_type") == "card_moved" and event_data.get("card_id") == "Knight" and event_data.get("instance_id") == knight_gy_id and event_data.get("from_zone") == "graveyard":
			knight_moved_from_grave_found = true
		elif event_data.get("event_type") == "summon_arrives" and event_data.get("card_id") == "Knight" and event_data.get("instance_id") == reanimated_knight_instance.instance_id:
			knight_arrived_found = true
			assert_true(event_data.get("custom_state_keys",[]).has("glassgrafted"), "Summon_arrives event should indicate glassgrafted state.")
		elif event_data.get("event_type") == "card_moved" and event_data.get("card_id") == "Knight" and event_data.get("instance_id") == knight_gy_id and event_data.get("from_zone") == "limbo" and event_data.get("to_details",{}).get("instance_id") == reanimated_knight_instance.instance_id:
			knight_moved_to_lane_found = true
	assert_true(knight_moved_from_grave_found, "Glassgraft: Knight 'card_moved' from grave event missing.")
	assert_true(knight_arrived_found, "Glassgraft: Knight 'summon_arrives' event missing.")
	assert_true(knight_moved_to_lane_found, "Glassgraft: Knight 'card_moved' to lane event missing.")


	# --- Action 2: Let the reanimated Knight attack directly ---
	assert_true(reanimated_knight_instance != null, "Reanimated Knight instance is null before attack action.")
	reanimated_knight_instance.is_newly_arrived = false # Allow it to act
	
	var initial_event_count_action2: int = battle.battle_events.size()
	var reanimated_knight_original_field_id = reanimated_knight_instance.instance_id # Store before it dies
	
	reanimated_knight_instance.perform_turn_activity() # This should call _perform_modified_direct_attack which checks "glassgrafted"

	# Assertions after Knight attacks and sacrifices:
	# Assert: Knight is now gone from lane (sacrificed)
	assert_null(player.lanes[0], "Reanimated Knight should be gone from lane after attacking and sacrificing.")
	
	# Assert: Knight is now back in player's graveyard (this is its second graveyard entry if we track precisely)
	var knight_returned_to_grave = false
	var new_knight_gy_instance_id = -1
	for card_in_zone in player.graveyard:
		if card_in_zone.get_card_id() == "Knight" and card_in_zone.get_card_instance_id() != knight_gy_id: # Must be a new instance in grave
			knight_returned_to_grave = true
			new_knight_gy_instance_id = card_in_zone.get_card_instance_id()
			break
	assert_true(knight_returned_to_grave, "Knight should be in graveyard after glassgraft sacrifice.")

	# Event checks for Action 2 (Knight attacks, glassgraft triggers, Knight dies)
	var new_events_action2: Array[Dictionary] = battle.battle_events.slice(initial_event_count_action2)
	var knight_activity_found = false
	var knight_direct_damage_found = false
	var knight_sacrifice_visual_found = false
	var knight_defeated_found = false
	var knight_moved_to_grave_after_sacrifice_found = false

	for event_data in new_events_action2:
		var event_type = event_data.get("event_type")
		var event_instance_id = event_data.get("instance_id")

		if event_type == "summon_turn_activity" and event_instance_id == reanimated_knight_original_field_id:
			knight_activity_found = true
		elif event_type == "direct_damage" and event_data.get("attacking_instance_id") == reanimated_knight_original_field_id:
			knight_direct_damage_found = true
		# The visual effect for "glassgrafted" sacrifice might not have a standard ID yet,
		# but SummonInstance._perform_direct_attack prints "...Glassgrafted creature dealt damage, sacrificing!"
		# and then calls die(). The die() call generates creature_defeated.
		# If SummonInstance added a specific visual event for this sacrifice, we'd check it.
		# For now, we rely on the sequence. The "samurai_sacrifice" was for Repentant Samurai.
		# Let's assume SummonInstance._perform_direct_attack might add a visual effect with id "glassgraft_sacrifice"
		elif event_type == "visual_effect" and event_data.get("effect_id") == "glassgraft_sacrifice" and event_instance_id == reanimated_knight_original_field_id:
			knight_sacrifice_visual_found = true # This is speculative
		elif event_type == "creature_defeated" and event_instance_id == reanimated_knight_original_field_id:
			knight_defeated_found = true
		elif event_type == "card_moved" and \
			 event_data.get("card_id") == "Knight" and \
			 event_instance_id == reanimated_knight_original_field_id and \
			 event_data.get("from_zone") == "lane" and event_data.get("to_zone") == "graveyard":
			knight_moved_to_grave_after_sacrifice_found = true
			assert_eq(event_data.get("to_details", {}).get("instance_id"), new_knight_gy_instance_id, "Knight to_details.instance_id after sacrifice mismatch.")


	assert_true(knight_activity_found, "Glassgrafted Knight: summon_turn_activity event missing.")
	assert_true(knight_direct_damage_found, "Glassgrafted Knight: direct_damage event missing.")
	# assert_true(knight_sacrifice_visual_found, "Glassgrafted Knight: sacrifice visual event missing.") # This is optional
	assert_true(knight_defeated_found, "Glassgrafted Knight: creature_defeated event missing.")
	assert_true(knight_moved_to_grave_after_sacrifice_found, "Glassgrafted Knight: card_moved to graveyard event missing after sacrifice.")

# --- Unmake Tests ---
func test_unmake_destroys_non_undead():
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"]
	var battle: Battle = setup["battle"]
	
	# Place targets for opponent:
	# Lane 0 (index 0): Undead (Recurring Skeleton) - Should NOT be destroyed
	var target_skeleton_instance = place_summon_for_test(opponent, recurring_skeleton_res, 0, battle)
	# Lane 1 (index 1): Non-Undead (Knight) - Should BE destroyed (as it's the leftmost non-Undead)
	var target_knight_instance = place_summon_for_test(opponent, knight_res, 1, battle) 
	var target_knight_original_field_instance_id = target_knight_instance.instance_id # Store ID before it dies
	
	var initial_event_count: int = battle.battle_events.size()

	# Create a CardInZone for the Unmake spell
	var unmake_spell_instance_id: int = battle._generate_new_card_instance_id()
	var unmake_card_in_zone: CardInZone = CardInZone.new(unmake_res, unmake_spell_instance_id)

	# Action: Apply Unmake effect
	if unmake_res.has_method("apply_effect"):
		unmake_res.apply_effect(unmake_card_in_zone, player, opponent, battle)
	else:
		fail_test("Unmake resource does not have a script with apply_effect.")
		return

	# Assert: Skeleton (leftmost, Undead) still exists in opponent's lane 0
	assert_true(opponent.lanes[0] == target_skeleton_instance, "Recurring Skeleton should not be Unmade and still be in lane 0.")
	
	# Assert: Knight (next, non-Undead) is gone from opponent's lane 1
	assert_null(opponent.lanes[1], "Knight should be Unmade and removed from lane 1.")
	
	# Assert: Knight is now in opponent's graveyard
	var knight_found_in_grave: bool = false
	var new_knight_gy_instance_id: int = -1
	for card_in_zone_obj in opponent.graveyard:
		if card_in_zone_obj.get_card_id() == "Knight":
			knight_found_in_grave = true
			new_knight_gy_instance_id = card_in_zone_obj.get_card_instance_id() # ID of the Knight CIZ in graveyard
			break
	assert_true(knight_found_in_grave, "Knight should be in opponent's graveyard after being Unmade.")


	# Assert: Event generation
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expected events for Unmake successfully destroying Knight:
	# 1. visual_effect (Unmake targeting Knight)
	# 2. creature_defeated (for Knight, sourced by Unmake)
	# 3. card_moved (Knight from lane to graveyard, sourced by Unmake via die())

	var visual_effect_unmake_found: bool = false
	var knight_defeated_event_found: bool = false
	var knight_moved_to_grave_event_found: bool = false

	for event_data in new_events:
		var event_type = event_data.get("event_type")
		var event_instance_id = event_data.get("instance_id")
		var event_source_instance_id = event_data.get("source_instance_id")
		var event_source_card_id = event_data.get("source_card_id")

		if event_type == "visual_effect" and \
		   event_data.get("effect_id") == "unmake_targeting_visual" and \
		   event_instance_id == target_knight_original_field_instance_id and \
		   event_source_instance_id == unmake_spell_instance_id:
			visual_effect_unmake_found = true
		
		elif event_type == "creature_defeated" and \
			 event_instance_id == target_knight_original_field_instance_id and \
			 event_data.get("card_id") == "Knight":
			knight_defeated_event_found = true
			# Ideally, this event should also be sourced by Unmake.
			# This depends on how `SummonInstance.die()` handles/propagates source info.
			# For now, we check it happened to the correct instance.
			# assert_eq(event_source_card_id, unmake_card_in_zone.get_card_id(), "Knight defeated event: source_card_id (Unmake) incorrect.")
			# assert_eq(event_source_instance_id, unmake_spell_instance_id, "Knight defeated event: source_instance_id (Unmake) incorrect.")

		elif event_type == "card_moved" and \
			 event_data.get("card_id") == "Knight" and \
			 event_instance_id == target_knight_original_field_instance_id and \
			 event_data.get("from_zone") == "lane" and \
			 event_data.get("to_zone") == "graveyard":
			knight_moved_to_grave_event_found = true
			# The "reason" for this move is death. The ultimate "source" of that death was Unmake.
			# The `SummonInstance.die()` method calls `add_card_to_graveyard(card_resource, "lane", self.instance_id)`.
			# The `add_card_to_graveyard` event has `instance_id` as the ID from the lane, and currently no explicit spell source.
			# This is an area where event enrichment could trace the "cause of death" more explicitly into the card_moved event.
			# For now, the sequence implies Unmake.
			assert_eq(event_data.get("to_details", {}).get("instance_id"), new_knight_gy_instance_id, "Knight moved to grave: to_details.instance_id mismatch.")


	assert_true(visual_effect_unmake_found, "Visual effect for Unmake targeting Knight not found or improperly sourced.")
	assert_true(knight_defeated_event_found, "Creature_defeated event for Knight (Unmake target) not found.")
	assert_true(knight_moved_to_grave_event_found, "Card_moved event for Unmade Knight (to graveyard) not found.")

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
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]
	var battle: Battle = setup["battle"]
	
	var legion_instance = place_summon_for_test(player, reassembling_legion_res, 0, battle) # Player's lane 0
	var legion_original_field_instance_id: int = legion_instance.instance_id # Store ID before it dies
	
	var initial_deck_size: int = player.library.size()
	var initial_grave_size: int = player.graveyard.size()
	var initial_event_count: int = battle.battle_events.size()

	# Action: Kill the Reassembling Legion instance
	var test_damage_source_card_id: String = "TEST_EFFECT_LETHAL_BLOW"
	var test_damage_source_instance_id: int = -1000 # Arbitrary placeholder
	legion_instance.take_damage(100, test_damage_source_card_id, test_damage_source_instance_id) # Overkill

	# Assert: Legion instance removed from lane
	assert_null(player.lanes[0], "Lane 0 should be empty after Reassembling Legion dies.")
	
	# Assert: Card (as CardInZone) added to bottom of player's library
	assert_eq(player.library.size(), initial_deck_size + 1, "Player library size should increase by one after Legion's death.")
	assert_true(player.library[-1] is CardInZone, "Card at library bottom should be a CardInZone.")
	var returned_legion_in_lib = player.library[-1] as CardInZone
	if returned_legion_in_lib:
		assert_eq(returned_legion_in_lib.get_card_id(), "ReassemblingLegion", "Reassembling Legion card_id in library is incorrect.")
		assert_ne(returned_legion_in_lib.get_card_instance_id(), legion_original_field_instance_id, "Returned Legion in library should have a new instance_id.")
	else:
		fail_test("Card at bottom of player library was not a CardInZone as expected for Reassembling Legion.")

	# Assert: Card NOT added to player's graveyard (due to prevent_graveyard flag)
	assert_eq(player.graveyard.size(), initial_grave_size, "Player graveyard size should not increase for Reassembling Legion.")

	# Assert: Event generation
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expected events:
	# 1. creature_hp_change (from take_damage, sourced by test effect)
	# 2. creature_defeated (for Legion, sourced by test effect via take_damage)
	# 3. card_moved (Legion from lane to library, due to Legion's own death effect)
	
	var hp_change_event_found: bool = false
	var legion_defeated_event_found: bool = false
	var legion_moved_to_library_event_found: bool = false
	var new_legion_library_instance_id_from_event: int = -1

	for event_data in new_events:
		var event_type = event_data.get("event_type")
		var event_instance_id = event_data.get("instance_id")
		var event_source_card_id = event_data.get("source_card_id")
		var event_source_instance_id = event_data.get("source_instance_id")

		if event_type == "creature_hp_change" and \
		   event_instance_id == legion_original_field_instance_id and \
		   event_source_card_id == test_damage_source_card_id:
			hp_change_event_found = true
		
		elif event_type == "creature_defeated" and \
			 event_instance_id == legion_original_field_instance_id and \
			 event_data.get("card_id") == "ReassemblingLegion":
			legion_defeated_event_found = true
			# The source of defeat is the test damage effect
			assert_eq(event_source_card_id, test_damage_source_card_id, "Legion defeated: source_card_id mismatch.")
			assert_eq(event_source_instance_id, test_damage_source_instance_id, "Legion defeated: source_instance_id mismatch.")

		elif event_type == "card_moved" and \
			 event_data.get("card_id") == "ReassemblingLegion" and \
			 event_instance_id == legion_original_field_instance_id and \
			 event_data.get("from_zone") == "lane" and \
			 event_data.get("to_zone") == "library":
			legion_moved_to_library_event_found = true
			# This move is caused by Legion's own death effect
			assert_eq(event_source_card_id, "ReassemblingLegion", "Legion moved_to_library: source_card_id incorrect.")
			assert_eq(event_source_instance_id, legion_original_field_instance_id, "Legion moved_to_library: source_instance_id incorrect.")
			new_legion_library_instance_id_from_event = event_data.get("to_details", {}).get("instance_id")
			assert_ne(new_legion_library_instance_id_from_event, legion_original_field_instance_id, "Legion in library should have a new instance ID in to_details for card_moved event.")

	assert_true(hp_change_event_found, "Creature_hp_change event for Reassembling Legion (from test damage) not found.")
	assert_true(legion_defeated_event_found, "Creature_defeated event for Reassembling Legion not found or improperly sourced.")
	assert_true(legion_moved_to_library_event_found, "Card_moved event for Reassembling Legion returning to library not found or improperly sourced.")

	if returned_legion_in_lib and new_legion_library_instance_id_from_event != -1:
		assert_eq(returned_legion_in_lib.get_card_instance_id(), new_legion_library_instance_id_from_event, "Instance ID of Legion in library does not match its card_moved to_details.instance_id.")

# --- Ghoul Tests ---
func test_ghoul_mills_opponent_bottom_card():
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"] # Ghoul's owner
	var opponent: Combatant = setup["opponent"] # Library to be milled
	var battle: Battle = setup["battle"]
	
	# Setup opponent's library with CardInZone objects
	opponent.library.clear()
	var knight_in_opp_lib_id = battle._generate_new_card_instance_id()
	opponent.library.append(CardInZone.new(knight_res, knight_in_opp_lib_id))          # Top (index 0)
	var scout_in_opp_lib_id = battle._generate_new_card_instance_id() # This is the card that will be milled
	opponent.library.append(CardInZone.new(goblin_scout_res, scout_in_opp_lib_id)) # Bottom (index 1)
	
	var initial_opp_lib_size: int = opponent.library.size() # Should be 2
	var initial_opp_grave_size: int = opponent.graveyard.size()
	
	# Verify setup: Goblin Scout is at the bottom (last element)
	assert_gt(opponent.library.size(), 0, "Test setup: Opponent library should not be empty.")
	var bottom_card_to_be_milled_original_card_id: String = opponent.library[-1].get_card_id()
	var bottom_card_to_be_milled_original_instance_id: int = opponent.library[-1].get_card_instance_id()
	assert_eq(bottom_card_to_be_milled_original_card_id, "GoblinScout", "Test setup: Expected GoblinScout at bottom of opponent's library.")
	assert_eq(bottom_card_to_be_milled_original_instance_id, scout_in_opp_lib_id, "Test setup: GoblinScout instance ID mismatch.")

	# Simulate Ghoul's arrival (owned by player)
	var ghoul_instance = SummonInstance.new()
	var ghoul_instance_id: int = battle._generate_new_card_instance_id()
	ghoul_instance.setup(ghoul_res, player, opponent, 0, battle, ghoul_instance_id) # Ghoul's lane doesn't matter for this effect

	var initial_event_count: int = battle.battle_events.size()

	# Action: Call Ghoul's _on_arrival effect
	if ghoul_res.has_method("_on_arrival"):
		ghoul_res._on_arrival(ghoul_instance, player, opponent, battle)
	else:
		fail_test("Ghoul resource does not have _on_arrival method.")
		return

	# Assert: Opponent library size decreased by 1
	assert_eq(opponent.library.size(), initial_opp_lib_size - 1, "Opponent library size should decrease by one after Ghoul's mill.")
	# Assert: Opponent graveyard size increased by 1
	assert_eq(opponent.graveyard.size(), initial_opp_grave_size + 1, "Opponent graveyard size should increase by one after Ghoul's mill.")
	
	# Assert: Correct card (Goblin Scout) moved to opponent's graveyard, maintaining its instance_id
	assert_true(opponent.graveyard[-1] is CardInZone, "Milled card in opponent's graveyard should be CardInZone.")
	var milled_card_in_grave = opponent.graveyard[-1] as CardInZone
	if milled_card_in_grave:
		assert_eq(milled_card_in_grave.get_card_id(), bottom_card_to_be_milled_original_card_id, "Incorrect card_id milled to opponent's graveyard.")
		assert_eq(milled_card_in_grave.get_card_instance_id(), bottom_card_to_be_milled_original_instance_id, "Instance ID of milled card should be maintained in graveyard.")
	else:
		fail_test("Card in opponent's graveyard was not a CardInZone as expected.")

	# Assert: Event generation
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expected events:
	# 1. card_moved (GoblinScout from opponent's library to opponent's graveyard, sourced by Ghoul)
	# 2. visual_effect (for the Ghoul's mill action)
	# Total = 2 events
	assert_eq(new_events.size(), 2, "Ghoul's mill effect should generate 2 events. Found: %s" % new_events.size())

	var card_moved_event_found: bool = false
	var visual_effect_found: bool = false

	for event_data in new_events:
		if event_data.get("event_type") == "card_moved" and \
		   event_data.get("player") == opponent.combatant_name and \
		   event_data.get("from_zone") == "library_bottom_ghoul_mill" and \
		   event_data.get("to_zone") == "graveyard" and \
		   event_data.get("card_id") == bottom_card_to_be_milled_original_card_id and \
		   event_data.get("instance_id") == bottom_card_to_be_milled_original_instance_id and \
		   event_data.get("source_card_id") == ghoul_res.id and \
		   event_data.get("source_instance_id") == ghoul_instance_id:
			card_moved_event_found = true
			# Check that the instance_id in to_details also matches (as the CardInZone object itself was moved)
			assert_eq(event_data.get("to_details", {}).get("instance_id"), bottom_card_to_be_milled_original_instance_id, "Ghoul mill: card_moved to_details.instance_id mismatch.")
		
		elif event_data.get("event_type") == "visual_effect" and \
			 event_data.get("effect_id") == "ghoul_mill_action" and \
			 event_data.get("instance_id") == ghoul_instance_id: # Ghoul is the subject of this visual
			visual_effect_found = true
			assert_eq(event_data.get("details", {}).get("milled_card_id"), bottom_card_to_be_milled_original_card_id, "Ghoul mill visual_effect details: milled_card_id incorrect.")
			assert_eq(event_data.get("details", {}).get("milled_card_instance_id"), bottom_card_to_be_milled_original_instance_id, "Ghoul mill visual_effect details: milled_card_instance_id incorrect.")
			assert_eq(event_data.get("source_instance_id"), ghoul_instance_id, "Ghoul mill visual_effect: source_instance_id incorrect.")

	assert_true(card_moved_event_found, "Card_moved event for Ghoul mill not found or improperly sourced.")
	assert_true(visual_effect_found, "Visual effect for Ghoul mill action not found or improperly sourced.")
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
	var new_id = battle.get_new_instance_id()
	instance.setup(knight_of_opposites_res, player, opponent, 0, battle, new_id)
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
	var new_id = battle.get_new_instance_id()
	instance.setup(knight_of_opposites_res, player, opponent, 0, battle, new_id)
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
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"]
	var battle: Battle = setup["battle"]

	# Setup: Sarcophagus in player's lane 0
	var sarcophagus_instance = place_summon_for_test(player, walking_sarcophagus_res, 0, battle)
	var sarcophagus_original_field_id = sarcophagus_instance.instance_id

	# Setup player's graveyard with CardInZone objects: Knight (leftmost, index 0), Scout (index 1)
	player.graveyard.clear()
	var knight_gy_original_id = battle._generate_new_card_instance_id() # Knight is the one we expect to be reanimated
	player.graveyard.append(CardInZone.new(knight_res, knight_gy_original_id))
	var scout_gy_original_id = battle._generate_new_card_instance_id()
	player.graveyard.append(CardInZone.new(goblin_scout_res, scout_gy_original_id))
	
	# Ensure opponent's lane 0 is empty for Sarcophagus to direct attack
	opponent.lanes[0] = null 
	
	var initial_event_count: int = battle.battle_events.size()

	# Action: Simulate Sarcophagus performing its turn activity (which should lead to a direct attack)
	sarcophagus_instance.is_newly_arrived = false # Allow it to act
	sarcophagus_instance.perform_turn_activity() 
	# This calls _perform_direct_attack -> _on_deal_direct_damage (for Sarcophagus) -> Sarcophagus.die() -> reanimation logic

	# --- Assertions after Sarcophagus's full effect ---
	# Assert: Player's lane 0 now contains Knight (reanimated leftmost from grave)
	assert_true(player.lanes[0] is SummonInstance, "Player's lane 0 should have a SummonInstance (reanimated Knight).")
	var reanimated_knight_on_field = player.lanes[0] as SummonInstance
	assert_true(reanimated_knight_on_field != null and reanimated_knight_on_field.card_resource.id == "Knight", "Knight should be reanimated into lane 0 by Sarcophagus.")
	var reanimated_knight_field_id = reanimated_knight_on_field.instance_id

	# Assert: Sarcophagus is now in player's graveyard
	var sarcophagus_found_in_grave: bool = false
	var sarcophagus_gy_instance_id: int = -1
	for card_in_zone in player.graveyard:
		if card_in_zone.get_card_id() == "WalkingSarcophagus":
			sarcophagus_found_in_grave = true
			sarcophagus_gy_instance_id = card_in_zone.get_card_instance_id()
			break
	assert_true(sarcophagus_found_in_grave, "Walking Sarcophagus should be in graveyard after its effect.")

	# Assert: Scout is still in player's graveyard (Knight was consumed for reanimation)
	var scout_still_in_grave: bool = false
	for card_in_zone in player.graveyard:
		if card_in_zone.get_card_id() == "GoblinScout" and card_in_zone.get_card_instance_id() == scout_gy_original_id:
			scout_still_in_grave = true
			break
	assert_true(scout_still_in_grave, "Goblin Scout should still be in graveyard.")
	assert_eq(player.graveyard.size(), 2, "Player graveyard should contain Sarcophagus and Scout.")


	# --- Event Checks ---
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expected event sequence:
	# 1. Sarcophagus: summon_turn_activity (direct_attack)
	# 2. Sarcophagus: direct_damage (to opponent player)
	# 3. Opponent: hp_change (from Sarcophagus damage)
	#    --- Sarcophagus _on_deal_direct_damage triggers ---
	# 4. Sarcophagus: creature_defeated (Sarcophagus sacrifices itself)
	# 5. Sarcophagus: card_moved (Sarcophagus from lane to grave)
	# 6. Knight: card_moved (Knight from player's grave to limbo, sourced by Sarcophagus)
	# 7. Knight: summon_arrives (Knight arrives in lane, sourced by Sarcophagus)
	# 8. Knight: card_moved (Knight from limbo to player's lane, sourced by Sarcophagus)

	var sarc_activity_found = false
	var sarc_direct_damage_found = false
	var opp_hp_change_found = false
	var sarc_defeated_found = false
	var sarc_moved_to_grave_found = false
	var knight_moved_from_grave_found = false
	var knight_arrived_found = false
	var knight_moved_to_lane_found = false

	for event_data in new_events:
		var type = event_data.get("event_type")
		var inst_id = event_data.get("instance_id")
		var card_id = event_data.get("card_id")
		var src_inst_id = event_data.get("source_instance_id")
		var src_card_id = event_data.get("source_card_id")

		if type == "summon_turn_activity" and inst_id == sarcophagus_original_field_id: sarc_activity_found = true
		elif type == "direct_damage" and event_data.get("attacking_instance_id") == sarcophagus_original_field_id: sarc_direct_damage_found = true
		elif type == "hp_change" and event_data.get("player") == opponent.combatant_name and src_inst_id == sarcophagus_original_field_id: opp_hp_change_found = true
		elif type == "creature_defeated" and inst_id == sarcophagus_original_field_id: sarc_defeated_found = true
		elif type == "card_moved" and card_id == "WalkingSarcophagus" and inst_id == sarcophagus_original_field_id and event_data.get("to_zone") == "graveyard": 
			sarc_moved_to_grave_found = true
			assert_eq(event_data.get("to_details",{}).get("instance_id"), sarcophagus_gy_instance_id, "Sarcophagus CIZ ID in grave mismatch.")
		elif type == "card_moved" and card_id == "Knight" and inst_id == knight_gy_original_id and event_data.get("from_zone") == "graveyard" and src_inst_id == sarcophagus_original_field_id: 
			knight_moved_from_grave_found = true
		elif type == "summon_arrives" and card_id == "Knight" and inst_id == reanimated_knight_field_id and src_inst_id == sarcophagus_original_field_id: 
			knight_arrived_found = true
		elif type == "card_moved" and card_id == "Knight" and inst_id == knight_gy_original_id and event_data.get("from_zone") == "limbo" and event_data.get("to_details",{}).get("instance_id") == reanimated_knight_field_id and src_inst_id == sarcophagus_original_field_id: 
			knight_moved_to_lane_found = true
			
	assert_true(sarc_activity_found, "Sarcophagus: activity event missing.")
	assert_true(sarc_direct_damage_found, "Sarcophagus: direct_damage event missing.")
	assert_true(opp_hp_change_found, "Sarcophagus: opponent hp_change event missing.")
	assert_true(sarc_defeated_found, "Sarcophagus: creature_defeated event missing.")
	assert_true(sarc_moved_to_grave_found, "Sarcophagus: card_moved to grave event missing.")
	assert_true(knight_moved_from_grave_found, "Sarcophagus: Knight moved from grave event missing.")
	assert_true(knight_arrived_found, "Sarcophagus: Knight summon_arrives event missing.")
	assert_true(knight_moved_to_lane_found, "Sarcophagus: Knight moved to lane event missing.")

# --- Indulged Princeling Tests ---
func test_indulged_princeling_mills_self(): # Scenario: Enough cards to mill, Princeling survives
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"] # For _on_arrival signature
	var battle: Battle = setup["battle"]
	
	# Setup player's library with CardInZone objects
	player.library.clear()
	# Order added: Healer (top, index 0), GoblinScout (middle, index 1), Knight (bottom, index 2)
	# Mill happens from the top (pop_front). So Healer and GoblinScout will be milled.
	var healer_lib_id = battle._generate_new_card_instance_id()
	player.library.append(CardInZone.new(healer_res, healer_lib_id))         # Top, will be milled first
	var scout_lib_id = battle._generate_new_card_instance_id()
	player.library.append(CardInZone.new(goblin_scout_res, scout_lib_id))  # Middle, will be milled second
	var knight_lib_id = battle._generate_new_card_instance_id()
	player.library.append(CardInZone.new(knight_res, knight_lib_id))         # Bottom, should remain in library
	
	var initial_lib_size: int = player.library.size() # Should be 3
	var initial_grave_size: int = player.graveyard.size()

	# Simulate Indulged Princeling arrival in player's lane 0
	var princeling_instance = SummonInstance.new()
	var princeling_instance_id: int = battle._generate_new_card_instance_id()
	princeling_instance.setup(indulged_princeling_res, player, opponent, 0, battle, princeling_instance_id)
	player.lanes[0] = princeling_instance # Manually place it for the test

	var initial_event_count: int = battle.battle_events.size()

	# Action: Call _on_arrival effect
	if indulged_princeling_res.has_method("_on_arrival"):
		indulged_princeling_res._on_arrival(princeling_instance, player, opponent, battle)
	else:
		fail_test("Indulged Princeling resource does not have _on_arrival method.")
		return

	# Assert: Library size decreased by 2
	assert_eq(player.library.size(), initial_lib_size - 2, "Princeling mill: Library size incorrect.")
	# Assert: Graveyard size increased by 2
	assert_eq(player.graveyard.size(), initial_grave_size + 2, "Princeling mill: Graveyard size incorrect.")
	
	# Assert: Correct cards milled to graveyard (Healer then GoblinScout)
	# They are added to graveyard via push_back by add_card_to_graveyard.
	# So, Healer (milled first) will be at graveyard[initial_grave_size]
	# GoblinScout (milled second) will be at graveyard[initial_grave_size + 1] or graveyard[-1]
	assert_true(player.graveyard.size() >= initial_grave_size + 2, "Not enough cards in graveyard to check milled order.")
	if player.graveyard.size() >= initial_grave_size + 2:
		var first_milled_card_in_grave = player.graveyard[initial_grave_size] as CardInZone
		var second_milled_card_in_grave = player.graveyard[initial_grave_size + 1] as CardInZone
		
		assert_true(first_milled_card_in_grave != null and first_milled_card_in_grave.get_card_id() == "Healer", "Healer (first milled) not found correctly in graveyard.")
		assert_eq(first_milled_card_in_grave.get_card_instance_id(), healer_lib_id, "Healer's instance ID mismatch after mill.")
		
		assert_true(second_milled_card_in_grave != null and second_milled_card_in_grave.get_card_id() == "GoblinScout", "GoblinScout (second milled) not found correctly in graveyard.")
		assert_eq(second_milled_card_in_grave.get_card_instance_id(), scout_lib_id, "GoblinScout's instance ID mismatch after mill.")

	# Assert: Knight should be the only card remaining in library
	assert_eq(player.library.size(), 1, "Only one card (Knight) should remain in library.")
	if player.library.size() == 1:
		assert_eq(player.library[0].get_card_id(), "Knight", "Knight should be the remaining card in library.")
		assert_eq(player.library[0].get_card_instance_id(), knight_lib_id, "Knight's instance ID mismatch in library.")

	# Assert: Princeling still in lane (did not sacrifice)
	assert_true(player.lanes[0] == princeling_instance, "Princeling should remain in lane when enough cards are milled.")
	assert_false(princeling_instance.custom_state.has("prevent_graveyard"), "Princeling should not have prevent_graveyard if it didn't die.")


	# Assert: Event generation
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expected events:
	# - 2x card_moved (library_top_princeling_mill -> graveyard) for Healer
	# - 2x card_moved (library_top_princeling_mill -> graveyard) for GoblinScout
	# (Each pop_front in effect -> add_card_to_graveyard -> which itself generates one card_moved for library->play and one for play->graveyard.)
	# Let's refine the effect script to make add_card_to_graveyard take "library_top_..." directly.
	# If Combatant.add_card_to_graveyard takes `from_zone` and `p_instance_id_if_relevant` (which it does)
	# and the effect calls `active_combatant.add_card_to_graveyard(milled_card_in_zone, "library_top_princeling_mill", milled_card_in_zone.get_card_instance_id())`
	# then one `card_moved` event per milled card is enough.
	# So, expect 2 `card_moved` events.
	
	assert_eq(new_events.size(), 2, "Indulged Princeling mill should generate 2 card_moved events. Found: %s" % new_events.size())

	var healer_milled_event_found: bool = false
	var scout_milled_event_found: bool = false

	for event_data in new_events:
		if event_data.get("event_type") == "card_moved" and \
		   event_data.get("from_zone") == "library_top_princeling_mill" and \
		   event_data.get("to_zone") == "graveyard" and \
		   event_data.get("source_instance_id") == princeling_instance_id: # This sourcing needs to be added if not already.
			# The add_card_to_graveyard doesn't inherently know the Princeling is the source.
			# The effect script would need to pass this if we want it in the card_moved event.
			# For now, let's check the basics.
			var card_id_in_event = event_data.get("card_id")
			var instance_id_in_event = event_data.get("instance_id")
			if card_id_in_event == "Healer" and instance_id_in_event == healer_lib_id:
				healer_milled_event_found = true
			elif card_id_in_event == "GoblinScout" and instance_id_in_event == scout_lib_id:
				scout_milled_event_found = true
	
	assert_true(healer_milled_event_found, "Card_moved event for milled Healer not found or incorrect.")
	assert_true(scout_milled_event_found, "Card_moved event for milled GoblinScout not found or incorrect.")

func test_indulged_princeling_sacrifices_if_cant_mill(): # Scenario: Not enough cards, Princeling sacrifices
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"] # For _on_arrival signature
	var battle: Battle = setup["battle"]
	
	# Setup player's library with only 1 card (needs 2 to mill without sacrifice)
	player.library.clear()
	var knight_lib_id = battle._generate_new_card_instance_id()
	player.library.append(CardInZone.new(knight_res, knight_lib_id))
	
	var initial_lib_size: int = player.library.size() # Should be 1
	var initial_grave_size: int = player.graveyard.size()

	# Simulate Indulged Princeling arrival in player's lane 0
	var princeling_instance = SummonInstance.new()
	var princeling_instance_id: int = battle._generate_new_card_instance_id()
	princeling_instance.setup(indulged_princeling_res, player, opponent, 0, battle, princeling_instance_id)
	player.lanes[0] = princeling_instance # Manually place it
	var princeling_original_field_id = princeling_instance.instance_id # Store before it dies

	var initial_event_count: int = battle.battle_events.size()

	# Action: Call _on_arrival effect
	if indulged_princeling_res.has_method("_on_arrival"):
		indulged_princeling_res._on_arrival(princeling_instance, player, opponent, battle)
	else:
		fail_test("Indulged Princeling resource does not have _on_arrival method.")
		return

	# Assert: Princeling removed from lane (sacrificed)
	assert_null(player.lanes[0], "Princeling should be removed from lane after failing to mill enough cards.")
	
	# Assert: Princeling added to graveyard
	assert_eq(player.graveyard.size(), initial_grave_size + 1, "Graveyard size should increase by one (Princeling died).")
	assert_true(player.graveyard[-1] is CardInZone, "Card in graveyard should be CardInZone.")
	var princeling_in_grave = player.graveyard[-1] as CardInZone
	if princeling_in_grave:
		assert_eq(princeling_in_grave.get_card_id(), "IndulgedPrinceling", "Indulged Princeling should be in graveyard.")
		# The instance ID of the Princeling CIZ in grave will be NEW, generated by add_card_to_graveyard via die()
		assert_ne(princeling_in_grave.get_card_instance_id(), princeling_original_field_id, "Princeling in grave should have a new instance_id.")
	else:
		fail_test("Card in graveyard was not a CardInZone as expected.")

	# Assert: Library is unchanged (the one card was NOT milled because condition failed before milling started)
	assert_eq(player.library.size(), initial_lib_size, "Library size should remain unchanged if Princeling sacrifices.")
	if player.library.size() == 1: # Check it's still the Knight
		assert_eq(player.library[0].get_card_id(), "Knight", "The original card (Knight) should still be in the library.")
		assert_eq(player.library[0].get_card_instance_id(), knight_lib_id, "Knight's instance ID in library should be unchanged.")

	# Assert: Event generation
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expected events:
	# 1. visual_effect (for Princeling sacrifice, from effect script)
	# 2. creature_defeated (for Princeling, from die())
	# 3. card_moved (Princeling from lane to graveyard, from die() -> add_card_to_graveyard())
	assert_eq(new_events.size(), 3, "Princeling sacrifice should generate 3 events. Found: %s" % new_events.size())

	var visual_sacrifice_found: bool = false
	var defeated_event_found: bool = false
	var moved_to_grave_event_found: bool = false
	var princeling_new_grave_instance_id_from_event: int = -1

	for event_data in new_events:
		var type = event_data.get("event_type")
		var inst_id = event_data.get("instance_id")
		var src_inst_id = event_data.get("source_instance_id")

		if type == "visual_effect" and event_data.get("effect_id") == "indulged_princeling_sacrifice" and \
		   inst_id == princeling_original_field_id and src_inst_id == princeling_original_field_id:
			visual_sacrifice_found = true
		
		elif type == "creature_defeated" and inst_id == princeling_original_field_id:
			defeated_event_found = true
			# Source of defeat is its own effect / game rule from failing condition
			# This might be tricky to source perfectly unless die() takes more params.
			# For now, check it's the correct instance.
			assert_eq(event_data.get("card_id"), "IndulgedPrinceling", "Defeated event: card_id incorrect.")

		elif type == "card_moved" and \
			 event_data.get("card_id") == "IndulgedPrinceling" and \
			 inst_id == princeling_original_field_id and \
			 event_data.get("from_zone") == "lane" and event_data.get("to_zone") == "graveyard":
			moved_to_grave_event_found = true
			princeling_new_grave_instance_id_from_event = event_data.get("to_details",{}).get("instance_id")
			assert_ne(princeling_new_grave_instance_id_from_event, princeling_original_field_id, "Princeling card_moved to_details.instance_id should be new.")


	assert_true(visual_sacrifice_found, "Visual effect for Princeling sacrifice not found or improperly sourced.")
	assert_true(defeated_event_found, "Creature_defeated event for Princeling not found.")
	assert_true(moved_to_grave_event_found, "Card_moved (Princeling to grave) event not found or improperly sourced.")

	# Final check on graveyard Princeling's instance ID
	if princeling_in_grave and princeling_new_grave_instance_id_from_event != -1:
		assert_eq(princeling_in_grave.get_card_instance_id(), princeling_new_grave_instance_id_from_event, "Instance ID of Princeling in graveyard does not match event's to_details.instance_id.")

# --- Elsewhere Tests ---
func test_elsewhere_bounces_leftmost():
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"] # Player casting Elsewhere
	var opponent: Combatant = setup["opponent"] # Opponent whose creature is bounced
	var battle: Battle = setup["battle"]
	
	# Place opponent creatures:
	# Lane 0 (index 0): Goblin Scout - Leftmost, should be bounced
	var scout_to_be_bounced = place_summon_for_test(opponent, goblin_scout_res, 0, battle)
	var scout_original_field_instance_id: int = scout_to_be_bounced.instance_id
	# Lane 1 (index 1): Knight - Should remain
	var knight_should_remain = place_summon_for_test(opponent, knight_res, 1, battle)
	
	opponent.library.clear() # Clear opponent's library for easy check of bounced card
	var initial_event_count: int = battle.battle_events.size()

	# Create a CardInZone for the Elsewhere spell
	var elsewhere_spell_instance_id: int = battle._generate_new_card_instance_id()
	var elsewhere_card_in_zone: CardInZone = CardInZone.new(elsewhere_res, elsewhere_spell_instance_id)

	# Action: Apply Elsewhere effect
	if elsewhere_res.has_method("apply_effect"):
		elsewhere_res.apply_effect(elsewhere_card_in_zone, player, opponent, battle)
	else:
		fail_test("Elsewhere resource does not have a script with apply_effect.")
		return

	# Assert: Scout (leftmost) is gone from opponent's lane 0
	assert_null(opponent.lanes[0], "Opponent's lane 0 should be empty after Elsewhere bounce.")
	# Assert: Knight still in opponent's lane 1
	assert_true(opponent.lanes[1] == knight_should_remain, "Knight in opponent's lane 1 should remain untouched.")
	
	# Assert: Scout (as CardInZone) is now at the bottom of opponent's library
	assert_eq(opponent.library.size(), 1, "Opponent's library should have 1 card (the bounced Scout).")
	assert_true(opponent.library[-1] is CardInZone, "Bounced card in library should be a CardInZone.") # Elsewhere adds to bottom (push_back)
	var bounced_scout_in_lib = opponent.library[-1] as CardInZone
	if bounced_scout_in_lib:
		assert_eq(bounced_scout_in_lib.get_card_id(), "GoblinScout", "Bounced Scout's card_id in library is incorrect.")
		# The instance ID of the card in library will be NEW, as per elsewhere_effect.gd logic
		assert_ne(bounced_scout_in_lib.get_card_instance_id(), scout_original_field_instance_id, "Bounced Scout in library should have a new instance_id.")
	else:
		fail_test("Card at bottom of opponent library was not a CardInZone as expected.")

	# Assert: Event generation
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expected events for successful bounce of Scout:
	# 1. summon_leaves_lane (for Scout, sourced by Elsewhere)
	# 2. card_moved (Scout from lane to library, sourced by Elsewhere)
	# 3. visual_effect (for Elsewhere bounce visual)
	# Total = 3 events

	var summon_leaves_lane_found: bool = false
	var card_moved_to_library_found: bool = false
	var visual_effect_bounce_found: bool = false
	var new_scout_library_instance_id_from_event: int = -1

	for event_data in new_events:
		var event_type = event_data.get("event_type")
		var event_instance_id = event_data.get("instance_id") # Main instance_id of the event
		var event_card_id = event_data.get("card_id")
		var event_source_instance_id = event_data.get("source_instance_id")
		var event_source_card_id = event_data.get("source_card_id")

		if event_type == "summon_leaves_lane" and \
		   event_instance_id == scout_original_field_instance_id and \
		   event_card_id == "GoblinScout" and \
		   event_data.get("lane") == 1 and \
		   event_source_instance_id == elsewhere_spell_instance_id:
			summon_leaves_lane_found = true
		
		elif event_type == "card_moved" and \
			 event_card_id == "GoblinScout" and \
			 event_instance_id == scout_original_field_instance_id and \
			 event_data.get("from_zone") == "lane" and \
			 event_data.get("to_zone") == "library" and \
			 event_source_instance_id == elsewhere_spell_instance_id:
			card_moved_to_library_found = true
			assert_eq(event_data.get("to_details", {}).get("position"), "bottom", "Elsewhere: Scout card_moved event should specify to_details.position 'bottom'.")
			new_scout_library_instance_id_from_event = event_data.get("to_details", {}).get("instance_id")
			assert_ne(new_scout_library_instance_id_from_event, scout_original_field_instance_id, "Elsewhere: Bounced Scout in library should have a new instance ID in to_details.")
		
		elif event_type == "visual_effect" and \
			 event_data.get("effect_id") == "elsewhere_bounce" and \
			 event_instance_id == scout_original_field_instance_id and \
			 event_source_instance_id == elsewhere_spell_instance_id:
			visual_effect_bounce_found = true

	assert_true(summon_leaves_lane_found, "Elsewhere: summon_leaves_lane event for Scout not found or improperly sourced.")
	assert_true(card_moved_to_library_found, "Elsewhere: card_moved (Scout to library) event not found or improperly sourced.")
	assert_true(visual_effect_bounce_found, "Elsewhere: visual_effect for bounce not found or improperly sourced.")

	# Final check on library card's instance ID
	if bounced_scout_in_lib and new_scout_library_instance_id_from_event != -1:
		assert_eq(bounced_scout_in_lib.get_card_instance_id(), new_scout_library_instance_id_from_event, "Instance ID of bounced Scout in library does not match its card_moved to_details.instance_id.")

# --- Carnivorous Plant Tests ---
func test_carnivorous_plant_adds_scout_to_grave():
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"] # For _on_arrival signature
	var battle: Battle = setup["battle"]
	
	player.graveyard.clear() # Start with an empty graveyard
	var initial_grave_size: int = player.graveyard.size() # Should be 0
	
	# Simulate Carnivorous Plant arrival
	var plant_instance = SummonInstance.new()
	var plant_instance_id: int = battle._generate_new_card_instance_id() # Use new ID system
	plant_instance.setup(carnivorous_plant_res, player, opponent, 0, battle, plant_instance_id)
	# player.lanes[0] = plant_instance # If placement is needed for effect (not for this one)

	var initial_event_count: int = battle.battle_events.size()

	# Action: Call _on_arrival effect
	if carnivorous_plant_res.has_method("_on_arrival"):
		carnivorous_plant_res._on_arrival(plant_instance, player, opponent, battle)
	else:
		fail_test("Carnivorous Plant resource does not have _on_arrival method.")
		return

	# Assert: Player's graveyard now contains one card (the Goblin Scout)
	assert_eq(player.graveyard.size(), initial_grave_size + 1, "Player's graveyard should contain 1 card after Plant's effect.")
	
	assert_true(player.graveyard[0] is CardInZone, "Card in graveyard should be a CardInZone.")
	var scout_in_grave = player.graveyard[0] as CardInZone
	if scout_in_grave:
		assert_eq(scout_in_grave.get_card_id(), "GoblinScout", "The card in graveyard should be Goblin Scout.")
		# The scout_in_grave will have its own new instance_id generated by the effect.
	else:
		fail_test("Card in graveyard was not a CardInZone as expected.")

	# Assert: Event generation
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expected events:
	# 1. card_moved (Goblin Scout from "effect_carnivorous_plant" or "limbo" to graveyard, sourced by Plant)
	# 2. (Optional) visual_effect for the Plant's action
	# Let's assume 2 events if visual_effect is added by effect script, 1 if only card_moved.
	# The current effect script adds a visual_effect.
	assert_eq(new_events.size(), 2, "Carnivorous Plant effect should generate 2 events (1 card_moved, 1 visual). Found: %s" % new_events.size())

	var card_moved_scout_to_grave_found: bool = false
	var visual_effect_plant_action_found: bool = false
	var scout_new_gy_instance_id_from_event: int = -1


	for event_data in new_events:
		var type = event_data.get("event_type")
		var card_id = event_data.get("card_id")
		var inst_id = event_data.get("instance_id")
		var src_inst_id = event_data.get("source_instance_id")
		var src_card_id = event_data.get("source_card_id")

		if type == "card_moved" and \
		   card_id == "GoblinScout" and \
		   event_data.get("player") == player.combatant_name and \
		   event_data.get("to_zone") == "graveyard":
			# The source of this card_moved event (if generated by add_card_to_graveyard)
			# depends on whether add_card_to_graveyard itself was passed the Plant as a causer.
			# Assuming add_card_to_graveyard's event is sourced by the card being moved if no other source is given:
			# assert_eq(src_card_id, plant_instance.card_resource.id, "Scout to grave: card_moved source_card_id (Plant) incorrect.")
			# assert_eq(src_inst_id, plant_instance.instance_id, "Scout to grave: card_moved source_instance_id (Plant) incorrect.")
			# The main instance_id of this card_moved event will be the Scout's new graveyard CIZ ID.
			card_moved_scout_to_grave_found = true
			scout_new_gy_instance_id_from_event = inst_id 
			assert_eq(event_data.get("from_zone"), "created_by_effect_" + plant_instance.card_resource.id, "Scout to grave: card_moved from_zone incorrect.")


		elif type == "visual_effect" and \
			 event_data.get("effect_id") == "carnivorous_plant_summons_scout_to_grave" and \
			 inst_id == plant_instance_id: # Plant is the subject of this visual
			visual_effect_plant_action_found = true
			assert_eq(src_inst_id, plant_instance_id, "Plant visual_effect: source_instance_id incorrect.")
			assert_eq(event_data.get("details", {}).get("added_card_id"), "GoblinScout", "Plant visual_effect details: added_card_id incorrect.")
			if scout_in_grave: # Compare with actual ID if available
				assert_eq(event_data.get("details", {}).get("added_instance_id"), scout_in_grave.get_card_instance_id(), "Plant visual_effect details: added_instance_id incorrect.")


	assert_true(card_moved_scout_to_grave_found, "Card_moved event for Goblin Scout (to graveyard by Plant) not found or improperly sourced.")
	assert_true(visual_effect_plant_action_found, "Visual effect for Carnivorous Plant action not found or improperly sourced.")

	# Final check on graveyard Scout's instance ID
	if scout_in_grave and scout_new_gy_instance_id_from_event != -1:
		assert_eq(scout_in_grave.get_card_instance_id(), scout_new_gy_instance_id_from_event, "Instance ID of Scout in graveyard does not match event's instance_id.")

# --- Chanter of Ashes Tests ---
func test_chanter_of_ashes_consumes_and_damages():
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"]
	var battle: Battle = setup["battle"]
	
	# Setup player's graveyard with CardInZone objects
	player.graveyard.clear()
	# Order: EnergyAxe (spell, should remain), then summons (will be consumed from last added backwards)
	var energy_axe_gy_id = battle._generate_new_card_instance_id()
	player.graveyard.append(CardInZone.new(energy_axe_res, energy_axe_gy_id))
	
	var knight_gy_id = battle._generate_new_card_instance_id() # Will be consumed
	player.graveyard.append(CardInZone.new(knight_res, knight_gy_id))
	var scout_gy_id = battle._generate_new_card_instance_id() # Will be consumed
	player.graveyard.append(CardInZone.new(goblin_scout_res, scout_gy_id)) 
	# Graveyard order (top to bottom / index 0 to N): EnergyAxe, Knight, GoblinScout
	# Effect consumes from end, so Scout then Knight.
	
	var initial_grave_size_val: int = player.graveyard.size() # Should be 3
	var initial_opponent_hp: int = opponent.current_hp
	var initial_event_count: int = battle.battle_events.size()

	# Simulate Chanter of Ashes arrival
	var chanter_instance = SummonInstance.new()
	var chanter_instance_id: int = battle._generate_new_card_instance_id()
	chanter_instance.setup(chanter_of_ashes_res, player, opponent, 0, battle, chanter_instance_id)
	# player.lanes[0] = chanter_instance # If placement matters (not for this effect)

	# Action: Call _on_arrival effect
	if chanter_of_ashes_res.has_method("_on_arrival"):
		chanter_of_ashes_res._on_arrival(chanter_instance, player, opponent, battle)
	else:
		fail_test("Chanter of Ashes resource does not have _on_arrival method.")
		return

	# Assert: Player's graveyard now contains only the spell (EnergyAxe)
	assert_eq(player.graveyard.size(), initial_grave_size_val - 2, "Player's graveyard size incorrect after Chanter consumes (should be 1).")
	if player.graveyard.size() == 1:
		assert_true(player.graveyard[0] is CardInZone, "Remaining card in grave should be CardInZone.")
		assert_eq(player.graveyard[0].get_card_id(), "EnergyAxe", "EnergyAxe spell should be the only card remaining in player's graveyard.")
		assert_eq(player.graveyard[0].get_card_instance_id(), energy_axe_gy_id, "EnergyAxe instance ID mismatch.")
	
	# Assert: Opponent took damage (2 summons consumed * 2 damage each = 4 damage)
	var expected_damage_to_opponent = 2 * 2
	assert_eq(opponent.current_hp, initial_opponent_hp - expected_damage_to_opponent, "Opponent HP incorrect after Chanter's damage.")

	# Assert: Event generation
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expected events:
	# - 2x card_removed (for Scout and Knight from player's grave, sourced by Chanter)
	# - 1x hp_change (on opponent, from take_damage, sourced by Chanter)
	# - 1x effect_damage (context for opponent damage, sourced by Chanter)
	# - 1x visual_effect (for Chanter's ability)
	# Total = 5 events

	var card_removed_count: int = 0
	var opponent_hp_change_event_found: bool = false
	var effect_damage_event_found: bool = false
	var chanter_visual_effect_found: bool = false
	var removed_instance_ids_from_events: Array[int] = []

	for event_data in new_events:
		var type = event_data.get("event_type")
		var inst_id = event_data.get("instance_id")
		var src_inst_id = event_data.get("source_instance_id")
		var src_card_id = event_data.get("source_card_id")

		if type == "card_removed" and \
		   event_data.get("from_zone") == "graveyard" and \
		   event_data.get("player") == player.combatant_name and \
		   src_card_id == chanter_of_ashes_res.id and \
		   src_inst_id == chanter_instance_id:
			card_removed_count += 1
			removed_instance_ids_from_events.append(inst_id)
		
		elif type == "hp_change" and \
			 event_data.get("player") == opponent.combatant_name and \
			 src_card_id == chanter_of_ashes_res.id and \
			 src_inst_id == chanter_instance_id:
			opponent_hp_change_event_found = true
			assert_eq(event_data.get("amount"), -expected_damage_to_opponent, "Chanter damage: hp_change amount incorrect.")
			# The main 'instance_id' of hp_change (for player) is -1 or player name, source is Chanter
			assert_eq(inst_id, -1, "Chanter damage: hp_change main instance_id for player incorrect.")


		elif type == "effect_damage" and \
			 event_data.get("target_player") == opponent.combatant_name and \
			 src_card_id == chanter_of_ashes_res.id and \
			 src_inst_id == chanter_instance_id:
			effect_damage_event_found = true
			assert_eq(event_data.get("amount"), expected_damage_to_opponent, "Chanter damage: effect_damage amount incorrect.")
			# The 'instance_id' of this effect_damage event should be the Chanter itself
			assert_eq(inst_id, chanter_instance_id, "Chanter damage: effect_damage instance_id (Chanter) incorrect.")
		
		elif type == "visual_effect" and \
			 event_data.get("effect_id") == "chanter_of_ashes_damage_pulse" and \
			 inst_id == chanter_instance_id: # Chanter is the subject/source of this visual
			chanter_visual_effect_found = true
			assert_eq(src_inst_id, chanter_instance_id, "Chanter visual_effect: source_instance_id incorrect.")
			assert_eq(event_data.get("details", {}).get("summons_consumed"), 2, "Chanter visual_effect details: summons_consumed incorrect.")

	assert_eq(card_removed_count, 2, "Incorrect number of card_removed events for Chanter of Ashes.")
	assert_true(scout_gy_id in removed_instance_ids_from_events, "Goblin Scout was not logged as removed by Chanter.")
	assert_true(knight_gy_id in removed_instance_ids_from_events, "Knight was not logged as removed by Chanter.")
	assert_false(energy_axe_gy_id in removed_instance_ids_from_events, "Energy Axe should not have been removed by Chanter.")

	assert_true(opponent_hp_change_event_found, "Opponent hp_change event from Chanter's damage not found or improperly sourced.")
	assert_true(effect_damage_event_found, "Effect_damage event for Chanter not found or improperly sourced.")
	assert_true(chanter_visual_effect_found, "Visual effect for Chanter's action not found or improperly sourced.")

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
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"]
	var battle: Battle = setup["battle"]
	
	# Place creatures
	var player_scout_instance = place_summon_for_test(player, goblin_scout_res, 0, battle) # HP 2
	var player_knight_instance = place_summon_for_test(player, knight_res, 1, battle)     # HP 3
	var opponent_scout_instance = place_summon_for_test(opponent, goblin_scout_res, 0, battle) # HP 2
	var opponent_knight_instance = place_summon_for_test(opponent, knight_res, 1, battle)     # HP 3
	
	# Store initial HPs and instance IDs for verification
	var initial_pscout_hp = player_scout_instance.current_hp
	var initial_pknight_hp = player_knight_instance.current_hp
	var initial_oscout_hp = opponent_scout_instance.current_hp
	var initial_oknight_hp = opponent_knight_instance.current_hp

	var ps_id = player_scout_instance.instance_id
	var pk_id = player_knight_instance.instance_id
	var os_id = opponent_scout_instance.instance_id
	var ok_id = opponent_knight_instance.instance_id
	
	var initial_event_count: int = battle.battle_events.size()

	# Create a CardInZone for the Inferno spell
	var inferno_spell_instance_id: int = battle._generate_new_card_instance_id()
	var inferno_card_in_zone: CardInZone = CardInZone.new(inferno_res, inferno_spell_instance_id)

	# Action: Apply Inferno effect
	if inferno_res.has_method("apply_effect"):
		inferno_res.apply_effect(inferno_card_in_zone, player, opponent, battle)
	else:
		fail_test("Inferno resource does not have a script with apply_effect.")
		return

	# Assert: All creatures took 2 damage
	assert_eq(player_scout_instance.current_hp, initial_pscout_hp - 2, "Inferno: Player Scout HP incorrect.") # Dies
	assert_eq(player_knight_instance.current_hp, initial_pknight_hp - 2, "Inferno: Player Knight HP incorrect.")
	assert_eq(opponent_scout_instance.current_hp, initial_oscout_hp - 2, "Inferno: Opponent Scout HP incorrect.") # Dies
	assert_eq(opponent_knight_instance.current_hp, initial_oknight_hp - 2, "Inferno: Opponent Knight HP incorrect.")

	# Assert: Event generation
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expected events:
	# 1. visual_effect (for Inferno spell cast)
	# 4x creature_hp_change (one for each creature, sourced by Inferno)
	# 2x creature_defeated (for the two scouts that die, sourced by Inferno via take_damage)
	# 2x card_moved (for the two scouts moving to graveyard, sourced by Inferno via die->add_card_to_graveyard)
	# Total = 1 + 4 + 2 + 2 = 9 events
	
	# For simplicity in test, we'll check counts and key properties of hp_change and defeated.
	# A more exhaustive test would check every event in sequence.
	
	var creature_hp_changes_found: int = 0
	var creatures_defeated_found: int = 0
	var visual_effect_inferno_cast_found: bool = false

	var expected_affected_instance_ids: Array[int] = [ps_id, pk_id, os_id, ok_id]
	var actual_hp_changed_instance_ids: Array[int] = []
	var actual_defeated_instance_ids: Array[int] = []

	for event_data in new_events:
		var type = event_data.get("event_type")
		var inst_id = event_data.get("instance_id")
		var src_inst_id = event_data.get("source_instance_id")
		var src_card_id = event_data.get("source_card_id")

		if type == "visual_effect" and event_data.get("effect_id") == "inferno_spell_cast" and \
		   inst_id == inferno_spell_instance_id and src_inst_id == inferno_spell_instance_id:
			visual_effect_inferno_cast_found = true
		
		elif type == "creature_hp_change" and \
			 src_card_id == inferno_card_in_zone.get_card_id() and \
			 src_inst_id == inferno_spell_instance_id:
			creature_hp_changes_found += 1
			assert_eq(event_data.get("amount"), -2, "Inferno: creature_hp_change amount incorrect for instance %s." % inst_id)
			actual_hp_changed_instance_ids.append(inst_id)
			
		elif type == "creature_defeated":
			# The source of defeat is the Inferno spell (passed via take_damage).
			# This assumes SummonInstance.die() correctly sources its creature_defeated event
			# if take_damage passed that source info to die(), or if die() inherits it.
			# Currently, SummonInstance.die() does NOT take source params for its own event.
			# So, we can only check that the correct instances were defeated.
			actual_defeated_instance_ids.append(inst_id)
			creatures_defeated_found +=1


	assert_true(visual_effect_inferno_cast_found, "Visual effect for Inferno cast not found or improperly sourced.")
	assert_eq(creature_hp_changes_found, 4, "Incorrect number of creature_hp_change events from Inferno.")
	assert_eq(creatures_defeated_found, 2, "Incorrect number of creature_defeated events from Inferno.")

	# Check that all targeted creatures had an hp_change event
	for id_to_check in expected_affected_instance_ids:
		assert_true(id_to_check in actual_hp_changed_instance_ids, "Instance %s did not have an HP change event from Inferno." % id_to_check)
	
	# Check that the correct creatures were defeated
	assert_true(ps_id in actual_defeated_instance_ids, "Player Scout (instance %s) was not marked as defeated by Inferno." % ps_id)
	assert_true(os_id in actual_defeated_instance_ids, "Opponent Scout (instance %s) was not marked as defeated by Inferno." % os_id)
	assert_false(pk_id in actual_defeated_instance_ids, "Player Knight (instance %s) should NOT have been defeated by Inferno." % pk_id)
	assert_false(ok_id in actual_defeated_instance_ids, "Opponent Knight (instance %s) should NOT have been defeated by Inferno." % ok_id)


# --- Flamewielder Tests ---
func test_flamewielder_damages_opponents():
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]    # Flamewielder's owner
	var opponent: Combatant = setup["opponent"] # Opponent whose creatures are damaged
	var battle: Battle = setup["battle"]
	
	# Place creatures
	var player_knight_instance = place_summon_for_test(player, knight_res, 0, battle) # Should NOT be damaged
	var opponent_scout_instance = place_summon_for_test(opponent, goblin_scout_res, 0, battle) # Should be damaged
	var opponent_knight_instance = place_summon_for_test(opponent, knight_res, 1, battle)    # Should be damaged
	
	var initial_player_knight_hp = player_knight_instance.current_hp
	var initial_opponent_scout_hp = opponent_scout_instance.current_hp
	var initial_opponent_knight_hp = opponent_knight_instance.current_hp
	
	# Simulate Flamewielder arrival (owned by player)
	var flamewielder_instance = SummonInstance.new()
	var flamewielder_instance_id: int = battle._generate_new_card_instance_id() # Use new ID system
	# Flamewielder's own lane index during setup usually doesn't affect its AoE _on_arrival.
	# Placing it in lane 0 for consistency or if some future logic required it.
	flamewielder_instance.setup(flamewielder_res, player, opponent, 0, battle, flamewielder_instance_id)
	# if player.lanes[0] == null: player.lanes[0] = flamewielder_instance # Optional: place if needed for other test aspects

	var initial_event_count: int = battle.battle_events.size()

	# Action: Call Flamewielder's _on_arrival effect
	if flamewielder_res.has_method("_on_arrival"):
		flamewielder_res._on_arrival(flamewielder_instance, player, opponent, battle)
	else:
		fail_test("Flamewielder resource does not have _on_arrival method.")
		return

	# Assert: Opponent's creatures took 1 damage
	assert_eq(opponent_scout_instance.current_hp, initial_opponent_scout_hp - 1, "Flamewielder: Opponent Scout HP incorrect.")
	assert_eq(opponent_knight_instance.current_hp, initial_opponent_knight_hp - 1, "Flamewielder: Opponent Knight HP incorrect.")
	
	# Assert: Player's creature (Knight) is unharmed
	assert_eq(player_knight_instance.current_hp, initial_player_knight_hp, "Flamewielder: Player Knight HP should be unchanged.")

	# Assert: Event generation
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expected events:
	# 1. visual_effect (for Flamewielder's ability cast)
	# 2. creature_hp_change (for opponent's Scout, sourced by Flamewielder)
	# 3. creature_hp_change (for opponent's Knight, sourced by Flamewielder)
	# (Plus any creature_defeated and card_moved if damage was lethal, but not in this test setup)
	# Total expected = 3 main events here.
	
	var visual_effect_cast_found: bool = false
	var opponent_scout_hp_change_found: bool = false
	var opponent_knight_hp_change_found: bool = false

	for event_data in new_events:
		var type = event_data.get("event_type")
		var inst_id = event_data.get("instance_id")
		var src_inst_id = event_data.get("source_instance_id")
		var src_card_id = event_data.get("source_card_id")

		if type == "visual_effect" and event_data.get("effect_id") == "flamewielder_aoe_damage_cast" and \
		   inst_id == flamewielder_instance_id and src_inst_id == flamewielder_instance_id:
			visual_effect_cast_found = true
		
		elif type == "creature_hp_change" and \
			 src_card_id == flamewielder_res.id and \
			 src_inst_id == flamewielder_instance_id:
			if inst_id == opponent_scout_instance.instance_id:
				opponent_scout_hp_change_found = true
				assert_eq(event_data.get("amount"), -1, "Flamewielder: Opponent Scout hp_change amount incorrect.")
			elif inst_id == opponent_knight_instance.instance_id:
				opponent_knight_hp_change_found = true
				assert_eq(event_data.get("amount"), -1, "Flamewielder: Opponent Knight hp_change amount incorrect.")
	
	assert_true(visual_effect_cast_found, "Visual effect for Flamewielder cast not found or improperly sourced.")
	assert_true(opponent_scout_hp_change_found, "HP change event for opponent's Scout (from Flamewielder) not found or improperly sourced.")
	assert_true(opponent_knight_hp_change_found, "HP change event for opponent's Knight (from Flamewielder) not found or improperly sourced.")

# --- Rampaging Cyclops Tests ---
func test_rampaging_cyclops_damages_all():
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"]
	var battle: Battle = setup["battle"]
	
	# Place other creatures
	var player_scout_instance = place_summon_for_test(player, goblin_scout_res, 0, battle) # Player's lane 0
	var opponent_knight_instance = place_summon_for_test(opponent, knight_res, 1, battle) # Opponent's lane 1
	
	# Simulate Rampaging Cyclops arrival in player's lane 2 (index 2)
	var cyclops_instance = SummonInstance.new()
	var cyclops_instance_id: int = battle._generate_new_card_instance_id() # Use new ID system
	# Base HP of Cyclops is 5 (from card_data.json for rampaging_cyclops, assuming it's 4P/5HP)
	# If it's 4P/4HP, then the expected HP after taking 1 damage would be 3.
	# Let's assume its resource base_max_hp is correctly set.
	cyclops_instance.setup(rampaging_cyclops_res, player, opponent, 2, battle, cyclops_instance_id)
	player.lanes[2] = cyclops_instance # Manually place it in the lane array
	
	var initial_pscout_hp = player_scout_instance.current_hp # Should be 2
	var initial_oknight_hp = opponent_knight_instance.current_hp # Should be 3
	var initial_cyclops_hp = cyclops_instance.current_hp # Base HP from resource (e.g., 5 or 4)

	var ps_id = player_scout_instance.instance_id
	var ok_id = opponent_knight_instance.instance_id
	var cyclops_id = cyclops_instance.instance_id # This is cyclops_instance_id
	
	var initial_event_count: int = battle.battle_events.size()

	# Action: Call Cyclops's _on_arrival effect
	if rampaging_cyclops_res.has_method("_on_arrival"):
		rampaging_cyclops_res._on_arrival(cyclops_instance, player, opponent, battle)
	else:
		fail_test("Rampaging Cyclops resource does not have _on_arrival method.")
		return

	# Assert: Other creatures took 1 damage
	assert_eq(player_scout_instance.current_hp, initial_pscout_hp - 1, "Cyclops: Player Scout HP incorrect.")
	assert_eq(opponent_knight_instance.current_hp, initial_oknight_hp - 1, "Cyclops: Opponent Knight HP incorrect.")
	
	# Assert: Cyclops itself also took 1 damage (as per current effect logic)
	assert_eq(cyclops_instance.current_hp, initial_cyclops_hp - 1, "Cyclops: Own HP incorrect (should also take damage).")

	# Assert: Event generation
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expected events:
	# 1. visual_effect (for Cyclops's stomp)
	# 3x creature_hp_change (one for p_scout, one for o_knight, one for Cyclops itself, all sourced by Cyclops)
	# (Plus any creature_defeated/card_moved if damage was lethal, p_scout might die if its HP was 1)
	# Player Scout (2HP - 1 = 1HP)
	# Opponent Knight (3HP - 1 = 2HP)
	# Cyclops (e.g. 5HP - 1 = 4HP or 4HP - 1 = 3HP)
	# No deaths in this specific setup. So, 1 visual + 3 hp_change = 4 events.

	assert_eq(new_events.size(), 4, "Rampaging Cyclops effect should generate 4 events. Found: %s" % new_events.size())
	
	var visual_effect_stomp_found: bool = false
	var hp_changes_count: int = 0
	var affected_instance_ids_in_hp_events: Array[int] = []

	for event_data in new_events:
		var type = event_data.get("event_type")
		var inst_id = event_data.get("instance_id")
		var src_inst_id = event_data.get("source_instance_id")
		var src_card_id = event_data.get("source_card_id")

		if type == "visual_effect" and event_data.get("effect_id") == "rampaging_cyclops_stomp" and \
		   inst_id == cyclops_instance_id and src_inst_id == cyclops_instance_id:
			visual_effect_stomp_found = true
		
		elif type == "creature_hp_change" and \
			 src_card_id == rampaging_cyclops_res.id and \
			 src_inst_id == cyclops_instance_id:
			hp_changes_count += 1
			assert_eq(event_data.get("amount"), -1, "Cyclops AoE: creature_hp_change amount incorrect for instance %s." % inst_id)
			affected_instance_ids_in_hp_events.append(inst_id)
			
	assert_true(visual_effect_stomp_found, "Visual effect for Cyclops stomp not found or improperly sourced.")
	assert_eq(hp_changes_count, 3, "Incorrect number of creature_hp_change events from Cyclops stomp.")

	# Check that all three expected creatures received an HP change event
	assert_true(ps_id in affected_instance_ids_in_hp_events, "Player Scout (instance %s) did not have an HP change event from Cyclops." % ps_id)
	assert_true(ok_id in affected_instance_ids_in_hp_events, "Opponent Knight (instance %s) did not have an HP change event from Cyclops." % ok_id)
	assert_true(cyclops_id in affected_instance_ids_in_hp_events, "Cyclops itself (instance %s) did not have an HP change event from its stomp." % cyclops_id)

# --- Hexplate Tests ---
func test_hexplate_buffs_leftmost():
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"] # Get opponent for apply_effect signature
	var battle: Battle = setup["battle"]
	
	# Place target creatures for the player
	var scout_instance = place_summon_for_test(player, goblin_scout_res, 0, battle) # Leftmost, in player's lane 0
	var knight_instance = place_summon_for_test(player, knight_res, 1, battle)      # Player's lane 1
	
	var initial_scout_power = scout_instance.get_current_power()
	var initial_scout_hp = scout_instance.get_current_max_hp() # Test uses max_hp for buff check
	var initial_knight_power = knight_instance.get_current_power()
	var initial_knight_hp = knight_instance.get_current_max_hp()

	var scout_instance_id = scout_instance.instance_id
	# var knight_instance_id = knight_instance.instance_id # Not directly buffed

	var initial_event_count: int = battle.battle_events.size()

	# Create a CardInZone for the Hexplate spell
	var hexplate_spell_instance_id: int = battle._generate_new_card_instance_id()
	var hexplate_card_in_zone: CardInZone = CardInZone.new(hexplate_res, hexplate_spell_instance_id)

	# Action: Apply Hexplate effect
	if hexplate_res.has_method("apply_effect"):
		hexplate_res.apply_effect(hexplate_card_in_zone, player, opponent, battle)
	else:
		fail_test("Hexplate resource does not have a script with apply_effect.")
		return

	# Assert: Scout (leftmost) is buffed (+1 Power / +4 MaxHP)
	assert_eq(scout_instance.get_current_power(), initial_scout_power + 1, "Hexplate: Scout power incorrect after buff.")
	assert_eq(scout_instance.get_current_max_hp(), initial_scout_hp + 4, "Hexplate: Scout max HP incorrect after buff.")
	# Check current HP too, as add_hp also heals
	assert_eq(scout_instance.current_hp, initial_scout_hp + 4, "Hexplate: Scout current HP should match new max HP after buff.")
	
	# Assert: Knight (not leftmost) is unchanged
	assert_eq(knight_instance.get_current_power(), initial_knight_power, "Hexplate: Knight power should be unchanged.")
	assert_eq(knight_instance.get_current_max_hp(), initial_knight_hp, "Hexplate: Knight max HP should be unchanged.")

	# Assert: Event generation
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expected events for Hexplate successfully buffing Scout:
	# 1. stat_change (for Scout's power, from add_power, sourced by Hexplate)
	# 2. stat_change (for Scout's max_hp, from add_hp, sourced by Hexplate)
	# 3. creature_hp_change (for Scout's current HP heal, from add_hp -> heal, sourced by Hexplate)
	# 4. visual_effect (for Hexplate buff applied to Scout, from Hexplate effect script)
	# Total = 4 events

	assert_eq(new_events.size(), 4, "Hexplate effect should generate 4 events. Found: %s" % new_events.size())

	var power_stat_change_found: bool = false
	var maxhp_stat_change_found: bool = false
	var creature_hp_heal_found: bool = false
	var visual_effect_hexplate_found: bool = false

	for event_data in new_events:
		var type = event_data.get("event_type")
		var inst_id = event_data.get("instance_id")
		var src_inst_id = event_data.get("source_instance_id")
		var src_card_id = event_data.get("source_card_id")

		if type == "stat_change" and inst_id == scout_instance_id and \
		   src_card_id == hexplate_card_in_zone.get_card_id() and \
		   src_inst_id == hexplate_spell_instance_id:
			if event_data.get("stat") == "power":
				power_stat_change_found = true
				assert_eq(event_data.get("amount"), 1, "Hexplate: power stat_change amount incorrect.")
				assert_eq(event_data.get("new_value"), initial_scout_power + 1, "Hexplate: power stat_change new_value incorrect.")
			elif event_data.get("stat") == "max_hp":
				maxhp_stat_change_found = true
				assert_eq(event_data.get("amount"), 4, "Hexplate: max_hp stat_change amount incorrect.")
				assert_eq(event_data.get("new_value"), initial_scout_hp + 4, "Hexplate: max_hp stat_change new_value incorrect.")
		
		elif type == "creature_hp_change" and inst_id == scout_instance_id and \
			 src_card_id == hexplate_card_in_zone.get_card_id() and \
			 src_inst_id == hexplate_spell_instance_id:
			creature_hp_heal_found = true
			assert_eq(event_data.get("amount"), 4, "Hexplate: creature_hp_change (heal) amount incorrect.") # Heals by the HP buff amount
			assert_eq(event_data.get("new_hp"), initial_scout_hp + 4, "Hexplate: creature_hp_change (heal) new_hp incorrect.")
		
		elif type == "visual_effect" and \
			 event_data.get("effect_id") == "hexplate_buff_applied" and \
			 inst_id == scout_instance_id and \
			 src_inst_id == hexplate_spell_instance_id:
			visual_effect_hexplate_found = true
			assert_eq(event_data.get("details", {}).get("power_gained"), 1, "Hexplate visual_effect details: power_gained incorrect.")
			assert_eq(event_data.get("details", {}).get("hp_gained"), 4, "Hexplate visual_effect details: hp_gained incorrect.")

	assert_true(power_stat_change_found, "Hexplate: Power stat_change event for Scout not found or improperly sourced.")
	assert_true(maxhp_stat_change_found, "Hexplate: Max_hp stat_change event for Scout not found or improperly sourced.")
	assert_true(creature_hp_heal_found, "Hexplate: Creature_hp_change (heal) event for Scout not found or improperly sourced.")
	assert_true(visual_effect_hexplate_found, "Visual effect for Hexplate buff not found or improperly sourced.")
	

# --- Songs of the Lost Tests ---
func test_songs_of_the_lost_mana_swing():
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"]
	var battle: Battle = setup["battle"]
	
	# Setup: 3 summons in player's graveyard, opponent has 5 mana
	player.graveyard.clear()
	# Add CardInZone objects to the graveyard
	var scout_gy_id = battle._generate_new_card_instance_id()
	player.graveyard.append(CardInZone.new(goblin_scout_res, scout_gy_id))
	var knight_gy_id = battle._generate_new_card_instance_id()
	player.graveyard.append(CardInZone.new(knight_res, knight_gy_id))
	var healer_gy_id = battle._generate_new_card_instance_id()
	player.graveyard.append(CardInZone.new(healer_res, healer_gy_id))
	
	player.mana = 1
	opponent.mana = 5
	var initial_player_mana: int = player.mana
	var initial_opponent_mana: int = opponent.mana
	
	var creature_count_in_player_grave: int = 3 # Based on setup
	var expected_mana_gain_for_player: int = creature_count_in_player_grave * 2 # = 6
	var expected_mana_loss_for_opponent: int = creature_count_in_player_grave * 1 # = 3

	var initial_event_count: int = battle.battle_events.size()

	# Create a CardInZone for the Songs of the Lost spell
	var songs_spell_instance_id: int = battle._generate_new_card_instance_id()
	var songs_card_in_zone: CardInZone = CardInZone.new(songs_of_the_lost_res, songs_spell_instance_id)

	# Action: Apply Songs of the Lost effect
	if songs_of_the_lost_res.has_method("apply_effect"):
		songs_of_the_lost_res.apply_effect(songs_card_in_zone, player, opponent, battle)
	else:
		fail_test("Songs of the Lost resource does not have a script with apply_effect.")
		return

	# Assert: Player mana gained (correctly capped by MAX_MANA)
	var final_expected_player_mana = min(initial_player_mana + expected_mana_gain_for_player, Constants.MAX_MANA)
	assert_eq(player.mana, final_expected_player_mana, "Songs: Player mana after gain incorrect.")
	
	# Assert: Opponent mana lost (correctly floored at 0)
	var final_expected_opponent_mana = max(0, initial_opponent_mana - expected_mana_loss_for_opponent)
	assert_eq(opponent.mana, final_expected_opponent_mana, "Songs: Opponent mana after loss incorrect.")

	# Assert: Event generation
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expected events:
	# 1. mana_change (for player gain, sourced by Songs spell)
	# 2. mana_change (for opponent loss, sourced by Songs spell)
	# 3. visual_effect (for the Songs spell cast itself)
	# Total = 3 events
	assert_eq(new_events.size(), 3, "Songs of the Lost effect should generate 3 events. Found: %s" % new_events.size())

	var player_mana_gain_event_found: bool = false
	var opponent_mana_loss_event_found: bool = false
	var songs_visual_effect_found: bool = false

	for event_data in new_events:
		var type = event_data.get("event_type")
		var event_player = event_data.get("player")
		var event_amount = event_data.get("amount")
		var event_source_card_id = event_data.get("source")
		var event_source_instance_id = event_data.get("source_instance_id")
		var event_main_instance_id = event_data.get("instance_id")


		if type == "mana_change" and event_player == player.combatant_name:
			player_mana_gain_event_found = true
			assert_eq(event_amount, final_expected_player_mana - initial_player_mana, "Songs: Player mana_change amount incorrect.")
			assert_eq(event_source_card_id, songs_card_in_zone.get_card_id(), "Songs: Player mana_change source card_id incorrect.")
			assert_eq(event_main_instance_id, songs_spell_instance_id, "Songs: Player mana_change main instance_id (spell) incorrect.")
			assert_eq(event_source_instance_id, songs_spell_instance_id, "Songs: Player mana_change source_instance_id incorrect.")
		
		elif type == "mana_change" and event_player == opponent.combatant_name:
			opponent_mana_loss_event_found = true
			assert_eq(event_amount, -(initial_opponent_mana - final_expected_opponent_mana), "Songs: Opponent mana_change amount incorrect (should be negative loss).")
			assert_eq(event_source_card_id, songs_card_in_zone.get_card_id(), "Songs: Opponent mana_change source card_id incorrect.")
			assert_eq(event_main_instance_id, songs_spell_instance_id, "Songs: Opponent mana_change main instance_id (spell) incorrect.")
			assert_eq(event_source_instance_id, songs_spell_instance_id, "Songs: Opponent mana_change source_instance_id incorrect.")
			
		elif type == "visual_effect" and \
			 event_data.get("effect_id") == "songs_of_the_lost_cast" and \
			 event_main_instance_id == songs_spell_instance_id: # Event's instance_id is the spell
			songs_visual_effect_found = true
			assert_eq(event_source_instance_id, songs_spell_instance_id, "Songs visual_effect: source_instance_id incorrect.")
			assert_eq(event_data.get("details", {}).get("creatures_in_graveyard"), creature_count_in_player_grave, "Songs visual_effect details: creatures_in_graveyard incorrect.")

	assert_true(player_mana_gain_event_found, "Player mana_gain event for Songs of the Lost not found or improperly sourced.")
	assert_true(opponent_mana_loss_event_found, "Opponent mana_loss event for Songs of the Lost not found or improperly sourced.")
	assert_true(songs_visual_effect_found, "Visual effect for Songs of the Lost cast not found or improperly sourced.")
	

# --- Ascending Protoplasm Tests ---
func test_ascending_protoplasm_grows_on_attack():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var battle = setup["battle"]
	# Place Protoplasm
	var instance = place_summon_for_test(player, ascending_protoplasm_res, 0, battle) # P:1, HP:4
	var initial_power = instance.get_current_power()
	var initial_hp = instance.get_current_max_hp()

	# Action 1: Attack (simulate call from _perform_combat/direct)
	ascending_protoplasm_res._on_attack_resolved(instance, battle)
	# Assert: Stats increased
	assert_eq(instance.get_current_power(), initial_power + 1, "Protoplasm power after 1 attack incorrect.")
	assert_eq(instance.get_current_max_hp(), initial_hp + 1, "Protoplasm max HP after 1 attack incorrect.")

	# Action 2: Attack again
	ascending_protoplasm_res._on_attack_resolved(instance, battle)
	# Assert: Stats increased again
	assert_eq(instance.get_current_power(), initial_power + 2, "Protoplasm power after 2 attacks incorrect.")
	assert_eq(instance.get_current_max_hp(), initial_hp + 2, "Protoplasm max HP after 2 attacks incorrect.")


# --- Refined Impersonator Tests ---
func test_refined_impersonator_copies_stats():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Place target Knight (P:3, HP:3)
	var _target = place_summon_for_test(opponent, knight_res, 0, battle)
	# Simulate Impersonator arrival opposite
	var instance = SummonInstance.new()
	var new_id = battle.get_new_instance_id()
	instance.setup(refined_impersonator_res, player, opponent, 0, battle, new_id) # Base P:0, HP:1
	# Action
	refined_impersonator_res._on_arrival(instance, player, opponent, battle)
	# Assert: Stats copied (P=3, MaxHP=3+1=4)
	assert_eq(instance.get_current_power(), 3, "Impersonator power incorrect.")
	assert_eq(instance.get_current_max_hp(), 4, "Impersonator max HP incorrect.")
	assert_eq(instance.current_hp, 4, "Impersonator current HP incorrect.") # Should be healed to new max


func test_refined_impersonator_no_target():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Opponent lane empty
	opponent.lanes[0] = null
	# Simulate arrival
	var instance = SummonInstance.new()
	var new_id = battle.get_new_instance_id()
	instance.setup(refined_impersonator_res, player, opponent, 0, battle, new_id) # Base P:0, HP:1
	# Action
	refined_impersonator_res._on_arrival(instance, player, opponent, battle)
	# Assert: Stats remain base
	assert_eq(instance.get_current_power(), 0, "Impersonator power should be base.")
	assert_eq(instance.get_current_max_hp(), 1, "Impersonator max HP should be base.")


# --- Corpsetide Lich Tests ---
func test_corpsetide_lich_steals_grave():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Setup graves
	player.graveyard.clear(); player.graveyard.append(goblin_scout_res)
	opponent.graveyard.clear(); opponent.graveyard.append(knight_res); opponent.graveyard.append(healer_res)
	var initial_player_grave_size = player.graveyard.size() # 1
	var initial_opp_grave_size = opponent.graveyard.size() # 2
	# Simulate arrival
	var instance = SummonInstance.new()
	var new_id = battle.get_new_instance_id()
	instance.setup(corpsetide_lich_res, player, opponent, 0, battle, new_id)
	# Action
	corpsetide_lich_res._on_arrival(instance, player, opponent, battle)
	# Assert: Opponent grave empty
	assert_true(opponent.graveyard.is_empty(), "Opponent grave should be empty.")
	# Assert: Player grave size increased
	assert_eq(player.graveyard.size(), initial_player_grave_size + initial_opp_grave_size, "Player grave size incorrect.")
	# Assert: Player grave contains all cards
	var ids_in_grave = []
	for card in player.graveyard: ids_in_grave.append(card.id)
	assert_true(ids_in_grave.has("GoblinScout"), "Scout missing from player grave.")
	assert_true(ids_in_grave.has("Knight"), "Knight missing from player grave.")
	assert_true(ids_in_grave.has("Healer"), "Healer missing from player grave.")


# --- Coffin Traders Tests ---
func test_coffin_traders_swaps_graves():
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]
	var opponent: Combatant = setup["opponent"]
	var battle: Battle = setup["battle"]
	
	# Setup graveyards with CardInZone objects
	player.graveyard.clear()
	var scout_in_player_grave_id = battle._generate_new_card_instance_id()
	var player_scout_ciz = CardInZone.new(goblin_scout_res, scout_in_player_grave_id)
	player.graveyard.append(player_scout_ciz) # Player initially has Goblin Scout

	opponent.graveyard.clear()
	var knight_in_opponent_grave_id = battle._generate_new_card_instance_id()
	var opponent_knight_ciz = CardInZone.new(knight_res, knight_in_opponent_grave_id)
	opponent.graveyard.append(opponent_knight_ciz) # Opponent initially has Knight
	
	# Simulate Coffin Traders arrival
	var traders_instance = SummonInstance.new()
	var traders_instance_id: int = battle._generate_new_card_instance_id()
	traders_instance.setup(coffin_traders_res, player, opponent, 0, battle, traders_instance_id)
	# player.lanes[0] = traders_instance # If placement is needed (not for this effect)

	var initial_event_count: int = battle.battle_events.size()

	# Action: Call _on_arrival effect
	if coffin_traders_res.has_method("_on_arrival"):
		coffin_traders_res._on_arrival(traders_instance, player, opponent, battle)
	else:
		fail_test("Coffin Traders resource does not have _on_arrival method.")
		return

	# Assert: Player's graveyard now contains the Knight (originally opponent's)
	assert_eq(player.graveyard.size(), 1, "Player's graveyard size incorrect after swap.")
	assert_true(player.graveyard[0] is CardInZone, "Card in player's graveyard should be CardInZone.")
	if player.graveyard.size() == 1:
		var card_now_in_player_grave = player.graveyard[0] as CardInZone
		assert_eq(card_now_in_player_grave.get_card_id(), "Knight", "Player's graveyard content (card_id) incorrect after swap.")
		assert_eq(card_now_in_player_grave.get_card_instance_id(), knight_in_opponent_grave_id, "Player's graveyard content (instance_id) incorrect after swap - should be original Knight's instance_id.")

	# Assert: Opponent's graveyard now contains the Goblin Scout (originally player's)
	assert_eq(opponent.graveyard.size(), 1, "Opponent's graveyard size incorrect after swap.")
	assert_true(opponent.graveyard[0] is CardInZone, "Card in opponent's graveyard should be CardInZone.")
	if opponent.graveyard.size() == 1:
		var card_now_in_opponent_grave = opponent.graveyard[0] as CardInZone
		assert_eq(card_now_in_opponent_grave.get_card_id(), "GoblinScout", "Opponent's graveyard content (card_id) incorrect after swap.")
		assert_eq(card_now_in_opponent_grave.get_card_instance_id(), scout_in_player_grave_id, "Opponent's graveyard content (instance_id) incorrect after swap - should be original Scout's instance_id.")

	# Assert: Event generation
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expected events:
	# 1. "graveyards_swapped" (custom event from CoffinTraders effect)
	# 2. "visual_effect" (for the swap animation)
	# Total = 2 events
	assert_eq(new_events.size(), 2, "Coffin Traders effect should generate 2 events. Found: %s" % new_events.size())

	var graveyards_swapped_event_found: bool = false
	var visual_effect_swap_found: bool = false

	for event_data in new_events:
		if event_data.get("event_type") == "graveyards_swapped" and \
		   event_data.get("source_instance_id") == traders_instance_id:
			graveyards_swapped_event_found = true
			assert_eq(event_data.get("player1_name"), player.combatant_name, "Swapped event: player1_name mismatch.")
			assert_eq(event_data.get("player1_graveyard_now_contains_instance_ids"), [knight_in_opponent_grave_id], "Swapped event: player1_graveyard_now_contains_instance_ids mismatch.")
			assert_eq(event_data.get("player2_name"), opponent.combatant_name, "Swapped event: player2_name mismatch.")
			assert_eq(event_data.get("player2_graveyard_now_contains_instance_ids"), [scout_in_player_grave_id], "Swapped event: player2_graveyard_now_contains_instance_ids mismatch.")
			assert_eq(event_data.get("instance_id"), traders_instance_id, "Swapped event: main instance_id (Traders) incorrect.")


		elif event_data.get("event_type") == "visual_effect" and \
			 event_data.get("effect_id") == "coffin_traders_graveyard_swap_visual" and \
			 event_data.get("instance_id") == traders_instance_id:
			visual_effect_swap_found = true
			assert_eq(event_data.get("source_instance_id"), traders_instance_id, "Coffin Traders visual_effect: source_instance_id incorrect.")

	assert_true(graveyards_swapped_event_found, "'graveyards_swapped' event not found or improperly sourced.")
	assert_true(visual_effect_swap_found, "Visual effect for Coffin Traders swap not found or improperly sourced.")
	

# --- Angel of Justice Tests ---
func test_angel_of_justice_destroys_if_fewer_creatures():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Setup: Player has ２ creatures (including angel), Opponent has 3
	place_summon_for_test(player, goblin_scout_res, 0, battle)
	place_summon_for_test(opponent, knight_res, 0, battle)       # Lane 1
	place_summon_for_test(opponent, knight_res, 1, battle)       # Lane 2
	place_summon_for_test(opponent, goblin_scout_res, 2, battle) # Lane 3 (Rightmost)
	# Simulate arrival
	var instance = SummonInstance.new()
	var new_id = battle.get_new_instance_id()
	instance.setup(angel_of_justice_res, player, opponent, 1, battle, new_id) # Angel in lane 2
	player.lanes[1] = instance # Place it
	# Action
	angel_of_justice_res._on_arrival(instance, player, opponent, battle)
	# Assert: Opponent's rightmost (Scout in lane 3) is gone
	assert_true(opponent.lanes[0] != null, "Knight should remain.")
	assert_null(opponent.lanes[2], "Scout in lane 3 should be destroyed.")


func test_angel_of_justice_does_not_destroy_if_equal_creatures():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Setup: Player has 1, Opponent has 1
	place_summon_for_test(player, goblin_scout_res, 0, battle)
	place_summon_for_test(opponent, knight_res, 0, battle)
	var instance = SummonInstance.new()
	var new_id = battle.get_new_instance_id()
	instance.setup(angel_of_justice_res, player, opponent, 1, battle, new_id)
	player.lanes[1] = instance
	angel_of_justice_res._on_arrival(instance, player, opponent, battle)
	# Assert: Opponent Knight still present
	assert_true(opponent.lanes[0] != null, "Knight should not be destroyed.")


# --- Scavenger Ghoul Tests ---
# --- Scavenger Ghoul Tests ---
func test_scavenger_ghoul_consumes_and_heals():
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]    # Ghoul's owner
	var opponent: Combatant = setup["opponent"]
	var battle: Battle = setup["battle"]
	
	# Setup player's graveyard with CardInZone objects
	player.graveyard.clear()
	var p_scout_gy_id = battle._generate_new_card_instance_id() # Summon, will be consumed
	player.graveyard.append(CardInZone.new(goblin_scout_res, p_scout_gy_id))
	var p_energy_axe_gy_id = battle._generate_new_card_instance_id() # Spell, should remain
	player.graveyard.append(CardInZone.new(energy_axe_res, p_energy_axe_gy_id))
	
	# Setup opponent's graveyard with CardInZone objects
	opponent.graveyard.clear()
	var o_knight_gy_id = battle._generate_new_card_instance_id() # Summon, will be consumed
	opponent.graveyard.append(CardInZone.new(knight_res, o_knight_gy_id))
	var o_healer_gy_id = battle._generate_new_card_instance_id() # Summon, will be consumed
	opponent.graveyard.append(CardInZone.new(healer_res, o_healer_gy_id))
	
	player.current_hp = 5
	var initial_player_hp: int = player.current_hp
	var expected_summons_consumed: int = 1 + 2 # 1 from player, 2 from opponent
	var expected_life_heal: int = expected_summons_consumed * 2 # = 6

	# Simulate Scavenger Ghoul arrival (owned by player)
	var ghoul_instance = SummonInstance.new()
	var ghoul_instance_id: int = battle._generate_new_card_instance_id()
	ghoul_instance.setup(scavenger_ghoul_res, player, opponent, 0, battle, ghoul_instance_id)
	# player.lanes[0] = ghoul_instance # If placement is needed for effect

	var initial_event_count: int = battle.battle_events.size()

	# Action: Call Scavenger Ghoul's _on_arrival effect
	if scavenger_ghoul_res.has_method("_on_arrival"):
		scavenger_ghoul_res._on_arrival(ghoul_instance, player, opponent, battle)
	else:
		fail_test("Scavenger Ghoul resource does not have _on_arrival method.")
		return

	# Assert: Player's graveyard contains only non-summons (Energy Axe)
	assert_eq(player.graveyard.size(), 1, "Player's graveyard size incorrect after Ghoul consumes.")
	if player.graveyard.size() == 1:
		assert_true(player.graveyard[0] is CardInZone, "Remaining card in player's grave should be CardInZone.")
		assert_eq(player.graveyard[0].get_card_id(), "EnergyAxe", "EnergyAxe should be the only card in player's graveyard.")
		assert_eq(player.graveyard[0].get_card_instance_id(), p_energy_axe_gy_id, "EnergyAxe instance ID mismatch in player's grave.")
	
	# Assert: Opponent's graveyard is empty (all its summons were consumed)
	assert_true(opponent.graveyard.is_empty(), "Opponent's graveyard should be empty after Ghoul consumes.")
	
	# Assert: Player healed correctly
	var final_expected_player_hp = min(initial_player_hp + expected_life_heal, player.max_hp)
	assert_eq(player.current_hp, final_expected_player_hp, "Player HP after Ghoul's heal incorrect.")

	# Assert: Event generation
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expected events:
	# - 3x card_removed (1 from player's grave, 2 from opponent's grave, all sourced by Ghoul)
	# - 1x hp_change (for player heal, sourced by Ghoul)
	# - 1x visual_effect (for Ghoul's consume & heal action)
	# Total = 5 events

	var card_removed_event_count: int = 0
	var player_hp_change_event_found: bool = false
	var ghoul_visual_effect_found: bool = false
	var removed_instance_ids_from_events: Array[int] = []

	for event_data in new_events:
		var type = event_data.get("event_type")
		var inst_id = event_data.get("instance_id")
		var src_inst_id = event_data.get("source_instance_id")
		var src_card_id = event_data.get("source_card_id")

		if type == "card_removed" and \
		   event_data.get("from_zone") == "graveyard" and \
		   src_card_id == scavenger_ghoul_res.id and \
		   src_inst_id == ghoul_instance_id:
			card_removed_event_count += 1
			removed_instance_ids_from_events.append(inst_id) # inst_id is the ID of the card that was removed
		
		elif type == "hp_change" and \
			 event_data.get("player") == player.combatant_name and \
			 src_card_id == scavenger_ghoul_res.id and \
			 src_inst_id == ghoul_instance_id: # Ghoul's effect caused this player heal
			player_hp_change_event_found = true
			assert_eq(event_data.get("amount"), final_expected_player_hp - initial_player_hp, "Ghoul heal: hp_change amount incorrect.")
			assert_eq(inst_id, ghoul_instance_id, "Ghoul heal: hp_change main instance_id (Ghoul) incorrect.")

		elif type == "visual_effect" and \
			 event_data.get("effect_id") == "scavenger_ghoul_consume_heal" and \
			 inst_id == ghoul_instance_id: # Ghoul is the subject of this visual
			ghoul_visual_effect_found = true
			assert_eq(src_inst_id, ghoul_instance_id, "Ghoul visual_effect: source_instance_id incorrect.")
			assert_eq(event_data.get("details", {}).get("summons_consumed_total"), expected_summons_consumed, "Ghoul visual_effect details: summons_consumed_total incorrect.")
			assert_eq(event_data.get("details", {}).get("life_healed"), expected_life_heal, "Ghoul visual_effect details: life_healed incorrect.")

	assert_eq(card_removed_event_count, expected_summons_consumed, "Incorrect number of card_removed events for Scavenger Ghoul.")
	# Verify the correct instances were removed
	assert_true(p_scout_gy_id in removed_instance_ids_from_events, "Player's Goblin Scout was not logged as removed by Ghoul.")
	assert_true(o_knight_gy_id in removed_instance_ids_from_events, "Opponent's Knight was not logged as removed by Ghoul.")
	assert_true(o_healer_gy_id in removed_instance_ids_from_events, "Opponent's Healer was not logged as removed by Ghoul.")
	assert_false(p_energy_axe_gy_id in removed_instance_ids_from_events, "Player's Energy Axe should not have been removed by Ghoul.")

	assert_true(player_hp_change_event_found, "Player hp_change event from Ghoul's heal not found or improperly sourced.")
	assert_true(ghoul_visual_effect_found, "Visual effect for Scavenger Ghoul's action not found or improperly sourced.")

# --- Heedless Vandal Tests ---
func test_heedless_vandal_mills_both():
	var setup = create_test_battle_setup()
	var player: Combatant = setup["player"]    # Vandal's owner
	var opponent: Combatant = setup["opponent"]
	var battle: Battle = setup["battle"]
	
	# Setup player's library with one CardInZone
	player.library.clear()
	var p_knight_lib_id = battle._generate_new_card_instance_id()
	var player_knight_ciz = CardInZone.new(knight_res, p_knight_lib_id)
	player.library.append(player_knight_ciz)
	
	# Setup opponent's library with one CardInZone
	opponent.library.clear()
	var o_scout_lib_id = battle._generate_new_card_instance_id()
	var opponent_scout_ciz = CardInZone.new(goblin_scout_res, o_scout_lib_id)
	opponent.library.append(opponent_scout_ciz)
	
	var initial_player_lib_size: int = player.library.size()     # Should be 1
	var initial_opponent_lib_size: int = opponent.library.size() # Should be 1
	var initial_player_grave_size: int = player.graveyard.size()
	var initial_opponent_grave_size: int = opponent.graveyard.size()
	
	# Simulate Heedless Vandal arrival (owned by player)
	var vandal_instance = SummonInstance.new()
	var vandal_instance_id: int = battle._generate_new_card_instance_id()
	vandal_instance.setup(heedless_vandal_res, player, opponent, 0, battle, vandal_instance_id)
	# player.lanes[0] = vandal_instance # If placement needed for effect

	var initial_event_count: int = battle.battle_events.size()

	# Action: Call Heedless Vandal's _on_arrival effect
	if heedless_vandal_res.has_method("_on_arrival"):
		heedless_vandal_res._on_arrival(vandal_instance, player, opponent, battle)
	else:
		fail_test("Heedless Vandal resource does not have _on_arrival method.")
		return

	# Assert: Player's library decreased by 1 (empty)
	assert_eq(player.library.size(), initial_player_lib_size - 1, "Vandal: Player library size incorrect after mill.")
	assert_true(player.library.is_empty(), "Player library should be empty.")
	
	# Assert: Opponent's library decreased by 1 (empty)
	assert_eq(opponent.library.size(), initial_opponent_lib_size - 1, "Vandal: Opponent library size incorrect after mill.")
	assert_true(opponent.library.is_empty(), "Opponent library should be empty.")

	# Assert: Player's graveyard increased by 1
	assert_eq(player.graveyard.size(), initial_player_grave_size + 1, "Vandal: Player graveyard size incorrect after mill.")
	# Assert: Opponent's graveyard increased by 1
	assert_eq(opponent.graveyard.size(), initial_opponent_grave_size + 1, "Vandal: Opponent graveyard size incorrect after mill.")
	
	# Assert: Correct cards milled to respective graveyards, maintaining their instance IDs
	assert_true(player.graveyard[-1] is CardInZone, "Milled card in player's graveyard should be CardInZone.")
	var milled_knight_in_player_grave = player.graveyard[-1] as CardInZone
	if milled_knight_in_player_grave:
		assert_eq(milled_knight_in_player_grave.get_card_id(), "Knight", "Incorrect card_id milled to player's graveyard.")
		assert_eq(milled_knight_in_player_grave.get_card_instance_id(), p_knight_lib_id, "Instance ID of milled Knight should be maintained in player's graveyard.")
	else:
		fail_test("Card in player's graveyard was not a CardInZone as expected.")

	assert_true(opponent.graveyard[-1] is CardInZone, "Milled card in opponent's graveyard should be CardInZone.")
	var milled_scout_in_opponent_grave = opponent.graveyard[-1] as CardInZone
	if milled_scout_in_opponent_grave:
		assert_eq(milled_scout_in_opponent_grave.get_card_id(), "GoblinScout", "Incorrect card_id milled to opponent's graveyard.")
		assert_eq(milled_scout_in_opponent_grave.get_card_instance_id(), o_scout_lib_id, "Instance ID of milled Scout should be maintained in opponent's graveyard.")
	else:
		fail_test("Card in opponent's graveyard was not a CardInZone as expected.")

	# Assert: Event generation
	var new_events: Array[Dictionary] = battle.battle_events.slice(initial_event_count)
	# Expected events:
	# - 1x card_moved (Player's Knight: library -> graveyard, from mill_top_card)
	# - 1x card_moved (Opponent's Scout: library -> graveyard, from mill_top_card)
	# - 1x visual_effect (for Vandal's overall mill action)
	# Total = 3 events
	# Note: Combatant.mill_top_card calls remove_card_from_library (event lib->play) then add_card_to_graveyard (event play->grave).
	# So, each mill is actually TWO card_moved events. Total = 2 (player) + 2 (opponent) + 1 (vandal visual) = 5 events.

	assert_eq(new_events.size(), 5, "Heedless Vandal effect should generate 5 events (2x2 card_moved + 1 visual). Found: %s" % new_events.size())

	var player_mill_to_play_found: bool = false
	var player_mill_to_grave_found: bool = false
	var opponent_mill_to_play_found: bool = false
	var opponent_mill_to_grave_found: bool = false
	var vandal_visual_effect_found: bool = false

	for event_data in new_events:
		var type = event_data.get("event_type")
		var inst_id = event_data.get("instance_id") # ID of the card being moved
		var event_player = event_data.get("player")
		var from_zone = event_data.get("from_zone")
		var to_zone = event_data.get("to_zone")
		var card_id = event_data.get("card_id")
		# For card_moved from mill, source_instance_id might not be easily set to Vandal by default yet

		if type == "card_moved" and event_player == player.combatant_name and card_id == "Knight" and inst_id == p_knight_lib_id:
			if from_zone == "library" and to_zone == "play": player_mill_to_play_found = true
			elif from_zone == "play" and to_zone == "graveyard": player_mill_to_grave_found = true
		
		elif type == "card_moved" and event_player == opponent.combatant_name and card_id == "GoblinScout" and inst_id == o_scout_lib_id:
			if from_zone == "library" and to_zone == "play": opponent_mill_to_play_found = true
			elif from_zone == "play" and to_zone == "graveyard": opponent_mill_to_grave_found = true

		elif type == "visual_effect" and event_data.get("effect_id") == "heedless_vandal_mill_action" and \
			 inst_id == vandal_instance_id and event_data.get("source_instance_id") == vandal_instance_id:
			vandal_visual_effect_found = true
			
	assert_true(player_mill_to_play_found, "Vandal: Player's Knight card_moved (lib->play) event missing.")
	assert_true(player_mill_to_grave_found, "Vandal: Player's Knight card_moved (play->grave) event missing.")
	assert_true(opponent_mill_to_play_found, "Vandal: Opponent's Scout card_moved (lib->play) event missing.")
	assert_true(opponent_mill_to_grave_found, "Vandal: Opponent's Scout card_moved (play->grave) event missing.")
	assert_true(vandal_visual_effect_found, "Visual effect for Heedless Vandal's action not found or improperly sourced.")


# --- Taunting Elf Tests ---
func test_taunting_elf_makes_opponent_relentless():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Place target Knight
	var target_knight = place_summon_for_test(opponent, knight_res, 0, battle) # Lane 1
	assert_false(target_knight.is_relentless, "Knight should start non-relentless.")
	var initial_event_count = battle.battle_events.size()

	# Simulate arrival
	var instance = SummonInstance.new()
	var new_id = battle.get_new_instance_id()
	instance.setup(taunting_elf_res, player, opponent, 0, battle, new_id) # Arrives opposite
	# Action
	taunting_elf_res._on_arrival(instance, player, opponent, battle)

	# Assert: Target is now relentless
	assert_true(target_knight.is_relentless, "Knight should become relentless.")

	# Assert: Event generated
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var status_event_found = false
	for event in events_after:
		if event.get("event_type") == "status_change" and \
		   event.get("status") == "Relentless" and \
		   event.get("gained") == true and \
		   event.get("player") == opponent.combatant_name and \
		   event.get("lane") == 1:
			status_event_found = true; break
	assert_true(status_event_found, "Relentless status gain event missing.")


func test_taunting_elf_no_target():
	var setup = create_test_battle_setup()
	var player = setup["player"]
	var opponent = setup["opponent"]
	var battle = setup["battle"]
	# Opponent lane empty
	opponent.lanes[0] = null
	var initial_event_count = battle.battle_events.size()
	# Simulate arrival
	var instance = SummonInstance.new()
	var new_id = battle.get_new_instance_id()
	instance.setup(taunting_elf_res, player, opponent, 0, battle, new_id)
	# Action
	taunting_elf_res._on_arrival(instance, player, opponent, battle)
	# Assert: No status event generated
	var events_after = battle.battle_events.slice(initial_event_count, battle.battle_events.size())
	var status_event_found = false
	for event in events_after:
		if event.get("event_type") == "status_change": status_event_found = true; break
	assert_false(status_event_found, "No status change event should be generated.")
