extends SummonCardResource

func _on_arrival(_summon_instance: SummonInstance, active_combatant, opponent_combatant, battle_instance):
	print("Corpsetide Lich arrival trigger.")
	var opponent_grave_size = opponent_combatant.graveyard.size()
	if opponent_grave_size > 0:
		print("...Moving %d cards from opponent's graveyard to player's." % opponent_grave_size)
		# Move cards one by one to generate events
		# Iterate copy as we modify original
		var cards_to_move = opponent_combatant.graveyard.duplicate()
		opponent_combatant.graveyard.clear() # Clear opponent grave first

		for card_res in cards_to_move:
			# Event for leaving opponent grave
			battle_instance.add_event({
				"event_type": "card_moved",
				"card_id": card_res.id,
				"player": opponent_combatant.combatant_name,
				"from_zone": "graveyard",
				"to_zone": "limbo", # Or "transfer"?
				"reason": "corpsetide_lich"
			}) # card_moved event
			# Add to player's graveyard (generates its own card_moved event)
			active_combatant.add_card_to_graveyard(card_res, "limbo") # Source is limbo

		# Optional visual effect
		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "corpsetide_transfer",
			"target_locations": [opponent_combatant.combatant_name + " graveyard", active_combatant.combatant_name + " graveyard"],
			"details": {"count": opponent_grave_size}
		}) # visual_effect event
	else:
		print("...Opponent graveyard is empty.")
