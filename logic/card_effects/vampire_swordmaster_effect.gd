extends SummonCardResource

# Override the new _on_kill_target method
func _on_kill_target(killer_instance: SummonInstance, _defeated_instance: SummonInstance, _battle_instance):
	# Heal the killer (Vampire Swordmaster) to full HP
	var max_hp = killer_instance.get_current_max_hp()
	if killer_instance.current_hp < max_hp:
		print("Vampire Swordmaster heals to full on kill.")
		# Call heal with a large amount to guarantee full heal, heal() handles clamping
		killer_instance.heal(max_hp) # heal() generates the event
