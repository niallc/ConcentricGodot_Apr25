# res://logic/card_effects/energy_axe_effect.gd
extends "res://logic/cards/spell_card.gd"

# Override the base SpellCard apply_effect method
func apply_effect(source_card_res: SpellCardResource, active_combatant, opponent_combatant, battle_instance):
	var target_instance # SummonInstance = null # Use inference or # Type hint
	# Find the leftmost summon instance for the active combatant
	var target_lane_index = -1
	for i in range(active_combatant.lanes.size()):
		if active_combatant.lanes[i] != null:
			target_instance = active_combatant.lanes[i]
			target_lane_index = i
			break # Found the leftmost

	if target_instance != null:
		var power_boost = 3
		# *** Use source_card_res.id or .card_name for the source_id ***
		target_instance.add_power(power_boost, source_card_res.id, -1) # Pass ID, duration -1 for permanent

		# Generate a visual effect event
		var visual_event = {
			"event_type": "visual_effect",
			"effect_id": "energy_axe_boost", # Identifier for the visual effect
			"target_locations": ["%s lane %d" % [active_combatant.combatant_name, target_lane_index + 1]], # Target lane (1-based)
			"details": {"boost_amount": power_boost}
		}
		battle_instance.add_event(visual_event)

		# Optional: Add a log message event (can be useful for debugging/detailed replays)
		# var log_event = { ... event_type: "log_message", message: "..." }
		# battle_instance.add_event(log_event)
	else:
		# Log if no target was found (optional, good practice)
		var no_target_event = {
			"event_type": "log_message",
			"message": "%s's Energy Axe found no target." % active_combatant.name
		} 
		battle_instance.add_event(no_target_event)

# Override can_play to check for a valid target *before* casting
func can_play(active_combatant: Combatant, opponent_combatant: Combatant, turn_count: int, battle_instance: Battle) -> bool:
	# Default mana check first
	if active_combatant.mana < self.cost:
		return false
	# Check if there is at least one summon in the lanes
	for summon_instance in active_combatant.lanes:
		if summon_instance != null:
			return true # Found a valid target
	return false # No target found
