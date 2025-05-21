extends SummonCardResource

func _on_arrival(summon_instance: SummonInstance, active_combatant, _opponent_combatant, _battle_instance):
	print("Insatiable Devourer arrival trigger.")
	var consumed_count = 0
	# Need to copy lane indices to avoid issues while modifying the array
	var lanes_to_check: Array[int] = []
	for i in range(active_combatant.lanes.size()):
		lanes_to_check.append(i)

	for i in lanes_to_check:
		var other_instance = active_combatant.lanes[i]
		# Check if it's another summon and NOT the Devourer itself
		if other_instance != null and other_instance != summon_instance:
			print("...Devouring %s in lane %d." % [other_instance.card_resource.card_name, i + 1])
			other_instance.die(summon_instance.card_resource.id, summon_instance.instance_id)
			consumed_count += 1

	if consumed_count > 0:
		print("...Devourer consumed %d creatures, gaining +%d/+%d." % [consumed_count, consumed_count * 2, consumed_count * 2])
		summon_instance.add_counter(consumed_count * 2, summon_instance.card_resource.id + "_arrival", summon_instance.instance_id, -1)
	else:
		print("...Found no other creatures to devour.")
