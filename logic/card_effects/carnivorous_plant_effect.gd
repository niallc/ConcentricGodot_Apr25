extends SummonCardResource

const GOBLIN_SCOUT_RES_PATH = "res://data/cards/instances/goblin_scout.tres"
var goblin_scout_res = null

func _init():
	if goblin_scout_res == null:
		goblin_scout_res = load(GOBLIN_SCOUT_RES_PATH) as SummonCardResource
		if goblin_scout_res == null: printerr("CarnivorousPlant Error: Failed to load Goblin Scout!")

func _on_arrival(_summon_instance: SummonInstance, active_combatant, _opponent_combatant, _battle_instance):
	print("Carnivorous Plant arrival trigger.")
	if goblin_scout_res != null:
		print("...Adding Goblin Scout to graveyard.")
		# Add card resource to graveyard (generates card_moved event)
		active_combatant.add_card_to_graveyard(goblin_scout_res, "effect_carnivorous_plant") # Specify source
	else:
		printerr("Carnivorous Plant cannot add Scout: Resource not loaded.")
