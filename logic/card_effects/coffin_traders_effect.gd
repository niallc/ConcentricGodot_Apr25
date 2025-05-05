extends SummonCardResource

func _on_arrival(_summon_instance: SummonInstance, active_combatant, opponent_combatant, battle_instance):
	print("Coffin Traders arrival trigger: Swapping graveyards.")
	# Simple swap using a temporary variable
	var temp_graveyard = active_combatant.graveyard
	active_combatant.graveyard = opponent_combatant.graveyard
	opponent_combatant.graveyard = temp_graveyard

	# Generate events indicating the swap (maybe custom event type?)
	# For now, just log - replay might need library/graveyard update events after this
	battle_instance.add_event({
		"event_type": "log_message",
		"message": "%s and %s swapped graveyards." % [active_combatant.combatant_name, opponent_combatant.combatant_name]
	}) # log_message event
	# TODO: Consider adding full library_graveyard_update events for both players here
	# active_combatant.outputDeckAndGraveyard() # Old JS method - replace with event generation
	# opponent_combatant.outputDeckAndGraveyard()

	# Optional visual effect
	battle_instance.add_event({
		"event_type": "visual_effect",
		"effect_id": "coffin_traders_swap",
		"target_locations": [active_combatant.combatant_name + " graveyard", opponent_combatant.combatant_name + " graveyard"],
		"details": {}
	}) # visual_effect event
