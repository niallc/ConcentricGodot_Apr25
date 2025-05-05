# res://logic/card_effects/troll_effect.gd
extends SummonCardResource

# Override the end-of-turn upkeep hook for regeneration
func _end_of_turn_upkeep_effect(summon_instance: SummonInstance, _battle_instance):
	# Heal self for 1 HP, but not above max HP
	var heal_amount = 1
	if summon_instance.current_hp < summon_instance.get_current_max_hp():
		print("Troll regenerating %d HP." % heal_amount)
		summon_instance.heal(heal_amount) # heal() handles clamping and event generation
	# else: # Already at max HP, do nothing
	#	print("Troll already at max HP.")
