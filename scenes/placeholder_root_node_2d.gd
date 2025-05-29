extends Node2D

# Preload the replay scene
const BattleReplayScene = preload("res://scenes/battle_replay_scene.tscn")

func _ready():
	print("--- Running Temporary _ready() Test ---")

	# Test loading a resource
	var card_res = load("res://data/cards/instances/goblin_scout.tres") as SummonCardResource
	if card_res:
		print("Loaded Card: %s, Cost: %d" % [card_res.card_name, card_res.cost])
	else:
		printerr("Failed to load card resource!")

	var _amnesia_mage_res = load("res://data/cards/instances/amnesia_mage.tres") as SummonCardResource
	var _angel_of_justice_res = load("res://data/cards/instances/angel_of_justice.tres") as SummonCardResource
	var _apprentice_assassin_res = load("res://data/cards/instances/apprentice_assassin.tres") as SummonCardResource
	var _ascending_protoplasm_res = load("res://data/cards/instances/ascending_protoplasm.tres") as SummonCardResource
	var _avenging_tiger_res = load("res://data/cards/instances/avenging_tiger.tres") as SummonCardResource
	var _bloodrager_res = load("res://data/cards/instances/bloodrager.tres") as SummonCardResource
	var _bog_giant_res = load("res://data/cards/instances/bog_giant.tres") as SummonCardResource
	var _carnivorous_plant_res = load("res://data/cards/instances/carnivorous_plant.tres") as SummonCardResource
	var _chanter_of_ashes_res = load("res://data/cards/instances/chanter_of_ashes.tres") as SummonCardResource
	var _charging_bull_res = load("res://data/cards/instances/charging_bull.tres") as SummonCardResource
	var _coffin_traders_res = load("res://data/cards/instances/coffin_traders.tres") as SummonCardResource
	var _corpsecraft_titan_res = load("res://data/cards/instances/corpsecraft_titan.tres") as SummonCardResource
	var _corpsetide_lich_res = load("res://data/cards/instances/corpsetide_lich.tres") as SummonCardResource
	var _cursed_samurai_res = load("res://data/cards/instances/cursed_samurai.tres") as SummonCardResource
	var _disarm_res = load("res://data/cards/instances/disarm.tres") as SpellCardResource
	var _dreadhorde_res = load("res://data/cards/instances/dreadhorde.tres") as SummonCardResource
	var _elsewhere_res = load("res://data/cards/instances/elsewhere.tres") as SpellCardResource
	var _energy_axe_res = load("res://data/cards/instances/energy_axe.tres") as SpellCardResource
	var _focus_res = load("res://data/cards/instances/focus.tres") as SpellCardResource
	var _ghoul_res = load("res://data/cards/instances/ghoul.tres") as SummonCardResource
	var _flamewielder_res = load("res://data/cards/instances/flamewielder.tres") as SummonCardResource
	var _goblin_gladiator_res = load("res://data/cards/instances/goblin_gladiator.tres") as SummonCardResource
	var _goblin_chieftain_res = load("res://data/cards/instances/goblin_chieftain.tres") as SummonCardResource
	var _goblin_firework_res = load("res://data/cards/instances/goblin_firework.tres") as SummonCardResource
	var _goblin_rally_res = load("res://data/cards/instances/goblin_rally.tres") as SpellCardResource
	var _goblin_recruiter_res = load("res://data/cards/instances/goblin_recruiter.tres") as SummonCardResource
	var _goblin_scout_res = load("res://data/cards/instances/goblin_scout.tres") as SummonCardResource
	var _goblin_warboss_res = load("res://data/cards/instances/goblin_warboss.tres") as SummonCardResource
	var _glassgraft_res = load("res://data/cards/instances/glassgraft.tres") as SpellCardResource
	var _healer_res = load("res://data/cards/instances/healer.tres") as SummonCardResource
	var _heedless_vandal_res = load("res://data/cards/instances/heedless_vandal.tres") as SummonCardResource
	var _hexplate_res = load("res://data/cards/instances/hexplate.tres") as SpellCardResource
	var _indulged_princeling_res = load("res://data/cards/instances/indulged_princeling.tres") as SummonCardResource
	var _inexorable_ooze_res = load("res://data/cards/instances/inexorable_ooze.tres") as SummonCardResource
	var _inferno_res = load("res://data/cards/instances/inferno.tres") as SpellCardResource
	var _insatiable_devourer_res = load("res://data/cards/instances/insatiable_devourer.tres") as SummonCardResource
	var _knight_res = load("res://data/cards/instances/knight.tres") as SummonCardResource
	var _knight_of_opposites_res = load("res://data/cards/instances/knight_of_opposites.tres") as SummonCardResource
	var _malignant_imp_res = load("res://data/cards/instances/malignant_imp.tres") as SummonCardResource
	var _master_of_strategy_res = load("res://data/cards/instances/master_of_strategy.tres") as SummonCardResource
	var _nap_res = load("res://data/cards/instances/nap.tres") as SpellCardResource
	var _overconcentrate_res = load("res://data/cards/instances/overconcentrate.tres") as SpellCardResource
	var _portal_mage_res = load("res://data/cards/instances/portal_mage.tres") as SummonCardResource
	var _reanimate_res = load("res://data/cards/instances/reanimate.tres") as SpellCardResource
	var _recurring_skeleton_res = load("res://data/cards/instances/recurring_skeleton.tres") as SummonCardResource
	var _repentant_samurai_res = load("res://data/cards/instances/repentant_samurai.tres") as SummonCardResource
	var _reassembling_legion_res = load("res://data/cards/instances/reassembling_legion.tres") as SummonCardResource
	var _skeletal_infantry_res = load("res://data/cards/instances/skeletal_infantry.tres") as SummonCardResource
	var _slayer_res = load("res://data/cards/instances/slayer.tres") as SummonCardResource
	var _spiteful_fang_res = load("res://data/cards/instances/spiteful_fang.tres") as SummonCardResource
	var _superior_intellect_res = load("res://data/cards/instances/superior_intellect.tres") as SpellCardResource
	var _totem_of_champions_res = load("res://data/cards/instances/totem_of_champions.tres") as SpellCardResource
	var _rampaging_cyclops_res = load("res://data/cards/instances/rampaging_cyclops.tres") as SummonCardResource
	var _refined_impersonator_res = load("res://data/cards/instances/refined_impersonator.tres") as SummonCardResource
	var _river_efreet_res = load("res://data/cards/instances/river_efreet.tres") as SummonCardResource
	var _scavenger_ghoul_res = load("res://data/cards/instances/scavenger_ghoul.tres") as SummonCardResource
	var _songs_of_the_lost_res = load("res://data/cards/instances/songs_of_the_lost.tres") as SpellCardResource
	var _taunting_elf_res = load("res://data/cards/instances/taunting_elf.tres") as SummonCardResource
	var _thought_acquirer_res = load("res://data/cards/instances/thought_acquirer.tres") as SummonCardResource
	var _troll_res = load("res://data/cards/instances/troll.tres") as SummonCardResource
	var _unmake_res = load("res://data/cards/instances/unmake.tres") as SpellCardResource
	var _vampire_swordmaster = load("res://data/cards/instances/vampire_swordmaster.tres") as SummonCardResource
	var _vengeful_warlord_res = load("res://data/cards/instances/vengeful_warlord.tres") as SummonCardResource
	var _wall_of_vines_res = load("res://data/cards/instances/wall_of_vines.tres") as SummonCardResource
	var _walking_sarcophagus_res = load("res://data/cards/instances/walking_sarcophagus.tres") as SummonCardResource


# 	# Test instantiating Battle
	var battle_sim = Battle.new()
	print("Battle instance created.")
	print("Loaded Card: %s, Cost: %d" % [card_res.card_name, card_res.cost])
	var opp_deck: Array[CardResource] = [_overconcentrate_res, _taunting_elf_res, _scavenger_ghoul_res, _unmake_res]
	var pla_deck: Array[CardResource] = [_healer_res, _coffin_traders_res, _superior_intellect_res, _reanimate_res]
	var events = battle_sim.run_battle(pla_deck, opp_deck, "Player", "Opponent")
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
