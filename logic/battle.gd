# res://logic/battle.gd
extends Object
class_name Battle

var duelist1: Combatant
var duelist2: Combatant
var turn_count: int = 0
var battle_events: Array[Dictionary] = []
var _event_timestamp_counter: float = 0.0 # Use float for finer granularity
var _event_id_counter: int = 0 # Unique ID per event

var rng = RandomNumberGenerator.new()
var current_seed = 0 # Store the seed used

var battle_state = "Ongoing" # "Ongoing", "Finished"

func run_battle(deck1: Array[CardResource], deck2: Array[CardResource], name1: String, name2: String, seed: int = 0) -> Array[Dictionary]:
	print("Is it an Ostrich, a Quokka, a Polar Bear, or a Marmot?")
	battle_events.clear()
	_event_timestamp_counter = 0.0
	_event_id_counter = 0
	turn_count = 0
	battle_state = "Ongoing"

	if seed == 0:
		rng.randomize()
		current_seed = rng.get_state() # Store the generated seed state if needed
	else:
		rng.seed = seed
		current_seed = seed

	print("Starting battle. Seed: %s" % str(current_seed))

	duelist1 = Combatant.new()
	duelist2 = Combatant.new()
	duelist1.setup(deck1, Constants.STARTING_HP, name1, self, duelist2)
	duelist2.setup(deck2, Constants.STARTING_HP, name2, self, duelist1)

	var active_duelist = duelist1
	var opponent_duelist = duelist2

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

	add_event({"event_type": "turn_start", "player": active_duelist.combatant_name})

	# 1. Start of Turn Effects / Mana Gain
	active_duelist.gain_mana(Constants.MANA_PER_TURN)
	# TODO: Add start-of-turn triggers for summons/player effects here

	if check_game_over(): return

	# 2. Card Play Phase
	# TODO: Implement card draw/play logic based on v1 spec pseudocode
	# - Get top card: active_duelist.library[0]
	# - Check can_play (mana, custom script check)
	# - Check lanes (if Summon)
	# - Pay mana: active_duelist.pay_mana()
	# - Remove card: active_duelist.remove_card_from_library()
	# - If Spell: card_script.apply_effect(...); active_duelist.add_card_to_graveyard(...)
	# - If Summon: Create SummonInstance, place in lane, generate summon_arrives, call _on_arrival
	pass # Placeholder

	if check_game_over(): return

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
		"winner": winner_name
	})
	print("Battle Over! Outcome: %s, Winner: %s" % [outcome, winner_name])
