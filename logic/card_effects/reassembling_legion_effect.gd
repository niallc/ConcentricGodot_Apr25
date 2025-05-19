# res://logic/card_effects/reassembling_legion_effect.gd
extends SummonCardResource

# summon_instance is the Reassembling Legion that just died.
func _on_death(summon_instance: SummonInstance, active_combatant: Combatant, _opponent_combatant, battle_instance_ref: Battle):
	var dying_legion_instance_id: int = summon_instance.instance_id
	var legion_card_resource: SummonCardResource = summon_instance.card_resource 
	var legion_card_id: String = legion_card_resource.id # Should be "ReassemblingLegion"

	print("Reassembling Legion (Instance: %s) death trigger! Returning to deck." % dying_legion_instance_id)
	
	if legion_card_resource != null:
		# Create a new CardInZone for the library representation.
		var new_instance_id_for_library: int = battle_instance_ref._generate_new_card_instance_id()
		var card_in_zone_for_library: CardInZone = CardInZone.new(legion_card_resource, new_instance_id_for_library)
		
		active_combatant.library.push_back(card_in_zone_for_library) # Add to bottom
		
		battle_instance_ref.add_event({
			"event_type": "card_moved",
			"card_id": legion_card_id,
			"instance_id": dying_legion_instance_id, # ID of the Legion that died from the lane
			"player": active_combatant.combatant_name,
			"from_zone": "lane",
			"from_details": {
				"lane": summon_instance.lane_index + 1, 
				"instance_id": dying_legion_instance_id
			},
			"to_zone": "library",
			"to_details": {
				"position": "bottom",
				"instance_id": new_instance_id_for_library # The new ID in the library
			},
			"reason": "death_effect_" + legion_card_id,
			"source_card_id": legion_card_id,         # Legion's own effect
			"source_instance_id": dying_legion_instance_id # This specific Legion instance
		})
		
		summon_instance.custom_state["prevent_graveyard"] = true # Prevent default graveyard addition
	else:
		printerr("Reassembling Legion (Instance: %s) _on_death: Dying instance has no card_resource!" % dying_legion_instance_id)
