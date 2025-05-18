# res://logic/card_effects/glassgraft_effect.gd
extends SpellCardResource

func apply_effect(p_glassgraft_card_in_zone: CardInZone, active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle):
	var glassgraft_spell_instance_id: int = p_glassgraft_card_in_zone.get_card_instance_id()
	var glassgraft_spell_card_id: String = p_glassgraft_card_in_zone.get_card_id()

	print("Glassgraft (Instance: %s) effect." % glassgraft_spell_instance_id)

	var target_card_from_graveyard: CardInZone = null
	var target_graveyard_index: int = -1
	# Iterate forwards to find the *last* (rightmost) SummonCardResource in the graveyard
	for i in range(active_combatant.graveyard.size()):
		var card_in_grave_slot = active_combatant.graveyard[i]
		if card_in_grave_slot.card_resource is SummonCardResource:
			target_card_from_graveyard = card_in_grave_slot # Keep updating to get the last one found
			target_graveyard_index = i

	var target_lane_index: int = active_combatant.find_first_empty_lane()

	if target_card_from_graveyard != null and target_lane_index != -1:
		var reanimated_card_res: SummonCardResource = target_card_from_graveyard.card_resource as SummonCardResource
		var original_graveyard_instance_id: int = target_card_from_graveyard.get_card_instance_id()

		print("...Glassgraft reanimating rightmost: %s (Original GY Instance: %s) into lane %d" % [reanimated_card_res.card_name, original_graveyard_instance_id, target_lane_index + 1])
		
		active_combatant.graveyard.remove_at(target_graveyard_index)
		
		battle_instance.add_event({
			"event_type": "card_moved",
			"card_id": reanimated_card_res.id,
			"instance_id": original_graveyard_instance_id,
			"player": active_combatant.combatant_name,
			"from_zone": "graveyard",
			"to_zone": "limbo",
			"reason": "glassgraft_effect_" + glassgraft_spell_card_id,
			"source_card_id": glassgraft_spell_card_id,
			"source_instance_id": glassgraft_spell_instance_id
		})

		var new_summon = SummonInstance.new()
		var new_summon_field_instance_id: int = battle_instance._generate_new_card_instance_id()
		
		new_summon.setup(reanimated_card_res, active_combatant, opponent_combatant, target_lane_index, battle_instance, new_summon_field_instance_id)
		
		new_summon.custom_state["glassgrafted"] = true # Add the special state
		print("    ...%s (Instance: %s) is now glassgrafted." % [reanimated_card_res.card_name, new_summon_field_instance_id])

		active_combatant.place_summon_in_lane(new_summon, target_lane_index)
		
		battle_instance.add_event({
			"event_type": "summon_arrives",
			"player": active_combatant.combatant_name,
			"card_id": reanimated_card_res.id,
			"lane": target_lane_index + 1,
			"instance_id": new_summon_field_instance_id,
			"power": new_summon.get_current_power(),
			"max_hp": new_summon.get_current_max_hp(),
			"current_hp": new_summon.current_hp,
			"is_swift": new_summon.is_swift,
			"tags": new_summon.tags.duplicate(), # Send current tags
			"custom_state_keys": new_summon.custom_state.keys(), # Optional: log keys for debugging special states
			"source_card_id": glassgraft_spell_card_id,
			"source_instance_id": glassgraft_spell_instance_id
		})
		
		battle_instance.add_event({
			"event_type": "card_moved",
			"card_id": reanimated_card_res.id,
			"instance_id": original_graveyard_instance_id, # ID of the card as it was in limbo/graveyard
			"player": active_combatant.combatant_name,
			"from_zone": "limbo",
			"from_details": { "original_instance_id": original_graveyard_instance_id },
			"to_zone": "lane",
			"to_details": {
				"lane": target_lane_index + 1,
				"instance_id": new_summon_field_instance_id # ID of the new summon on the field
			},
			"reason": "glassgraft_effect_" + glassgraft_spell_card_id,
			"source_card_id": glassgraft_spell_card_id,
			"source_instance_id": glassgraft_spell_instance_id
		})
		
		if new_summon.card_resource != null and new_summon.card_resource.has_method("_on_arrival"):
			new_summon.card_resource._on_arrival(new_summon, active_combatant, opponent_combatant, battle_instance)

	elif target_card_from_graveyard == null:
		print("...Glassgraft (Instance: %s) found no summon target in graveyard." % glassgraft_spell_instance_id)
		battle_instance.add_event({
			"event_type":"log_message", 
			"message":"Glassgraft (Instance: %s) found no summon target in graveyard." % glassgraft_spell_instance_id,
			"source_card_id": glassgraft_spell_card_id,
			"source_instance_id": glassgraft_spell_instance_id
			})
	else: # No empty lane
		print("...Glassgraft (Instance: %s) found no empty lane for target." % glassgraft_spell_instance_id)
		battle_instance.add_event({
			"event_type":"log_message", 
			"message":"Glassgraft (Instance: %s) found no empty lane for target." % glassgraft_spell_instance_id,
			"source_card_id": glassgraft_spell_card_id,
			"source_instance_id": glassgraft_spell_instance_id
			})

# `can_play` also needs to check `card_in_zone_obj.card_resource`
func can_play(active_combatant: Combatant, _opponent_combatant: Combatant, _turn_count: int, _battle_instance: Battle) -> bool:
	if active_combatant.mana < self.cost: 
		return false
	var summon_in_grave = false
	for card_in_zone_obj in active_combatant.graveyard:
		if card_in_zone_obj.card_resource is SummonCardResource: # Check the wrapped resource
			summon_in_grave = true
			# For Glassgraft, we don't break; we need to know if *any* summon exists.
			# The apply_effect logic will find the rightmost.
	if not summon_in_grave: # Explicitly check after iterating
		return false
		
	var lane_available = active_combatant.find_first_empty_lane() != -1
	return lane_available # No need for summon_in_grave check here again, it's covered
