extends SummonCardResource

func _on_arrival(_summon_instance: SummonInstance, active_combatant, opponent_combatant, battle_instance):
	print("Thought Acquirer arrival trigger.")
	# Check if opponent library has cards
	if not opponent_combatant.library.is_empty():
		# Remove bottom card from opponent library
		var stolen_card_res = opponent_combatant.library.pop_back()
		print("...Stole %s from bottom of opponent library." % stolen_card_res.card_name)

		# Generate event for card leaving opponent library
		battle_instance.add_event({
			"event_type": "card_moved",
			"card_id": stolen_card_res.id,
			"player": opponent_combatant.combatant_name,
			"from_zone": "library",
			"from_details": {"position": "bottom"},
			"to_zone": "limbo", # Or specific "stolen" zone?
			"reason": "thought_acquirer",
		"	instance_id": "Not implemented yet. Thought Acquirer card moved from target lbrary."
		})

		# Add it to bottom of active player's library
		active_combatant.library.push_back(stolen_card_res)
		print("...Added %s to bottom of player library." % stolen_card_res.card_name)

		# Generate event for card entering player library
		battle_instance.add_event({
			"event_type": "card_moved",
			"card_id": stolen_card_res.id,
			"player": active_combatant.combatant_name,
			"from_zone": "limbo",
			"to_zone": "library",
			"to_details": {"position": "bottom"},
			"reason": "thought_acquirer",
		"	instance_id": "Not implemented yet. Thought Acquirer card moved to new library."
		})

		# Optional visual effect
		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "thought_acquirer_steal",
			"target_locations": [opponent_combatant.combatant_name + " library", active_combatant.combatant_name + " library"],
			"details": {"card_id": stolen_card_res.id},
		"	instance_id": "Not implemented yet, probably needed. Visual Effect."
		})
	else:
		print("...Opponent library is empty, nothing to steal.")
