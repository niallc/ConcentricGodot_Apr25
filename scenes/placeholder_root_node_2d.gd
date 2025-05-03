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

	var avenging_tiger_res = load("res://data/cards/instances/avenging_tiger.tres") as SummonCardResource
	var _charging_bull_res = load("res://data/cards/instances/charging_bull.tres") as SummonCardResource
	var _disarm_res = load("res://data/cards/instances/disarm.tres") as SpellCardResource
	var energy_axe_res = load("res://data/cards/instances/energy_axe.tres") as SpellCardResource
	var focus_res = load("res://data/cards/instances/focus.tres") as SpellCardResource
	var goblin_firework_res = load("res://data/cards/instances/goblin_firework.tres") as SummonCardResource
	var goblin_scout_res = load("res://data/cards/instances/goblin_scout.tres") as SummonCardResource
	var healer_res = load("res://data/cards/instances/healer.tres") as SummonCardResource # Example
	var knight_res = load("res://data/cards/instances/knight.tres") as SummonCardResource
	var portal_mage_res = load("res://data/cards/instances/portal_mage.tres") as SummonCardResource
	var recurring_skeleton_res = load("res://data/cards/instances/recurring_skeleton.tres") as SummonCardResource
	var wall_of_vines_res = load("res://data/cards/instances/wall_of_vines.tres") as SummonCardResource

	if not (goblin_scout_res and energy_axe_res and healer_res):
		printerr("Failed to load all required card resources!")
		return # Stop if resources didn't load

	# Test instantiating Battle
	var battle_sim = Battle.new()
	if battle_sim:
		print("Battle instance created.")
		print("Loaded Card: %s, Cost: %d" % [card_res.card_name, card_res.cost])
		#var deck1: Array[CardResource] = [goblin_scout_res, energy_axe_res]
		#var deck2: Array[CardResource] = [healer_res, goblin_scout_res]
		var deck1: Array[CardResource] = [wall_of_vines_res, portal_mage_res, goblin_firework_res, recurring_skeleton_res]
		var deck2: Array[CardResource] = [focus_res, avenging_tiger_res, healer_res, knight_res]
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
