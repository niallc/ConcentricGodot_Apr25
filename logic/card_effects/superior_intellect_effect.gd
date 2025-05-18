# res://logic/card_effects/superior_intellect_effect.gd
extends SpellCardResource

func apply_effect(p_intellect_card_in_zone: CardInZone, active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle):
	var intellect_spell_instance_id: int = p_intellect_card_in_zone.get_card_instance_id()
	var intellect_spell_card_id: String = p_intellect_card_in_zone.get_card_id()

	print("Superior Intellect (Instance: %s) effect." % intellect_spell_instance_id)

	# 1. Move player's graveyard to bottom of their library
	if not active_combatant.graveyard.is_empty():
		print("...Moving %d cards from %s's graveyard to library bottom." % [active_combatant.graveyard.size(), active_combatant.combatant_name])
		
		# Iterate a copy for modification, or iterate backwards if removing one by one
		# If we add to library first, then clear, order is preserved if push_back is used.
		var cards_to_move_from_player_graveyard: Array[CardInZone] = active_combatant.graveyard.duplicate()
		
		for card_in_zone_to_move in cards_to_move_from_player_graveyard:
			var original_gy_instance_id: int = card_in_zone_to_move.get_card_instance_id()
			var card_res_id: String = card_in_zone_to_move.get_card_id()

			# The card_in_zone_to_move object itself is moved. Its instance_id remains the same
			# as it moves from graveyard to library, unless we decide to give it a new one.
			# For simplicity and less ID churn, let's assume it keeps its instance ID.
			# If it needed a new ID in the library, we'd .new(card_resource, new_id_for_lib) here.
			# For now, we move the existing CardInZone object.
			active_combatant.library.push_back(card_in_zone_to_move) 
			
			battle_instance.add_event({
				"event_type": "card_moved",
				"card_id": card_res_id,
				"instance_id": original_gy_instance_id, # ID it had in graveyard
				"player": active_combatant.combatant_name,
				"from_zone": "graveyard",
				"from_details": {"original_instance_id": original_gy_instance_id},
				"to_zone": "library",
				"to_details": {
					"position": "bottom",
					"instance_id": original_gy_instance_id # Assuming it keeps its ID when moving like this
				},
				"reason": "superior_intellect_effect_" + intellect_spell_card_id,
				"source_card_id": intellect_spell_card_id,
				"source_instance_id": intellect_spell_instance_id
			})
		active_combatant.graveyard.clear()

	# 2. Empty opponent's graveyard
	if not opponent_combatant.graveyard.is_empty():
		print("...Emptying %s's graveyard (%d cards)." % [opponent_combatant.combatant_name, opponent_combatant.graveyard.size()])
		
		# Iterate a copy because we are modifying the original by clearing it later (or removing one by one)
		var cards_to_remove_from_opponent_graveyard: Array[CardInZone] = opponent_combatant.graveyard.duplicate()
		
		for card_in_zone_to_remove in cards_to_remove_from_opponent_graveyard:
			battle_instance.add_event({
				"event_type": "card_removed", 
				"card_id": card_in_zone_to_remove.get_card_id(),
				"instance_id": card_in_zone_to_remove.get_card_instance_id(), # ID it had in opponent's graveyard
				"player": opponent_combatant.combatant_name,
				"from_zone": "graveyard",
				"reason": "superior_intellect_effect_" + intellect_spell_card_id,
				"source_card_id": intellect_spell_card_id,
				"source_instance_id": intellect_spell_instance_id
			})
		opponent_combatant.graveyard.clear()

	battle_instance.add_event({
		"event_type": "visual_effect",
		"effect_id": "superior_intellect_cast",
		"target_locations": [active_combatant.combatant_name + " graveyard", active_combatant.combatant_name + " library", opponent_combatant.combatant_name + " graveyard"],
		"details": {},
		"instance_id": intellect_spell_instance_id, 
		"source_card_id": intellect_spell_card_id,
		"source_instance_id": intellect_spell_instance_id
	})
