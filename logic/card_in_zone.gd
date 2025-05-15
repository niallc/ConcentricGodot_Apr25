# logic/card_in_zone.gd
class_name CardInZone extends RefCounted

# --- Properties ---
## The actual CardResource this instance represents.
var card_resource: CardResource

## The unique identifier for this specific instance of the card in this battle.
var instance_id: int = -1 # Default to -1 to indicate it hasn't been properly set if seen

## The original card_id from the CardResource, stored for convenience and debugging.
var source_card_id: String = "UNINITIALIZED"


# --- Constructor ---
func _init(p_card_resource: CardResource, p_instance_id: int):
	if not p_card_resource is CardResource:
		printerr("CardInZone._init: p_card_resource is not a valid CardResource. Received: ", typeof(p_card_resource))
		# Depending on strictness, you might want to assert here or handle it
		# For now, we'll allow it but card_resource will be null.
		card_resource = null # Ensure it's null if invalid
	else:
		card_resource = p_card_resource

	instance_id = p_instance_id

	if card_resource:
		# CardResource.id is an @export var String
		source_card_id = card_resource.id
	elif p_card_resource == null: # Explicitly check for null after the type check
		source_card_id = "NULL_RESOURCE_PASSED"
		printerr("CardInZone._init: A null CardResource was passed.")
	else: # Was not a CardResource and also not null (e.g. wrong type)
		source_card_id = "INVALID_RESOURCE_TYPE"


# --- Delegate Methods (for convenience) ---

## Returns the ID of the wrapped CardResource.
func get_card_id() -> String:
	if card_resource:
		return card_resource.id
	printerr("CardInZone.get_card_id: Attempted to get ID from a null card_resource for instance_id: %s" % instance_id)
	return ""


## Returns the name of the wrapped CardResource.
func get_card_name() -> String:
	if card_resource:
		# CardResource.card_name is an @export var String
		return card_resource.card_name
	printerr("CardInZone.get_card_name: Attempted to get name from a null card_resource for instance_id: %s" % instance_id)
	return "Unknown Card"


## Returns the cost of the wrapped CardResource.
func get_cost() -> int:
	if card_resource:
		# CardResource.cost is an @export var int
		return card_resource.cost
	printerr("CardInZone.get_cost: Attempted to get cost from a null card_resource for instance_id: %s" % instance_id)
	return -1 # Or some other sensible default for an invalid cost


# --- Utility ---
## Provides a string representation for debugging.
func _to_string() -> String:
	var card_id_str = "null_res"
	if card_resource:
		card_id_str = card_resource.id
	return "CardInZone(instance_id: %s, card_id: %s)" % [instance_id, card_id_str]

## Returns the unique instance ID of this card in the current battle.
func get_card_instance_id() -> int:
	return instance_id
