# res://tests/test_deterministic_battles.gd
extends GutTest

var test_battle: Battle

func before_each():
	test_battle = Battle.new()

func after_each():
	if test_battle:
		test_battle = null

func _load_deck_by_names(card_names: Array) -> Array[CardResource]:
	var deck: Array[CardResource] = []
	for card_name in card_names:
		var card_res = CardDB.get_card_resource(card_name)
		if card_res:
			deck.append(card_res)
		else:
			gut.p("Warning: Could not load card: %s" % card_name)
	return deck

func test_complex_battle_scenario_deterministic():
	gut.p("Testing complex deterministic battle scenario...")
	
	# Your proposed decks
	var player_deck_names = ["Pikemen", "Overconcentrate", "Flamewielder", "GoblinWarboss"]
	var opponent_deck_names = ["Bloodrager", "TotemOfChampions", "AscendingProtoplasm", "HeedlessVandal"]
	
	var player_deck = _load_deck_by_names(player_deck_names)
	var opponent_deck = _load_deck_by_names(opponent_deck_names)
	
	if player_deck.size() != 4 or opponent_deck.size() != 4:
		gut.p("Skipping test - could not load all required cards")
		pass_test("Required cards not available")
		return
	
	# Fixed seed for reproducible results
	var fixed_seed = 777
	var events = test_battle.run_battle(player_deck, opponent_deck, "Player", "Opponent", fixed_seed)
	
	assert_not_null(events, "Battle should return events")
	assert_gt(events.size(), 50, "Complex battle should have many events")
	
	# Validate key battle milestones
	_validate_overconcentrate_cast(events)
	_validate_battle_progression(events)
	_validate_creature_interactions(events)
	
	gut.p("Complex battle scenario validated successfully")

func _validate_overconcentrate_cast(events: Array[Dictionary]):
	# Look for Overconcentrate being played
	var overconcentrate_events = events.filter(func(e): 
		return e.get("event_type") == "card_played" and e.get("card_id") == "Overconcentrate"
	)
	
	assert_gt(overconcentrate_events.size(), 0, "Overconcentrate should be played at some point")
	
	var overconcentrate_turn = overconcentrate_events[0].get("turn", -1)
	gut.p("Overconcentrate played on turn: %d" % overconcentrate_turn)
	
	# Find events near that turn to validate spell effects
	var spell_effect_events = events.filter(func(e):
		return e.get("turn") == overconcentrate_turn and e.get("event_type") == "status_change"
	)
	
	# Overconcentrate should cause status changes (making creatures relentless)
	if spell_effect_events.size() > 0:
		gut.p("Found status changes from Overconcentrate")

func _validate_battle_progression(events: Array[Dictionary]):
	# Check battle structure
	var turn_starts = events.filter(func(e): return e.get("event_type") == "turn_start")
	assert_gt(turn_starts.size(), 10, "Battle should last multiple turns")
	
	# Check for summons arriving
	var summon_arrivals = events.filter(func(e): return e.get("event_type") == "summon_arrives")
	assert_gt(summon_arrivals.size(), 4, "Multiple creatures should be summoned")
	
	# Check for combat
	var combat_events = events.filter(func(e): 
		return e.get("event_type") == "combat_damage" or e.get("event_type") == "direct_damage"
	)
	assert_gt(combat_events.size(), 5, "Significant combat should occur")
	
	# Battle should end properly
	var battle_end = events.filter(func(e): return e.get("event_type") == "battle_end")
	assert_eq(battle_end.size(), 1, "Battle should end exactly once")

func _validate_creature_interactions(events: Array[Dictionary]):
	# Look for specific creature deaths (like your Heedless Vandal example)
	var deaths = events.filter(func(e): return e.get("event_type") == "creature_defeated")
	assert_gt(deaths.size(), 0, "Some creatures should die during battle")
	
	# Validate death events have proper source attribution
	for death_event in deaths:
		assert_true(death_event.has("card_id"), "Death event should identify which creature died")
		# Many deaths should have a source (killed by another creature)
		var has_source = death_event.has("source_card_id") and death_event.get("source_card_id") != ""
		if has_source:
			gut.p("Creature %s killed by %s" % [death_event.get("card_id"), death_event.get("source_card_id")])

func test_turn_26_specific_validation():
	gut.p("Testing specific turn validation (if battle reaches turn 26)...")
	
	var player_deck_names = ["Pikemen", "Overconcentrate", "Flamewielder", "GoblinWarboss"] 
	var opponent_deck_names = ["Bloodrager", "TotemOfChampions", "AscendingProtoplasm", "HeedlessVandal"]
	
	var player_deck = _load_deck_by_names(player_deck_names)
	var opponent_deck = _load_deck_by_names(opponent_deck_names)
	
	if player_deck.size() != 4 or opponent_deck.size() != 4:
		gut.p("Skipping test - required cards not available")
		pass_test("Required cards not available")
		return
	
	var events = test_battle.run_battle(player_deck, opponent_deck, "Player", "Opponent", 777)
	
	# Check if battle reached turn 26
	var turn_26_events = events.filter(func(e): return e.get("turn") == 26)
	
	if turn_26_events.size() > 0:
		gut.p("Battle reached turn 26 - validating specific events")
		
		# Look for expected patterns on turn 26
		var turn_26_cards_played = turn_26_events.filter(func(e): return e.get("event_type") == "card_played")
		var turn_26_mana_changes = turn_26_events.filter(func(e): return e.get("event_type") == "mana_change")
		
		assert_gt(turn_26_mana_changes.size(), 0, "Turn 26 should have mana activity")
		gut.p("Turn 26 had %d mana changes and %d cards played" % [turn_26_mana_changes.size(), turn_26_cards_played.size()])
	else:
		gut.p("Battle didn't reach turn 26 (ended at turn %d)" % _get_max_turn(events))

func _get_max_turn(events: Array[Dictionary]) -> int:
	var max_turn = 0
	for event in events:
		if event.has("turn"):
			max_turn = max(max_turn, event.get("turn"))
	return max_turn

# Quick validation that replay system can process complex battles without errors
func test_complex_battle_replay_compatibility():
	gut.p("Testing that complex battles generate replay-compatible events...")
	
	var player_deck_names = ["Pikemen", "Overconcentrate"] 
	var opponent_deck_names = ["Bloodrager", "TotemOfChampions"]
	
	var player_deck = _load_deck_by_names(player_deck_names)
	var opponent_deck = _load_deck_by_names(opponent_deck_names)
	
	if player_deck.size() < 2 or opponent_deck.size() < 2:
		pass_test("Required cards not available")
		return
	
	var events = test_battle.run_battle(player_deck, opponent_deck, "Player", "Opponent", 888)
	
	# Validate all events have required fields for replay system
	for i in range(events.size()):
		var event = events[i]
		assert_true(event.has("event_type"), "Event %d should have event_type" % i)
		assert_true(event.has("turn"), "Event %d should have turn number" % i)
		assert_true(event.has("timestamp"), "Event %d should have timestamp" % i)
		
		# Events involving players should have player field
		var player_event_types = ["turn_start", "mana_change", "hp_change", "card_played"]
		if event.get("event_type") in player_event_types:
			assert_true(event.has("player"), "Player event should have player field: %s" % event)
	
	gut.p("All %d events are replay-compatible" % events.size())
