extends SpellCardResource

func apply_effect(source_card_res: SpellCardResource, active_combatant, opponent_combatant, battle_instance):
	print("Glassgraft effect.")
	# Find the rightmost Summon card resource in the graveyard
	var target_card_res: SummonCardResource = null
	var target_index = -1
	for i in range(active_combatant.graveyard.size()): # Iterate forwards
		if active_combatant.graveyard[i] is SummonCardResource:
			target_card_res = active_combatant.graveyard[i]
			target_index = i # Keep track of the last one found

	# Find an empty lane
	var target_lane_index = active_combatant.find_first_empty_lane()

	if target_card_res != null and target_lane_index != -1:
		print("...Reanimating %s (rightmost) into lane %d" % [target_card_res.card_name, target_lane_index + 1])
		# Remove from graveyard
		active_combatant.graveyard.remove_at(target_index)
		# Generate event (ensure dictionary is complete)
		battle_instance.add_event({
			"event_type": "card_moved",
			"card_id": target_card_res.id,
			"player": active_combatant.combatant_name,
			"from_zone": "graveyard",
			"to_zone": "limbo",
			"reason": "glassgraft"
		}) # card_moved grave->limbo

		# --- Simulate Summoning ---
		var new_summon = SummonInstance.new()
		var new_id = battle_instance.get_new_instance_id()
		new_summon.setup(target_card_res, active_combatant, opponent_combatant, target_lane_index, battle_instance, new_id)

		# Add custom sacrifice logic flag
		new_summon.custom_state["glassgrafted"] = true

		active_combatant.place_summon_in_lane(new_summon, target_lane_index)
		# Generate Arrives Event (ensure dictionary is complete)
		battle_instance.add_event({
			"event_type": "summon_arrives",
			"player": active_combatant.combatant_name,
			"card_id": target_card_res.id,
			"lane": target_lane_index + 1,
			"instance_id": new_id,
			"power": new_summon.get_current_power(),
			"max_hp": new_summon.get_current_max_hp(),
			"current_hp": new_summon.current_hp,
			"is_swift": new_summon.is_swift,
			"tags": new_summon.tags.duplicate(),
			"source_effect": source_card_res.id
		}) # summon_arrives event
		# Generate Moved Event (ensure dictionary is complete)
		battle_instance.add_event({
			"event_type": "card_moved",
			"card_id": target_card_res.id,
			"player": active_combatant.combatant_name,
			"from_zone": "limbo",
			"to_zone": "lane",
			"to_details": {"lane": target_lane_index + 1},
			"reason": "glassgraft"
		}) # card_moved limbo->lane
		if new_summon.card_resource.has_method("_on_arrival"):
			new_summon.card_resource._on_arrival(new_summon, active_combatant, opponent_combatant, battle_instance)
		# --- End Simulate Summoning ---

	elif target_card_res == null:
		print("...No summon found in graveyard.")
	else: # No empty lane
		print("...No empty lane available.")


# Check graveyard and lane availability
func can_play(active_combatant, _opponent_combatant, _turn_count: int, _battle_instance) -> bool:
	if active_combatant.mana < self.cost: return false
	var summon_in_grave = false
	for card in active_combatant.graveyard:
		if card is SummonCardResource: summon_in_grave = true; break
	var lane_available = active_combatant.find_first_empty_lane() != -1
	return summon_in_grave and lane_available
