extends SpellCardResource

#func apply_effect(p_overconcentrate_card_in_zone: CardInZone, _active_combatant, opponent_combatant, battle_instance):
func apply_effect(p_reanimate_card_in_zone: CardInZone, active_combatant, opponent_combatant, battle_instance):
	print("Reanimate effect.")
	var reanimate_spell_instance_id: int = p_reanimate_card_in_zone.get_card_instance_id()
	var reanimate_spell_card_id: String = p_reanimate_card_in_zone.get_card_id()
	# Find the first (leftmost) Summon card resource in the graveyard
	#var target_card_res: SummonCardResource = null
	var target_card_in_zone: CardInZone = null
	var target_index = -1
	for i in range(active_combatant.graveyard.size()):
		if active_combatant.graveyard[i] is SummonCardResource:
			target_card_in_zone = active_combatant.graveyard[i]
			target_index = i
			break

	# Find an empty lane
	var target_lane_index = active_combatant.find_first_empty_lane()

	if target_card_in_zone != null and target_lane_index != -1:
		print("...Reanimating %s into lane %d" % [target_card_in_zone.get_card_name(), target_lane_index + 1])
		# Remove the card from the graveyard *before* summoning to avoid issues if it reanimates itself?
		active_combatant.graveyard.remove_at(target_index)
		# Generate event for leaving graveyard
		battle_instance.add_event({
			"event_type": "card_moved",
			"card_id": target_card_in_zone.id,
			"instance_id": target_card_in_zone.get_card_instance_id(),
			"source_instance_id": reanimate_spell_instance_id,
			"player": active_combatant.combatant_name,
			"from_zone": "graveyard",
			"to_zone": "limbo", # Temporary zone before lane
			"reason": "reanimate"
		})

		# --- Simulate Summoning ---
		var new_summon = SummonInstance.new()
		var new_id = battle_instance.get_new_instance_id()
		new_summon.setup(target_card_in_zone.card_resource, active_combatant, opponent_combatant, target_lane_index, battle_instance, new_id) # Pass ID
		# Add the Undead tag dynamically
		if not new_summon.tags.has(Constants.TAG_UNDEAD):
			new_summon.tags.append(Constants.TAG_UNDEAD)
			# Optional: Event for gaining tag?
			# battle_instance.add_event({event_type:"status_change", status:"Undead", gained:true ...})

		active_combatant.place_summon_in_lane(new_summon, target_lane_index)
		# Generate Arrives Event (include tags)
		battle_instance.add_event({
			"event_type": "summon_arrives",
			"player": active_combatant.combatant_name,
			"card_id": target_card_in_zone.get_card_id(),
			"lane": target_lane_index + 1,
			"instance_id": new_id,
			"power": new_summon.get_current_power(),
			"max_hp": new_summon.get_current_max_hp(),
			"current_hp": new_summon.current_hp,
			"is_swift": new_summon.is_swift,
			"tags": new_summon.tags.duplicate(),
			"source_isntance_id": reanimate_spell_instance_id,
			"source_effect": reanimate_spell_card_id
		})
		# Generate Moved Event (limbo -> lane)
		battle_instance.add_event({
			"event_type": "card_moved",
			"card_id": target_card_in_zone.get_card_id(),
			"instance_id": target_card_in_zone.get_card_instance_id(),
			"source_id": reanimate_spell_card_id,
			"source_instance_id": reanimate_spell_instance_id,
			"player": active_combatant.combatant_name,
			"from_zone": "limbo",
			"to_zone": "lane",
			"to_details": {"lane": target_lane_index + 1},
			"reason": "reanimate"
		})
		# Call _on_arrival (though reanimated creature might not have one)
		if new_summon.card_resource != null and new_summon.card_resource.has_method("_on_arrival"):
			new_summon.card_resource._on_arrival(new_summon, active_combatant, opponent_combatant, battle_instance)
		# --- End Simulate Summoning ---

	elif target_card_in_zone == null:
		print("...No summon found in graveyard to reanimate.")
		battle_instance.add_event({"event_type":"log_message", "message":"Reanimate found no target in graveyard."})
	else: # No empty lane
		print("...No empty lane available to reanimate into.")
		battle_instance.add_event({"event_type":"log_message", "message":"Reanimate found no empty lane."})


# Check if graveyard has a summon and player has an empty lane
func can_play(active_combatant, _opponent_combatant, _turn_count: int, _battle_instance) -> bool:
	if active_combatant.mana < self.cost: return false
	var summon_in_grave = false
	for card in active_combatant.graveyard:
		if card is SummonCardResource:
			summon_in_grave = true
			break
	var lane_available = active_combatant.find_first_empty_lane() != -1
	return summon_in_grave and lane_available
