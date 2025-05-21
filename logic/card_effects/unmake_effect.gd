# res://logic/card_effects/unmake_effect.gd
extends SpellCardResource

func apply_effect(p_unmake_card_in_zone: CardInZone, _active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle):
	var unmake_spell_instance_id: int = p_unmake_card_in_zone.get_card_instance_id()
	var unmake_spell_card_id: String = p_unmake_card_in_zone.get_card_id()

	print("Unmake (Instance: %s) effect." % unmake_spell_instance_id)
	
	var target_creature_instance: SummonInstance = null
	var target_creature_lane_index: int = -1
	
	# Find opponent's leftmost non-Undead creature
	for i in range(opponent_combatant.lanes.size()):
		var potential_target = opponent_combatant.lanes[i]
		if potential_target != null and not potential_target.tags.has(Constants.TAG_UNDEAD):
			target_creature_instance = potential_target
			target_creature_lane_index = i
			break # Found leftmost valid target

	if target_creature_instance != null:
		var target_card_id_str: String = target_creature_instance.card_resource.id
		var target_instance_id_val: int = target_creature_instance.instance_id

		print("...Unmake (Instance: %s) destroying %s (Instance: %s) in lane %d." % [unmake_spell_instance_id, target_card_id_str, target_instance_id_val, target_creature_lane_index + 1])
		
		# Visual effect for Unmake targeting the creature BEFORE it dies
		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "unmake_targeting_visual", # e.g., a beam or mark
			"instance_id": target_instance_id_val, # The creature being targeted/destroyed
			"card_id": target_card_id_str,
			"target_locations": ["%s lane %d (ID: %s)" % [opponent_combatant.combatant_name, target_creature_lane_index + 1, target_instance_id_val]],
			"details": {"destroyed_by_card_id": unmake_spell_card_id},
			"source_card_id": unmake_spell_card_id,
			"source_instance_id": unmake_spell_instance_id
		})
		
		# target_instance.die() will generate:
		# 1. "creature_defeated" event (instance_id: target_instance_id_val)
		# 2. Calls to _on_death hooks (if any on the target)
		# 3. "card_moved" event (from lane to graveyard) for the target.
		#    The source information for *why* it died isn't directly in those events yet.
		#    We might need to pass source info into die() if we want the creature_defeated event to know it was "unmade".
		#    For now, the visual effect above and log message give context.
		target_creature_instance.die(unmake_spell_card_id, unmake_spell_instance_id)
		# The die() method internally calls add_card_to_graveyard, which will generate
		# a card_moved event. That event's source_instance_id should ideally reflect the Unmake spell.
		# This requires `SummonInstance.die()` to pass the `source_instance_id` of what caused the death
		# down to `add_card_to_graveyard`.
		# Currently, SummonInstance.die() calls:
		# owner_combatant.add_card_to_graveyard(card_resource, "lane", self.instance_id)
		# The last `self.instance_id` is for `p_instance_id_if_relevant` for the card_moved from lane.
		# To correctly attribute the *reason* for going to graveyard to "Unmake", the `reason` field in `card_moved`
		# within `add_card_to_graveyard` is key. `die()` itself doesn't take a "reason" yet.
		# This is a more advanced point about enriching `die()` further. For now, the visual effect provides some link.
	else:
		print("...Unmake (Instance: %s) found no non-Undead target." % unmake_spell_instance_id)
		battle_instance.add_event({
			"event_type": "log_message", 
			"message": "Unmake (Instance: %s) found no non-Undead target." % unmake_spell_instance_id,
			"source_card_id": unmake_spell_card_id,
			"source_instance_id": unmake_spell_instance_id
		})

# can_play also needs to be aware of the TAG_UNDEAD constant.
func can_play(active_combatant: Combatant, opponent_combatant: Combatant, _turn_count: int, _battle_instance: Battle) -> bool:
	if active_combatant.mana < self.cost: # self.cost refers to Unmake's cost
		return false
	for creature_instance in opponent_combatant.lanes:
		if creature_instance != null and not creature_instance.tags.has(Constants.TAG_UNDEAD):
			return true # Found a valid (non-Undead) target
	return false # No valid target found
