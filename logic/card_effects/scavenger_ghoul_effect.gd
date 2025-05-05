extends SummonCardResource

func _on_arrival(_summon_instance: SummonInstance, active_combatant, opponent_combatant, battle_instance):
	print("Scavenger Ghoul arrival trigger.")
	var consumed_count = 0
	var consumed_ids = []

	# Consume player's graveyard
	for i in range(active_combatant.graveyard.size() - 1, -1, -1):
		var card_res = active_combatant.graveyard[i]
		if card_res is SummonCardResource:
			consumed_ids.append({"player": active_combatant.combatant_name, "id": card_res.id})
			active_combatant.graveyard.remove_at(i)
			consumed_count += 1
			battle_instance.add_event({ }) # card_removed event

	# Consume opponent's graveyard
	for i in range(opponent_combatant.graveyard.size() - 1, -1, -1):
		var card_res = opponent_combatant.graveyard[i]
		if card_res is SummonCardResource:
			consumed_ids.append({"player": opponent_combatant.combatant_name, "id": card_res.id})
			opponent_combatant.graveyard.remove_at(i)
			consumed_count += 1
			battle_instance.add_event({ }) # card_removed event

	if consumed_count > 0:
		var life_gain = consumed_count * 2
		print("...Consumed %d creatures total. Gaining %d life." % [consumed_count, life_gain])
		active_combatant.heal(life_gain) # heal() handles event

		# Optional visual effect
		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "scavenger_consume_heal",
			"target_locations": [active_combatant.combatant_name],
			"details": {"consumed": consumed_count, "healed": life_gain}
		}) # visual_effect event
	else:
		print("...Found no creatures in any graveyard to consume.")
