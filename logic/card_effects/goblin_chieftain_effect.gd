extends SummonCardResource

# Need Goblin Warboss resource
const GOBLIN_WARBOSS_RES_PATH = "res://data/cards/instances/goblin_warboss.tres"
var goblin_warboss_res = null

func _init():
	if goblin_warboss_res == null:
		goblin_warboss_res = load(GOBLIN_WARBOSS_RES_PATH) as SummonCardResource
		if goblin_warboss_res == null:
			printerr("GoblinChieftain Error: Failed to load Goblin Warboss resource!")

func _on_arrival(_summon_instance: SummonInstance, active_combatant, _opponent_combatant, battle_instance):
	print("Goblin Chieftain arrival trigger.")
	if goblin_warboss_res != null:
		print("...Adding Goblin Warboss to bottom of library.")
		active_combatant.library.push_back(goblin_warboss_res)
		# Generate event
		battle_instance.add_event({
			"event_type": "card_moved",
			"card_id": goblin_warboss_res.id,
			"player": active_combatant.combatant_name,
			"from_zone": "limbo", # Created from effect
			"to_zone": "library",
			"to_details": {"position": "bottom"},
			"reason": "goblin_chieftain"
		})
	else:
		printerr("Goblin Chieftain cannot add Warboss: Resource not loaded.")
