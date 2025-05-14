extends SpellCardResource

func apply_effect(p_source_spell_card_res: SpellCardResource, p_played_spell_instance_id: int, _active_combatant, opponent_combatant, battle_instance: Battle):
	print("Elsewhere effect (Spell Instance ID: %s)." % p_played_spell_instance_id)
	# Find opponent's leftmost creature
	var target_instance: SummonInstance = null # Explicit type hint
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

		# 1. Remove from lane
		opponent_combatant.remove_summon_from_lane(target_lane_index)
		
		# 2. Create CardInZone for the library
		var new_library_card_instance_id = battle_instance._generate_new_card_instance_id()
		var card_in_zone_for_library = CardInZone.new(bounced_summon_card_res, new_library_card_instance_id)
		opponent_combatant.library.push_back(card_in_zone_for_library) # Elsewhere bounces to bottom

		# 3. Generate events
		# Event for the summon leaving the lane
		battle_instance.add_event({
			"event_type": "summon_leaves_lane",
			"player": opponent_combatant.combatant_name,
			"lane": bounced_from_lane_1_based,
			"card_id": bounced_summon_card_res.id, # Corrected: card resource ID
			"instance_id": bounced_summon_instance_id, # Correct: ID of the summon that left
			"reason": "bounce_effect_" + p_source_spell_card_res.id,
			"source_instance_id": p_played_spell_instance_id # Corrected: ID of the Elsewhere spell instance
		})
		
		# Event for the card moving to the library
		battle_instance.add_event({
			"event_type": "card_moved",
			"card_id": bounced_summon_card_res.id, # Corrected: card resource ID
			"player": opponent_combatant.combatant_name,
			"from_zone": "lane",
			"from_details": {
				"lane": bounced_from_lane_1_based,
				"instance_id": bounced_summon_instance_id 
			},
			"to_zone": "library",
			"to_details": {
				"position": "bottom", # Elsewhere is bottom
				"instance_id": new_library_card_instance_id 
			},
			"instance_id": bounced_summon_instance_id, 
			"reason": "bounce_effect_" + p_source_spell_card_res.id,
			"source_instance_id": p_played_spell_instance_id # Corrected: ID of the Elsewhere spell instance
		})
		
		# Optional visual effect
		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "elsewhere_bounce",
			"target_locations": ["%s lane %d" % [opponent_combatant.combatant_name, bounced_from_lane_1_based]],
			"details": {},
			# For visual effects, source_instance_id can also be useful if the effect animates from the spell card area
			"source_instance_id": p_played_spell_instance_id 
		})
	else:
		print("...Elsewhere found no target creature.")
		battle_instance.add_event({
			"event_type":"log_message", 
			"message":"Elsewhere (Instance: %s) found no target." % p_played_spell_instance_id,
			"source_instance_id": p_played_spell_instance_id
			})

# Check if opponent has creatures
func can_play(active_combatant, opponent_combatant, _turn_count: int, _battle_instance) -> bool:
	if active_combatant.mana < self.cost: return false
	for instance in opponent_combatant.lanes:
		if instance != null: return true
	return false
