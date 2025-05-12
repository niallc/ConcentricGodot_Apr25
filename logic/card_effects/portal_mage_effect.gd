extends SummonCardResource

# Override _on_arrival to handle the bounce effect
func _on_arrival(summon_instance: SummonInstance, _active_combatant, opponent_combatant, battle_instance):
	print("Portal Mage arrival trigger!")
	var target_lane_index = summon_instance.lane_index
	var target_instance = opponent_combatant.lanes[target_lane_index]

	if target_instance != null:
		var target_card_res = target_instance.card_resource
		print("...bouncing opposing %s" % target_card_res.card_name)

		# 1. Remove the target instance from the opponent's lane
		opponent_combatant.remove_summon_from_lane(target_lane_index)
		# Note: remove_summon_from_lane doesn't generate an event itself

		# 2. Add the target's card *resource* to the top of the opponent's library
		opponent_combatant.library.push_front(target_card_res)

		# 3. Generate events for replay
		# Event for the creature leaving the lane
		battle_instance.add_event({
			"event_type": "summon_leaves_lane", # New event type? Or use card_moved?
			"player": opponent_combatant.combatant_name,
			"lane": target_lane_index + 1,
			"card_id": target_card_res.id,
			"reason": "bounce_portal_mage",
			"instance_id": "Not implemented yet. Portal mage leave-lane effect."
		})
		# Event for card moving to library
		battle_instance.add_event({
			"event_type": "card_moved",
			"card_id": target_card_res.id,
			"player": opponent_combatant.combatant_name,
			"from_zone": "lane", # Or maybe "bounce_effect"?
			"to_zone": "library",
			"to_details": {"position": "top"},
			"instance_id": "Not implemented yet. Portal mage back in library effect."
		})
		# Optional: Visual effect event
		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "portal_mage_bounce",
			"target_locations": ["%s lane %d" % [opponent_combatant.combatant_name, target_lane_index + 1]],
			"details": {},
			"instance_id": "Not implemented yet. Portal mage visual effect."
		})

	else:
		print("...no target found in opposing lane.")
