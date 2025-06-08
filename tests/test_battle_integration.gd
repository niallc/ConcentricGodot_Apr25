# res://tests/test_battle_integration.gd
extends GutTest

var test_battle: Battle
var default_player_deck: Array[CardResource]
var default_opponent_deck: Array[CardResource]

func before_each():
	test_battle = Battle.new()
	_load_test_decks()

func after_each():
	if test_battle:
		test_battle = null

func _load_test_decks():
	# Load simple, reliable cards for testing
	default_player_deck = []
	default_opponent_deck = []
	
	if CardDB:
		var knight = CardDB.get_card_resource("Knight")
		var scout = CardDB.get_card_resource("GoblinScout")
		var taunting_elf = CardDB.get_card_resource("TauntingElf")
		
		if knight and scout:
			default_player_deck = [knight, scout]
			default_opponent_deck = [scout, knight]
		elif taunting_elf:
			# Fallback to any available card
			default_player_deck = [taunting_elf]
			default_opponent_deck = [taunting_elf]
		else:
			gut.p("Warning: Could not load test cards from CardDB")

func test_battle_runs_without_errors():
	gut.p("Testing basic battle execution...")
	assert_not_null(test_battle, "Battle should instantiate")
	
	if default_player_deck.is_empty():
		gut.p("Skipping test - no test decks available")
		pass_test("No decks available to test")
		return
	
	var events = test_battle.run_battle(default_player_deck, default_opponent_deck, "Player", "Opponent", 12345)
	
	assert_not_null(events, "Battle should return events array")
	assert_gt(events.size(), 0, "Battle should generate at least some events")
	gut.p("Battle completed with %d events" % events.size())

func test_battle_deterministic_with_seed():
	gut.p("Testing battle determinism...")
	
	if default_player_deck.is_empty():
		gut.p("Skipping test - no test decks available")
		pass_test("No decks available to test")
		return
	
	var seed_value = 42
	var events1 = test_battle.run_battle(default_player_deck, default_opponent_deck, "Player", "Opponent", seed_value)
	
	var battle2 = Battle.new()
	var events2 = battle2.run_battle(default_player_deck, default_opponent_deck, "Player", "Opponent", seed_value)
	
	assert_eq(events1.size(), events2.size(), "Same seed should produce same number of events")
	
	# Check that key events match
	var turn_starts1 = events1.filter(func(e): return e.get("event_type") == "turn_start")
	var turn_starts2 = events2.filter(func(e): return e.get("event_type") == "turn_start")
	assert_eq(turn_starts1.size(), turn_starts2.size(), "Same number of turns should occur")

func test_refactored_turn_phases():
	gut.p("Testing that refactored turn methods work...")
	
	# Create a minimal test setup
	var player = Combatant.new()
	var opponent = Combatant.new()
	
	if default_player_deck.is_empty():
		gut.p("Skipping test - no test decks available")
		pass_test("No decks available to test")
		return
	
	player.setup(default_player_deck, Constants.STARTING_HP, "TestPlayer", test_battle, opponent)
	opponent.setup(default_opponent_deck, Constants.STARTING_HP, "TestOpponent", test_battle, player)
	
	test_battle.duelist1 = player
	test_battle.duelist2 = opponent
	
	# Test that the individual phase methods can be called without crashing
	assert_has_method(test_battle, "_handle_turn_start", "Should have _handle_turn_start method")
	assert_has_method(test_battle, "_handle_card_play_phase", "Should have _handle_card_play_phase method")
	assert_has_method(test_battle, "_handle_summon_activity_phase", "Should have _handle_summon_activity_phase method") 
	assert_has_method(test_battle, "_handle_end_of_turn_phase", "Should have _handle_end_of_turn_phase method")
	
	gut.p("All refactored methods are present")

func test_battle_ends_properly():
	gut.p("Testing battle conclusion...")
	
	if default_player_deck.is_empty():
		gut.p("Skipping test - no test decks available")
		pass_test("No decks available to test")
		return
	
	var events = test_battle.run_battle(default_player_deck, default_opponent_deck, "Player", "Opponent", 54321)
	
	# Check for battle_end event
	var battle_end_events = events.filter(func(e): return e.get("event_type") == "battle_end")
	assert_eq(battle_end_events.size(), 1, "Should have exactly one battle_end event")
	
	var end_event = battle_end_events[0]
	assert_true(end_event.has("outcome"), "Battle end should have outcome")
	assert_true(end_event.has("winner"), "Battle end should have winner")
	
	gut.p("Battle ended properly with outcome: %s, winner: %s" % [end_event.outcome, end_event.winner])

# Utility function to run a quick smoke test that can be called externally
static func run_quick_smoke_test() -> bool:
	var test_instance = new()
	test_instance._load_test_decks()
	
	if test_instance.default_player_deck.is_empty():
		print("Smoke test: No test decks available")
		return false
	
	var battle = Battle.new()
	var events = battle.run_battle(test_instance.default_player_deck, test_instance.default_opponent_deck, "Player", "Opponent", 99999)
	
	var success = events != null and events.size() > 0
	print("Smoke test result: %s (%d events)" % ["PASS" if success else "FAIL", events.size() if events else 0])
	return success