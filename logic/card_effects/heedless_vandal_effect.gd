extends SummonCardResource

func _on_arrival(_summon_instance: SummonInstance, active_combatant, opponent_combatant, _battle_instance):
	print("Heedless Vandal arrival trigger.")
	# Mill self
	print("...Milling own top card.")
	active_combatant.mill_top_card("heedless_vandal")
	# Mill opponent
	print("...Milling opponent's top card.")
	opponent_combatant.mill_top_card("heedless_vandal")

	# Optional visual effect
	_battle_instance.add_event({
		"event_type": "visual_effect",
		"effect_id": "heedless_vandal_mill",
		"target_locations": [active_combatant.combatant_name + " library", opponent_combatant.combatant_name + " library"],
		"details": {},
		"instance_id": "None, Heedless vandal arrival visual effect."
	}) # visual_effect event
