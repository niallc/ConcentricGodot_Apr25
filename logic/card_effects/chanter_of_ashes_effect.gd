extends SummonCardResource

func _on_arrival(_summon_instance: SummonInstance, active_combatant, opponent_combatant, battle_instance):
	print("Chanter of Ashes arrival trigger.")
	var consumed_count = 0
	var consumed_ids = [] # Keep track for events

	# Iterate backwards to safely remove from graveyard
	for i in range(active_combatant.graveyard.size() - 1, -1, -1):
		var card_res = active_combatant.graveyard[i]
		if card_res is SummonCardResource:
			print("...Consuming %s from graveyard." % card_res.card_name)
			consumed_ids.append(card_res.id)
			active_combatant.graveyard.remove_at(i)
			consumed_count += 1
			# Generate event for removal
			battle_instance.add_event({
				"event_type": "card_removed",
				"card_id": card_res.id,
				"player": active_combatant.combatant_name,
				"from_zone": "graveyard",
				"reason": "chanter_of_ashes"
			}) # card_removed event

	if consumed_count > 0:
		var damage_to_deal = consumed_count * 2
		print("...Consumed %d creatures, dealing %d damage to opponent." % [consumed_count, damage_to_deal])
		# Deal damage (take_damage generates hp_change event)
		var _defeated = opponent_combatant.take_damage(damage_to_deal, _summon_instance)
		# Generate specific damage event for context
		battle_instance.add_event({
			"event_type": "effect_damage", # New type? Or use direct_damage with source?
			"source_card_id": _summon_instance.card_resource.id,
			"source_player": active_combatant.combatant_name,
			"target_player": opponent_combatant.combatant_name,
			"amount": damage_to_deal,
			"target_player_remaining_hp": opponent_combatant.current_hp
		}) # effect_damage event
		# Optional visual effect
		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "chanter_damage",
			"target_locations": [opponent_combatant.combatant_name],
			"details": {"damage": damage_to_deal, "consumed_count": consumed_count}
		}) # visual_effect event
		# Check game over after dealing damage
		battle_instance.check_game_over()
	else:
		print("...Found no creatures in graveyard to consume.")
