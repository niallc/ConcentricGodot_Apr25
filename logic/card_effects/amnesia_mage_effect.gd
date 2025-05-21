extends SummonCardResource

func _on_arrival(summon_instance: SummonInstance, active_combatant, opponent_combatant, battle_instance):
	print("Amnesia Mage arrival trigger.")
	# Calculate mana drain: 2 base + 1 per card in owner's graveyard
	var base_drain = 2
	var grave_bonus = active_combatant.graveyard.size()
	var total_drain = base_drain + grave_bonus

	# Drain opponent's mana, ensuring it doesn't go below 0
	var mana_to_lose = min(total_drain, opponent_combatant.mana)

	if mana_to_lose > 0:
		print("...Opponent losing %d mana." % mana_to_lose)
		# We need a way to directly reduce opponent mana and generate event
		# Let's add a lose_mana method to Combatant
		opponent_combatant.lose_mana(mana_to_lose, summon_instance.card_resource.id, summon_instance.instance_id)

		# Optional visual effect
		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "amnesia_mana_drain",
			"target_locations": [opponent_combatant.combatant_name],
			"details": {"amount": mana_to_lose},
			"instance_id": summon_instance.instance_id,
			"source_instance_id": summon_instance.instance_id,
			"source_id": summon_instance.card_resource.id
		})
	else:
		print("...Opponent has no mana to lose.")
