extends SpellCardResource

# Destroy opponent's leftmost non-Undead creature
func apply_effect(_source_card_res: SpellCardResource, _active_combatant, opponent_combatant, battle_instance):
	print("Unmake effect.")
	var target_instance = null # SummonInstance
	var target_lane_index = -1
	# Find leftmost non-Undead
	for i in range(opponent_combatant.lanes.size()):
		var instance = opponent_combatant.lanes[i]
		if instance != null and not instance.tags.has(Constants.TAG_UNDEAD):
			target_instance = instance
			target_lane_index = i
			break

	if target_instance != null:
		print("...Unmaking %s in lane %d." % [target_instance.card_resource.card_name, target_lane_index + 1])
		# Optional visual effect
		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "unmake_destroy",
			"target_locations": ["%s lane %d" % [opponent_combatant.combatant_name, target_lane_index + 1]],
			"details": {}
		}) # visual_effect event
		target_instance.die() # die() handles events
	else:
		print("...Found no non-Undead target.")
		battle_instance.add_event({"event_type":"log_message", "message":"Unmake found no valid target."})


# Check if opponent has a non-Undead creature
func can_play(active_combatant, opponent_combatant, _turn_count: int, _battle_instance) -> bool:
	if active_combatant.mana < self.cost: return false
	for instance in opponent_combatant.lanes:
		if instance != null and not instance.tags.has(Constants.TAG_UNDEAD):
			return true # Found valid target
	return false
