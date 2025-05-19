# res://logic/card_effects/heedless_vandal_effect.gd
extends SummonCardResource

# _summon_instance is the Heedless Vandal itself
func _on_arrival(_summon_instance: SummonInstance, active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle):
	var vandal_instance_id: int = _summon_instance.instance_id
	var vandal_card_id: String = _summon_instance.card_resource.id # "HeedlessVandal"

	print("Heedless Vandal (Instance: %s) arrival trigger." % vandal_instance_id)
	
	# Mill self (active_combatant)
	if not active_combatant.library.is_empty():
		print("...Vandal (Instance: %s) milling top card from %s's library." % [vandal_instance_id, active_combatant.combatant_name])
		active_combatant.mill_top_card("heedless_vandal_effect_" + vandal_card_id)
		# The card_moved events are generated inside mill_top_card -> add_card_to_graveyard.
		# They will have "library_top_heedless_vandal_effect_HeedlessVandal" as from_zone if we use that reason.
		# Sourcing them directly to vandal_instance_id would require passing it through mill_top_card.
	else:
		print("...Vandal (Instance: %s): %s's library is empty, cannot mill." % [vandal_instance_id, active_combatant.combatant_name])

	# Mill opponent
	if not opponent_combatant.library.is_empty():
		print("...Vandal (Instance: %s) milling top card from %s's library." % [vandal_instance_id, opponent_combatant.combatant_name])
		opponent_combatant.mill_top_card("heedless_vandal_effect_" + vandal_card_id)
	else:
		print("...Vandal (Instance: %s): %s's library is empty, cannot mill." % [vandal_instance_id, opponent_combatant.combatant_name])

	# Visual effect for the Vandal's general mill action
	battle_instance.add_event({
		"event_type": "visual_effect",
		"effect_id": "heedless_vandal_mill_action",
		"instance_id": vandal_instance_id, # The Vandal is the subject/source of this visual
		"target_locations": [active_combatant.combatant_name + " library", opponent_combatant.combatant_name + " library", active_combatant.combatant_name + " graveyard", opponent_combatant.combatant_name + " graveyard"],
		"details": {"mill_reason": "heedless_vandal_effect"},
		"source_card_id": vandal_card_id,
		"source_instance_id": vandal_instance_id
	})
