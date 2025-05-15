# res://logic/card_effects/inferno_effect.gd
extends "res://logic/cards/spell_card.gd"

# Updated signature to use parameters
func apply_effect(p_inferno_card_res: SpellCardResource, p_inferno_spell_instance_id: int, active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle):
	print("Inferno effect (Spell Instance ID: %s)." % p_inferno_spell_instance_id)
	var damage_amount: int = 2
	var affected_locations: Array[String] = []
	var targets_to_damage: Array[SummonInstance] = []

	# Find all targets first (player's creatures)
	for creature_instance in active_combatant.lanes:
		if creature_instance != null:
			targets_to_damage.append(creature_instance)
			affected_locations.append("%s lane %d (ID: %s)" % [active_combatant.combatant_name, creature_instance.lane_index + 1, creature_instance.instance_id])
	
	# Find all targets (opponent's creatures)
	for creature_instance in opponent_combatant.lanes:
		if creature_instance != null:
			targets_to_damage.append(creature_instance)
			affected_locations.append("%s lane %d (ID: %s)" % [opponent_combatant.combatant_name, creature_instance.lane_index + 1, creature_instance.instance_id])

	if targets_to_damage.is_empty():
		print("...Inferno found no creatures to damage.")
		# Optionally log a "fizzle" type event if desired, or just return
		battle_instance.add_event({
			"event_type": "log_message",
			"message": "Inferno (Instance: %s) cast but found no targets." % p_inferno_spell_instance_id,
			"source_instance_id": p_inferno_spell_instance_id
		})
		return

	# Log the visual effect for the Inferno spell itself
	battle_instance.add_event({
		"event_type": "visual_effect",
		"effect_id": "inferno_spell_cast", # A general visual for the spell casting
		"target_locations": ["all_lanes"], # Or perhaps just the player who cast it
		"details": {"damage_potential": damage_amount, "num_targets": targets_to_damage.size()},
		"instance_id": p_inferno_spell_instance_id, # The Inferno spell is the subject of this visual
		"source_instance_id": p_inferno_spell_instance_id, # And also its source
		"instance_id_note": "Visual for the Inferno spell being cast."
	})

	print("...Inferno dealing %d damage to %d creatures." % [damage_amount, targets_to_damage.size()])
	
	# Apply damage to all targeted creatures
	for target_summon_instance in targets_to_damage:
		if is_instance_valid(target_summon_instance): # Ensure target hasn't been removed by a prior effect in a complex chain (unlikely for Inferno)
			# The SummonInstance.take_damage method will generate the "creature_hp_change" event.
			# That event will correctly list the target_summon_instance.instance_id as its main "instance_id".
			# It will also correctly list p_inferno_card_res.id as the "source" (card type)
			# and p_inferno_spell_instance_id as the "source_instance_id".
			target_summon_instance.take_damage(damage_amount, p_inferno_card_res.id, p_inferno_spell_instance_id)
		# No separate "effect_damage" event needed here if SummonInstance.take_damage creates creature_hp_change with proper sourcing.
		# The "effect_damage" event type in the spec is more for direct damage to PLAYERS from spells/effects.
