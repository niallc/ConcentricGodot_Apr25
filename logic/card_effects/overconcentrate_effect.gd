extends SpellCardResource

func apply_effect(source_card_res: SpellCardResource, _active_combatant, opponent_combatant, battle_instance):
	print("Overconcentrate effect.")
	# Find opponent's leftmost creature
	var target_instance = null # SummonInstance
	var target_lane_index = -1
	for i in range(opponent_combatant.lanes.size()):
		if opponent_combatant.lanes[i] != null:
			target_instance = opponent_combatant.lanes[i]
			target_lane_index = i
			break

	if target_instance != null:
		if not target_instance.is_relentless:
			print("...Making %s in lane %d Relentless." % [target_instance.card_resource.card_name, target_lane_index + 1])
			target_instance.is_relentless = true
			# Generate status change event
			battle_instance.add_event({
				"event_type": "status_change",
				"player": opponent_combatant.combatant_name,
				"lane": target_lane_index + 1,
				"status": "Relentless",
				"gained": true,
				"source": source_card_res.id
			})
			# Optional visual effect
			battle_instance.add_event({
				"event_type": "visual_effect",
				"effect_id": "overconcentrate_debuff",
				"target_locations": ["%s lane %d" % [opponent_combatant.combatant_name, target_lane_index + 1]],
				"details": {}
			})
		else:
			print("...Target %s is already Relentless." % target_instance.card_resource.card_name)
	else:
		print("...Found no target creature.")
		battle_instance.add_event({"event_type":"log_message", "message":"Overconcentrate found no target."})


# Check if opponent has creatures
func can_play(active_combatant, opponent_combatant, _turn_count: int, _battle_instance) -> bool:
	if active_combatant.mana < self.cost: return false
	for instance in opponent_combatant.lanes:
		if instance != null: return true
	return false
