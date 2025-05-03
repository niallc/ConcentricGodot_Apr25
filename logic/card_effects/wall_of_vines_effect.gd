extends SummonCardResource

# Override the default turn activity to generate mana instead of attacking
func perform_turn_activity_override(summon_instance: SummonInstance, active_combatant, _opponent_combatant, battle_instance) -> bool:
	var mana_gain = 1
	print("Wall of Vines generates %d mana for %s." % [mana_gain, active_combatant.combatant_name])
	active_combatant.gain_mana(mana_gain) # gain_mana handles event generation

	# Generate a specific event for this ability activation (optional but good)
	battle_instance.add_event({
		"event_type": "summon_turn_activity",
		"player": active_combatant.combatant_name,
		"lane": summon_instance.lane_index + 1,
		"activity_type": "ability_mana_gen", # Specific type for replay
		"details": {"mana_gained": mana_gain}
	})

	return true # Return true to indicate we handled the turn activity
