extends SummonCardResource

const HITS_TO_SACRIFICE = 2

# Need to modify direct attack behavior
# We'll override perform_turn_activity and call a custom direct attack method

func perform_turn_activity_override(summon_instance: SummonInstance, active_combatant, opponent_combatant, battle_instance) -> bool:
	# Check if we should attack directly (no opposing creature)
	var opposing_instance = opponent_combatant.lanes[summon_instance.lane_index]
	if opposing_instance == null:
		_perform_modified_direct_attack(summon_instance, active_combatant, opponent_combatant, battle_instance)
		# Generate the base activity event
		battle_instance.add_event({
			"event_type": "summon_turn_activity",
			"player": active_combatant.combatant_name,
			"lane": summon_instance.lane_index + 1,
			"activity_type": "direct_attack"
		}) # summon_turn_activity event
		return true # We handled the activity
	else:
		# Not attacking directly, let base logic handle combat
		return false


# Custom direct attack logic for tracking hits
func _perform_modified_direct_attack(summon_instance: SummonInstance, active_combatant, opponent_combatant, battle_instance):
	var damage = max(0, summon_instance.get_current_power())
	print("Repentant Samurai attacks opponent directly for %d damage" % damage)
	var _defeated = opponent_combatant.take_damage(damage, self)
	# Deal damage (generates hp_change event)
	#var defeated = opponent_combatant.take_damage(damage, summon_instance)
	# Generate direct_damage event
	battle_instance.add_event({
		"event_type": "direct_damage",
		"attacking_player": active_combatant.combatant_name,
		"attacking_lane": summon_instance.lane_index + 1,
		"target_player": opponent_combatant.combatant_name,
		"amount": damage,
		"target_player_remaining_hp": opponent_combatant.current_hp
	}) # direct_damage event
	battle_instance.check_game_over() # Check if game ended

	# Track hits using custom_state
	var hits = summon_instance.custom_state.get("hits_dealt", 0)
	hits += 1
	summon_instance.custom_state["hits_dealt"] = hits
	print("...Samurai hits dealt: ", hits)

	# Check if sacrifice condition met
	if hits >= HITS_TO_SACRIFICE:
		print("...Samurai has dealt enough damage, sacrificing!")
		# Generate visual effect?
		# --- FIX: Replace ellipsis with empty dictionary or actual data ---
		battle_instance.add_event({
			"event_type":"visual_effect",
			"effect_id":"samurai_sacrifice",
			"target_locations": ["%s lane %d" % [active_combatant.combatant_name, summon_instance.lane_index + 1]],
			"details": {} # Use empty dictionary for now
		}) # visual_effect event
		# --- END FIX ---
		summon_instance.die() # Sacrifice self
