extends SummonCardResource

func _on_arrival(summon_instance: SummonInstance, _active_combatant, opponent_combatant, battle_instance):
	print("Slayer arrival trigger.")
	var target_lane_index = summon_instance.lane_index
	var target_instance = opponent_combatant.lanes[target_lane_index]

	if target_instance != null:
		# Check if the opposing creature has the Undead tag
		if target_instance.tags.has(Constants.TAG_UNDEAD):
			print("...Slayer found Undead target (%s)! Destroying." % target_instance.card_resource.card_name)
			# Generate visual effect first (optional)
			battle_instance.add_event({
				"event_type": "visual_effect",
				"effect_id": "slayer_destroy",
				"target_locations": ["%s lane %d" % [opponent_combatant.combatant_name, target_lane_index + 1]],
				"details": {},
				"source_instance_id": summon_instance.instance_id,
				"instance_id": target_instance.instance_id
			})
			# Destroy the target (die handles events)
			target_instance.die()
		else:
			print("...Opposing creature (%s) is not Undead." % target_instance.card_resource.card_name)
	else:
		print("...No target found in opposing lane.")
