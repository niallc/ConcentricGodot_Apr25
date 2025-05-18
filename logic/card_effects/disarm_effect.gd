# res://logic/card_effects/disarm_effect.gd
extends SpellCardResource

# Updated signature to take CardInZone for the Disarm spell
func apply_effect(p_disarm_card_in_zone: CardInZone, active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle):
	var disarm_spell_instance_id: int = p_disarm_card_in_zone.get_card_instance_id()
	var disarm_spell_card_id: String = p_disarm_card_in_zone.get_card_id()

	print("Disarm (Instance: %s) effect." % disarm_spell_instance_id)

	var target_creature_instance: SummonInstance = null
	var target_creature_lane_index: int = -1
	var highest_found_power: int = -1 

	# Find the opponent's creature with the highest current power
	for i in range(opponent_combatant.lanes.size()):
		var potential_target = opponent_combatant.lanes[i]
		if potential_target != null:
			var current_power = potential_target.get_current_power()
			# If powers are equal, leftmost wins (due to loop order i=0,1,2)
			if current_power > highest_found_power:
				highest_found_power = current_power
				target_creature_instance = potential_target
				target_creature_lane_index = i
	
	if target_creature_instance != null:
		var power_reduction_amount: int = -2
		var target_card_id_str: String = target_creature_instance.card_resource.id
		var target_instance_id_val: int = target_creature_instance.instance_id

		print("...Disarm (Instance: %s) targeting %s (Instance: %s) in lane %d (Power: %d) for %d power." % [disarm_spell_instance_id, target_card_id_str, target_instance_id_val, target_creature_lane_index + 1, highest_found_power, power_reduction_amount])
		
		# Call add_power on the target, passing Disarm's card_id and instance_id as the source
		# Signature: add_power(amount: int, p_source_card_id: String, p_source_instance_id: int, duration: int)
		target_creature_instance.add_power(power_reduction_amount, disarm_spell_card_id, disarm_spell_instance_id, -1) # -1 for permanent

		# Visual effect for the debuff on the target creature
		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "disarm_debuff_applied", 
			"instance_id": target_instance_id_val, # The creature being debuffed is the primary subject
			"card_id": target_card_id_str,         # Card type of the debuffed creature
			"target_locations": ["%s lane %d (ID: %s)" % [opponent_combatant.combatant_name, target_creature_lane_index + 1, target_instance_id_val]],
			"details": {"power_change": power_reduction_amount, "debuff_source_card_id": disarm_spell_card_id},
			"source_card_id": disarm_spell_card_id,
			"source_instance_id": disarm_spell_instance_id 
		})
	else:
		print("...Disarm (Instance: %s) found no target creature." % disarm_spell_instance_id)
		battle_instance.add_event({
			"event_type": "log_message",
			"message": "%s's Disarm (Instance: %s) found no target." % [active_combatant.combatant_name, disarm_spell_instance_id],
			"source_card_id": disarm_spell_card_id,
			"source_instance_id": disarm_spell_instance_id
		})

# can_play method:
# The original can_play method used _opponent_combatant.
# The apply_effect method also uses _opponent_combatant (which is good, it's the correct one).
# The parameter name in apply_effect was just _opponent_combatant. I've changed it to opponent_combatant.
# For can_play, it should take opponent_combatant as well.
func can_play(active_combatant: Combatant, opponent_combatant: Combatant, _turn_count: int, _battle_instance: Battle) -> bool:
	if active_combatant.mana < self.cost: # self.cost is Disarm's cost
		return false
	for creature_instance in opponent_combatant.lanes:
		if creature_instance != null:
			return true # Found a potential target
	return false
