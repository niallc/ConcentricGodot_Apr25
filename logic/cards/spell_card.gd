# res://logic/cards/spell_card.gd
extends CardResource
class_name SpellCardResource

# --- Spell-specific properties could go here if needed ---

# Virtual method to be overridden by specific spell effect scripts
# Parameters match the spec: Combatant refs & Battle ref for event generation
func apply_effect(source_card_res: SpellCardResource, p_played_spell_instance_id: int, _active_combatant, _opponent_combatant, _battle_instance):
	print("WARNING: Base apply_effect called for %s" % source_card_res.card_name)
# Virtual method for checking playability beyond mana cost
func can_play(active_combatant, _opponent_combatant, _turn_count: int, _battle_instance) -> bool:
	# Base implementation only checks mana, card scripts can override
	return active_combatant.mana >= cost

# Override base type getter
func get_card_type() -> String:
	return "Spell"
