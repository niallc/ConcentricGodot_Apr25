extends SummonCardResource

const REQUIRED_GRAVE_COUNT = 3

# Override can_play to check graveyard count
func can_play(active_combatant, _opponent_combatant, _turn_count: int, _battle_instance) -> bool:
	# Base mana check
	if active_combatant.mana < self.cost: return false
	# Lane check
	if active_combatant.find_first_empty_lane() == -1: return false
	# Graveyard check
	var summon_count = 0
	for card in active_combatant.graveyard:
		if card is SummonCardResource:
			summon_count += 1
	if summon_count < REQUIRED_GRAVE_COUNT:
		print("Corpsecraft Titan cannot be played: requires %d summons in graveyard, found %d." % [REQUIRED_GRAVE_COUNT, summon_count])
		return false
	return true


# On arrival, consume 3 creatures from graveyard
func _on_arrival(_summon_instance: SummonInstance, active_combatant, _opponent_combatant, battle_instance):
	print("Corpsecraft Titan arrival trigger.")
	var consumed_count = 0
	# Iterate backwards to safely remove elements
	for i in range(active_combatant.graveyard.size() - 1, -1, -1):
		if consumed_count >= REQUIRED_GRAVE_COUNT: break # Stop after consuming 3

		var card_res = active_combatant.graveyard[i]
		if card_res is SummonCardResource:
			print("...Consuming %s from graveyard." % card_res.card_name)
			active_combatant.graveyard.remove_at(i)
			consumed_count += 1
			# Generate event for card removal/consumption
			battle_instance.add_event({
				"event_type": "card_removed", # Or "card_consumed"?
				"card_id": card_res.id,
				"player": active_combatant.combatant_name,
				"from_zone": "graveyard",
				"reason": "corpsecraft_titan"
			}) # card_removed event
			# Optional: Visual effect for consumption

	if consumed_count < REQUIRED_GRAVE_COUNT:
		# This shouldn't happen if can_play worked correctly, but log defensively
		printerr("Corpsecraft Titan Error: Consumed only %d creatures, expected %d." % [consumed_count, REQUIRED_GRAVE_COUNT])
