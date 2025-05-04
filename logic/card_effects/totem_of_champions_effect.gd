extends SpellCardResource

func apply_effect(source_card_res: SpellCardResource, active_combatant, opponent_combatant, battle_instance):
	print("Totem of Champions effect.")
	var buff_amount = 1
	var debuff_amount = -1
	var source_id = source_card_res.id

	# Buff player's creatures
	print("...Buffing player creatures.")
	for instance in active_combatant.lanes:
		if instance != null:
			instance.add_power(buff_amount, source_id, -1) # Permanent

	# Debuff opponent's creatures
	print("...Debuffing opponent creatures.")
	for instance in opponent_combatant.lanes:
		if instance != null:
			# Only apply debuff if power > 0? Original JS didn't seem to check.
			# Let's apply it always, get_current_power() handles clamping to 0.
			instance.add_power(debuff_amount, source_id, -1) # Permanent

	# Optional visual effect (could target all lanes?)
	battle_instance.add_event({
		"event_type": "visual_effect",
		"effect_id": "totem_of_champions_cast",
		"target_locations": ["all_lanes"], # Example target
		"details": {}
	})
