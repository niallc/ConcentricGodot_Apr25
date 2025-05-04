extends SummonCardResource

const GOBLIN_SCOUT_RES_PATH = "res://data/cards/instances/goblin_scout.tres"
var goblin_scout_res = null

func _init():
	if goblin_scout_res == null:
		goblin_scout_res = load(GOBLIN_SCOUT_RES_PATH) as SummonCardResource
		if goblin_scout_res == null: printerr("GoblinRecruiter Error: Failed to load Goblin Scout!")

func _on_arrival(_summon_instance: SummonInstance, active_combatant, opponent_combatant, battle_instance):
	print("Goblin Recruiter arrival trigger.")
	if goblin_scout_res == null: return # Cannot proceed if resource failed

	# Check HP condition
	if active_combatant.current_hp < opponent_combatant.current_hp:
		print("...Player HP lower, summoning scouts!")
		var summoned_count = 0
		for i in range(active_combatant.lanes.size()):
			if active_combatant.lanes[i] == null: # Found an empty lane
				print("...Summoning Goblin Scout in lane %d" % (i+1))
				summoned_count += 1
				# Simulate Summoning
				var new_summon = SummonInstance.new()
				new_summon.setup(goblin_scout_res, active_combatant, opponent_combatant, i, battle_instance)
				active_combatant.place_summon_in_lane(new_summon, i)
				# Generate Arrives Event (ensure dictionary is complete)
				battle_instance.add_event({
					"event_type": "summon_arrives",
					"player": active_combatant.combatant_name,
					"card_id": goblin_scout_res.id,
					"lane": i + 1, # 1-based
					"power": new_summon.get_current_power(),
					"max_hp": new_summon.get_current_max_hp(),
					"current_hp": new_summon.current_hp,
					"is_swift": new_summon.is_swift,
					"source_effect": "GoblinRecruiter" # Indicate source
				}) # summon_arrives event
				if new_summon.card_resource.has_method("_on_arrival"):
					new_summon.card_resource._on_arrival(new_summon, active_combatant, opponent_combatant, battle_instance)
		if summoned_count == 0: print("...No empty lanes found.")
	else:
		print("...Player HP not lower, no scouts summoned.")
