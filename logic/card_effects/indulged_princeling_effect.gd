# res://logic/card_effects/indulged_princeling_effect.gd
extends SummonCardResource

func _on_arrival(summon_instance: SummonInstance, active_combatant: Combatant, _opponent_combatant, battle_instance: Battle):
	var princeling_instance_id: int = summon_instance.instance_id
	var princeling_card_id: String = summon_instance.card_resource.id # "IndulgedPrinceling"
	var cards_to_mill_count: int = 2

	print("Indulged Princeling (Instance: %s) arrival trigger." % princeling_instance_id)

	if active_combatant.library.size() >= cards_to_mill_count:
		print("...Princeling (Instance: %s) milling top %d cards from %s's library." % [princeling_instance_id, cards_to_mill_count, active_combatant.combatant_name])
		for _i in range(cards_to_mill_count):
			if active_combatant.library.is_empty(): # Should not happen if initial check was correct, but defensive
				printerr("Indulged Princeling (Instance: %s): Library became empty during mill loop unexpectedly." % princeling_instance_id)
				break
			
			var milled_card_in_zone: CardInZone = active_combatant.library.pop_front() # This is a CardInZone
			
			if milled_card_in_zone != null and milled_card_in_zone.card_resource != null:
				print("    -> Milling %s (Instance: %s)" % [milled_card_in_zone.get_card_name(), milled_card_in_zone.get_card_instance_id()])
				# Pass the CardInZone object and its original instance ID (from library) to add_card_to_graveyard
				# The CardInZone object itself is moved, so it keeps its instance ID.
				active_combatant.add_card_to_graveyard(milled_card_in_zone, "library_top_princeling_mill",
													  milled_card_in_zone.get_card_instance_id(), princeling_card_id,
													  princeling_instance_id)
			else:
				printerr("Indulged Princeling (Instance: %s): Popped null or invalid CardInZone from library." % princeling_instance_id)
				# If something goes wrong here, we might still need to consider the sacrifice logic below.
				# For now, just log and continue, but this indicates a problem if reached.
	else:
		print("...%s's library has %d cards, less than %d required. Princeling (Instance: %s) sacrificing itself!" % [active_combatant.combatant_name, active_combatant.library.size(), cards_to_mill_count, princeling_instance_id])
		
		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "indulged_princeling_sacrifice",
			"instance_id": princeling_instance_id, # The Princeling is the subject
			"card_id": princeling_card_id,
			"target_locations": ["%s lane %d (ID: %s)" % [active_combatant.combatant_name, summon_instance.lane_index + 1, princeling_instance_id]],
			"details": {"reason": "insufficient_cards_to_mill", "required": cards_to_mill_count, "available": active_combatant.library.size()},
			"source_card_id": princeling_card_id,
			"source_instance_id": princeling_instance_id 
		})
		# die will generate creature_defeated & card_moved events (Princeling to grave)
		summon_instance.die(princeling_card_id, princeling_instance_id)
