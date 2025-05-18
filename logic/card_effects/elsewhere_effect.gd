# res://logic/card_effects/elsewhere_effect.gd
extends SpellCardResource

# Corrected signature to take CardInZone for the Elsewhere spell itself
func apply_effect(p_elsewhere_card_in_zone: CardInZone, _active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle):
	var elsewhere_spell_instance_id: int = p_elsewhere_card_in_zone.get_card_instance_id()
	var elsewhere_spell_card_id: String = p_elsewhere_card_in_zone.get_card_id()

	print("Elsewhere (Instance: %s) effect." % elsewhere_spell_instance_id)
	
	var target_instance: SummonInstance = null 
	var target_lane_index: int = -1
	for i in range(opponent_combatant.lanes.size()):
		if opponent_combatant.lanes[i] != null:
			target_instance = opponent_combatant.lanes[i]
			target_lane_index = i
			break

	if target_instance != null:
		var bounced_summon_card_res: CardResource = target_instance.card_resource 
		var bounced_summon_instance_id: int = target_instance.instance_id
		var bounced_from_lane_1_based: int = target_lane_index + 1

		print("...Bouncing %s (Instance: %s) from lane %d to bottom of deck." % [bounced_summon_card_res.card_name, bounced_summon_instance_id, bounced_from_lane_1_based])

		opponent_combatant.remove_summon_from_lane(target_lane_index)
		
		var new_library_card_instance_id: int = battle_instance._generate_new_card_instance_id()
		var card_in_zone_for_library: CardInZone = CardInZone.new(bounced_summon_card_res, new_library_card_instance_id)
		opponent_combatant.library.push_back(card_in_zone_for_library) # Elsewhere bounces to bottom

		battle_instance.add_event({
			"event_type": "summon_leaves_lane",
			"player": opponent_combatant.combatant_name,
			"lane": bounced_from_lane_1_based,
			"card_id": bounced_summon_card_res.id, 
			"instance_id": bounced_summon_instance_id, 
			"reason": "bounce_effect_" + elsewhere_spell_card_id,
			"source_card_id": elsewhere_spell_card_id, 
			"source_instance_id": elsewhere_spell_instance_id 
		})
		
		battle_instance.add_event({
			"event_type": "card_moved",
			"card_id": bounced_summon_card_res.id, 
			"player": opponent_combatant.combatant_name,
			"from_zone": "lane",
			"from_details": {
				"lane": bounced_from_lane_1_based,
				"instance_id": bounced_summon_instance_id 
			},
			"to_zone": "library",
			"to_details": {
				"position": "bottom", 
				"instance_id": new_library_card_instance_id 
			},
			"instance_id": bounced_summon_instance_id, 
			"reason": "bounce_effect_" + elsewhere_spell_card_id, 
			"source_card_id": elsewhere_spell_card_id, 
			"source_instance_id": elsewhere_spell_instance_id 
		})
		
		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "elsewhere_bounce",
			"instance_id": bounced_summon_instance_id, # Creature being bounced is primary subject of visual
			"card_id": bounced_summon_card_res.id, 
			"target_locations": ["%s lane %d (ID: %s)" % [opponent_combatant.combatant_name, bounced_from_lane_1_based, bounced_summon_instance_id]],
			"details": {},
			"source_card_id": elsewhere_spell_card_id,
			"source_instance_id": elsewhere_spell_instance_id 
		})
	else:
		print("...Elsewhere (Instance: %s) found no target creature." % elsewhere_spell_instance_id)
		battle_instance.add_event({
			"event_type":"log_message", 
			"message":"Elsewhere (Instance: %s) found no target." % elsewhere_spell_instance_id,
			"source_card_id": elsewhere_spell_card_id, 
			"source_instance_id": elsewhere_spell_instance_id
			})

# can_play method should remain the same as it doesn't depend on the spell's instance, only its cost and game state.
func can_play(active_combatant: Combatant, opponent_combatant: Combatant, _turn_count: int, _battle_instance: Battle) -> bool:
	if active_combatant.mana < self.cost: # self.cost comes from the SpellCardResource this script extends
		return false
	for creature_instance in opponent_combatant.lanes:
		if creature_instance != null: return true
	return false
