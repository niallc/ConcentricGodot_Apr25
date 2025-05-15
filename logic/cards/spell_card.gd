# res://logic/cards/spell_card.gd
extends CardResource
class_name SpellCardResource

# --- Spell-specific properties could go here if needed ---

# Virtual method to be overridden by specific spell effect scripts
# Parameters match the spec: Combatant refs & Battle ref for event generation
func apply_effect(p_played_spell_card_in_zone: CardInZone, active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle):
	# Access static data: p_played_spell_card_in_zone.card_resource (e.g., .id, .cost)
	# Access instance ID: p_played_spell_card_in_zone.instance_id
	print("WARNING: Base apply_effect called for %s (Instance ID: %s)" % [p_played_spell_card_in_zone.get_card_id(), p_played_spell_card_in_zone.instance_id])

# Virtual method for checking playability beyond mana cost
func can_play(active_combatant, _opponent_combatant, _turn_count: int, _battle_instance) -> bool:
	# Base implementation only checks mana, card scripts can override
	return active_combatant.mana >= cost

# Override base type getter
func get_card_type() -> String:
	return "Spell"
