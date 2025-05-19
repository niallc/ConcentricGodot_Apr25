# res://logic/card_effects/chanter_of_ashes_effect.gd
extends SummonCardResource

# _summon_instance is the Chanter of Ashes itself
func _on_arrival(_summon_instance: SummonInstance, active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle):
	var chanter_instance_id: int = _summon_instance.instance_id
	var chanter_card_id: String = _summon_instance.card_resource.id # "ChanterOfAshes"

	print("Chanter of Ashes (Instance: %s) arrival trigger." % chanter_instance_id)
	
	var consumed_summons_count: int = 0
	# Iterate backwards to safely remove elements from active_combatant.graveyard
	for i in range(active_combatant.graveyard.size() - 1, -1, -1):
		var card_in_zone_to_check = active_combatant.graveyard[i]
		if card_in_zone_to_check.card_resource is SummonCardResource:
			var removed_card_instance_id: int = card_in_zone_to_check.get_card_instance_id()
			var removed_card_res_id: String = card_in_zone_to_check.get_card_id()
			
			print("...Chanter (Instance: %s) consuming %s (Instance: %s) from %s's graveyard." % [chanter_instance_id, removed_card_res_id, removed_card_instance_id, active_combatant.combatant_name])
			
			active_combatant.graveyard.remove_at(i)
			consumed_summons_count += 1
			
			battle_instance.add_event({
				"event_type": "card_removed",
				"card_id": removed_card_res_id,
				"instance_id": removed_card_instance_id, # ID of the card removed from graveyard
				"player": active_combatant.combatant_name,
				"from_zone": "graveyard",
				"reason": "consumed_by_" + chanter_card_id,
				"source_card_id": chanter_card_id,
				"source_instance_id": chanter_instance_id
			})

	if consumed_summons_count > 0:
		var damage_to_deal_to_opponent: int = consumed_summons_count * 2
		print("...Chanter (Instance: %s) consumed %d creatures, dealing %d damage to opponent %s." % [chanter_instance_id, consumed_summons_count, damage_to_deal_to_opponent, opponent_combatant.combatant_name])
		
		# Call Combatant.take_damage with Chanter of Ashes as the source
		# Signature: take_damage(amount: int, p_source_card_id: String, p_source_instance_id: int)
		opponent_combatant.take_damage(damage_to_deal_to_opponent, chanter_card_id, chanter_instance_id)
		
		# The "hp_change" event is generated inside opponent_combatant.take_damage().
		# We still need an "effect_damage" event for specific context if our spec calls for it,
		# or if "hp_change" alone isn't descriptive enough for the replay.
		# Your spec has "effect_damage".
		battle_instance.add_event({
			"event_type": "effect_damage", 
			"source_card_id": chanter_card_id,
			"source_instance_id": chanter_instance_id, # Instance ID of the Chanter
			"source_player": active_combatant.combatant_name, # Player controlling the Chanter
			"target_player": opponent_combatant.combatant_name,
			"amount": damage_to_deal_to_opponent,
			"target_player_remaining_hp": opponent_combatant.current_hp,
			"instance_id": chanter_instance_id
			# The main "instance_id" of this event could be the Chanter causing the damage.
			# "instance_id": chanter_instance_id 
		})
		
		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "chanter_of_ashes_damage_pulse",
			"target_locations": [opponent_combatant.combatant_name], # Opponent player takes the visual hit
			"details": {"damage_dealt": damage_to_deal_to_opponent, "summons_consumed": consumed_summons_count},
			"instance_id": chanter_instance_id, # Chanter is the origin of this visual
			"source_card_id": chanter_card_id,
			"source_instance_id": chanter_instance_id
		})
		
		battle_instance.check_game_over() # Damage was dealt to a player
	else:
		print("...Chanter (Instance: %s) found no summon creatures in %s's graveyard to consume." % [chanter_instance_id, active_combatant.combatant_name])
		battle_instance.add_event({
			"event_type": "log_message",
			"message": "Chanter of Ashes (Instance: %s) found no summons in own graveyard." % chanter_instance_id,
			"source_card_id": chanter_card_id,
			"source_instance_id": chanter_instance_id
		})
