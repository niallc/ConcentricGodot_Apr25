extends SpellCardResource

# Preload the Goblin Scout resource - this is fine.
const GOBLIN_SCOUT_RES_PATH = "res://data/cards/instances/goblin_scout.tres"
var goblin_scout_res: SummonCardResource = null # Add type hint

func _init():
	if goblin_scout_res == null:
		goblin_scout_res = load(GOBLIN_SCOUT_RES_PATH) as SummonCardResource
		if goblin_scout_res == null:
			printerr("GoblinRally Error: Failed to load Goblin Scout resource at %s!" % GOBLIN_SCOUT_RES_PATH)

# Updated signature
func apply_effect(p_rally_card_in_zone: CardInZone, active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle):
	var rally_spell_instance_id: int = p_rally_card_in_zone.get_card_instance_id()
	var rally_spell_card_id: String = p_rally_card_in_zone.get_card_id()

	print("Goblin Rally (Instance: %s) effect." % rally_spell_instance_id)
	
	if goblin_scout_res == null:
		printerr("Cannot execute Goblin Rally (Instance: %s): Goblin Scout resource not loaded." % rally_spell_instance_id)
		battle_instance.add_event({
			"event_type": "log_message",
			"message": "Goblin Rally (Instance: %s) failed: GoblinScout resource missing." % rally_spell_instance_id,
			"source_card_id": rally_spell_card_id,
			"source_instance_id": rally_spell_instance_id
		})
		return

	var summoned_count: int = 0
	for i in range(active_combatant.lanes.size()):
		if active_combatant.lanes[i] == null: # Found an empty lane
			summoned_count += 1
			var target_lane_index: int = i
			print("...Goblin Rally (Instance: %s) summoning Goblin Scout in lane %d" % [rally_spell_instance_id, target_lane_index + 1])
			
			var new_scout_summon = SummonInstance.new()
			var new_scout_instance_id: int = battle_instance._generate_new_card_instance_id()
			
			new_scout_summon.setup(goblin_scout_res, active_combatant, opponent_combatant, target_lane_index, battle_instance, new_scout_instance_id)
			active_combatant.place_summon_in_lane(new_scout_summon, target_lane_index)
			
			battle_instance.add_event({
				"event_type": "summon_arrives",
				"player": active_combatant.combatant_name,
				"card_id": goblin_scout_res.id, # The Card ID of the scout
				"lane": target_lane_index + 1, 
				"instance_id": new_scout_instance_id, # The new Instance ID of the summoned scout
				"power": new_scout_summon.get_current_power(),
				"max_hp": new_scout_summon.get_current_max_hp(),
				"current_hp": new_scout_summon.current_hp,
				"is_swift": new_scout_summon.is_swift,
				"tags": new_scout_summon.tags.duplicate(),
				"source_card_id": rally_spell_card_id,    # e.g., "GoblinRally"
				"source_instance_id": rally_spell_instance_id # Instance ID of the Rally spell that caused this
			})
			
			# Goblin Scout is vanilla, so its _on_arrival is likely empty, but good practice to call.
			if new_scout_summon.card_resource != null and new_scout_summon.card_resource.has_method("_on_arrival"):
				new_scout_summon.card_resource._on_arrival(new_scout_summon, active_combatant, opponent_combatant, battle_instance)
	
	if summoned_count == 0:
		print("...No empty lanes found for Goblin Rally (Instance: %s)." % rally_spell_instance_id)
		battle_instance.add_event({
			"event_type": "log_message",
			"message": "Goblin Rally (Instance: %s) found no empty lanes." % rally_spell_instance_id,
			"source_card_id": rally_spell_card_id,
			"source_instance_id": rally_spell_instance_id,
			"instance_id": rally_spell_instance_id
		})

	# Visual effect for the Goblin Rally spell itself casting
	battle_instance.add_event({
		"event_type": "visual_effect",
		"effect_id": "goblin_rally_cast",
		"target_locations": [active_combatant.combatant_name], # Or perhaps "all_friendly_lanes" if visuals target lanes
		"details": {"summoned_count": summoned_count, "summon_card_id": goblin_scout_res.id if goblin_scout_res else "unknown"},
		"instance_id": rally_spell_instance_id,
		"source_card_id": rally_spell_card_id, # Card ID of the spell causing the visual
		"source_instance_id": rally_spell_instance_id # Instance ID of the spell causing the visual
	})
