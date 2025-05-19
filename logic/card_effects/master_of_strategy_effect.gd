# res://logic/card_effects/master_of_strategy_effect.gd
extends SummonCardResource

func _on_arrival(master_strategist_instance: SummonInstance, active_combatant: Combatant, _opponent_combatant, _battle_instance: Battle): # Use a more descriptive name for self
	var strategist_card_id: String = master_strategist_instance.card_resource.id
	var strategist_instance_id: int = master_strategist_instance.instance_id

	print("Master of Strategy (Instance: %s) arrival trigger." % strategist_instance_id)
	var buff_count: int = 0
	for other_creature_instance in active_combatant.lanes:
		if other_creature_instance != null and other_creature_instance != master_strategist_instance:
			print("...Master of Strategy (Instance: %s) buffing %s (Instance: %s)" % [strategist_instance_id, other_creature_instance.card_resource.card_name, other_creature_instance.instance_id])
			# Pass the Master of Strategy's card_id and instance_id as the source of the buff
			other_creature_instance.add_counter(1, strategist_card_id, strategist_instance_id, -1) # -1 for permanent duration
			buff_count += 1

	if buff_count == 0:
		print("...Master of Strategy (Instance: %s) found no other friendly creatures to buff." % strategist_instance_id)
	# No specific visual effect for Master of Strategy itself, buffs cause their own events.
