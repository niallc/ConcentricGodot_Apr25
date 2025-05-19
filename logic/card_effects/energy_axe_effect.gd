# res://logic/card_effects/energy_axe_effect.gd
extends "res://logic/cards/spell_card.gd"

func apply_effect(p_energy_axe_card_in_zone: CardInZone, active_combatant: Combatant, _opponent_combatant, battle_instance: Battle):
	var target_instance: SummonInstance = null 
	var target_lane_index = -1
	# Find the leftmost summon instance for the active combatant
	for i in range(active_combatant.lanes.size()):
		if active_combatant.lanes[i] != null:
			target_instance = active_combatant.lanes[i]
			target_lane_index = i
			break # Found the leftmost

	if target_instance != null:
		var power_boost = 3
		# Pass the Energy Axe's CardResource ID and its specific Instance ID
		target_instance.add_power(power_boost, p_energy_axe_card_in_zone.get_card_id(), p_energy_axe_card_in_zone.instance_id, -1)

		var visual_event = {
			"event_type": "visual_effect",
			"effect_id": "energy_axe_boost", 
			"target_locations": ["%s lane %d" % [active_combatant.combatant_name, target_lane_index + 1]],
			"details": {"boost_amount": power_boost},
			"instance_id": target_instance.instance_id, # Target of the visual
			"source_instance_id": p_energy_axe_card_in_zone.instance_id # Source of the visual
		}
		battle_instance.add_event(visual_event)
	else:
		var no_target_event = {
			"event_type": "log_message",
			"message": "%s's %s (Instance: %s) found no target." % [active_combatant.combatant_name, p_energy_axe_card_in_zone.get_card_name(), str(p_energy_axe_card_in_zone.instance_id)],
			"source_instance_id": p_energy_axe_card_in_zone.instance_id,
			"instance_id": target_instance.instance_id
		} 
		battle_instance.add_event(no_target_event)
# Override can_play to check for a valid target *before* casting
func can_play(active_combatant: Combatant, _opponent_combatant: Combatant, _turn_count: int, _battle_instance: Battle) -> bool:
	# Default mana check first
	if active_combatant.mana < self.cost:
		return false
	# Check if there is at least one summon in the lanes
	for summon_instance in active_combatant.lanes:
		if summon_instance != null:
			return true # Found a valid target
	return false # No target found
