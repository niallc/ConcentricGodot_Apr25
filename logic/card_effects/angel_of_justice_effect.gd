extends SummonCardResource

func _on_arrival(_summon_instance: SummonInstance, active_combatant, opponent_combatant, battle_instance):
	print("Angel of Justice arrival trigger.")
	# Count creatures
	var player_creature_count = 0
	for instance in active_combatant.lanes:
		if instance != null: player_creature_count += 1
	var opponent_creature_count = 0
	for instance in opponent_combatant.lanes:
		if instance != null: opponent_creature_count += 1

	print("...Player creatures: %d, Opponent creatures: %d" % [player_creature_count, opponent_creature_count])

	# Check condition
	if player_creature_count < opponent_creature_count:
		print("...Player has fewer creatures. Destroying opponent's rightmost.")
		# Find opponent's rightmost creature
		var target_instance = null # SummonInstance
		var target_lane_index = -1
		for i in range(opponent_combatant.lanes.size() - 1, -1, -1): # Iterate right-to-left
			if opponent_combatant.lanes[i] != null:
				target_instance = opponent_combatant.lanes[i]
				target_lane_index = i
				break

		if target_instance != null:
			print("...Destroying %s in lane %d." % [target_instance.card_resource.card_name, target_lane_index + 1])
			# Optional visual effect
			battle_instance.add_event({
				"event_type": "visual_effect",
				"effect_id": "angel_destroy",
				"target_locations": ["%s lane %d" % [opponent_combatant.combatant_name, target_lane_index + 1]],
				"details": {},
				"source_instance_id": _summon_instance.instance_id,
				"instance_id": target_instance.instance_id
			}) # visual_effect event
			target_instance.die(_summon_instance.card_resource.id, _summon_instance.instance_id)
		else:
			# Should not happen if opponent_creature_count > 0, but log defensively
			printerr("Angel of Justice Error: Condition met but no rightmost creature found?")
	else:
		print("...Condition not met.")
