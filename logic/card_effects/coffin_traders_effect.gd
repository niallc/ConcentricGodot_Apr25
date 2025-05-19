# res://logic/card_effects/coffin_traders_effect.gd
extends SummonCardResource

# _summon_instance is the Coffin Traders SummonInstance itself.
func _on_arrival(_summon_instance: SummonInstance, active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle):
	var traders_instance_id: int = _summon_instance.instance_id
	var traders_card_id: String = _summon_instance.card_resource.id # "CoffinTraders"

	print("Coffin Traders (Instance: %s) arrival trigger: Swapping graveyards between %s and %s." % [traders_instance_id, active_combatant.combatant_name, opponent_combatant.combatant_name])
	
	# Store a snapshot of instance IDs in each graveyard BEFORE the swap for the event log
	var player_graveyard_instance_ids_before: Array[int] = []
	for card_in_zone in active_combatant.graveyard:
		player_graveyard_instance_ids_before.append(card_in_zone.get_card_instance_id())
		
	var opponent_graveyard_instance_ids_before: Array[int] = []
	for card_in_zone in opponent_combatant.graveyard:
		opponent_graveyard_instance_ids_before.append(card_in_zone.get_card_instance_id())

	# Perform the swap
	var temp_graveyard_array: Array[CardInZone] = active_combatant.graveyard
	active_combatant.graveyard = opponent_combatant.graveyard
	opponent_combatant.graveyard = temp_graveyard_array

	# Log a custom event detailing the swap
	# This event tells the replay which instance IDs ended up in which graveyard.
	# The replay would then need to update its visual representation of those graveyards.
	battle_instance.add_event({
		"event_type": "graveyards_swapped", # Custom event type
		"player1_name": active_combatant.combatant_name,
		"player1_graveyard_now_contains_instance_ids": opponent_graveyard_instance_ids_before, # P1 now has what opponent had
		"player2_name": opponent_combatant.combatant_name,
		"player2_graveyard_now_contains_instance_ids": player_graveyard_instance_ids_before, # P2 now has what player had
		"source_card_id": traders_card_id,
		"source_instance_id": traders_instance_id,
		"instance_id": traders_instance_id # The Coffin Traders is the primary subject of this action
	})

	# Optional: A visual effect for the swap action itself
	battle_instance.add_event({
		"event_type": "visual_effect",
		"effect_id": "coffin_traders_graveyard_swap_visual",
		"target_locations": [active_combatant.combatant_name + " graveyard", opponent_combatant.combatant_name + " graveyard"],
		"details": {
			"player1_ended_with_count": active_combatant.graveyard.size(),
			"player2_ended_with_count": opponent_combatant.graveyard.size()
		},
		"instance_id": traders_instance_id,
		"source_card_id": traders_card_id,
		"source_instance_id": traders_instance_id
	})
