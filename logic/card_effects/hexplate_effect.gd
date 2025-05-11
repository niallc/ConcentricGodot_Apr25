extends SpellCardResource

# Buff leftmost creature +1 Power / +4 HP
func apply_effect(source_card_res: SpellCardResource, active_combatant, _opponent_combatant, battle_instance):
	print("Hexplate effect.")
	var target_instance = null # SummonInstance
	var target_lane_index = -1
	# Find leftmost target
	for i in range(active_combatant.lanes.size()):
		if active_combatant.lanes[i] != null:
			target_instance = active_combatant.lanes[i]; target_lane_index = i; break

	if target_instance != null:
		print("...Applying Hexplate to %s in lane %d." % [target_instance.card_resource.card_name, target_lane_index + 1])
		# Apply buffs (methods handle events)
		target_instance.add_power(1, source_card_res.id, -1) # Permanent
		target_instance.add_hp(4, source_card_res.id, -1)    # Permanent

		# Optional visual effect
		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "hexplate_buff",
			"target_locations": ["%s lane %d" % [active_combatant.combatant_name, target_lane_index + 1]],
			"details": {"power": 1, "hp": 4},
			"instance_id": target_instance.instance_id
		}) # visual_effect event
	else:
		print("...Found no target creature.")
		battle_instance.add_event({"event_type":"log_message", "message":"Hexplate found no target."})
