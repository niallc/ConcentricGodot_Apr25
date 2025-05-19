# res://logic/card_effects/repentant_samurai_effect.gd
extends SummonCardResource

const HITS_TO_SACRIFICE = 2

# summon_instance is the Repentant Samurai itself
func perform_turn_activity_override(summon_instance: SummonInstance, active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle) -> bool:
	var opposing_creature_instance = opponent_combatant.lanes[summon_instance.lane_index]
	
	if opposing_creature_instance == null: # Condition for direct attack
		_perform_modified_direct_attack(summon_instance, active_combatant, opponent_combatant, battle_instance)
		
		battle_instance.add_event({
			"event_type": "summon_turn_activity",
			"player": active_combatant.combatant_name,
			"card_id": summon_instance.card_resource.id, # Repentant Samurai's card ID
			"instance_id": summon_instance.instance_id,  # Repentant Samurai's instance ID
			"lane": summon_instance.lane_index + 1,
			"activity_type": "direct_attack_modified" # Indicate it's the special attack
		})
		return true # Activity handled by this override
	else:
		return false # Let base SummonInstance logic handle combat against opposing_creature_instance

# summon_instance is the Repentant Samurai itself
func _perform_modified_direct_attack(summon_instance: SummonInstance, active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle):
	var samurai_instance_id: int = summon_instance.instance_id
	var samurai_card_id: String = summon_instance.card_resource.id
	var damage_amount: int = max(0, summon_instance.get_current_power())

	print("Repentant Samurai (Instance: %s) attacks opponent %s directly for %d damage" % [samurai_instance_id, opponent_combatant.combatant_name, damage_amount])
	
	# Call Combatant.take_damage with proper source info
	# Signature: take_damage(amount: int, p_source_card_id_for_event: String, p_source_instance_id_for_event: int)
	var _player_defeated = opponent_combatant.take_damage(damage_amount, samurai_card_id, samurai_instance_id)
	
	# The Combatant.take_damage method generates the "hp_change" event.
	# We still need a "direct_damage" event to specify context.
	battle_instance.add_event({
		"event_type": "direct_damage",
		"attacking_player": active_combatant.combatant_name,
		"attacking_lane": summon_instance.lane_index + 1,
		"attacking_card_id": samurai_card_id,
		"attacking_instance_id": samurai_instance_id,
		"target_player": opponent_combatant.combatant_name,
		"amount": damage_amount,
		"target_player_remaining_hp": opponent_combatant.current_hp
		# source_card_id and source_instance_id are implicitly the attacker here
	})
	
	if battle_instance.check_game_over(): return # Check if game ended

	# Track hits using custom_state
	var hits_dealt: int = summon_instance.custom_state.get("hits_dealt", 0) + 1
	summon_instance.custom_state["hits_dealt"] = hits_dealt
	print("...Repentant Samurai (Instance: %s) hits dealt: %s" % [samurai_instance_id, hits_dealt])

	if hits_dealt >= HITS_TO_SACRIFICE:
		print("...Repentant Samurai (Instance: %s) has dealt enough damage, sacrificing!" % samurai_instance_id)
		
		battle_instance.add_event({
			"event_type":"visual_effect",
			"effect_id":"repentant_samurai_sacrifice",
			"instance_id": samurai_instance_id, # The Samurai is the subject of this visual
			"card_id": samurai_card_id,
			"target_locations": ["%s lane %d (ID: %s)" % [active_combatant.combatant_name, summon_instance.lane_index + 1, samurai_instance_id]],
			"details": {"hits_achieved": hits_dealt},
			"source_card_id": samurai_card_id,         # Self-sacrifice
			"source_instance_id": samurai_instance_id  # Self-sacrifice
		})
		summon_instance.die() # This will trigger creature_defeated and card_moved to graveyard
							  # The source of these events will be the Samurai itself.
