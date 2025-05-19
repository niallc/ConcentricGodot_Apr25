# res://logic/card_effects/corpsecraft_titan_effect.gd
extends SummonCardResource

const REQUIRED_GRAVE_COUNT = 3

# can_play needs to check CardInZone's resource
func can_play(active_combatant: Combatant, _opponent_combatant, _turn_count: int, _battle_instance: Battle) -> bool:
	if active_combatant.mana < self.cost: 
		return false
	if active_combatant.find_first_empty_lane() == -1: 
		return false
	
	var summon_card_in_graveyard_count: int = 0
	for card_in_zone_obj in active_combatant.graveyard:
		if card_in_zone_obj.card_resource is SummonCardResource:
			summon_card_in_graveyard_count += 1
			
	if summon_card_in_graveyard_count < REQUIRED_GRAVE_COUNT:
		# print("Corpsecraft Titan cannot be played: requires %d summons in graveyard, found %d." % [REQUIRED_GRAVE_COUNT, summon_card_in_graveyard_count])
		return false
	return true

# _summon_instance is the Corpsecraft Titan itself
func _on_arrival(_summon_instance: SummonInstance, active_combatant: Combatant, _opponent_combatant, battle_instance: Battle):
	var titan_instance_id: int = _summon_instance.instance_id
	var titan_card_id: String = _summon_instance.card_resource.id # "CorpsecraftTitan"

	print("Corpsecraft Titan (Instance: %s) arrival trigger. Consuming %d creatures." % [titan_instance_id, REQUIRED_GRAVE_COUNT])
	
	var consumed_count: int = 0
	# Iterate backwards to safely remove elements while iterating
	for i in range(active_combatant.graveyard.size() - 1, -1, -1):
		if consumed_count >= REQUIRED_GRAVE_COUNT:
			break 

		var card_in_zone_to_check = active_combatant.graveyard[i]
		if card_in_zone_to_check.card_resource is SummonCardResource:
			var removed_card_instance_id: int = card_in_zone_to_check.get_card_instance_id()
			var removed_card_res_id: String = card_in_zone_to_check.get_card_id()
			
			print("...Titan (Instance: %s) consuming %s (Instance: %s) from graveyard." % [titan_instance_id, removed_card_res_id, removed_card_instance_id])
			
			active_combatant.graveyard.remove_at(i)
			consumed_count += 1
			
			battle_instance.add_event({
				"event_type": "card_removed",
				"card_id": removed_card_res_id,
				"instance_id": removed_card_instance_id, # ID of the card removed from graveyard
				"player": active_combatant.combatant_name,
				"from_zone": "graveyard",
				"reason": "consumed_by_" + titan_card_id,
				"source_card_id": titan_card_id,
				"source_instance_id": titan_instance_id
			})

	if consumed_count < REQUIRED_GRAVE_COUNT:
		# This indicates an issue if can_play was supposed to prevent this.
		# However, can_play might be called before other effects could alter the graveyard.
		printerr("Corpsecraft Titan (Instance: %s) Error: Consumed only %d creatures, expected %d." % [titan_instance_id, consumed_count, REQUIRED_GRAVE_COUNT])
		battle_instance.add_event({
			"event_type": "log_message",
			"message": "Corpsecraft Titan (Instance: %s) consumed %d/%d required creatures." % [titan_instance_id, consumed_count, REQUIRED_GRAVE_COUNT],
			"source_card_id": titan_card_id,
			"source_instance_id": titan_instance_id
		})
