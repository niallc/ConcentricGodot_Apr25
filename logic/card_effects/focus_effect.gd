# res://logic/card_effects/focus_effect.gd
extends "res://logic/cards/spell_card.gd"

func apply_effect(p_source_spell_card_res: SpellCardResource, p_played_spell_instance_id: int, active_combatant: Combatant, _opponent_combatant, battle_instance: Battle):
	var mana_gain = 8
	print("Focus (Instance: %s) granting %d mana to %s." % [p_played_spell_instance_id, mana_gain, active_combatant.combatant_name])
	
	active_combatant.gain_mana(mana_gain, p_source_spell_card_res.id, p_played_spell_instance_id)

	# Visual effect related to the Focus spell itself.
	# The "target_locations" indicates who is visually affected by the mana gain.
	# The "instance_id" here can be the spell that was played.
	battle_instance.add_event({
		"event_type": "visual_effect",
		"effect_id": "focus_mana_gain",
		"target_locations": [active_combatant.combatant_name], # Player is visually affected
		"details": {"amount": mana_gain},
		"instance_id": p_played_spell_instance_id, # The Focus spell instance is the origin of this visual
		"source_instance_id": p_played_spell_instance_id # Also the source
	})
