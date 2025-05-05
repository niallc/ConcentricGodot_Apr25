# res://logic/cards/summon_card.gd
extends CardResource
class_name SummonCardResource

@export var base_power: int = 0
@export var base_max_hp: int = 1 # Min 1 HP
@export var tags: Array[String] = [] # e.g., ["Undead"]
@export var is_swift: bool = false # Can it act on arrival?

# --- Placeholder virtual methods for summon behaviors ---
# These will be called by SummonInstance, allowing card-specific overrides
func _on_arrival(_summon_instance, _active_combatant, _opponent_combatant, _battle_instance):
	pass # Override in effect script if needed

func _on_death(_summon_instance, _active_combatant, _opponent_combatant, _battle_instance):
	pass # Override in effect script if needed

func _on_kill_target(_killer_instance: SummonInstance, _defeated_instance: SummonInstance, _battle_instance):
	pass # Override in effect script if needed

# Override if summon has non-standard turn activity (e.g., Wall of Vines)
func perform_turn_activity_override(_summon_instance, _active_combatant, _opponent_combatant, _battle_instance) -> bool:
	return false # Return true if this override handled the action

# --- Virtual method for direct attack bonus damage ---
func _get_direct_attack_bonus_damage(_summon_instance: SummonInstance) -> int:
	return 0 # Default is no bonus damage

# --- Virtual method for trigger after an attack resolves ---
func _on_attack_resolved(_attacker_instance: SummonInstance, _battle_instance):
	pass # Default does nothing

# --- Virtual method for bonus combat damage ---
func _get_bonus_combat_damage(_attacker_instance: SummonInstance, _target_instance: SummonInstance) -> int:
	return 0 # Default is no bonus damage

# --- Virtual method for trigger after dealing direct damage ---
# Return true if this effect caused the summon to be sacrificed/removed
func _on_deal_direct_damage(_summon_instance: SummonInstance, _target_combatant: Combatant, _battle_instance) -> bool:
	return false # Default does nothing

# --- Virtual method for end-of-turn passive effects ---
func _end_of_turn_upkeep_effect(_summon_instance: SummonInstance, _battle_instance):
	pass # Override in effect script if needed


# Override base type getter
func get_card_type() -> String:
	return "Summon"
