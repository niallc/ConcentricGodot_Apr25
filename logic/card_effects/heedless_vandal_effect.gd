# res://logic/card_effects/heedless_vandal_effect.gd
extends SummonCardResource

func _on_arrival(_summon_instance: SummonInstance, active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle):
	var vandal_instance_id: int = _summon_instance.instance_id
	var vandal_card_id: String = _summon_instance.card_resource.id

	print("Heedless Vandal (Instance: %s) arrival trigger." % vandal_instance_id)
	
	# Mill self (active_combatant)
	if not active_combatant.library.is_empty():
		print("...Vandal (Instance: %s) milling top card from %s's library." % [vandal_instance_id, active_combatant.combatant_name])
		active_combatant.mill_top_card(vandal_card_id, vandal_instance_id)
	else:
		print("...Vandal (Instance: %s): %s's library is empty, cannot mill." % [vandal_instance_id, active_combatant.combatant_name])

	# Mill opponent
	if not opponent_combatant.library.is_empty():
		print("...Vandal (Instance: %s) milling top card from %s's library." % [vandal_instance_id, opponent_combatant.combatant_name])
		opponent_combatant.mill_top_card(vandal_card_id, vandal_instance_id)
	else:
		print("...Vandal (Instance: %s): %s's library is empty, cannot mill." % [vandal_instance_id, opponent_combatant.combatant_name])

	battle_instance.add_event({
		"event_type": "visual_effect",
		"effect_id": "heedless_vandal_mill_action",
		"instance_id": vandal_instance_id, 
		"target_locations": [active_combatant.combatant_name + " library", opponent_combatant.combatant_name + " library", active_combatant.combatant_name + " graveyard", opponent_combatant.combatant_name + " graveyard"],
		"details": {"mill_reason_card_id": vandal_card_id}, # Added detail
		"source_card_id": vandal_card_id,
		"source_instance_id": vandal_instance_id
	})
