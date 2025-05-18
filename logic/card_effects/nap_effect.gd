# Nap
extends SpellCardResource

func apply_effect(_source_card_res: SpellCardResource, active_combatant, _opponent_combatant, battle_instance):
	var heal_amount = 2
	print("Nap healing %s for %d" % [active_combatant.combatant_name, heal_amount])
	active_combatant.heal(heal_amount) # heal() handles event generation

	# Optional visual effect
	battle_instance.add_event({
		"event_type": "visual_effect",
		"effect_id": "nap_heal_player",
		"target_locations": [active_combatant.combatant_name],
		"details": {"amount": heal_amount}
	})
