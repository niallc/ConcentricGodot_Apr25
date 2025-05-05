extends SpellCardResource

func apply_effect(_source_card_res: SpellCardResource, _active_combatant, opponent_combatant, battle_instance):
	print("Elsewhere effect.")
	# Find opponent's leftmost creature
	var target_instance = null # SummonInstance
	var target_lane_index = -1
	for i in range(opponent_combatant.lanes.size()):
		if opponent_combatant.lanes[i] != null:
			target_instance = opponent_combatant.lanes[i]
			target_lane_index = i
			break

	if target_instance != null:
		var target_card_res = target_instance.card_resource
		print("...Bouncing %s from lane %d to bottom of deck." % [target_card_res.card_name, target_lane_index + 1])

		# 1. Remove from lane
		opponent_combatant.remove_summon_from_lane(target_lane_index)
		# 2. Add card resource to bottom of library
		opponent_combatant.library.push_back(target_card_res)

		# 3. Generate events
		battle_instance.add_event({
			"event_type": "summon_leaves_lane",
			"player": opponent_combatant.combatant_name,
			"lane": target_lane_index + 1,
			"card_id": target_card_res.id,
			"reason": "elsewhere_bounce"
		}) # summon_leaves_lane event
		battle_instance.add_event({
			"event_type": "card_moved",
			"card_id": target_card_res.id,
			"player": opponent_combatant.combatant_name,
			"from_zone": "lane",
			"to_zone": "library",
			"to_details": {"position": "bottom"},
			"reason": "elsewhere_bounce"
		}) # card_moved event
		# Optional visual effect
		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "elsewhere_bounce",
			"target_locations": ["%s lane %d" % [opponent_combatant.combatant_name, target_lane_index + 1]],
			"details": {}
		}) # visual_effect event
	else:
		print("...Found no target creature.")
		battle_instance.add_event({"event_type":"log_message", "message":"Elsewhere found no target."})


# Check if opponent has creatures
func can_play(active_combatant, opponent_combatant, _turn_count: int, _battle_instance) -> bool:
	if active_combatant.mana < self.cost: return false
	for instance in opponent_combatant.lanes:
		if instance != null: return true
	return false
