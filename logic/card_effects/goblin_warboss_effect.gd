extends SummonCardResource

# Need Goblin Expendable resource
const GOBLIN_EXPENDABLE_RES_PATH = "res://data/cards/instances/goblin_expendable.tres"
var goblin_expendable_res = null

func _init():
	if goblin_expendable_res == null:
		goblin_expendable_res = load(GOBLIN_EXPENDABLE_RES_PATH) as SummonCardResource
		if goblin_expendable_res == null:
			printerr("GoblinWarboss Error: Failed to load Goblin Expendable resource!")

func _on_arrival(_summon_instance: SummonInstance, active_combatant, _opponent_combatant, battle_instance):
	print("Goblin Warboss arrival trigger.")
	if goblin_expendable_res != null:
		print("...Adding Goblin Expendable to bottom of library.")
		active_combatant.library.push_back(goblin_expendable_res)
		# Generate event
		battle_instance.add_event({
			"event_type": "card_moved",
			"card_id": goblin_expendable_res.id,
			"player": active_combatant.combatant_name,
			"from_zone": "limbo", # Created from effect
			"to_zone": "library",
			"to_details": {"position": "bottom"},
			"reason": "goblin_warboss"
		})
	else:
		printerr("Goblin Warboss cannot add Expendable: Resource not loaded.")
