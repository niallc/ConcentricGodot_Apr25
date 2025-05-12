extends SpellCardResource

func apply_effect(_source_card_res: SpellCardResource, active_combatant, opponent_combatant, battle_instance):
	print("Superior Intellect effect.")
	# 1. Move player's graveyard to bottom of library
	var cards_moved_count = active_combatant.graveyard.size()
	if cards_moved_count > 0:
		print("...Moving %d cards from player graveyard to library bottom." % cards_moved_count)
		#Backards approach...
		# Iterate backwards to preserve original graveyard order at bottom of library
		# for i in range(cards_moved_count - 1, -1, -1): # Old backward iteration
		# Forward Approach
		# Iterate forwards to preserve order with push_back ---
		for card_to_move in active_combatant.graveyard: # Iterate forwards
			# var card_to_move = active_combatant.graveyard[i]
			active_combatant.library.push_back(card_to_move)
			# Generate event for each card moved
			battle_instance.add_event({
				"event_type": "card_moved",
				"card_id": card_to_move.id,
				"player": active_combatant.combatant_name,
				"from_zone": "graveyard",
				"to_zone": "library",
				"to_details": {"position": "bottom"},
				"instance_id": "None, card moving effect."
			})
		active_combatant.graveyard.clear() # Clear graveyard after moving

	# 2. Empty opponent's graveyard
	var opponent_grave_count = opponent_combatant.graveyard.size()
	if opponent_grave_count > 0:
		print("...Emptying opponent's graveyard (%d cards)." % opponent_grave_count)
		# Generate event for each card removed (optional, could be one summary event)
		for card_to_remove in opponent_combatant.graveyard:
			battle_instance.add_event({
				"event_type": "card_removed", # Or card_moved to "oblivion"?
				"card_id": card_to_remove.id,
				"player": opponent_combatant.combatant_name,
				"from_zone": "graveyard",
				"reason": "superior_intellect",
				"instance_id": "None, card effect (emptying graveyard)."
			})
		opponent_combatant.graveyard.clear()

	# Optional: Generate visual effect event
	battle_instance.add_event({
		"event_type": "visual_effect",
		"effect_id": "superior_intellect_cast",
		"target_locations": [active_combatant.combatant_name + " graveyard", opponent_combatant.combatant_name + " graveyard"],
		"details": {},
		"instance_id": "None, visual effect."
	})
