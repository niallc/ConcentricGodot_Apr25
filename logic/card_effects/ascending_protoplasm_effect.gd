extends SummonCardResource

# Override the hook called after an attack resolves
func _on_attack_resolved(attacker_instance: SummonInstance, _battle_instance):
	print("Ascending Protoplasm attacked, gaining +1/+1.")
	# Apply permanent +1/+1 counter
	attacker_instance.add_counter(1, attacker_instance.card_resource.id + "_attack", attacker_instance.instance_id, -1)
