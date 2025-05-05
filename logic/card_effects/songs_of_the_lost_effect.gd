extends SpellCardResource

func apply_effect(source_card_res: SpellCardResource, active_combatant, opponent_combatant, battle_instance):
	print("Songs of the Lost effect.")
	# Count creatures in own graveyard
	var creature_count = 0
	for card in active_combatant.graveyard:
		if card is SummonCardResource:
			creature_count += 1

	if creature_count > 0:
		# Gain mana (2 per creature)
		var mana_gained = creature_count * 2
		print("...Gaining %d mana." % mana_gained)
		active_combatant.gain_mana(mana_gained) # Handles event

		# Opponent loses mana (1 per creature)
		var mana_lost = creature_count
		print("...Opponent losing %d mana." % mana_lost)
		opponent_combatant.lose_mana(mana_lost, source_card_res.id) # Handles event & clamping

		# Optional visual effect
		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "songs_of_the_lost_cast",
			"target_locations": [active_combatant.combatant_name, opponent_combatant.combatant_name],
			"details": {"creatures": creature_count, "mana_gained": mana_gained, "mana_lost": mana_lost}
		}) # visual_effect event
	else:
		print("...No creatures in graveyard.")
