# res://tests/test_resources.gd
extends GutTest

# Preload the base resource types to check against
# Note: We use preload here because these script paths are fixed
# const CardResourceScript = preload("res://logic/cards/card.gd") # Not strictly needed for 'is' check
# const SpellCardResourceScript = preload("res://logic/cards/spell_card.gd")
# const SummonCardResourceScript = preload("res://logic/cards/summon_card.gd")

# Test loading and basic properties of Energy Axe
func test_load_energy_axe():
	var res = load("res://data/cards/instances/energy_axe.tres")
	assert_not_null(res, "Failed to load energy_axe.tres.")
	assert_true(res is SpellCardResource, "energy_axe.tres should be a SpellCardResource.")
	assert_eq(res.id, "EnergyAxe", "Energy Axe ID is incorrect.")
	assert_eq(res.cost, 4, "Energy Axe cost is incorrect.")
	assert_not_null(res.script, "Energy Axe should have an effect script linked.")

# Test loading and basic properties of Goblin Scout
func test_load_goblin_scout():
	var res = load("res://data/cards/instances/goblin_scout.tres")
	assert_not_null(res, "Failed to load goblin_scout.tres.")
	assert_true(res is SummonCardResource, "goblin_scout.tres should be a SummonCardResource.")
	assert_eq(res.id, "GoblinScout", "Goblin Scout ID is incorrect.")
	assert_eq(res.cost, 2, "Goblin Scout cost is incorrect.")
	assert_eq(res.base_power, 1, "Goblin Scout base power is incorrect.")
	assert_eq(res.base_max_hp, 2, "Goblin Scout base max HP is incorrect.")
	assert_not_null(res.script, "Goblin Scout should have an effect script linked.")

# Test loading and basic properties of Healer
func test_load_healer():
	var res = load("res://data/cards/instances/healer.tres")
	assert_not_null(res, "Failed to load healer.tres.")
	assert_true(res is SummonCardResource, "healer.tres should be a SummonCardResource.")
	assert_eq(res.id, "Healer", "Healer ID is incorrect.")
	assert_eq(res.cost, 4, "Healer cost is incorrect.")
	assert_eq(res.base_power, 1, "Healer base power is incorrect.")
	assert_eq(res.base_max_hp, 5, "Healer base max HP is incorrect.")
	assert_not_null(res.script, "Healer should have an effect script linked.")

# Test loading the NEW card resources
func test_load_disarm():
	var res = load("res://data/cards/instances/disarm.tres")
	assert_not_null(res, "Failed to load disarm.tres.")
	assert_true(res is SpellCardResource, "disarm.tres should be a SpellCardResource.")
	assert_eq(res.id, "Disarm", "Disarm ID is incorrect.")
	assert_eq(res.cost, 3, "Disarm cost is incorrect.")
	assert_not_null(res.script, "Disarm should have an effect script linked.")

func test_load_goblin_firework():
	var res = load("res://data/cards/instances/goblin_firework.tres")
	assert_not_null(res, "Failed to load goblin_firework.tres.")
	assert_true(res is SummonCardResource, "goblin_firework.tres should be a SummonCardResource.")
	assert_eq(res.id, "GoblinFirework", "Goblin Firework ID is incorrect.")
	assert_eq(res.cost, 2, "Goblin Firework cost is incorrect.")
	assert_eq(res.base_power, 0, "Goblin Firework base power is incorrect.")
	assert_eq(res.base_max_hp, 1, "Goblin Firework base max HP is incorrect.")
	assert_not_null(res.script, "Goblin Firework should have an effect script linked.")

func test_load_knight():
	var res = load("res://data/cards/instances/knight.tres")
	assert_not_null(res, "Failed to load knight.tres.")
	assert_true(res is SummonCardResource, "knight.tres should be a SummonCardResource.")
	assert_eq(res.id, "Knight", "Knight ID is incorrect.")
	assert_eq(res.cost, 4, "Knight cost is incorrect.")
	assert_eq(res.base_power, 3, "Knight base power is incorrect.")
	assert_eq(res.base_max_hp, 3, "Knight base max HP is incorrect.")
	assert_not_null(res.script, "Knight should have an effect script linked.")


# Test loading base resources (less critical but good sanity check)
# These check the base template files themselves
func test_load_base_card_resource():
	# *** CORRECTED PATH v2 ***
	var res = load("res://logic/cards/card.tres") # Path to the base .tres in logic/
	assert_not_null(res, "Failed to load card.tres.")
	assert_true(res is CardResource, "card.tres should load as CardResource.")


func test_load_base_spell_resource():
	# *** CORRECTED PATH v2 ***
	var res = load("res://logic/cards/spell_card.tres") # Path in logic/
	assert_not_null(res, "Failed to load spell_card.tres.")
	assert_true(res is SpellCardResource, "spell_card.tres should load as SpellCardResource.")


func test_load_base_summon_resource():
	# *** CORRECTED PATH v2 ***
	var res = load("res://logic/cards/summon_card.tres") # Path in logic/
	assert_not_null(res, "Failed to load summon_card.tres.")
	assert_true(res is SummonCardResource, "summon_card.tres should load as SummonCardResource.")
