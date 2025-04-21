# res://logic/cards/summon_card.gd
extends CardResource
class_name SummonCardResource

@export var base_power: int = 0
@export var base_max_hp: int = 1 # Min 1 HP
@export var tags: Array[String] = [] # e.g., ["Undead"]
@export var is_swift: bool = false # Can it act on arrival?

# --- Placeholder virtual methods for summon behaviors ---
# These will be called by SummonInstance, allowing card-specific overrides
func _on_arrival(summon_instance, active_combatant, opponent_combatant, battle_instance):
	pass # Override in effect script if needed

func _on_death(summon_instance, active_combatant, opponent_combatant, battle_instance):
	pass # Override in effect script if needed

# Override if summon has non-standard turn activity (e.g., Wall of Vines)
func perform_turn_activity_override(summon_instance, active_combatant, opponent_combatant, battle_instance) -> bool:
	return false # Return true if this override handled the action

# Override base type getter
func get_card_type() -> String:
	return "Summon"
