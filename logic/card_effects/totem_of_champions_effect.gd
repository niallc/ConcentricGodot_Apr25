# res://logic/card_effects/totem_of_champions_effect.gd
extends SpellCardResource

func apply_effect(p_totem_card_in_zone: CardInZone, active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle):
	var totem_spell_instance_id: int = p_totem_card_in_zone.get_card_instance_id()
	var totem_spell_card_id: String = p_totem_card_in_zone.get_card_id()

	print("Totem of Champions (Instance: %s) effect." % totem_spell_instance_id)
	
	var buff_amount: int = 1
	var debuff_amount: int = -1 # Note: add_power handles the "amount" which can be negative for debuffs

	# Buff player's creatures
	print("...Buffing player's creatures with Totem of Champions (Instance: %s)." % totem_spell_instance_id)
	for target_creature_instance in active_combatant.lanes:
		if target_creature_instance != null:
			print("    -> Buffing %s (Instance: %s)" % [target_creature_instance.card_resource.card_name, target_creature_instance.instance_id])
			# Signature: add_power(amount: int, p_source_card_id: String, p_source_instance_id: int, duration: int)
			target_creature_instance.add_power(buff_amount, totem_spell_card_id, totem_spell_instance_id, -1) # -1 for permanent

	# Debuff opponent's creatures
	print("...Debuffing opponent's creatures with Totem of Champions (Instance: %s)." % totem_spell_instance_id)
	for target_creature_instance in opponent_combatant.lanes:
		if target_creature_instance != null:
			print("    -> Debuffing %s (Instance: %s)" % [target_creature_instance.card_resource.card_name, target_creature_instance.instance_id])
			target_creature_instance.add_power(debuff_amount, totem_spell_card_id, totem_spell_instance_id, -1) # -1 for permanent

	# Visual effect for the Totem spell itself being cast and affecting the board globally
	battle_instance.add_event({
		"event_type": "visual_effect",
		"effect_id": "totem_of_champions_wave", # e.g., a wave of energy across lanes
		"target_locations": ["all_lanes"], 
		"details": {"buff_amount": buff_amount, "debuff_amount": debuff_amount},
		"instance_id": totem_spell_instance_id, # The Totem spell is the primary subject of this visual
		"source_card_id": totem_spell_card_id,
		"source_instance_id": totem_spell_instance_id,
		"instance_id_note": "Visual for the Totem of Champions spell affecting all lanes."
	})
