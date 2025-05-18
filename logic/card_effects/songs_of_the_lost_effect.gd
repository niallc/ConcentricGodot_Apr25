# res://logic/card_effects/songs_of_the_lost_effect.gd
extends SpellCardResource

func apply_effect(p_songs_card_in_zone: CardInZone, active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle):
	var songs_spell_instance_id: int = p_songs_card_in_zone.get_card_instance_id()
	var songs_spell_card_id: String = p_songs_card_in_zone.get_card_id()

	print("Songs of the Lost (Instance: %s) effect." % songs_spell_instance_id)
	
	var creature_count_in_graveyard: int = 0
	for card_in_zone_obj in active_combatant.graveyard: # Iterate through CardInZone objects
		if card_in_zone_obj.card_resource is SummonCardResource: # Check the wrapped resource
			creature_count_in_graveyard += 1

	if creature_count_in_graveyard > 0:
		var mana_gained_by_player: int = creature_count_in_graveyard * 2
		print("...Songs of the Lost (Instance: %s) causes player to gain %d mana." % [songs_spell_instance_id, mana_gained_by_player])
		# Assumes Combatant.gain_mana signature: (amount, p_source_card_id, p_source_instance_id)
		active_combatant.gain_mana(mana_gained_by_player, songs_spell_card_id, songs_spell_instance_id)

		var mana_lost_by_opponent: int = creature_count_in_graveyard * 1 # Or just creature_count_in_graveyard
		print("...Songs of the Lost (Instance: %s) causes opponent to lose %d mana." % [songs_spell_instance_id, mana_lost_by_opponent])
		# Assumes Combatant.lose_mana signature: (amount, p_source_card_id, p_source_instance_id)
		opponent_combatant.lose_mana(mana_lost_by_opponent, songs_spell_card_id, songs_spell_instance_id)

		battle_instance.add_event({
			"event_type": "visual_effect",
			"effect_id": "songs_of_the_lost_cast",
			"target_locations": [active_combatant.combatant_name, opponent_combatant.combatant_name],
			"details": {
				"creatures_in_graveyard": creature_count_in_graveyard, 
				"mana_gained_player": mana_gained_by_player, 
				"mana_lost_opponent": mana_lost_by_opponent
			},
			"instance_id": songs_spell_instance_id, # The Songs of the Lost spell is the subject/origin
			"source_card_id": songs_spell_card_id,
			"source_instance_id": songs_spell_instance_id
		})
	else:
		print("...Songs of the Lost (Instance: %s) found no creatures in graveyard." % songs_spell_instance_id)
		battle_instance.add_event({
			"event_type": "log_message",
			"message": "Songs of the Lost (Instance: %s) cast, but no creatures in player's graveyard." % songs_spell_instance_id,
			"source_card_id": songs_spell_card_id,
			"source_instance_id": songs_spell_instance_id
		})
