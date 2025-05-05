# res://scenes/placeholder_root_node_2d.gd
extends Node2D

func _ready():
	print("--- Running Temporary _ready() Test ---")

	# Test loading a resource
	var card_res = load("res://data/cards/instances/goblin_scout.tres") as SummonCardResource
	if card_res:
		print("Loaded Card: %s, Cost: %d" % [card_res.card_name, card_res.cost])
	else:
		printerr("Failed to load card resource!")

	var _apprentice_assassin_res = load("res://data/cards/instances/apprentice_assassin.tres") as SummonCardResource
	var _amnesia_mage_res = load("res://data/cards/instances/amnesia_mage.tres") as SummonCardResource
	var _avenging_tiger_res = load("res://data/cards/instances/avenging_tiger.tres") as SummonCardResource
	var _bloodrager_res = load("res://data/cards/instances/bloodrager.tres") as SummonCardResource
	var _charging_bull_res = load("res://data/cards/instances/charging_bull.tres") as SummonCardResource
	var _cursed_samurai_res = load("res://data/cards/instances/cursed_samurai.tres") as SummonCardResource
	var _disarm_res = load("res://data/cards/instances/disarm.tres") as SpellCardResource
	var _energy_axe_res = load("res://data/cards/instances/energy_axe.tres") as SpellCardResource
	var _focus_res = load("res://data/cards/instances/focus.tres") as SpellCardResource
	var _goblin_chieftain_res = load("res://data/cards/instances/goblin_chieftain.tres") as SummonCardResource
	var _goblin_firework_res = load("res://data/cards/instances/goblin_firework.tres") as SummonCardResource
	var _goblin_rally_res = load("res://data/cards/instances/goblin_rally.tres") as SpellCardResource
	var _goblin_scout_res = load("res://data/cards/instances/goblin_scout.tres") as SummonCardResource
	var _goblin_warboss_res = load("res://data/cards/instances/goblin_warboss.tres") as SummonCardResource
	var _healer_res = load("res://data/cards/instances/healer.tres") as SummonCardResource
	var _inexorable_ooze_res = load("res://data/cards/instances/inexorable_ooze.tres") as SummonCardResource
	var _insatiable_devourer_res = load("res://data/cards/instances/insatiable_devourer.tres") as SummonCardResource
	var _knight_res = load("res://data/cards/instances/knight.tres") as SummonCardResource
	var _master_of_strategy_res = load("res://data/cards/instances/master_of_strategy.tres") as SummonCardResource
	var _nap_res = load("res://data/cards/instances/nap.tres") as SpellCardResource
	var _overconcentrate_res = load("res://data/cards/instances/overconcentrate.tres") as SpellCardResource
	var _portal_mage_res = load("res://data/cards/instances/portal_mage.tres") as SummonCardResource
	var _reanimate_res = load("res://data/cards/instances/reanimate.tres") as SpellCardResource
	var _recurring_skeleton_res = load("res://data/cards/instances/recurring_skeleton.tres") as SummonCardResource
	var _repentant_samurai_res = load("res://data/cards/instances/repentant_samurai.tres") as SummonCardResource
	var _slayer_res = load("res://data/cards/instances/slayer.tres") as SummonCardResource
	var _spiteful_fang_res = load("res://data/cards/instances/spiteful_fang.tres") as SummonCardResource
	var _superior_intellect_res = load("res://data/cards/instances/superior_intellect.tres") as SpellCardResource
	var _thought_acquirer_res = load("res://data/cards/instances/thought_acquirer.tres") as SummonCardResource
	var _totem_of_champions_res = load("res://data/cards/instances/totem_of_champions.tres") as SpellCardResource
	var _vengeful_warlord_res = load("res://data/cards/instances/vengeful_warlord.tres") as SummonCardResource
	var _wall_of_vines_res = load("res://data/cards/instances/wall_of_vines.tres") as SummonCardResource
	var _goblin_recruiter_res = load("res://data/cards/instances/goblin_recruiter.tres") as SummonCardResource
	var _corpsecraft_titan_res = load("res://data/cards/instances/corpsecraft_titan.tres") as SummonCardResource
	var _glassgraft_res = load("res://data/cards/instances/glassgraft.tres") as SpellCardResource
	var _unmake_res = load("res://data/cards/instances/unmake.tres") as SpellCardResource
	var _skeletal_infantry_res = load("res://data/cards/instances/skeletal_infantry.tres") as SummonCardResource
	var _reassembling_legion_res = load("res://data/cards/instances/reassembling_legion.tres") as SummonCardResource
	var _ghoul_res = load("res://data/cards/instances/ghoul.tres") as SummonCardResource

	var _dreadhorde_res = load("res://data/cards/instances/dreadhorde.tres") as SummonCardResource
	var _bog_giant_res = load("res://data/cards/instances/bog_giant.tres") as SummonCardResource
	var _knight_of_opposites_res = load("res://data/cards/instances/knight_of_opposites.tres") as SummonCardResource
	var _malignant_imp_res = load("res://data/cards/instances/malignant_imp.tres") as SummonCardResource
	var _walking_sarcophagus_res = load("res://data/cards/instances/walking_sarcophagus.tres") as SummonCardResource
	var _indulged_princeling_res = load("res://data/cards/instances/indulged_princeling.tres") as SummonCardResource

	# Test instantiating Battle
	var battle_sim = Battle.new()
	if battle_sim:
		print("Battle instance created.")
		print("Loaded Card: %s, Cost: %d" % [card_res.card_name, card_res.cost])
		var deck1: Array[CardResource] = [_wall_of_vines_res, _wall_of_vines_res, _healer_res]
		var deck2: Array[CardResource] = [_indulged_princeling_res, _healer_res, _knight_res, _walking_sarcophagus_res]
		# ---<<< THIS WILL CALL YOUR FUNCTION >>>---
		var events = battle_sim.run_battle(deck1, deck2, "Player", "Opponent")

		var event_count = events.size()
		print("run_battle finished. Events list (%d events):" % event_count)

		var max_events_to_show = 25 # Show all if fewer than this
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
