extends SpellCardResource

# Apply the mana gain effect
func apply_effect(_source_card_res: SpellCardResource, active_combatant, _opponent_combatant, battle_instance):
	var mana_gain = 8
	print("Focus granting %d mana to %s." % [mana_gain, active_combatant.combatant_name])
	active_combatant.gain_mana(mana_gain) # gain_mana handles event generation

	# Optional: Visual effect
	battle_instance.add_event({
		"event_type": "visual_effect",
		"effect_id": "focus_mana_gain",
		"target_locations": [active_combatant.combatant_name],
		"details": {"amount": mana_gain}
	})
