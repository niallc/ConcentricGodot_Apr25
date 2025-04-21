# res://logic/cards/card.gd
extends Resource
class_name CardResource # Make this type globally recognizable

@export var id: String = "UNKNOWN_CARD" # Unique identifier string
@export var card_name: String = "Unnamed Card" # Display name
@export var cost: int = 0
@export var artwork_path: String = "res://art/default_card.png" # Placeholder art
@export var description_template: String = "Card Description Missing."
# @export var tags: Array[String] = [] # Base tags if any

# Placeholder method for getting card type (Spell/Summon)
func get_card_type() -> String:
	return "Base"

# Placeholder for generating formatted description (we'll refine this later)
func get_formatted_description() -> String:
	return description_template
