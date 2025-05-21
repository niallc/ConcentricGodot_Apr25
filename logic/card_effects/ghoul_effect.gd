# res://logic/card_effects/ghoul_effect.gd
extends SummonCardResource

# _summon_instance is the Ghoul SummonInstance itself.
func _on_arrival(_summon_instance: SummonInstance, _active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle):
	var ghoul_instance_id: int = _summon_instance.instance_id
	var ghoul_card_id: String = _summon_instance.card_resource.id # "Ghoul"

	print("Ghoul (Instance: %s) arrival trigger." % ghoul_instance_id)
	
	if not opponent_combatant.library.is_empty():
		# opponent_combatant.library.pop_back() now returns a CardInZone
		var milled_card_in_zone: CardInZone = opponent_combatant.library.pop_back()
		
		var milled_card_original_instance_id: int = milled_card_in_zone.get_card_instance_id()
		var milled_card_res_id: String = milled_card_in_zone.get_card_id()
		var milled_card_res_name: String = milled_card_in_zone.get_card_name()

		print("...Ghoul (Instance: %s) milling %s (Original Instance: %s) from bottom of %s's library." % [ghoul_instance_id, milled_card_res_name, milled_card_original_instance_id, opponent_combatant.combatant_name])
		
		# Add the *same CardInZone object* (that was popped) to the opponent's graveyard.
		# It retains its instance_id.
		# Signature: add_card_to_graveyard(card_in_zone_obj: CardInZone, from_zone: String, p_instance_id_if_relevant: int = -1)
		# p_instance_id_if_relevant is the ID the card had in the from_zone, which is milled_card_original_instance_id
		opponent_combatant.add_card_to_graveyard(milled_card_in_zone, "library_bottom_ghoul_mill", milled_card_original_instance_id, _summon_instance.card_resource.id, _summon_instance.instance_id)
		# The card_moved event inside add_card_to_graveyard will use milled_card_original_instance_id.

		# Optional visual effect for the mill action
		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "ghoul_mill_action", # Distinguish from a generic mill if needed
			"target_locations": [opponent_combatant.combatant_name + " library", opponent_combatant.combatant_name + " graveyard"],
			"details": {
				"milled_card_id": milled_card_res_id,
				"milled_card_instance_id": milled_card_original_instance_id,
				"mill_source_card_id": ghoul_card_id
			},
			"instance_id": ghoul_instance_id, # The Ghoul is the primary subject/source of this visual
			"source_card_id": ghoul_card_id,
			"source_instance_id": ghoul_instance_id
		})
	else:
		print("...Ghoul (Instance: %s) found %s's library empty, nothing to mill." % [ghoul_instance_id, opponent_combatant.combatant_name])
		battle_instance.add_event({
			"event_type": "log_message",
			"message": "Ghoul (Instance: %s) found opponent's library empty." % ghoul_instance_id,
			"source_card_id": ghoul_card_id,
			"source_instance_id": ghoul_instance_id
		})
