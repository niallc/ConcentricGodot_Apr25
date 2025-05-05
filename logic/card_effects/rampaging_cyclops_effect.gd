extends SummonCardResource

func _on_arrival(_summon_instance: SummonInstance, active_combatant, opponent_combatant, battle_instance):
	print("Rampaging Cyclops arrival trigger.")
	var damage = 1
	var affected_locations = []
	var targets = []

	# Find all targets (friendly and enemy)
	for instance in active_combatant.lanes:
		#if instance != null and instance != _summon_instance: # Don't damage self
		if instance != null: # Do damage self!!
			targets.append(instance)
			affected_locations.append("%s lane %d" % [active_combatant.combatant_name, instance.lane_index + 1])
	for instance in opponent_combatant.lanes:
		if instance != null:
			targets.append(instance)
			affected_locations.append("%s lane %d" % [opponent_combatant.combatant_name, instance.lane_index + 1])

	if targets.is_empty():
		print("...No other creatures found.")
		return

	# Generate visual effect first (optional)
	battle_instance.add_event({
		"event_type": "visual_effect",
		"effect_id": "cyclops_stomp",
		"target_locations": affected_locations,
		"details": {"damage": damage}
	}) # visual_effect event

	# Apply damage
	print("...Dealing %d damage to %d creatures." % [damage, targets.size()])
	for target_instance in targets:
		target_instance.take_damage(damage, _summon_instance.card_resource)
