extends SummonCardResource

# Override to provide bonus damage on direct attack
func _get_direct_attack_bonus_damage(_summon_instance: SummonInstance) -> int:
	return 1 # Deals +1 bonus damage
