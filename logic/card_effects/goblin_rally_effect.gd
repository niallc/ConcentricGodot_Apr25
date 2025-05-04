extends SpellCardResource

# Need access to Goblin Scout resource
const GOBLIN_SCOUT_RES_PATH = "res://data/cards/instances/goblin_scout.tres"
var goblin_scout_res = null # Cache it

func _init():
	# Preload the resource when the script instance is created (or first needed)
	if goblin_scout_res == null:
		goblin_scout_res = load(GOBLIN_SCOUT_RES_PATH) as SummonCardResource
		if goblin_scout_res == null:
			printerr("GoblinRally Error: Failed to load Goblin Scout resource!")

func apply_effect(source_card_res: SpellCardResource, active_combatant, opponent_combatant, battle_instance):
	print("Goblin Rally effect.")
	if goblin_scout_res == null:
		printerr("Cannot execute Goblin Rally: Goblin Scout resource not loaded.")
		return

	var summoned_count = 0
	# Iterate through lanes
	for i in range(active_combatant.lanes.size()):
		if active_combatant.lanes[i] == null: # Found an empty lane
			print("...Summoning Goblin Scout in lane %d" % (i+1))
			summoned_count += 1
			# --- Simulate Summoning (similar to Battle.conduct_turn) ---
			var target_lane_index = i
			var new_summon = SummonInstance.new()
			# Pass references needed by SummonInstance and its effects
			new_summon.setup(goblin_scout_res, active_combatant, opponent_combatant, target_lane_index, battle_instance)
			# Place in logic lane
			active_combatant.place_summon_in_lane(new_summon, target_lane_index)
			# Generate Arrives Event
			battle_instance.add_event({
				"event_type": "summon_arrives",
				"player": active_combatant.combatant_name,
				"card_id": goblin_scout_res.id,
				"lane": target_lane_index + 1, # 1-based
				"power": new_summon.get_current_power(),
				"max_hp": new_summon.get_current_max_hp(),
				"current_hp": new_summon.current_hp,
				"is_swift": new_summon.is_swift,
				"source_effect": source_card_res.id # Indicate it came from Rally
			})
			# Call _on_arrival effect script (Goblin Scout has none, but good practice)
			if new_summon.card_resource != null and new_summon.card_resource.has_method("_on_arrival"):
				new_summon.card_resource._on_arrival(new_summon, active_combatant, opponent_combatant, battle_instance)
			# --- End Simulate Summoning ---

	if summoned_count == 0:
		print("...No empty lanes found for Goblin Rally.")
		# Optional: Event for fizzle?

	# Optional: Visual effect event
	battle_instance.add_event({
		"event_type": "visual_effect",
		"effect_id": "goblin_rally_cast",
		"target_locations": [active_combatant.combatant_name], # General player area?
		"details": {"summoned_count": summoned_count}
	})
