# res://logic/card_effects/walking_sarcophagus_effect.gd
extends SummonCardResource

# summon_instance is the Walking Sarcophagus itself.
func _on_deal_direct_damage(summon_instance: SummonInstance, _target_player_combatant: Combatant, battle_instance: Battle) -> bool:
	var sarcophagus_instance_id: int = summon_instance.instance_id
	var sarcophagus_card_id: String = summon_instance.card_resource.id # "WalkingSarcophagus"
	var owner_combatant: Combatant = summon_instance.owner_combatant
	var opponent_of_owner: Combatant = summon_instance.opponent_combatant # Needed for new summon setup

	print("Walking Sarcophagus (Instance: %s) dealt direct damage, triggering effect." % sarcophagus_instance_id)

	# 1. Find leftmost creature CardInZone in owner's graveyard
	var target_card_from_graveyard: CardInZone = null
	var target_graveyard_index: int = -1
	for i in range(owner_combatant.graveyard.size()):
		var card_in_grave_slot = owner_combatant.graveyard[i]
		if card_in_grave_slot.card_resource is SummonCardResource:
			target_card_from_graveyard = card_in_grave_slot
			target_graveyard_index = i
			break # Found leftmost

	var sarcophagus_original_lane_index: int = summon_instance.lane_index # Store before die() might clear it from instance

	# 2. Sacrifice self (Walking Sarcophagus) FIRST
	print("...Sarcophagus (Instance: %s) sacrificing itself." % sarcophagus_instance_id)
	summon_instance.die(sarcophagus_card_id, sarcophagus_instance_id) # This generates creature_defeated and card_moved (lane to grave) for Sarcophagus

	# 3. Reanimate target if found AND lane Sarcophagus was in is now clear
	if target_card_from_graveyard != null:
		var reanimated_card_res: SummonCardResource = target_card_from_graveyard.card_resource as SummonCardResource
		var original_graveyard_instance_id_of_target: int = target_card_from_graveyard.get_card_instance_id()

		# Check if the lane the Sarcophagus was in is now clear.
		# die() calls owner_combatant.remove_summon_from_lane().
		if sarcophagus_original_lane_index != -1 and owner_combatant.lanes[sarcophagus_original_lane_index] == null:
			print("...Sarcophagus reanimating %s (Original GY Instance: %s) into lane %d." % [reanimated_card_res.card_name, original_graveyard_instance_id_of_target, sarcophagus_original_lane_index + 1])
			
			owner_combatant.graveyard.remove_at(target_graveyard_index) # Remove the target from graveyard
			
			battle_instance.add_event({
				"event_type": "card_moved",
				"card_id": reanimated_card_res.id,
				"instance_id": original_graveyard_instance_id_of_target,
				"player": owner_combatant.combatant_name,
				"from_zone": "graveyard",
				"to_zone": "limbo",
				"reason": "reanimated_by_" + sarcophagus_card_id,
				"source_card_id": sarcophagus_card_id,
				"source_instance_id": sarcophagus_instance_id 
			})

			var new_reanimated_summon = SummonInstance.new()
			var new_reanimated_field_instance_id: int = battle_instance._generate_new_card_instance_id()
			
			new_reanimated_summon.setup(reanimated_card_res, owner_combatant, opponent_of_owner, sarcophagus_original_lane_index, battle_instance, new_reanimated_field_instance_id)
			owner_combatant.place_summon_in_lane(new_reanimated_summon, sarcophagus_original_lane_index)

			battle_instance.add_event({
				"event_type": "summon_arrives",
				"player": owner_combatant.combatant_name,
				"card_id": reanimated_card_res.id,
				"lane": sarcophagus_original_lane_index + 1,
				"instance_id": new_reanimated_field_instance_id,
				"power": new_reanimated_summon.get_current_power(),
				"max_hp": new_reanimated_summon.get_current_max_hp(),
				"current_hp": new_reanimated_summon.current_hp,
				"is_swift": new_reanimated_summon.is_swift,
				"tags": new_reanimated_summon.tags.duplicate(),
				"source_card_id": sarcophagus_card_id,    
				"source_instance_id": sarcophagus_instance_id 
			})
			
			battle_instance.add_event({
				"event_type": "card_moved",
				"card_id": reanimated_card_res.id,
				"instance_id": original_graveyard_instance_id_of_target, 
				"player": owner_combatant.combatant_name,
				"from_zone": "limbo",
				"from_details": {"original_instance_id": original_graveyard_instance_id_of_target},
				"to_zone": "lane",
				"to_details": {
					"lane": sarcophagus_original_lane_index + 1,
					"instance_id": new_reanimated_field_instance_id 
				},
				"reason": "reanimated_by_" + sarcophagus_card_id,
				"source_card_id": sarcophagus_card_id,
				"source_instance_id": sarcophagus_instance_id
			})
			
			if new_reanimated_summon.card_resource.has_method("_on_arrival"):
				new_reanimated_summon.card_resource._on_arrival(new_reanimated_summon, owner_combatant, opponent_of_owner, battle_instance)
		else:
			printerr("Walking Sarcophagus (Instance: %s) Error: Lane %d not clear after sacrifice. Cannot reanimate." % [sarcophagus_instance_id, sarcophagus_original_lane_index + 1])
			# Card remains removed from graveyard but doesn't get summoned. This might be okay or might need putting back.
			# For now, assume it's consumed.
			battle_instance.add_event({
				"event_type":"log_message", 
				"message":"Sarcophagus (Instance: %s) lane %s not clear after sacrifice. Reanimation of %s failed." % [sarcophagus_instance_id, sarcophagus_original_lane_index + 1, reanimated_card_res.card_name],
				"source_card_id": sarcophagus_card_id,
				"source_instance_id": sarcophagus_instance_id
			})
	else:
		print("...Sarcophagus (Instance: %s) found no creature in graveyard to reanimate." % sarcophagus_instance_id)
		battle_instance.add_event({
			"event_type":"log_message", 
			"message":"Sarcophagus (Instance: %s) found no target in graveyard." % sarcophagus_instance_id,
			"source_card_id": sarcophagus_card_id,
			"source_instance_id": sarcophagus_instance_id
		})

	return true # Indicate that the original instance (Sarcophagus) was removed/handled by this effect.
