extends SummonCardResource

func _on_arrival(_summon_instance: SummonInstance, _active_combatant, opponent_combatant, battle_instance):
	print("Flamewielder arrival trigger.")
	var damage = 1
	var affected_locations = []
	var targets = []

	# Find targets
	for instance in opponent_combatant.lanes:
		if instance != null:
			targets.append(instance)
			affected_locations.append("%s lane %d" % [opponent_combatant.combatant_name, instance.lane_index + 1])

	if targets.is_empty():
		print("...No opposing creatures found.")
		return

	# Generate visual effect first (optional)
	battle_instance.add_event({
		"event_type": "visual_effect",
		"effect_id": "flamewielder_damage",
		"target_locations": affected_locations,
		"details": {"damage": damage}
	}) # visual_effect event

	# Apply damage
	print("...Dealing %d damage to %d opposing creatures." % [damage, targets.size()])
	for target_instance in targets:
		target_instance.take_damage(damage, _summon_instance.card_resource)
