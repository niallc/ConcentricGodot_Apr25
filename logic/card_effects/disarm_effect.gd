extends SpellCardResource

func apply_effect(source_card_res: SpellCardResource, active_combatant, opponent_combatant, battle_instance):
	var highest_power = -1
	var target_instance = null # SummonInstance
	var target_lane_index = -1

	# Find the opponent's creature with the highest current power
	for i in range(opponent_combatant.lanes.size()):
		var instance = opponent_combatant.lanes[i]
		if instance != null:
			var current_power = instance.get_current_power() # Use calculated power
			if current_power > highest_power:
				highest_power = current_power
				target_instance = instance
				target_lane_index = i

	# If a target was found, apply the power reduction
	if target_instance != null:
		var power_reduction = -2 # Negative value for reduction
		print("Disarm targeting %s in lane %d (Power: %d)" % [target_instance.card_resource.card_name, target_lane_index + 1, highest_power])
		# Add a permanent negative power modifier
		target_instance.add_power(power_reduction, source_card_res.id, -1)

		# Optional: Generate visual effect event
		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "disarm_debuff",
			"target_locations": ["%s lane %d" % [opponent_combatant.combatant_name, target_lane_index + 1]],
			"details": {"amount": power_reduction}
		})
	else:
		# Log if no target was found
		battle_instance.add_event({
			"event_type": "log_message",
			"message": "%s's Disarm found no target." % active_combatant.combatant_name
		})


func can_play(active_combatant, opponent_combatant, _turn_count: int, _battle_instance) -> bool:
	# Debug prints added previously - keep them for now if needed
	# Base mana check
	if active_combatant.mana < self.cost:
		# print("Disarm can_play: Fails mana check (%d < %d)" % [active_combatant.mana, self.cost])
		return false
	# Check if opponent has any creatures
	for instance in opponent_combatant.lanes:
		if instance != null:
			# print("Disarm can_play: Passes target check.")
			return true # Found a potential target
	# print("Disarm can_play: Fails target check (no opponent creatures).")
	return false
