extends SummonCardResource

func _on_arrival(summon_instance: SummonInstance, active_combatant, _opponent_combatant, _battle_instance):
	print("Master of Strategy arrival trigger.")
	var buff_count = 0
	# Iterate through the owner's lanes
	for i in range(active_combatant.lanes.size()):
		var other_instance = active_combatant.lanes[i]
		# Check if it's another summon instance and *not* the Master itself
		if other_instance != null and other_instance != summon_instance:
			print("...buffing %s in lane %d" % [other_instance.card_resource.card_name, i+1])
			# Apply +1/+1 counter (add_counter handles events)
			other_instance.add_counter(1, summon_instance.card_resource.id, -1) # Permanent buff
			buff_count += 1

	if buff_count == 0:
		print("...found no other creatures to buff.")
	# Optional: Visual effect event?
