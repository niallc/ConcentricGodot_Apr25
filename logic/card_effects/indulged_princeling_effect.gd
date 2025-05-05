extends SummonCardResource

func _on_arrival(summon_instance: SummonInstance, active_combatant, _opponent_combatant, battle_instance):
	print("Indulged Princeling arrival trigger.")
	var cards_to_mill = 2

	if active_combatant.library.size() >= cards_to_mill:
		print("...Milling top %d cards." % cards_to_mill)
		for _i in range(cards_to_mill):
			var milled_card = active_combatant.library.pop_front()
			if milled_card != null:
				# Add to graveyard (generates card_moved event)
				active_combatant.add_card_to_graveyard(milled_card, "library_top")
			else:
				printerr("Indulged Princeling Error: pop_front returned null unexpectedly.")
				# Sacrifice self if something went wrong during mill? Or just continue?
				# Let's assume we only sacrifice if library was too small initially.
	else:
		print("...Not enough cards in library (%d < %d). Sacrificing Princeling!" % [active_combatant.library.size(), cards_to_mill])
		# Optional visual effect for sacrifice
		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "princeling_sacrifice",
			"target_locations": ["%s lane %d" % [active_combatant.combatant_name, summon_instance.lane_index + 1]],
			"details": {}
		}) # visual_effect event
		summon_instance.die() # Sacrifice self
