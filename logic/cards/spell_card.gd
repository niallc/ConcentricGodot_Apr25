# res://logic/cards/spell_card.gd
extends CardResource
class_name SpellCardResource

# --- Spell-specific properties could go here if needed ---

# Virtual method to be overridden by specific spell effect scripts
# Parameters match the spec: Combatant refs & Battle ref for event generation
func apply_effect(active_combatant, opponent_combatant, battle_instance):
	# Specific spells MUST override this
	print("WARNING: Base apply_effect called for %s" % card_name)
	
# Virtual method for checking playability beyond mana cost
func can_play(active_combatant, opponent_combatant, turn_count: int, battle_instance) -> bool:
	# Base implementation only checks mana, card scripts can override
	return active_combatant.mana >= cost

# Override base type getter
func get_card_type() -> String:
	return "Spell"
