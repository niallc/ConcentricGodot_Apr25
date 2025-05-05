extends SummonCardResource

func _on_arrival(summon_instance: SummonInstance, _active_combatant, opponent_combatant, battle_instance):
	print("Refined Impersonator arrival trigger.")
	var target_lane_index = summon_instance.lane_index
	var opposing_instance = opponent_combatant.lanes[target_lane_index]

	if opposing_instance != null:
		# Get target's stats
		var target_power = opposing_instance.get_current_power()
		# Note: JS copied maxHP + 1. Let's copy base_max_hp + 1 to avoid copying temporary buffs.
		var target_base_max_hp = opposing_instance.base_max_hp
		var hp_to_set = target_base_max_hp + 1

		print("...Copying stats from %s (P:%d, BaseMaxHP:%d)." % [opposing_instance.card_resource.card_name, target_power, target_base_max_hp])

		# Calculate needed adjustments from Imp's base (0 P, 1 HP)
		var power_gain = target_power - summon_instance.base_power # Should be target_power - 0
		var hp_gain = hp_to_set - summon_instance.base_max_hp    # Should be target_base_max_hp + 1 - 1

		# Apply permanent modifiers (using add_power/add_hp for events)
		if power_gain != 0:
			summon_instance.add_power(power_gain, summon_instance.card_resource.id + "_arrival", -1)
		if hp_gain != 0:
			summon_instance.add_hp(hp_gain, summon_instance.card_resource.id + "_arrival", -1)
			# Ensure current HP matches new max HP after adjustment
			summon_instance.current_hp = summon_instance.get_current_max_hp()
			# Generate another event for the current HP change if needed, though add_hp's heal might cover it
			# We might need a direct set_hp method or ensure add_hp fully heals.
			# Let's assume add_hp's heal call is sufficient for now.

		# Optional visual effect
		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "impersonator_copy",
			"target_locations": ["%s lane %d" % [summon_instance.owner_combatant.combatant_name, target_lane_index + 1]],
			"details": {"target_id": opposing_instance.card_resource.id}
		}) # visual_effect event

	else:
		print("...No opposing creature to copy.")
