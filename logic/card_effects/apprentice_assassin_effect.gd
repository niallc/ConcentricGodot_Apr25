extends SummonCardResource

# Override the _on_kill_target virtual method
func _on_kill_target(killer_instance: SummonInstance, _defeated_instance: SummonInstance, _battle_instance):
	var power_gain = 2
	print("Apprentice Assassin killed target, gaining %d power." % power_gain)
	# Call add_power on self (the killer instance)
	killer_instance.add_power(power_gain, killer_instance.card_resource.id + "_kill_trigger", killer_instance.instance_id, -1) # Permanent boost
