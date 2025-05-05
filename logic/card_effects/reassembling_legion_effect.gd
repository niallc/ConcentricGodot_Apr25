extends SummonCardResource

# Immortal effect - return to deck on death
func _on_death(summon_instance: SummonInstance, active_combatant, _opponent_combatant, battle_instance):
	print("Reassembling Legion death trigger! Returning to deck.")
	# Add a new instance to the *bottom* of the owner's library
	var card_to_return = summon_instance.card_resource
	if card_to_return != null:
		active_combatant.library.push_back(card_to_return)
		# Generate card_moved event (lane -> library)
		battle_instance.add_event({
			"event_type": "card_moved",
			"card_id": card_to_return.id,
			"player": active_combatant.combatant_name,
			"from_zone": "lane", # Died from lane
			"to_zone": "library",
			"to_details": {"position": "bottom"}
		}) # card_moved event
		# Set flag to prevent die() adding to graveyard
		summon_instance.custom_state["prevent_graveyard"] = true
