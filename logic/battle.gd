# res://logic/battle.gd
extends Object
class_name Battle

var duelist1: Combatant
var duelist2: Combatant
var turn_count: int = 0
var battle_events: Array[Dictionary] = []
var _event_timestamp_counter: float = 0.0 # Use float for finer granularity
var _event_id_counter: int = 0 # Unique ID per event
var _next_instance_id: int = 0 # Counter for summon instances
# New (2025/05/13) card instancing approach (below)
var _next_card_instance_id: int = 1 

var rng = RandomNumberGenerator.new()
var current_seed = 0 # Store the seed used

var battle_state = "Ongoing" # "Ongoing", "Finished"

func get_new_instance_id() -> int:
	_next_instance_id += 1
	return _next_instance_id

# New (2025/05/13) method to generate unique card instance IDs for this battle
## Generates and returns a new unique ID for a card instance.
## These IDs are unique within the scope of this single battle.
func _generate_new_card_instance_id() -> int:
	var new_id = _next_card_instance_id
	_next_card_instance_id += 1
	return new_id

func run_battle(deck1: Array[CardResource], deck2: Array[CardResource], name1: String, name2: String, my_seed: int = 0) -> Array[Dictionary]:
	# print("Is it an Ostrich, a Quokka, a Polar Bear, or a Marmot?")
	battle_events.clear()
	_event_timestamp_counter = 0.0
	_event_id_counter = 0
	_next_instance_id = 0 # Reset instance counter for each battle
	_next_card_instance_id = 1 # Crucial: Reset ID counter for each new battle
	turn_count = 0
	battle_state = "Ongoing"

	if my_seed == 0:
		rng.randomize()
		current_seed = rng.get_state() # Store the generated seed state if needed
	else:
		rng.seed = my_seed
		current_seed = my_seed

	print("Starting battle. Seed: %s" % str(current_seed))

	duelist1 = Combatant.new()
	duelist2 = Combatant.new()
	duelist1.setup(deck1, Constants.STARTING_HP, name1, self, duelist2)
	duelist2.setup(deck2, Constants.STARTING_HP, name2, self, duelist1)

	var active_duelist = duelist1
	var opponent_duelist = duelist2

	var p1_initial_library_ids: Array[String] = []
	for card_res in duelist1.library: # deck1 is the array of CardResource
		p1_initial_library_ids.append(card_res.id)
	add_event({
		"event_type": "initial_library_state",
		"player": duelist1.combatant_name,
		"card_ids": p1_initial_library_ids,
		"instance_id": "None, Library Initialization"
		# 'turn' will be 0, 'timestamp' will be among the first
	})

	var p2_initial_library_ids: Array[String] = []
	for card_res in duelist2.library: # deck2 is the array of CardResource
		p2_initial_library_ids.append(card_res.id)
	add_event({
		"event_type": "initial_library_state",
		"player": duelist2.combatant_name,
		"card_ids": p2_initial_library_ids,
		"instance_id": "None, Library Initialization"
	})
	while battle_state == "Ongoing" and turn_count < Constants.MAX_TURNS:
		print("\n--- Turn %d (%s) ---" % [turn_count, active_duelist.combatant_name])
		conduct_turn(active_duelist, opponent_duelist)

		if battle_state != "Ongoing": break # Check if game ended mid-turn

		# Swap roles
		var temp = active_duelist
		active_duelist = opponent_duelist
		opponent_duelist = temp

		turn_count += 1 # Increment turn *after* both players have acted (or adjust logic)

	if battle_state == "Ongoing": # Check if ended due to turn limit
		log_winner()

	print("Battle finished. Events generated: %d" % battle_events.size())
	return battle_events

func conduct_turn(active_duelist: Combatant, opponent_duelist: Combatant):
	if battle_state != "Ongoing": return

	add_event({"event_type": "turn_start", "player": active_duelist.combatant_name, "instance_id": active_duelist.combatant_name})

	# 1. Start of Turn Effects / Mana Gain
	active_duelist.gain_mana(Constants.MANA_PER_TURN, "None, turn start mana", -1)
	# TODO: Add start-of-turn triggers for summons/player effects here

	if check_game_over(): return

	# 2. Card Play Phase
	# Summary: Implement card draw/play logic based on v1 spec pseudocode
	# - Get top card: active_duelist.library[0]
	# - Check can_play (mana, custom script check)
	# - Check lanes (if Summon)
	# - Pay mana: active_duelist.pay_mana()
	# - Remove card: active_duelist.remove_card_from_library()
	# - If Spell: card_script.apply_effect(...); active_duelist.add_card_to_graveyard(...)
	# - If Summon: Create SummonInstance, place in lane, generate summon_arrives, call _on_arrival
	if not active_duelist.library.is_empty():
		var top_card_in_zone: CardInZone = active_duelist.library[0]
		var top_card_resource: CardResource = top_card_in_zone.card_resource # Get the underlying resource
		if not top_card_resource: # Safety check
			printerr("Battle.conduct_turn: Top card in zone has no underlying CardResource!")
			return 

		var card_script_instance = null
		if top_card_resource.script != null:
			card_script_instance = top_card_resource.script.new()
			# NOTE: We might want to cache these script instances if .new() is slow,
			# but for now, creating it on demand is fine.
			card_script_instance = top_card_resource.script.new()

		# --- Check Playability ---
		var play_cost = top_card_resource.cost
		var can_afford = active_duelist.mana >= play_cost
		var custom_can_play = true
		var lane_available = true # Assume true unless it's a summon that needs one

		# Custom script check (if method exists)
		if card_script_instance != null and card_script_instance.has_method("can_play"):
			custom_can_play = card_script_instance.can_play(active_duelist, opponent_duelist, turn_count, self)

		# Lane check (only if it's a SummonCardResource)
		if top_card_in_zone is CardInZone:
			if active_duelist.find_first_empty_lane() == -1:
				lane_available = false

		# --- Attempt Play ---
		if can_afford and custom_can_play and lane_available:
			print("Attempting to play: %s (Instance: %s)" % [top_card_resource.card_name, top_card_in_zone.instance_id])
			var played_card_in_zone_obj: CardInZone = active_duelist.remove_card_from_library() 
			# Pay Cost
			if active_duelist.pay_mana(play_cost): # pay_mana generates mana_change event
				# Remove Card from Library (generates card_moved library -> play)
				#var played_card_res = active_duelist.remove_card_from_library()
				var underlying_played_card_res = played_card_in_zone_obj.card_resource

				if underlying_played_card_res != null: # Should always succeed if library wasn't empty
					# Generate Summary Event
					add_event({
						"event_type": "card_played",
						"player": active_duelist.combatant_name,
						"card_id": underlying_played_card_res.id,
						"card_type": underlying_played_card_res.get_card_type(), # "Spell" or "Summon"
						"remaining_mana": active_duelist.mana,
						"instance_id": played_card_in_zone_obj.instance_id # Log the instance_id of the card that was played
						# Lane added by summon_arrives event if applicable
					})

					# --- Resolve Effect ---
					if underlying_played_card_res is SummonCardResource:
						var summon_card_res = underlying_played_card_res as SummonCardResource
						var target_lane_index = active_duelist.find_first_empty_lane() # Find again to be safe

						if target_lane_index != -1:
							var new_summon = SummonInstance.new()
							var new_summon_instance_id = _generate_new_card_instance_id() # ID for the creature ON THE FIELD
							new_summon.setup(summon_card_res, active_duelist, opponent_duelist, target_lane_index, self, new_summon_instance_id)

							# Place in logic lane
							active_duelist.place_summon_in_lane(new_summon, target_lane_index)

							# Generate Arrives Event
							add_event({
								"event_type": "summon_arrives",
								"player": active_duelist.combatant_name,
								"card_id": summon_card_res.id,
								"lane": target_lane_index + 1, # 1-based
								"instance_id": new_summon_instance_id, # The SummonInstance's unique ID
								"power": new_summon.get_current_power(), # Use calculated value
								"max_hp": new_summon.get_current_max_hp(),
								"current_hp": new_summon.current_hp,
								"is_swift": new_summon.is_swift
							})

							# Generate Moved Event (play -> lane)
							add_event({
								"event_type": "card_moved",
								"card_id": underlying_played_card_res.id,
								"player": active_duelist.combatant_name,
								"from_zone": "play",
								"to_zone": "lane",
								"to_details": {"lane": target_lane_index + 1},
								"instance_id": new_summon_instance_id # The ID of the new SummonInstance in the lane
							})

							# Call _on_arrival effect script (if it exists)
							# The effect script is responsible for its own events
							if new_summon.script_instance != null and new_summon.script_instance.has_method("_on_arrival"):
								new_summon.script_instance._on_arrival(new_summon, active_duelist, opponent_duelist, self)

						else:
							# This case should ideally be prevented by the lane_available check, but log defensively
							printerr("Error: Tried to summon %s but no empty lane found after check!" % summon_card_res.card_name)
							# Should the card go to graveyard? Or fizzle? Let's assume graveyard for now.
							active_duelist.add_card_to_graveyard(played_card_in_zone_obj, "play", played_card_in_zone_obj.instance_id)


					elif underlying_played_card_res is SpellCardResource:
						var spell_card_res = underlying_played_card_res as SpellCardResource
						# Call apply_effect script (if it exists)
						# The effect script is responsible for its own events
						if card_script_instance != null and card_script_instance.has_method("apply_effect"):
							# *** PASS the spell_card_res ***
							card_script_instance.apply_effect(spell_card_res, played_card_in_zone_obj.instance_id, active_duelist, opponent_duelist, self)

						else:
							print("Warning: Spell %s has no apply_effect method." % spell_card_res.card_name)

						# Add spell to graveyard (generates card_moved play -> graveyard)
						# The played_card_in_zone_obj is the spell instance that was played.
						# Its instance_id is passed as p_instance_id_if_relevant because that's the ID
						# it had in the 'play' zone.
						active_duelist.add_card_to_graveyard(played_card_in_zone_obj, "play", played_card_in_zone_obj.instance_id)
						# I think the line below is now obsolete (13th May 2025, 19.25)
						# active_duelist.add_card_to_graveyard(spell_card_res, "play")

				else:
					printerr("Error: Failed to remove card from library after paying mana.")
			else:
				# This shouldn't happen if can_afford was true, but log defensively
				printerr("Error: Failed to pay mana for %s even though check passed." % top_card_resource.card_name)

		# else: # Card could not be played (mana, custom check, or no lane)
			# print("Could not play %s" % top_card.card_name) # Optional: Log non-play event?

	else: # Library is empty
		print("%s has no cards left to play." % active_duelist.combatant_name)


	if check_game_over(): return # Check if game ended due to card play effects


	# 3. Summon Activity Phase
	print("Summon Activity for %s" % active_duelist.combatant_name)
	var summons_to_act = active_duelist.lanes.filter(func(s): return s != null)
	for summon_instance in summons_to_act:
		if not summon_instance.is_newly_arrived or summon_instance.is_swift:
			summon_instance.perform_turn_activity()
			if check_game_over(): return # Check after each attack
		else:
			print("%s skips action (newly arrived)" % summon_instance.card_resource.card_name)

	# 4. End of Turn Phase
	print("End of Turn for %s" % active_duelist.combatant_name)
	for summon_instance in active_duelist.lanes:
		if summon_instance != null:
			summon_instance._end_of_turn_upkeep() # Process modifiers, reset flags
	# TODO: Add end-of-turn triggers

func add_event(event_data: Dictionary):
	event_data["turn"] = turn_count
	event_data["timestamp"] = _event_timestamp_counter
	event_data["event_id"] = _event_id_counter
	_event_timestamp_counter += 0.1 # Increment timestamp slightly for ordering
	_event_id_counter += 1
	battle_events.append(event_data)
	#if _event_id_counter == 78:
		#printerr("Temporary debugging to find out what's going on with instance_id.")
	if "instance_id" not in event_data.keys():
		printerr("instance_id missing from event_data")
	if event_data.size() <= 3:
		printerr("event_data does not contain required information: turn %d, timestamp %d, event_id %d",
				 turn_count, _event_id_counter, _event_id_counter)
	# print("Event Added: ", event_data) # Uncomment for verbose logging

func check_game_over() -> bool:
	if duelist1.current_hp <= 0 or duelist2.current_hp <= 0:
		if battle_state == "Ongoing": # Only log winner once
			log_winner()
		return true
	return false

func log_winner():
	battle_state = "Finished"
	var outcome = "Draw (Player loss)"
	var winner_name = "Computer Opponent"

	if duelist1.current_hp <= 0 and duelist2.current_hp > 0:
		outcome = "Duelist2 Wins" # Adjust based on who is player/adversary later
		winner_name = duelist2.combatant_name
	elif duelist2.current_hp <= 0 and duelist1.current_hp > 0:
		outcome = "Duelist1 Wins"
		winner_name = duelist1.combatant_name
	#elif turn_count >= Constants.MAX_TURNS: # Already handled by loop condition check
		#outcome = "Draw (Turn Limit)"

	add_event({
		"event_type": "battle_end",
		"outcome": outcome,
		"winner": winner_name,
		"instance_id": "None, logging winner."
	})
	print("Battle Over! Outcome: %s, Winner: %s" % [outcome, winner_name])
