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
	for card_in_zone in duelist1.library: # deck1 is the array of CardResource
		p1_initial_library_ids.append(card_in_zone.card_resource.id)
	add_event({
		"event_type": "initial_library_state",
		"player": duelist1.combatant_name,
		"card_ids": p1_initial_library_ids,
		"instance_id": "None, Library Initialization"
		# 'turn' will be 0, 'timestamp' will be among the first
	})

	var p2_initial_library_ids: Array[String] = []
	for card_in_zone in duelist2.library: # deck2 is the array of CardResource
		p2_initial_library_ids.append(card_in_zone.card_resource.id)
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

	_handle_turn_start(active_duelist)
	if check_game_over(): return

	_handle_card_play_phase(active_duelist, opponent_duelist)
	if check_game_over(): return

	_handle_summon_activity_phase(active_duelist)
	if check_game_over(): return

	_handle_end_of_turn_phase(active_duelist)

func _handle_turn_start(active_duelist: Combatant):
	add_event({"event_type": "turn_start", "player": active_duelist.combatant_name, "instance_id": active_duelist.combatant_name})
	active_duelist.gain_mana(Constants.MANA_PER_TURN, "None, turn start mana", -1)
	# TODO: Add start-of-turn triggers for summons/player effects here

func _handle_card_play_phase(active_duelist: Combatant, opponent_duelist: Combatant):
	if active_duelist.library.is_empty():
		print("%s has no cards left to play." % active_duelist.combatant_name)
		return

	var top_card_in_zone: CardInZone = active_duelist.library[0]
	var top_card_resource: CardResource = top_card_in_zone.card_resource
	if not top_card_resource:
		printerr("Battle._handle_card_play_phase: Top card in zone has no underlying CardResource!")
		return

	var card_script_instance = _get_card_script_instance(top_card_resource)
	var playability_result = _check_card_playability(top_card_in_zone, card_script_instance, active_duelist, opponent_duelist)
	
	if playability_result.can_play:
		_play_card(top_card_in_zone, card_script_instance, active_duelist, opponent_duelist)

func _get_card_script_instance(card_resource: CardResource):
	if card_resource.script != null:
		return card_resource.script.new()
	return null

func _check_card_playability(card_in_zone: CardInZone, script_instance, active_duelist: Combatant, opponent_duelist: Combatant) -> Dictionary:
	var card_resource = card_in_zone.card_resource
	var play_cost = card_resource.cost
	var can_afford = active_duelist.mana >= play_cost
	var custom_can_play = true
	var lane_available = true

	# Custom script check
	if script_instance != null and script_instance.has_method("can_play"):
		custom_can_play = script_instance.can_play(active_duelist, opponent_duelist, turn_count, self)

	# Lane check for summons
	if card_resource is SummonCardResource:
		if active_duelist.find_first_empty_lane() == -1:
			lane_available = false

	return {
		"can_play": can_afford and custom_can_play and lane_available,
		"can_afford": can_afford,
		"custom_can_play": custom_can_play,
		"lane_available": lane_available
	}

func _play_card(card_in_zone: CardInZone, script_instance, active_duelist: Combatant, opponent_duelist: Combatant):
	var card_resource = card_in_zone.card_resource
	print("Attempting to play: %s (Instance: %s)" % [card_resource.card_name, card_in_zone.instance_id])
	
	var played_card_in_zone_obj: CardInZone = active_duelist.remove_card_from_library()
	if not active_duelist.pay_mana(card_resource.cost):
		printerr("Error: Failed to pay mana for %s even though check passed." % card_resource.card_name)
		return

	var underlying_played_card_res = played_card_in_zone_obj.card_resource
	if not underlying_played_card_res:
		printerr("Error: Failed to remove card from library after paying mana.")
		return

	_generate_card_played_event(underlying_played_card_res, active_duelist, played_card_in_zone_obj)
	
	if underlying_played_card_res is SummonCardResource:
		_resolve_summon_card(underlying_played_card_res, played_card_in_zone_obj, active_duelist, opponent_duelist)
	elif underlying_played_card_res is SpellCardResource:
		_resolve_spell_card(underlying_played_card_res, played_card_in_zone_obj, script_instance, active_duelist, opponent_duelist)

func _generate_card_played_event(card_resource: CardResource, active_duelist: Combatant, played_card_in_zone_obj: CardInZone):
	add_event({
		"event_type": "card_played",
		"player": active_duelist.combatant_name,
		"card_id": card_resource.id,
		"card_type": card_resource.get_card_type(),
		"remaining_mana": active_duelist.mana,
		"instance_id": played_card_in_zone_obj.instance_id
	})

func _resolve_summon_card(summon_card_res: SummonCardResource, played_card_in_zone_obj: CardInZone, active_duelist: Combatant, opponent_duelist: Combatant):
	var target_lane_index = active_duelist.find_first_empty_lane()
	if target_lane_index == -1:
		printerr("Error: Tried to summon %s but no empty lane found after check!" % summon_card_res.card_name)
		active_duelist.add_card_to_graveyard(played_card_in_zone_obj, "play", played_card_in_zone_obj.instance_id)
		return

	var new_summon = SummonInstance.new()
	var new_summon_instance_id = _generate_new_card_instance_id()
	new_summon.setup(summon_card_res, active_duelist, opponent_duelist, target_lane_index, self, new_summon_instance_id)
	active_duelist.place_summon_in_lane(new_summon, target_lane_index)

	_generate_summon_events(summon_card_res, new_summon, active_duelist, target_lane_index, new_summon_instance_id)
	
	# Call _on_arrival effect script
	if new_summon.script_instance != null and new_summon.script_instance.has_method("_on_arrival"):
		new_summon.script_instance._on_arrival(new_summon, active_duelist, opponent_duelist, self)

func _generate_summon_events(summon_card_res: SummonCardResource, new_summon: SummonInstance, active_duelist: Combatant, target_lane_index: int, new_summon_instance_id: int):
	# Generate Arrives Event
	add_event({
		"event_type": "summon_arrives",
		"player": active_duelist.combatant_name,
		"card_id": summon_card_res.id,
		"lane": target_lane_index + 1,
		"instance_id": new_summon_instance_id,
		"power": new_summon.get_current_power(),
		"max_hp": new_summon.get_current_max_hp(),
		"current_hp": new_summon.current_hp,
		"is_swift": new_summon.is_swift
	})

	# Generate Moved Event (play -> lane)
	add_event({
		"event_type": "card_moved",
		"card_id": summon_card_res.id,
		"player": active_duelist.combatant_name,
		"from_zone": "play",
		"to_zone": "lane",
		"to_details": {"lane": target_lane_index + 1},
		"instance_id": new_summon_instance_id
	})

func _resolve_spell_card(spell_card_res: SpellCardResource, played_card_in_zone_obj: CardInZone, script_instance, active_duelist: Combatant, opponent_duelist: Combatant):
	if script_instance != null and script_instance.has_method("apply_effect"):
		script_instance.apply_effect(played_card_in_zone_obj, active_duelist, opponent_duelist, self)
	else:
		print("Warning: Spell %s has no apply_effect method." % spell_card_res.card_name)

	# Add spell to graveyard
	active_duelist.add_card_to_graveyard(played_card_in_zone_obj, "play", played_card_in_zone_obj.instance_id)

func _handle_summon_activity_phase(active_duelist: Combatant):
	print("Summon Activity for %s" % active_duelist.combatant_name)
	var summons_to_act = active_duelist.lanes.filter(func(s): return s != null)
	for summon_instance in summons_to_act:
		if not summon_instance.is_newly_arrived or summon_instance.is_swift:
			summon_instance.perform_turn_activity()
			if check_game_over(): return
		else:
			print("%s skips action (newly arrived)" % summon_instance.card_resource.card_name)

func _handle_end_of_turn_phase(active_duelist: Combatant):
	print("End of Turn for %s" % active_duelist.combatant_name)
	for summon_instance in active_duelist.lanes:
		if summon_instance != null:
			summon_instance._end_of_turn_upkeep()
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
	if event_data["turn"] == -1:
		printerr("Using an instance_id of -1, is this intended?")
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
