# res://logic/card_effects/goblin_chieftain_effect.gd
extends SummonCardResource

const GOBLIN_WARBOSS_RES_PATH = "res://data/cards/instances/goblin_warboss.tres"
var goblin_warboss_res: SummonCardResource = null # Add type hint

func _init():
	if goblin_warboss_res == null:
		goblin_warboss_res = load(GOBLIN_WARBOSS_RES_PATH) as SummonCardResource
		if goblin_warboss_res == null:
			printerr("GoblinChieftain Error: Failed to load Goblin Warboss resource at %s!" % GOBLIN_WARBOSS_RES_PATH)

# _summon_instance is the Goblin Chieftain itself
func _on_arrival(_summon_instance: SummonInstance, active_combatant: Combatant, _opponent_combatant, battle_instance: Battle):
	var chieftain_instance_id: int = _summon_instance.instance_id
	var chieftain_card_id: String = _summon_instance.card_resource.id # "GoblinChieftain"

	print("Goblin Chieftain (Instance: %s) arrival trigger." % chieftain_instance_id)
	
	if goblin_warboss_res != null:
		print("...Goblin Chieftain (Instance: %s) adding Goblin Warboss to bottom of library." % chieftain_instance_id)
		
		# Create a new CardInZone for the Goblin Warboss being added to the library
		var new_warboss_instance_id_for_library: int = battle_instance._generate_new_card_instance_id()
		var warboss_card_in_zone: CardInZone = CardInZone.new(goblin_warboss_res, new_warboss_instance_id_for_library)
		
		active_combatant.library.push_back(warboss_card_in_zone)
		
		battle_instance.add_event({
			"event_type": "card_moved",
			"card_id": goblin_warboss_res.id, # Card ID of the Warboss
			"instance_id": new_warboss_instance_id_for_library, # ID of the new Warboss CardInZone in the library
			"player": active_combatant.combatant_name,
			"from_zone": "limbo", # Conceptually created by an effect before entering library
			"from_details": {"created_by_effect_card_id": chieftain_card_id, "created_by_effect_instance_id": chieftain_instance_id},
			"to_zone": "library",
			"to_details": {
				"position": "bottom",
				"instance_id": new_warboss_instance_id_for_library # Redundant here as it's same as main instance_id, but good for pattern
			},
			"reason": "created_by_" + chieftain_card_id,
			"source_card_id": chieftain_card_id,         # Goblin Chieftain (card type)
			"source_instance_id": chieftain_instance_id  # Specific Chieftain instance
		})
	else:
		printerr("Goblin Chieftain (Instance: %s) cannot add Warboss: Resource not loaded." % chieftain_instance_id)
		battle_instance.add_event({
			"event_type": "log_message",
			"message": "Goblin Chieftain (Instance: %s) failed to add Warboss to library (resource not loaded)." % chieftain_instance_id,
			"source_card_id": chieftain_card_id,
			"source_instance_id": chieftain_instance_id
		})
