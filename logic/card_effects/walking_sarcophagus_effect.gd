extends SummonCardResource

# Override the trigger after dealing direct damage
func _on_deal_direct_damage(summon_instance: SummonInstance, _target_combatant: Combatant, battle_instance) -> bool:
	print("Walking Sarcophagus dealt direct damage trigger!")

	# 1. Find leftmost creature in owner's graveyard
	var active_combatant = summon_instance.owner_combatant
	var opponent_combatant = summon_instance.opponent_combatant # Needed for reanimation setup
	var target_card_res: SummonCardResource = null
	var target_grave_index = -1
	for i in range(active_combatant.graveyard.size()):
		if active_combatant.graveyard[i] is SummonCardResource:
			target_card_res = active_combatant.graveyard[i]
			target_grave_index = i
			break # Found leftmost

	# Store current lane before sacrificing
	var current_lane_index = summon_instance.lane_index

	# 2. Sacrifice self FIRST
	print("...Sacrificing self.")
	summon_instance.die() # Handles events for death/graveyard

	# 3. Reanimate target if found AND lane is now clear
	if target_card_res != null:
		# Check if the lane the sarcophagus was in is now clear
		# It should be, because die() calls remove_summon_from_lane
		if current_lane_index != -1 and active_combatant.lanes[current_lane_index] == null:
			print("...Reanimating %s into lane %d" % [target_card_res.card_name, current_lane_index + 1])
			# Remove from graveyard
			active_combatant.graveyard.remove_at(target_grave_index)
			battle_instance.add_event({  }) # card_moved grave->limbo

			# Simulate Summoning
			var new_summon = SummonInstance.new()
			# Reanimated creature is NOT swift by default unless card says so
			new_summon.setup(target_card_res, active_combatant, opponent_combatant, current_lane_index, battle_instance)
			active_combatant.place_summon_in_lane(new_summon, current_lane_index)
			battle_instance.add_event({  }) # summon_arrives event
			battle_instance.add_event({  }) # card_moved limbo->lane
			if new_summon.card_resource.has_method("_on_arrival"):
				new_summon.card_resource._on_arrival(new_summon, active_combatant, opponent_combatant, battle_instance)
		else:
			printerr("Walking Sarcophagus Error: Lane %d not clear after sacrifice?" % (current_lane_index + 1))
			# Put card back in grave if summon failed? Or let it be removed? Let's assume removed.
	else:
		print("...No creature found in graveyard to reanimate.")

	return true # Indicate that the original instance (Sarcophagus) was removed
