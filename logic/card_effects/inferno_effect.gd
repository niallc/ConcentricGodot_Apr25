# res://logic/card_effects/inferno_effect.gd
extends "res://logic/cards/spell_card.gd"

func apply_effect(p_inferno_card_in_zone: CardInZone, active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle):
	var inferno_spell_instance_id: int = p_inferno_card_in_zone.get_card_instance_id()
	var inferno_spell_card_id: String = p_inferno_card_in_zone.get_card_id()

	print("Inferno effect (Spell Instance ID: %s)." % inferno_spell_instance_id)
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
			"message": "Inferno (Instance: %s) cast but found no targets." % inferno_spell_instance_id,
			"source_instance_id": inferno_spell_instance_id
		})
		return

	# Log the visual effect for the Inferno spell itself
	battle_instance.add_event({
		"event_type": "visual_effect",
		"effect_id": "inferno_spell_cast",
		"target_locations": ["all_lanes"], 
		"details": {"damage_potential": damage_amount, "num_targets": targets_to_damage.size()},
		"instance_id": inferno_spell_instance_id,
		"source_instance_id": inferno_spell_instance_id,
		"instance_id_note": "Visual for the Inferno spell being cast, affecting all lanes."
	})

	print("...Inferno dealing %d damage to %d creatures." % [damage_amount, targets_to_damage.size()])
	
	# Apply damage to all targeted creatures
	for target_summon_instance in targets_to_damage:
		if is_instance_valid(target_summon_instance): # Ensure target hasn't been removed by a prior effect in a complex chain (unlikely for Inferno)
			# The SummonInstance.take_damage method will generate the "creature_hp_change" event.
			# That event will correctly list the target_summon_instance.instance_id as its main "instance_id".
			# It will also correctly list p_inferno_card_res.id as the "source" (card type)
			# and p_inferno_spell_instance_id as the "source_instance_id".
			#func take_damage(amount: int, p_source_card_id: String, p_source_instance_id: int):
			target_summon_instance.take_damage(damage_amount, inferno_spell_card_id, inferno_spell_instance_id)
