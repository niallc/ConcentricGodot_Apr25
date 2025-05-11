extends SummonCardResource

func _on_arrival(summon_instance: SummonInstance, _active_combatant, opponent_combatant, battle_instance):
	print("Taunting Elf arrival trigger.")
	var target_lane_index = summon_instance.lane_index
	var target_instance = opponent_combatant.lanes[target_lane_index]

	if target_instance != null:
		if not target_instance.is_relentless:
			print("...Making opposing %s Relentless." % target_instance.card_resource.card_name)
			target_instance.is_relentless = true
			# Generate status change event
			battle_instance.add_event({
				"event_type": "status_change",
				"player": opponent_combatant.combatant_name,
				"lane": target_lane_index + 1,
				"status": "Relentless",
				"gained": true,
				"source": summon_instance.card_resource.id,
				"instance_id": target_instance.instance_id
			}) # status_change event
			# Optional visual effect
			battle_instance.add_event({
				"event_type": "visual_effect",
				"effect_id": "taunting_elf_debuff",
				"target_locations": ["%s lane %d" % [opponent_combatant.combatant_name, target_lane_index + 1]],
				"details": {},
				"instance_id": target_instance.instance_id
			}) # visual_effect event
		else:
			print("...Opposing %s is already Relentless." % target_instance.card_resource.card_name)
	else:
		print("...No opposing creature found.")
