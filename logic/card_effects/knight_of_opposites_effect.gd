extends SummonCardResource

func _on_arrival(_summon_instance: SummonInstance, active_combatant, opponent_combatant, battle_instance):
	print("Knight of Opposites arrival trigger: Swapping HP.")
	var player_hp = active_combatant.current_hp
	var opponent_hp = opponent_combatant.current_hp

	# Only swap if HP values are different to avoid unnecessary events
	if player_hp != opponent_hp:
		# Calculate changes before applying
		var player_change = opponent_hp - player_hp
		var opponent_change = player_hp - opponent_hp

		# Apply changes directly (setter handles clamping)
		active_combatant.current_hp = opponent_hp
		opponent_combatant.current_hp = player_hp

		# Generate events for the changes
		battle_instance.add_event({
			"event_type": "hp_change",
			"player": active_combatant.combatant_name,
			"amount": player_change,
			"new_total": active_combatant.current_hp,
			"source": "KnightOfOpposites"
		}) # hp_change event for player
		battle_instance.add_event({
			"event_type": "hp_change",
			"player": opponent_combatant.combatant_name,
			"amount": opponent_change,
			"new_total": opponent_combatant.current_hp,
			"source": "KnightOfOpposites"
		}) # hp_change event for opponent

		# Optional visual effect
		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "knight_hp_swap",
			"target_locations": [active_combatant.combatant_name, opponent_combatant.combatant_name],
			"details": {}
		}) # visual_effect event

		# Check if swap caused game over
		battle_instance.check_game_over()
	else:
		print("...HP values are equal, no swap needed.")
