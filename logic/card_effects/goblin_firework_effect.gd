# res://logic/card_effects/goblin_firework_effect.gd
extends SummonCardResource

# Override the _on_death virtual method
# Note: Added underscore to unused parameters based on previous discussion
func _on_death(summon_instance: SummonInstance, _active_combatant, opponent_combatant, battle_instance):
	print("Goblin Firework death trigger!")
	var opposing_lane_index = summon_instance.lane_index
	# Check opponent has lanes and index is valid (defensive check)
	if opponent_combatant.lanes.size() > opposing_lane_index:
		var target_instance = opponent_combatant.lanes[opposing_lane_index]

		if target_instance != null:
			print("...damaging opposing %s" % target_instance.card_resource.card_name)
			var damage = 1
			# Target takes damage (generates creature_hp_change event)
			# Pass the dying firework instance as the source
			target_instance.take_damage(damage, summon_instance)

			# Generate specific visual effect event for explosion
			battle_instance.add_event({
				"event_type": "visual_effect",
				"effect_id": "firework_explode",
				"target_locations": ["%s lane %d" % [opponent_combatant.combatant_name, opposing_lane_index + 1]],
				"details": {"damage": damage}
			})
		else:
			print("...no target found in opposing lane.")
	else:
		printerr("Goblin Firework _on_death: Invalid opposing lane index %d" % opposing_lane_index)
