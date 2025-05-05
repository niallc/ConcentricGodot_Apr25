extends SummonCardResource

# On arrival, mill bottom card of opponent's deck
func _on_arrival(_summon_instance: SummonInstance, _active_combatant, opponent_combatant, battle_instance):
	print("Ghoul arrival trigger.")
	if not opponent_combatant.library.is_empty():
		# Remove bottom card
		var milled_card_res = opponent_combatant.library.pop_back()
		print("...Milling %s from bottom of opponent library." % milled_card_res.card_name)
		# Add it to opponent's graveyard (generates card_moved event)
		opponent_combatant.add_card_to_graveyard(milled_card_res, "library_bottom") # Specify source zone

		# Optional visual effect
		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "ghoul_mill",
			"target_locations": [opponent_combatant.combatant_name + " library", opponent_combatant.combatant_name + " graveyard"],
			"details": {"card_id": milled_card_res.id}
		}) # visual_effect event
	else:
		print("...Opponent library empty, nothing to mill.")
