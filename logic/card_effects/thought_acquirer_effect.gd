# res://logic/card_effects/thought_acquirer_effect.gd
extends SummonCardResource

# _summon_instance is the Thought Acquirer itself
func _on_arrival(_summon_instance: SummonInstance, active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle):
	var acquirer_instance_id: int = _summon_instance.instance_id
	var acquirer_card_id: String = _summon_instance.card_resource.id # This is "ThoughtAcquirer"

	print("Thought Acquirer (Instance: %s) arrival trigger." % acquirer_instance_id)

	if not opponent_combatant.library.is_empty():
		# opponent_combatant.library.pop_back() now returns a CardInZone
		var stolen_card_in_zone: CardInZone = opponent_combatant.library.pop_back()
		
		var stolen_card_original_instance_id: int = stolen_card_in_zone.get_card_instance_id()
		var stolen_card_res_id: String = stolen_card_in_zone.get_card_id()
		var stolen_card_res_name: String = stolen_card_in_zone.get_card_name()

		print("...Thought Acquirer (Instance: %s) stole %s (Original Instance: %s) from bottom of opponent's library." % [acquirer_instance_id, stolen_card_res_name, stolen_card_original_instance_id])

		# Event 1: Card moved from opponent's library to limbo
		battle_instance.add_event({
			"event_type": "card_moved",
			"card_id": stolen_card_res_id,
			"instance_id": stolen_card_original_instance_id, # ID it had in opponent's library
			"player": opponent_combatant.combatant_name,
			"from_zone": "library",
			"from_details": {"position": "bottom", "instance_id": stolen_card_original_instance_id},
			"to_zone": "limbo", # Conceptually stolen into limbo before going to player's library
			"reason": "stolen_by_" + acquirer_card_id,
			"source_card_id": acquirer_card_id,
			"source_instance_id": acquirer_instance_id
		})

		# Add the *same CardInZone object* to the active player's library.
		# It keeps its original instance_id as it moves.
		active_combatant.library.push_back(stolen_card_in_zone)
		print("...Added %s (Instance: %s) to bottom of %s's library." % [stolen_card_res_name, stolen_card_original_instance_id, active_combatant.combatant_name])

		# Event 2: Card moved from limbo to player's library
		battle_instance.add_event({
			"event_type": "card_moved",
			"card_id": stolen_card_res_id,
			"instance_id": stolen_card_original_instance_id, # ID it had in limbo (same as from opponent's library)
			"player": active_combatant.combatant_name,
			"from_zone": "limbo",
			"from_details": {"original_instance_id": stolen_card_original_instance_id},
			"to_zone": "library",
			"to_details": {
				"position": "bottom",
				"instance_id": stolen_card_original_instance_id # Its ID remains the same in the new library
			},
			"reason": "stolen_by_" + acquirer_card_id,
			"source_card_id": acquirer_card_id,
			"source_instance_id": acquirer_instance_id
		})

		# Event 3: Visual effect for the steal
		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "thought_acquirer_steal",
			"target_locations": [opponent_combatant.combatant_name + " library", active_combatant.combatant_name + " library"],
			"details": {
				"stolen_card_id": stolen_card_res_id,
				"stolen_card_original_instance_id": stolen_card_original_instance_id
			},
			"instance_id": acquirer_instance_id, # The Thought Acquirer is the primary subject of this visual
			"source_card_id": acquirer_card_id,
			"source_instance_id": acquirer_instance_id
		})
	else:
		print("...Thought Acquirer (Instance: %s) found opponent library empty, nothing to steal." % acquirer_instance_id)
		battle_instance.add_event({
			"event_type": "log_message",
			"message": "Thought Acquirer (Instance: %s) found opponent's library empty." % acquirer_instance_id,
			"source_card_id": acquirer_card_id,
			"source_instance_id": acquirer_instance_id,
			"instance_id": acquirer_instance_id
		})
