extends SpellCardResource

# Find highest power opposing creature and reduce its power by 2
func apply_effect(source_card_res: SpellCardResource, active_combatant, _opponent_combatant, battle_instance):
	var highest_power = -1 # Use -1 to correctly handle 0-power creatures
	var target_instance = null # SummonInstance
	var target_lane_index = -1

	# Find the opponent's creature with the highest current power
	# We now correctly use _opponent_combatant from the parameters
	for i in range(_opponent_combatant.lanes.size()):
		var instance = _opponent_combatant.lanes[i]
		if instance != null:
			var current_power = instance.get_current_power() # Use calculated power
			# If powers are equal, leftmost wins (due to loop order)
			if current_power > highest_power:
				highest_power = current_power
				target_instance = instance
				target_lane_index = i

	# If a target was found, apply the power reduction
	if target_instance != null:
		var power_reduction = -2 # Negative value for reduction
		print("Disarm targeting %s in lane %d (Power: %d)" % [target_instance.card_resource.card_name, target_lane_index + 1, highest_power])
		# Add a permanent negative power modifier
		# Pass the source card's ID for tracking/debugging
		target_instance.add_power(power_reduction, source_card_res.id, -1) # Duration -1 for permanent

		# Optional: Generate visual effect event
		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "disarm_debuff",
			"target_locations": ["%s lane %d" % [_opponent_combatant.combatant_name, target_lane_index + 1]],
			"details": {"amount": power_reduction}
		})
	else:
		# Log if no target was found
		print("Disarm found no target.")
		battle_instance.add_event({
			"event_type": "log_message", # Or "effect_fizzled"
			"message": "%s's Disarm found no target." % active_combatant.combatant_name
		})


# Check if opponent has creatures (required target)
func can_play(active_combatant, opponent_combatant, _turn_count: int, _battle_instance) -> bool:
	# Base mana check
	if active_combatant.mana < self.cost:
		return false
	# Check if opponent has any creatures
	for instance in opponent_combatant.lanes:
		if instance != null:
			return true # Found a potential target
	# print("Disarm can't be played: Opponent has no creatures.") # Keep print for debugging if needed
	return false
