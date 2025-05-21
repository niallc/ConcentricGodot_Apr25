extends SummonCardResource

const RETURNED_SAMURAI_RES_PATH = "res://data/cards/instances/returned_samurai.tres"
var returned_samurai_res = null

func _init():
	if returned_samurai_res == null:
		returned_samurai_res = load(RETURNED_SAMURAI_RES_PATH) as SummonCardResource
		if returned_samurai_res == null: printerr("CursedSamurai Error: Failed to load Returned Samurai!")

# On death, summon Returned Samurai in the same lane
func _on_death(summon_instance: SummonInstance, active_combatant, opponent_combatant, battle_instance):
	print("Cursed Samurai death trigger!")
	if returned_samurai_res == null: return

	var target_lane_index = summon_instance.lane_index
	# The lane WILL contain the dying instance when this is called.
	# The die() method clears the lane AFTER this _on_death call finishes.
	# We directly place the new summon, overwriting the dying one's slot.
	print("...Summoning Returned Samurai in lane %d" % (target_lane_index + 1))
	# Simulate Summoning
	var new_summon = SummonInstance.new()
	var new_id = battle_instance.get_new_instance_id()
	new_summon.setup(returned_samurai_res, active_combatant, opponent_combatant, target_lane_index, battle_instance, new_id)
	# Directly assign to the lane array, with a custom lane check ---
	if active_combatant.lanes[target_lane_index] == null:
		printerr("Expected Cursed Samurai in %d but fund null.", target_lane_index)
	var creature_in_lane = active_combatant.lanes[target_lane_index]
	var lane_check = creature_in_lane.card_resource.id == "CursedSamurai" # The only allowable creature in this lane
	# Removing below check: it's pretty unnecessary in this context and might not match future
	#                       ways that a creature could be removed (e.g. by a destroy effect)
	# lane_check = lane_check and creature_in_lane.current_hp <= 0 # Of course it should be dead
	lane_check = lane_check and target_lane_index >= 0 and target_lane_index < active_combatant.lanes.size()
	if lane_check:
		active_combatant.lanes[target_lane_index] = new_summon
		summon_instance.custom_state["replaced_in_lane"] = true
		print("...Returned Samurai placed directly into lane %d." % target_lane_index)
	else:
		printerr("Cursed Samurai Error: Invalid target_lane_index %d" % target_lane_index)
		return # Cannot place if index is invalid

	# Generate Arrives Event (ensure dictionary is complete)
	battle_instance.add_event({
		"event_type": "summon_arrives",
		"player": active_combatant.combatant_name,
		"card_id": returned_samurai_res.id,
		"lane": target_lane_index + 1,
		"instance_id": new_id,
		"power": new_summon.get_current_power(),
		"max_hp": new_summon.get_current_max_hp(),
		"current_hp": new_summon.current_hp,
		"is_swift": new_summon.is_swift,
		"tags": new_summon.tags.duplicate(),
		"source_effect": "CursedSamurai"
	}) # summon_arrives event
	# Note: Returned Samurai is likely vanilla, but call arrival just in case
	if new_summon.card_resource.has_method("_on_arrival"):
		new_summon.card_resource._on_arrival(new_summon, active_combatant, opponent_combatant, battle_instance)
