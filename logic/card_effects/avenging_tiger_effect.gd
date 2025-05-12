extends SummonCardResource

# On arrival, check HP and potentially grant swift
func _on_arrival(summon_instance: SummonInstance, active_combatant, opponent_combatant, battle_instance):
	print("Avenging Tiger arrival trigger.")
	if active_combatant.current_hp < opponent_combatant.current_hp:
		print("...Player HP lower, granting Swift!")
		# Grant swift by setting the flag on the instance
		# The Summon Activity phase in Battle checks is_newly_arrived and is_swift
		summon_instance.is_swift = true
		# Optional: Generate event indicating swift was gained
		battle_instance.add_event({
			"event_type": "status_change", # Or maybe specific "gained_swift"
			"player": active_combatant.combatant_name,
			"lane": summon_instance.lane_index + 1,
			"status": "Swift",
			"gained": true,
			# TODO: One way or another, handle instancing for status_change
			#       events. There could be multiple e.g. tigers.
			"instance_id": "Not implemented yet but needed. Gained swift event."
		})
	else:
		print("...Player HP not lower, no Swift granted.")
