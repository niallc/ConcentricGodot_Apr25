# res://tests/test_combatant.gd
extends GutTest

func test_combatant_instantiation():
	var combatant = Combatant.new()
	assert_not_null(combatant, "Combatant should instantiate.")
	assert_eq(combatant.current_hp, Constants.STARTING_HP, "Combatant should start with default HP.")

# In e.g., test_battle.gd (extends GutTest)
func test_battle_instantiation():
	var battle = Battle.new()
	assert_not_null(battle, "Battle should instantiate.")

# In e.g., test_summon_instance.gd (extends GutTest)
func test_summon_instance_instantiation():
	var instance = SummonInstance.new()
	assert_not_null(instance, "SummonInstance should instantiate.")
