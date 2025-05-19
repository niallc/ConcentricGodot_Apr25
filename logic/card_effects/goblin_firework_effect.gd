# res://logic/card_effects/goblin_firework_effect.gd
extends SummonCardResource

# summon_instance here is the Goblin Firework that just died.
func _on_death(summon_instance: SummonInstance, _active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle):
	var firework_instance_id: int = summon_instance.instance_id
	var firework_card_id: String = summon_instance.card_resource.id # Should be "GoblinFirework"

	print("Goblin Firework (Instance: %s) death trigger!" % firework_instance_id)
	
	var opposing_lane_index: int = summon_instance.lane_index 
	# Check opponent has lanes and index is valid (defensive check) - good.
	if opponent_combatant.lanes.size() > opposing_lane_index and opposing_lane_index != -1:
		var target_creature_instance = opponent_combatant.lanes[opposing_lane_index]

		if target_creature_instance != null:
			var damage_amount: int = 1
			print("...%s (Instance: %s) damaging opposing %s (Instance: %s) for %d" % [firework_card_id, firework_instance_id, target_creature_instance.card_resource.card_name, target_creature_instance.instance_id, damage_amount])
			
			# The Goblin Firework (summon_instance) is the source of this damage.
			target_creature_instance.take_damage(damage_amount, firework_card_id, firework_instance_id)

			# Visual effect for the explosion targeting the creature hit
			battle_instance.add_event({
				"event_type": "visual_effect",
				"effect_id": "firework_explosion_on_target",
				"instance_id": target_creature_instance.instance_id, # The creature hit is the main subject of this visual
				"card_id": target_creature_instance.card_resource.id, # Type of creature hit
				"target_locations": ["%s lane %d (ID: %s)" % [opponent_combatant.combatant_name, opposing_lane_index + 1, target_creature_instance.instance_id]],
				"details": {"damage_dealt": damage_amount, "explosion_source_card_id": firework_card_id},
				"source_card_id": firework_card_id,          # Caused by Goblin Firework card type
				"source_instance_id": firework_instance_id  # Caused by this specific Firework instance
			})
		else:
			print("...%s (Instance: %s) found no target in opposing lane %d." % [firework_card_id, firework_instance_id, opposing_lane_index + 1])
	else:
		printerr("Goblin Firework (Instance: %s) _on_death: Invalid opposing lane index %d or opponent has no lanes." % [firework_instance_id, opposing_lane_index])
