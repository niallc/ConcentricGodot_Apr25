extends SpellCardResource

func apply_effect(p_hexplate_card_in_zone: CardInZone, active_combatant: Combatant, _opponent_combatant, battle_instance: Battle):
	var hexplate_spell_instance_id: int = p_hexplate_card_in_zone.get_card_instance_id()
	var hexplate_spell_card_id: String = p_hexplate_card_in_zone.get_card_id()

	print("Hexplate effect (Spell Instance ID: %s)." % hexplate_spell_instance_id)
	
	var target_instance: SummonInstance = null
	var target_lane_index: int = -1
	for i in range(active_combatant.lanes.size()):
		if active_combatant.lanes[i] != null:
			target_instance = active_combatant.lanes[i]
			target_lane_index = i
			break # Found the leftmost

	if target_instance != null:
		var power_buff_amount: int = 1
		var hp_buff_amount: int = 4
		
		print("...Applying Hexplate to %s (Instance: %s) in lane %d." % [target_instance.card_resource.card_name, target_instance.instance_id, target_lane_index + 1])
		
		# Call add_power on the target, passing Hexplate's card_id and instance_id as the source
		# Signature: add_power(amount: int, p_source_card_id: String, p_source_instance_id: int, duration: int)
		target_instance.add_power(power_buff_amount, hexplate_spell_card_id, hexplate_spell_instance_id, -1) # -1 for permanent
		
		# Call add_hp on the target, passing Hexplate's card_id and instance_id as the source
		# Signature: add_hp(amount: int, p_source_card_id: String, p_source_instance_id: int, duration: int)
		target_instance.add_hp(hp_buff_amount, hexplate_spell_card_id, hexplate_spell_instance_id, -1) # -1 for permanent

		# Visual effect for the buff on the target creature
		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "hexplate_buff_applied", # Or similar specific ID
			"instance_id": target_instance.instance_id, # The creature being buffed is the primary subject of this visual
			"card_id": target_instance.card_resource.id, # Card type of the buffed creature
			"target_locations": ["%s lane %d (ID: %s)" % [active_combatant.combatant_name, target_lane_index + 1, target_instance.instance_id]],
			"details": {"power_gained": power_buff_amount, "hp_gained": hp_buff_amount, "buff_source_card_id": hexplate_spell_card_id},
			"source_card_id": hexplate_spell_card_id,       # Card ID of the Hexplate spell
			"source_instance_id": hexplate_spell_instance_id # Instance ID of the Hexplate spell
		})
	else:
		print("...Hexplate (Instance: %s) found no target creature." % hexplate_spell_instance_id)
		battle_instance.add_event({
			"event_type": "log_message", 
			"message": "Hexplate (Instance: %s) found no target creature." % hexplate_spell_instance_id,
			"source_card_id": hexplate_spell_card_id,
			"source_instance_id": hexplate_spell_instance_id
		})
