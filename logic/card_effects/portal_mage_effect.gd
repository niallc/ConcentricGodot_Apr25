extends SummonCardResource

# Override _on_arrival to handle the bounce effect
func _on_arrival(summon_instance: SummonInstance, _active_combatant, opponent_combatant, battle_instance):
	print("Portal Mage arrival trigger!")
	var portal_mage_instance_id = summon_instance.instance_id
	var portal_mage_card_id = summon_instance.card_resource.id
	var target_lane_index = summon_instance.lane_index
	var target_instance_to_bounce = opponent_combatant.lanes[summon_instance.lane_index] # Opposing creature

	if target_instance_to_bounce != null:
		#var target_card_res = target_instance.card_resource
		var bounced_card_resource = target_instance_to_bounce.card_resource
		var original_bounced_summon_instance_id = target_instance_to_bounce.instance_id
		var bounced_from_lane_index_1_based = target_instance_to_bounce.lane_index + 1
		print("...bouncing opposing %s" % bounced_card_resource.card_name)

		# 1. Remove the target instance from the opponent's lane
		opponent_combatant.remove_summon_from_lane(target_instance_to_bounce.lane_index)
		# Note: remove_summon_from_lane doesn't generate an event itself

		# 2. Add the target's card *resource* to the top of the opponent's library
		# When adding to library, wrap it in a new CardInZone with a new instance_id
		var new_instance_id_for_library = battle_instance._generate_new_card_instance_id()
		var card_in_zone_for_library = CardInZone.new(bounced_card_resource, new_instance_id_for_library)
		opponent_combatant.library.push_front(card_in_zone_for_library) # Portal mage bounces to top
		#opponent_combatant.library.push_front(target_card_res)

		# 3. Generate events for replay
		# Event for the creature leaving the lane
		battle_instance.add_event({
			"event_type": "summon_leaves_lane",
			"player": opponent_combatant.combatant_name,
			"lane": bounced_from_lane_index_1_based,
			"card_id": bounced_card_resource.id,
			"instance_id": original_bounced_summon_instance_id,
			"reason": "bounce_" + portal_mage_card_id,
			"source_instance_id": portal_mage_instance_id
		})
		battle_instance.add_event({
			"event_type": "card_moved",
			"card_id": bounced_card_resource.id,
			"player": opponent_combatant.combatant_name,
			"from_zone": "lane",
			"from_details": { # More explicit from_details
			"lane": bounced_from_lane_index_1_based,
			"original_instance_id": original_bounced_summon_instance_id 
			},
			"to_zone": "library",
			"to_details": {
				"position": "top",
				"new_instance_id": new_instance_id_for_library # ID of the card in its new zone
			},
			"instance_id": original_bounced_summon_instance_id, # Primary instance_id for this event is the one that initiated the move
			"reason": "bounce_" + portal_mage_instance_id,
			"source_instance_id": portal_mage_instance_id
		})
		## Event for card moving to library
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
