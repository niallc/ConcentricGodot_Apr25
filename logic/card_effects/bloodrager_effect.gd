extends SummonCardResource

# Override the _on_kill_target method
func _on_kill_target(killer_instance: SummonInstance, _defeated_instance: SummonInstance, battle_instance):
	print("Bloodrager killed target!")
	# Heal to full
	var max_hp = killer_instance.get_current_max_hp()
	if killer_instance.current_hp < max_hp:
		print("...Healing to full.")
		killer_instance.heal(max_hp) # heal() handles event

	# Become Relentless (if not already)
	if not killer_instance.is_relentless:
		print("...Becoming Relentless.")
		killer_instance.is_relentless = true
		# Optional: Generate status change event
		battle_instance.add_event({
			"event_type": "status_change",
			"player": killer_instance.owner_combatant.combatant_name,
			"lane": killer_instance.lane_index + 1,
			"status": "Relentless",
			"gained": true,
			"source": killer_instance.card_resource.id + "_kill_trigger"
		})
