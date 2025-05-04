extends SummonCardResource

# On arrival, check HP and potentially grant +2/+2
func _on_arrival(summon_instance: SummonInstance, active_combatant, opponent_combatant, _battle_instance):
	print("Spiteful Fang arrival trigger.")
	# Check if owner HP is less than opponent HP
	if active_combatant.current_hp < opponent_combatant.current_hp:
		print("...Player HP lower, gaining +2/+2.")
		# Apply +2/+2 counter (add_counter handles events)
		summon_instance.add_counter(2, summon_instance.card_resource.id + "_arrival", -1) # Permanent buff
	else:
		print("...Player HP not lower, no stat boost.")

	# Note: The "Relentless" aspect is handled by the tag + SummonInstance.setup()
