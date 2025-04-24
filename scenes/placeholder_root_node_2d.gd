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

	# Test instantiating Battle
	var battle_sim = Battle.new()
	if battle_sim:
		print("Battle instance created.")
		# Prepare minimal decks (using loaded resources)
		#var deck1 = [card_res] # Just one Goblin Scout
		#var deck2 = [] # Empty deck for opponent
		print("Loaded Card: %s, Cost: %d" % [card_res.card_name, card_res.cost])
		# --- FIX IS HERE ---
		var deck1: Array[CardResource] = [card_res] # Explicitly type the array
		var deck2: Array[CardResource] = []        # Good practice to type this too
		# --- END FIX ---

		# ---<<< THIS WILL CALL YOUR FUNCTION >>>---
		var events = battle_sim.run_battle(deck1, deck2, "Player", "Opponent")
		print("run_battle finished. Events list:")
		# Print first few events for inspection
		for i in min(5, events.size()):
			print("  ", events[i])
		print("------------------------------------")

	else:
		printerr("Failed to create Battle instance!")
