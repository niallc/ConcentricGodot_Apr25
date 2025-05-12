# res://logic/card_effects/healer_effect.gd
extends "res://logic/cards/summon_card.gd"

# Override the base SummonCard _on_arrival method
# This is called AFTER the summon_arrives event has been generated
func _on_arrival(_summon_instance: SummonInstance, active_combatant: Combatant, _opponent_combatant: Combatant, battle_instance: Battle):
	var heal_amount = 8
	active_combatant.heal(heal_amount) # Combatant.heal generates hp_change event

	# Generate a visual effect event for the heal
	var visual_event = {
		"event_type": "visual_effect",
		"effect_id": "heal_pulse_player",
		"target_locations": [active_combatant.combatant_name], # Target the player portrait/area
		"details": {"heal_amount": heal_amount},
		"instance_id": "None, player heal, visual event"
	}
	battle_instance.add_event(visual_event)
