# res://logic/card_effects/focus_effect.gd
extends "res://logic/cards/spell_card.gd"

func apply_effect(p_focus_card_in_zone: CardInZone, active_combatant: Combatant, _opponent_combatant, battle_instance: Battle):
	var mana_gain = 8
	var focus_spell_instance_id: int = p_focus_card_in_zone.get_card_instance_id()
	var focus_spell_card_id: String = p_focus_card_in_zone.get_card_id()

	print("Focus (Instance: %s) granting %d mana to %s." % [focus_spell_instance_id, mana_gain, active_combatant.combatant_name])
	
	active_combatant.gain_mana(mana_gain, focus_spell_card_id, focus_spell_instance_id)

	# Visual effect related to the Focus spell itself.
	# The "target_locations" indicates who is visually affected by the mana gain.
	# The "instance_id" here can be the spell that was played.
	battle_instance.add_event({
		"event_type": "visual_effect",
		"effect_id": "focus_mana_gain",
		"target_locations": [active_combatant.combatant_name], # Player is visually affected
		"details": {"amount": mana_gain},
		"instance_id": focus_spell_instance_id, # The Focus spell instance is the origin of this visual
		"source_instance_id": focus_spell_instance_id, # Also the source
		"instance_id_note": "Focus spell is the instance and the source of this visual."
	})
