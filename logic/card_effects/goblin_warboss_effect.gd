# res://logic/card_effects/goblin_warboss_effect.gd
extends SummonCardResource

const GOBLIN_EXPENDABLE_RES_PATH = "res://data/cards/instances/goblin_expendable.tres"
var goblin_expendable_res: SummonCardResource = null

func _init():
	if goblin_expendable_res == null:
		goblin_expendable_res = load(GOBLIN_EXPENDABLE_RES_PATH) as SummonCardResource
		if goblin_expendable_res == null:
			printerr("GoblinWarboss Error: Failed to load Goblin Expendable resource at %s!" % GOBLIN_EXPENDABLE_RES_PATH)

# _summon_instance is the Goblin Warboss itself
func _on_arrival(_summon_instance: SummonInstance, active_combatant: Combatant, _opponent_combatant, battle_instance: Battle):
	var warboss_instance_id: int = _summon_instance.instance_id
	var warboss_card_id: String = _summon_instance.card_resource.id # "GoblinWarboss"

	print("Goblin Warboss (Instance: %s) arrival trigger." % warboss_instance_id)
	
	if goblin_expendable_res != null:
		print("...Goblin Warboss (Instance: %s) adding Goblin Expendable to bottom of library." % warboss_instance_id)
		
		var new_expendable_instance_id_for_library: int = battle_instance._generate_new_card_instance_id()
		var expendable_card_in_zone: CardInZone = CardInZone.new(goblin_expendable_res, new_expendable_instance_id_for_library)
		
		active_combatant.library.push_back(expendable_card_in_zone)
		
		battle_instance.add_event({
			"event_type": "card_moved",
			"card_id": goblin_expendable_res.id, # Card ID of the Expendable
			"instance_id": new_expendable_instance_id_for_library, # ID of the new Expendable CardInZone
			"player": active_combatant.combatant_name,
			"from_zone": "limbo", 
			"from_details": {"created_by_effect_card_id": warboss_card_id, "created_by_effect_instance_id": warboss_instance_id},
			"to_zone": "library",
			"to_details": {
				"position": "bottom",
				"instance_id": new_expendable_instance_id_for_library 
			},
			"reason": "created_by_" + warboss_card_id,
			"source_card_id": warboss_card_id,         
			"source_instance_id": warboss_instance_id  
		})
	else:
		printerr("Goblin Warboss (Instance: %s) cannot add Expendable: Resource not loaded." % warboss_instance_id)
		battle_instance.add_event({
			"event_type": "log_message",
			"message": "Goblin Warboss (Instance: %s) failed to add Expendable to library (resource not loaded)." % warboss_instance_id,
			"source_card_id": warboss_card_id,
			"source_instance_id": warboss_instance_id
		})
