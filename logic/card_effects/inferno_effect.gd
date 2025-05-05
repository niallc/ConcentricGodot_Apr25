extends SpellCardResource

func apply_effect(source_card_res: SpellCardResource, active_combatant, opponent_combatant, battle_instance):
	print("Inferno effect.")
	var damage = 2
	var affected_locations = []
	var targets = [] # Store instances to damage after iteration

	# Find all targets first
	for instance in active_combatant.lanes:
		if instance != null:
			targets.append(instance)
			affected_locations.append("%s lane %d" % [active_combatant.combatant_name, instance.lane_index + 1])
	for instance in opponent_combatant.lanes:
		if instance != null:
			targets.append(instance)
			affected_locations.append("%s lane %d" % [opponent_combatant.combatant_name, instance.lane_index + 1])

	if targets.is_empty():
		print("...No creatures found to damage.")
		return

	# Generate visual effect first (optional)
	battle_instance.add_event({
		"event_type": "visual_effect",
		"effect_id": "inferno_damage",
		"target_locations": affected_locations,
		"details": {"damage": damage}
	}) # visual_effect event

	# Apply damage to all targets
	print("...Dealing %d damage to %d creatures." % [damage, targets.size()])
	for target_instance in targets:
		# Check if target is still valid (might have died from previous effect/trigger?)
		# This simple loop assumes no mid-effect deaths matter here.
		target_instance.take_damage(damage, source_card_res) # take_damage handles events
