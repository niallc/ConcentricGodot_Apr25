# res://logic/card_effects/wall_of_vines_effect.gd
extends SummonCardResource

# summon_instance here is the Wall of Vines SummonInstance itself.
func perform_turn_activity_override(summon_instance: SummonInstance, active_combatant: Combatant, _opponent_combatant, battle_instance: Battle) -> bool:
	var wall_instance_id: int = summon_instance.instance_id
	var wall_card_id: String = summon_instance.card_resource.id # This is "WallOfVines"
	var mana_gain_amount: int = 1

	print("Wall of Vines (Instance: %s) generates %d mana for %s." % [wall_instance_id, mana_gain_amount, active_combatant.combatant_name])
	
	# Call gain_mana on the active_combatant, providing the Wall of Vines as the source.
	# Signature: gain_mana(amount: int, p_source_card_id: String, p_source_instance_id: int)
	active_combatant.gain_mana(mana_gain_amount, wall_card_id, wall_instance_id)

	# The "summon_turn_activity" event logs that this summon did something.
	# The actual "mana_change" event will be generated inside active_combatant.gain_mana()
	# and will be correctly sourced to this Wall of Vines instance.
	battle_instance.add_event({
		"event_type": "summon_turn_activity",
		"player": active_combatant.combatant_name,
		"card_id": wall_card_id, # Card type of the summon performing activity
		"instance_id": wall_instance_id, # Instance ID of the Wall of Vines
		"lane": summon_instance.lane_index + 1,
		"activity_type": "ability_mana_gen", 
		"details": {"mana_generated_by_ability": mana_gain_amount} # Clarify detail key
		# No need for a separate source_instance_id here, as instance_id *is* the source (the Wall of Vines)
	})

	return true # Indicates this override handled the turn activity
