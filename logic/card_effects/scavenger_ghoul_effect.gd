# res://logic/card_effects/scavenger_ghoul_effect.gd
extends SummonCardResource

# _summon_instance is the Scavenger Ghoul SummonInstance itself.
func _on_arrival(_summon_instance: SummonInstance, active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle):
	var ghoul_instance_id: int = _summon_instance.instance_id
	var ghoul_card_id: String = _summon_instance.card_resource.id # "ScavengerGhoul"

	print("Scavenger Ghoul (Instance: %s) arrival trigger." % ghoul_instance_id)
	
	var total_summons_consumed: int = 0
	
	# Consume player's graveyard (summons only)
	# Iterate backwards to safely remove elements
	for i in range(active_combatant.graveyard.size() - 1, -1, -1):
		var card_in_zone_to_check = active_combatant.graveyard[i]
		if card_in_zone_to_check.card_resource is SummonCardResource:
			var removed_card_res_id: String = card_in_zone_to_check.get_card_id()
			var removed_card_instance_id: int = card_in_zone_to_check.get_card_instance_id()
			
			print("    ...Scavenger Ghoul consuming %s (Instance: %s) from %s's graveyard." % [removed_card_res_id, removed_card_instance_id, active_combatant.combatant_name])
			
			active_combatant.graveyard.remove_at(i)
			total_summons_consumed += 1
			
			battle_instance.add_event({
				"event_type": "card_removed",
				"card_id": removed_card_res_id,
				"instance_id": removed_card_instance_id, # ID of the card removed
				"player": active_combatant.combatant_name,
				"from_zone": "graveyard",
				"reason": "consumed_by_" + ghoul_card_id,
				"source_card_id": ghoul_card_id,
				"source_instance_id": ghoul_instance_id
			})

	# Consume opponent's graveyard (summons only)
	# Iterate backwards to safely remove elements
	for i in range(opponent_combatant.graveyard.size() - 1, -1, -1):
		var card_in_zone_to_check = opponent_combatant.graveyard[i]
		if card_in_zone_to_check.card_resource is SummonCardResource:
			var removed_card_res_id: String = card_in_zone_to_check.get_card_id()
			var removed_card_instance_id: int = card_in_zone_to_check.get_card_instance_id()

			print("    ...Scavenger Ghoul consuming %s (Instance: %s) from %s's graveyard." % [removed_card_res_id, removed_card_instance_id, opponent_combatant.combatant_name])
			
			opponent_combatant.graveyard.remove_at(i)
			total_summons_consumed += 1
			
			battle_instance.add_event({
				"event_type": "card_removed",
				"card_id": removed_card_res_id,
				"instance_id": removed_card_instance_id,
				"player": opponent_combatant.combatant_name,
				"from_zone": "graveyard",
				"reason": "consumed_by_" + ghoul_card_id,
				"source_card_id": ghoul_card_id,
				"source_instance_id": ghoul_instance_id
			})

	if total_summons_consumed > 0:
		var life_gain_amount: int = total_summons_consumed * 2
		print("...Scavenger Ghoul (Instance: %s) consumed %d summons total. %s gaining %d life." % [ghoul_instance_id, total_summons_consumed, active_combatant.combatant_name, life_gain_amount])
		
		# Call Combatant.heal with Scavenger Ghoul as the source
		# Signature: heal(amount: int, p_source_card_id: String, p_source_instance_id: int)
		active_combatant.heal(life_gain_amount, ghoul_card_id, ghoul_instance_id)
		# The "hp_change" event is generated inside active_combatant.heal()

		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "scavenger_ghoul_consume_heal",
			"instance_id": ghoul_instance_id, # Ghoul is the primary subject/source of this overall visual
			"target_locations": [active_combatant.combatant_name], # Player (Ghoul's owner) is visually healed
			"details": {"summons_consumed_total": total_summons_consumed, "life_healed": life_gain_amount},
			"source_card_id": ghoul_card_id,
			"source_instance_id": ghoul_instance_id
		})
	else:
		print("...Scavenger Ghoul (Instance: %s) found no summon creatures in any graveyard to consume." % ghoul_instance_id)
		battle_instance.add_event({
			"event_type": "log_message",
			"message": "Scavenger Ghoul (Instance: %s) found no summons in any graveyard." % ghoul_instance_id,
			"instance_id": ghoul_instance_id,
			"source_card_id": ghoul_card_id,
			"source_instance_id": ghoul_instance_id
		})
