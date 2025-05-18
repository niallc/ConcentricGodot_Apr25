# res://logic/card_effects/nap_effect.gd
extends SpellCardResource

func apply_effect(p_nap_card_in_zone: CardInZone, active_combatant: Combatant, _opponent_combatant, battle_instance: Battle):
	var heal_amount: int = 2
	
	var nap_spell_instance_id: int = p_nap_card_in_zone.get_card_instance_id()
	var nap_spell_card_id: String = p_nap_card_in_zone.get_card_id()

	print("Nap (Instance: %s) healing %s for %d" % [nap_spell_instance_id, active_combatant.combatant_name, heal_amount])
	
	# Assuming Combatant.heal() signature is updated to:
	# func heal(amount: int, p_source_card_id: String = "unknown_heal", p_source_instance_id: int = -1)
	active_combatant.heal(heal_amount, nap_spell_card_id, nap_spell_instance_id)

	battle_instance.add_event({
		"event_type": "visual_effect",
		"effect_id": "nap_heal_player",
		"target_locations": [active_combatant.combatant_name], # Player is visually affected
		"details": {"amount_healed": heal_amount, "healing_source_card_id": nap_spell_card_id},
		"instance_id": nap_spell_instance_id, # The Nap spell is the primary subject/origin of this visual
		"source_card_id": nap_spell_card_id,
		"source_instance_id": nap_spell_instance_id,
		"instance_id_note": "Visual for the Nap spell healing the player."
	})
