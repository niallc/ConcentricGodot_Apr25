extends SummonCardResource

const BONUS_DAMAGE_THRESHOLD = 4
const BONUS_DAMAGE_AMOUNT = 3

# Override to provide bonus damage against high-power creatures
func _get_bonus_combat_damage(_attacker_instance: SummonInstance, target_instance: SummonInstance) -> int:
	if target_instance != null and target_instance.get_current_power() >= BONUS_DAMAGE_THRESHOLD:
		print("Goblin Gladiator gets +%d bonus damage vs %s (Power %d)" % [BONUS_DAMAGE_AMOUNT, target_instance.card_resource.card_name, target_instance.get_current_power()])
		return BONUS_DAMAGE_AMOUNT
	return 0 # No bonus damage
