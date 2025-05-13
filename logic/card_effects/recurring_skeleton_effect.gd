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
	var dying_card_resource = summon_instance.card_resource
	var dying_summon_instance_id = summon_instance.instance_id # ID of the skeleton that died
	var skeleton_card_id = summon_instance.card_resource.id # e.g., "RecurringSkeleton"
	var skeleton_effect_source_instance_id = summon_instance.instance_id # The skeleton itself is the source of this effect

	if dying_card_resource != null:
		# 1. Create a new CardInZone for the library representation.
		#    This new CardInZone gets its own new instance_id.
		var new_instance_id_for_library = _battle_instance._generate_new_card_instance_id()
		var card_in_zone_for_library = CardInZone.new(dying_card_resource, new_instance_id_for_library)
		
		# 2. Add the CardInZone object to the library
		active_combatant.library.push_back(card_in_zone_for_library)

		# Generate card_moved event (lane -> library)
		_battle_instance.add_event({
			"event_type": "card_moved",
			"card_id": skeleton_card_id,
			"player": active_combatant.combatant_name,
			"from_zone": "lane",
			"from_details": {
				"lane": summon_instance.lane_index + 1, # Lane it died in
				"instance_id": dying_summon_instance_id
			},
			"to_zone": "library",
			"to_details": {
				"position": "bottom",
				"instance_id": new_instance_id_for_library # The new ID in the library
			},
			# Main instance_id of the event: the ID of the entity as it was in the from_zone.
			"instance_id": dying_summon_instance_id, 
			"reason": "death_effect_" + skeleton_card_id,
			"source_instance_id": skeleton_effect_source_instance_id # The skeleton caused its own return
		})
		
		# Prevent the default die() behavior from adding it to the graveyard
		summon_instance.custom_state["prevent_graveyard"] = true
	else:
		printerr("RecurringSkeleton _on_death: Dying instance has no card_resource!")
