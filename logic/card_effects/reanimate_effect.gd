extends SpellCardResource
# I'll assume you meant for this to be the path to your base spell card script.
# I'll assume you meant for this to be the path to your base spell card script.
# I'll assume you meant for this to be the path to your base spell card script.

func apply_effect(p_reanimate_card_in_zone: CardInZone, active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle): # Added type hints
	print("Reanimate effect.")
	var reanimate_spell_instance_id: int = p_reanimate_card_in_zone.get_card_instance_id()
	var reanimate_spell_card_id: String = p_reanimate_card_in_zone.get_card_id()
	
	var target_card_in_zone: CardInZone = null # This will be the CardInZone from the graveyard
	var target_index: int = -1
	for i in range(active_combatant.graveyard.size()):
		if active_combatant.graveyard[i].card_resource is SummonCardResource:
			target_card_in_zone = active_combatant.graveyard[i]
			target_index = i
			break

	var target_lane_index: int = active_combatant.find_first_empty_lane()

	if target_card_in_zone != null and target_lane_index != -1:
		var reanimated_creature_card_resource: SummonCardResource = target_card_in_zone.card_resource as SummonCardResource
		var reanimated_creature_original_instance_id: int = target_card_in_zone.get_card_instance_id()

		print("...Reanimating %s (Original Instance: %s) into lane %d" % [reanimated_creature_card_resource.card_name, reanimated_creature_original_instance_id, target_lane_index + 1])
		
		active_combatant.graveyard.remove_at(target_index)
		
		battle_instance.add_event({
			"event_type": "card_moved",
			"card_id": reanimated_creature_card_resource.id,
			"instance_id": reanimated_creature_original_instance_id,
			"source_card_id": reanimate_spell_card_id,
			"source_instance_id": reanimate_spell_instance_id,
			"player": active_combatant.combatant_name,
			"from_zone": "graveyard",
			"to_zone": "limbo", 
			"reason": "reanimate_effect_" + reanimate_spell_card_id # More specific reason
		})

		var new_summon_on_field = SummonInstance.new()
		var new_summon_on_field_instance_id = battle_instance._generate_new_card_instance_id()
		
		new_summon_on_field.setup(reanimated_creature_card_resource, active_combatant, opponent_combatant, target_lane_index, battle_instance, new_summon_on_field_instance_id)
		
		if not new_summon_on_field.tags.has(Constants.TAG_UNDEAD):
			new_summon_on_field.tags.append(Constants.TAG_UNDEAD)
			# It's good practice to log this status change as well!
			battle_instance.add_event({
				"event_type": "status_change",
				"player": active_combatant.combatant_name,
				"lane": target_lane_index + 1,
				"card_id": new_summon_on_field.card_resource.id,
				"instance_id": new_summon_on_field.instance_id,
				"status": Constants.TAG_UNDEAD,
				"gained": true,
				"source": reanimate_spell_card_id,
				"source_instance_id": reanimate_spell_instance_id
			})

		active_combatant.place_summon_in_lane(new_summon_on_field, target_lane_index)
		
		battle_instance.add_event({
			"event_type": "summon_arrives",
			"player": active_combatant.combatant_name,
			"card_id": reanimated_creature_card_resource.id,
			"lane": target_lane_index + 1,
			"instance_id": new_summon_on_field_instance_id,
			"power": new_summon_on_field.get_current_power(),
			"max_hp": new_summon_on_field.get_current_max_hp(),
			"current_hp": new_summon_on_field.current_hp,
			"is_swift": new_summon_on_field.is_swift,
			"tags": new_summon_on_field.tags.duplicate(),
			"source_card_id": reanimate_spell_card_id, # <<< ADDED (was source_effect)
			"source_instance_id": reanimate_spell_instance_id # <<< RENAMED (was source_isntance_id)
			# "source_effect": reanimate_spell_card_id # OLD - replacing with source_card_id and source_instance_id
		})
		
		battle_instance.add_event({
			"event_type": "card_moved",
			"card_id": reanimated_creature_card_resource.id, # Correct
			# Main instance_id for this event: the ID of the CardInZone that was in limbo (and originally graveyard)
			"instance_id": reanimated_creature_original_instance_id, 
			"source_card_id": reanimate_spell_card_id, # Correct (was source_id)
			"source_instance_id": reanimate_spell_instance_id,
			"player": active_combatant.combatant_name,
			"from_zone": "limbo",
			# "from_details": { "original_instance_id": reanimated_creature_original_instance_id }, # Could add for super explicitness
			"to_zone": "lane",
			"to_details": {
				"lane": target_lane_index + 1,
				"instance_id": new_summon_on_field_instance_id # ID of the NEW summon on the field
			},
			"reason": "reanimate_effect_" + reanimate_spell_card_id # More specific reason
		})
		
		if new_summon_on_field.card_resource != null and new_summon_on_field.card_resource.has_method("_on_arrival"):
			new_summon_on_field.card_resource._on_arrival(new_summon_on_field, active_combatant, opponent_combatant, battle_instance)

	elif target_card_in_zone == null:
		print("...No summon found in graveyard to reanimate.")
		battle_instance.add_event({
			"event_type":"log_message", 
			"message":"Reanimate (Instance: %s) found no summon target in graveyard." % reanimate_spell_instance_id,
			"source_card_id": reanimate_spell_card_id,
			"source_instance_id": reanimate_spell_instance_id
			})
	else: # No empty lane
		print("...No empty lane available to reanimate into.")
		battle_instance.add_event({
			"event_type":"log_message", 
			"message":"Reanimate (Instance: %s) found no empty lane for target." % reanimate_spell_instance_id,
			"source_card_id": reanimate_spell_card_id,
			"source_instance_id": reanimate_spell_instance_id
			})


# Check if graveyard has a summon and player has an empty lane
func can_play(active_combatant: Combatant, _opponent_combatant, _turn_count: int, _battle_instance) -> bool:
	if active_combatant.mana < self.cost: return false # self.cost refers to the Reanimate spell's cost
	var summon_in_grave = false
	for card_in_zone_obj in active_combatant.graveyard: # Iterate through CardInZone objects
		# --- CORRECTION 3: Check the type of the CardInZone's *resource* ---
		if card_in_zone_obj.card_resource is SummonCardResource: # Check the wrapped resource
			summon_in_grave = true
			break
	var lane_available = active_combatant.find_first_empty_lane() != -1
	return summon_in_grave and lane_available
