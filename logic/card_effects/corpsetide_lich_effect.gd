# res://logic/card_effects/corpsetide_lich_effect.gd
extends SummonCardResource

# _summon_instance is the Corpsetide Lich SummonInstance itself.
func _on_arrival(_summon_instance: SummonInstance, active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle):
	var lich_instance_id: int = _summon_instance.instance_id
	var lich_card_id: String = _summon_instance.card_resource.id # "CorpsetideLich"

	print("Corpsetide Lich (Instance: %s) arrival trigger: Stealing %s's graveyard for %s." % [lich_instance_id, opponent_combatant.combatant_name, active_combatant.combatant_name])
	
	var opponent_graveyard_size_before_steal: int = opponent_combatant.graveyard.size()

	if opponent_graveyard_size_before_steal > 0:
		print("...Corpsetide Lich (Instance: %s) moving %d cards from %s's graveyard to %s's graveyard." % [lich_instance_id, opponent_graveyard_size_before_steal, opponent_combatant.combatant_name, active_combatant.combatant_name])
		
		var cards_stolen_from_opponent: Array[CardInZone] = opponent_combatant.graveyard.duplicate() # Contains CardInZone objects
		opponent_combatant.graveyard.clear() # Empty opponent's graveyard

		for stolen_card_in_zone_obj in cards_stolen_from_opponent:
			var stolen_card_res_id: String = stolen_card_in_zone_obj.get_card_id()
			var stolen_card_original_instance_id: int = stolen_card_in_zone_obj.get_card_instance_id()

			# Event 1: Card moved from opponent's graveyard to limbo
			battle_instance.add_event({
				"event_type": "card_moved",
				"card_id": stolen_card_res_id,
				"instance_id": stolen_card_original_instance_id, # ID it had in opponent's graveyard
				"player": opponent_combatant.combatant_name,
				"from_zone": "graveyard",
				"from_details": {"original_instance_id": stolen_card_original_instance_id},
				"to_zone": "limbo",
				"reason": "stolen_by_effect_" + lich_card_id,
				"source_card_id": lich_card_id,
				"source_instance_id": lich_instance_id
			})

			# Add the *same CardInZone object* to the active player's (Lich's owner) graveyard.
			# It retains its original instance_id during this transfer.
			# The add_card_to_graveyard method will log its own card_moved event (limbo -> player_graveyard)
			# We need to ensure that sub-event is also sourced to the Lich.
			# Signature: add_card_to_graveyard(p_card_in_zone_obj: CardInZone, p_from_zone: String, 
			#                                p_instance_id_from_origin_zone: int = -1, 
			#                                p_reason_card_id: String = "", p_reason_instance_id: int = -1)
			active_combatant.add_card_to_graveyard(
				stolen_card_in_zone_obj, 
				"limbo_stolen_by_" + lich_card_id, 
				stolen_card_original_instance_id, # Its ID as it was in limbo
				lich_card_id,                     # Reason/Source Card for the move *into* player's grave
				lich_instance_id                  # Reason/Source Instance for the move *into* player's grave
			)
			print("    -> Moved %s (Instance: %s) to %s's graveyard." % [stolen_card_res_id, stolen_card_original_instance_id, active_combatant.combatant_name])

		# Visual effect for the overall graveyard steal action
		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "corpsetide_lich_graveyard_steal",
			"instance_id": lich_instance_id, # The Lich is the subject/source of this visual
			"target_locations": [opponent_combatant.combatant_name + " graveyard", active_combatant.combatant_name + " graveyard"],
			"details": {"cards_stolen_count": opponent_graveyard_size_before_steal},
			"source_card_id": lich_card_id,
			"source_instance_id": lich_instance_id
		})
	else:
		print("...Corpsetide Lich (Instance: %s) found %s's graveyard empty." % [lich_instance_id, opponent_combatant.combatant_name])
		battle_instance.add_event({
			"event_type": "log_message",
			"message": "Corpsetide Lich (Instance: %s) found opponent's graveyard empty." % lich_instance_id,
			"source_card_id": lich_card_id,
			"source_instance_id": lich_instance_id
		})
