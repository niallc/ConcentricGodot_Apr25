# res://logic/card_effects/portal_mage_effect.gd
extends SummonCardResource

func _on_arrival(summon_instance: SummonInstance, _active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle):
	var portal_mage_instance_id: int = summon_instance.instance_id
	var portal_mage_card_id: String = summon_instance.card_resource.id
	
	# target_lane_index is not actually used later, summon_instance.lane_index is, so it can be removed if not needed elsewhere
	# var target_lane_index: int = summon_instance.lane_index 
	var target_instance_to_bounce: SummonInstance = opponent_combatant.lanes[summon_instance.lane_index] 

	if target_instance_to_bounce != null:
		var bounced_card_resource: CardResource = target_instance_to_bounce.card_resource
		var original_bounced_summon_instance_id: int = target_instance_to_bounce.instance_id
		var bounced_from_lane_index_1_based: int = target_instance_to_bounce.lane_index + 1
		
		print("...Portal Mage (Instance: %s) bouncing %s (Instance: %s) from lane %d" % [portal_mage_instance_id, bounced_card_resource.card_name, original_bounced_summon_instance_id, bounced_from_lane_index_1_based])

		opponent_combatant.remove_summon_from_lane(target_instance_to_bounce.lane_index)

		var new_instance_id_for_library: int = battle_instance._generate_new_card_instance_id()
		var card_in_zone_for_library: CardInZone = CardInZone.new(bounced_card_resource, new_instance_id_for_library)
		opponent_combatant.library.push_front(card_in_zone_for_library) 

		battle_instance.add_event({
			"event_type": "summon_leaves_lane",
			"player": opponent_combatant.combatant_name,
			"lane": bounced_from_lane_index_1_based,
			"card_id": bounced_card_resource.id,
			"instance_id": original_bounced_summon_instance_id,
			"reason": "bounce_effect_" + portal_mage_card_id, # Using card_id is often better for machine readability
			"source_card_id": portal_mage_card_id,
			"source_instance_id": portal_mage_instance_id
		})
		
		battle_instance.add_event({
			"event_type": "card_moved",
			"card_id": bounced_card_resource.id,
			"player": opponent_combatant.combatant_name,
			"from_zone": "lane",
			"from_details": { 
				"lane": bounced_from_lane_index_1_based,
				"instance_id": original_bounced_summon_instance_id 
			},
			"to_zone": "library",
			"to_details": {
				"position": "top", # Portal Mage bounces to top
				"instance_id": new_instance_id_for_library 
			},
			"instance_id": original_bounced_summon_instance_id, 
			"reason": "bounce_effect_" + portal_mage_card_id, # Using card_id
			"source_card_id": portal_mage_card_id,
			"source_instance_id": portal_mage_instance_id
		})
		
		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "portal_mage_bounce",
			"instance_id": original_bounced_summon_instance_id, # Creature being bounced
			"card_id": bounced_card_resource.id,
			"target_locations": ["%s lane %d (ID: %s)" % [opponent_combatant.combatant_name, bounced_from_lane_index_1_based, original_bounced_summon_instance_id]],
			"details": {},
			"source_card_id": portal_mage_card_id,
			"source_instance_id": portal_mage_instance_id 
		})
	else:
		print("...Portal Mage (Instance: %s) found no target in opposing lane." % portal_mage_instance_id)
		battle_instance.add_event({
			"event_type":"log_message", 
			"message":"Portal Mage (Instance: %s) found no target in opposing lane." % portal_mage_instance_id,
			"card_id": portal_mage_card_id, # Good to have the card_id of the subject if instance_id is present
			"instance_id": portal_mage_instance_id, # The Portal Mage instance is the subject of this log
			"source_card_id": portal_mage_card_id,
			"source_instance_id": portal_mage_instance_id # Also the source
		})
