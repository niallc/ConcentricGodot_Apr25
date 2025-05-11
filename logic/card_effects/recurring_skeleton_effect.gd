extends SummonCardResource

# Override _on_death to return to deck instead of graveyard
func _on_death(summon_instance: SummonInstance, active_combatant, _opponent_combatant, _battle_instance):
	print("Recurring Skeleton death trigger! Returning to deck.")
	# IMPORTANT: We need to prevent the default graveyard addition.
	# The base die() method adds to graveyard AFTER calling _on_death.
	# We can achieve this by having die() check a return value from _on_death,
	# OR by adding the card back to library here and removing it from graveyard after die() finishes.
	# Let's try the second approach for now, it's less invasive to die().

	# Add a new instance to the *bottom* of the owner's library
	# We use the card_resource from the dying instance
	var card_to_return = summon_instance.card_resource
	if card_to_return != null:
		active_combatant.library.push_back(card_to_return)
		# Generate card_moved event (lane -> library)
		_battle_instance.add_event({
			"event_type": "card_moved",
			"card_id": card_to_return.id,
			"player": active_combatant.combatant_name,
			"from_zone": "lane", # Died from lane
			"to_zone": "library",
			"to_details": {"position": "bottom"},
			"instance_id": "None, card returning to library"
		})
		# We also need to ensure it's removed from the graveyard where die() put it.
		# Add a flag to the instance maybe? Or handle in Battle logic?
		# Let's add a flag for simplicity for now.
		summon_instance.custom_state["prevent_graveyard"] = true
