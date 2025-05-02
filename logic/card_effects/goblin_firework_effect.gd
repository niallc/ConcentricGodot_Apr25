extends SummonCardResource

# Override the _on_death virtual method
func _on_death(summon_instance: SummonInstance, _active_combatant, opponent_combatant, _battle_instance):
	print("Goblin Firework death trigger!")
	var opposing_lane_index = summon_instance.lane_index
	var target_instance = opponent_combatant.lanes[opposing_lane_index]

	if target_instance != null:
		print("...damaging opposing %s" % target_instance.card_resource.card_name)
		var damage = 1
		# Target takes damage (generates creature_hp_change event)
		target_instance.take_damage(damage, summon_instance)
		# TODO: Generate specific visual effect event for explosion?
		# battle_instance.add_event({event_type:"visual_effect", effect_id:"firework_explode", ...})
	else:
		print("...no target found in opposing lane.")
