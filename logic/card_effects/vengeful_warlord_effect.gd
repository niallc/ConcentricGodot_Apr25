extends SummonCardResource

func _on_arrival(summon_instance: SummonInstance, active_combatant, opponent_combatant, _battle_instance):
	print("Vengeful Warlord arrival trigger.")
	if active_combatant.current_hp < opponent_combatant.current_hp:
		print("...Player HP lower, gaining +1/+1.")
		summon_instance.add_counter(1, summon_instance.card_resource.id + "_arrival", summon_instance.instance_id, -1) # add_counter handles events
	else:
		print("...Player HP not lower, no stat boost.")
