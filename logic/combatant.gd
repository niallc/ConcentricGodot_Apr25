# res://logic/combatant.gd
extends Object
class_name Combatant

# --- Properties (as before) ---
var combatant_name: String = "Default Combatant"
var max_hp: int = Constants.STARTING_HP
var current_hp: int = Constants.STARTING_HP
var mana: int = Constants.STARTING_MANA
var library: Array[CardInZone] = []
var graveyard: Array[CardInZone] = []
var lanes: Array = []
var battle_instance # Battle
var opponent # Combatant

func _init():
	lanes.resize(Constants.LANE_COUNT)
	lanes.fill(null)

func setup(deck_res: Array[CardResource], start_hp: int, c_name: String, battle_ref: Battle, opp_ref): # Added Battle type hint
	# self.library = deck_res.duplicate() # Old line
	self.library.clear() # Ensure library is empty before populating
	for card_res in deck_res:
		if card_res is CardResource:
			var new_instance_id = battle_ref._generate_new_card_instance_id() # Get ID from battle
			var card_in_zone_obj = CardInZone.new(card_res, new_instance_id)
			self.library.append(card_in_zone_obj)
		else:
			printerr("Combatant.setup: Invalid item in deck_res, not a CardResource.")

	self.max_hp = start_hp
	self.current_hp = start_hp
	self.combatant_name = c_name
	self.battle_instance = battle_ref
	self.opponent = opp_ref
	self.mana = Constants.STARTING_MANA
	print("%s setup complete. Deck size: %d" % [combatant_name, library.size()])

	# Add initial library state event after setup here or in Battle.run_battle()
	# Battle.run_battle() already adds an "initial_library_state" event [cite: 93]
	# That event currently logs card_ids. It will need to be updated later
	# to log instance_ids if the replay needs to track specific instances in the library from the start.
	# For now, the existing event is okay.

# --- Methods with Event Generation ---
func take_damage(amount: int, p_source_card_id_for_event: String, p_source_instance_id_for_event: int) -> bool: # Returns true if defeated
	#if amount <= 0: return false
	var hp_decrement = max(0, amount)
	current_hp -= hp_decrement
	var defeated = false
	if current_hp <= 0:
		current_hp = 0
		defeated = true

	print("%s takes %d damage. Now %d/%d" % [combatant_name, hp_decrement, current_hp, max_hp])
	# Generate hp_change event
	battle_instance.add_event({
		"event_type": "hp_change",
		"player": combatant_name,
		"amount": -hp_decrement, # Negative for damage
		"new_total": current_hp,
		"source_card_id": p_source_card_id_for_event,
		"source_instance_id": p_source_instance_id_for_event,
		"instance_id": -1
		# TODO: Add source info?
	})

	if defeated:
		print("%s defeated!" % combatant_name)
		# Check game over state in Battle after this returns
	return defeated

func heal(amount: int, p_source_card_id: String = "unknown_heal_source", p_source_instance_id: int = -1):
	var heal_increment = max(0, amount)
	if heal_increment == 0:
		return

	var hp_before_heal = current_hp
	current_hp = min(current_hp + heal_increment, max_hp)

	if current_hp > hp_before_heal:
		print("%s heals %d HP from %s (Instance: %s). Now %d/%d" % [combatant_name, current_hp - hp_before_heal, p_source_card_id, str(p_source_instance_id), current_hp, max_hp])
		
		var event_data = {
			"event_type": "hp_change",
			"player": combatant_name, # Identifies the combatant being healed
			"amount": current_hp - hp_before_heal,
			"new_total": current_hp,
			"source_card_id": p_source_card_id # Card ID of the source of healing
		}
		
		# If a specific card instance caused this heal
		if p_source_instance_id != -1:
			event_data["source_instance_id"] = p_source_instance_id
			# The "instance_id" of the event could be the Nap spell instance.
			event_data["instance_id"] = p_source_instance_id 
		else:
			# If heal is generic (e.g., a game rule, or not from a specific card instance)
			event_data["instance_id"] = -1 # No specific card instance is the primary subject.
		
		battle_instance.add_event(event_data)

func gain_mana(amount: int, source_card_id_for_event: String, p_source_instance_id_for_event: int):
	var mana_add = max(0, amount)
	var old_mana = mana
	mana = min(mana + mana_add, Constants.MAX_MANA)
	if mana > old_mana:
		print("%s gains %d mana. Total: %d. Source: %s, SourceInstance: %s" % [combatant_name, mana - old_mana, mana, source_card_id_for_event, str(p_source_instance_id_for_event)])
		
		var event_data = {
			"event_type": "mana_change",
			"player": combatant_name, # Clearly identifies the player affected
			"amount": mana - old_mana,
			"new_total": mana,
			"source_card_id": source_card_id_for_event # e.g., "Focus" or "turn_start"
		}

		# If a specific card instance caused this mana gain (e.g., ability of a summon, or a played spell)
		if p_source_instance_id_for_event != -1:
			event_data["source_instance_id"] = p_source_instance_id_for_event
			# For "mana_change" caused by a specific card, the "instance_id" of the event
			# could be this source_instance_id, making that card the primary subject of this specific change.
			event_data["instance_id"] = p_source_instance_id_for_event
		else:
			# If mana gain is generic (e.g., turn_start), there's no specific *card instance*
			# that is the subject of the "instance_id" field.
			# Using -1 or null is appropriate here for the instance_id field.
			# Your spec previously had "instance_id": combatant_name for this case.
			# Let's use -1 to keep instance_id numeric if present, or null if the field can be omitted.
			# For now, aligning with a numeric -1 if the field must exist:
			event_data["instance_id"] = -1 # Or event_data["instance_id"] = null if you allow missing keys / null values more freely.
											# Using -1 is a common "invalid/none" for integer IDs.
		
		battle_instance.add_event(event_data)

func pay_mana(amount: int) -> bool:
	if mana >= amount:
		mana -= amount
		print("%s pays %d mana. Remaining: %d" % [combatant_name, amount, mana])
		# Generate mana_change event
		battle_instance.add_event({
			"event_type": "mana_change",
			"player": combatant_name,
			"amount": -amount, # Negative for cost
			"new_total": mana,
			"instance_id": combatant_name
		})
		return true
	return false

func add_card_to_graveyard(
	p_card_in_zone_for_graveyard: CardInZone, 
	p_from_zone: String, 
	p_instance_id_from_origin_zone: int = -1, 
	p_cause_source_card_id: String = "",     # Parameter for the ultimate cause's card_id
	p_cause_source_instance_id: int = -1     # Parameter for the ultimate cause's instance_id
):
	if not p_card_in_zone_for_graveyard is CardInZone or not p_card_in_zone_for_graveyard.card_resource:
		printerr("%s.add_card_to_graveyard: Attempted to add null or invalid CardInZone." % combatant_name)
		return
	
	var card_res_id_for_event: String = p_card_in_zone_for_graveyard.get_card_id()
	var new_graveyard_ciz_instance_id: int = p_card_in_zone_for_graveyard.get_card_instance_id()
	var event_main_instance_id: int = p_instance_id_from_origin_zone
	if p_instance_id_from_origin_zone == -1:
		# If it's moving from a zone where it was already this CardInZone (e.g., library -> graveyard, play -> graveyard for a spell)
		# then its current ID is the one from the origin zone.
		event_main_instance_id = new_graveyard_ciz_instance_id 
		if p_from_zone == "lane": # Should always have p_instance_id_from_origin_zone if from lane
			printerr("WARNING: Card moved from 'lane' to 'graveyard' without p_instance_id_from_origin_zone. Using new GY ID for event.")

	graveyard.push_back(p_card_in_zone_for_graveyard)

	var event_data = {
		"event_type": "card_moved",
		"card_id": card_res_id_for_event,
		"player": combatant_name,
		"from_zone": p_from_zone,
		"instance_id": event_main_instance_id, 
		"to_zone": "graveyard",
		"to_details": { "instance_id": new_graveyard_ciz_instance_id },
		"reason": p_from_zone # Or a more detailed reason if passed in
	}

	# Add source information if provided by the caller (the ultimate cause)
	if p_cause_source_card_id != "":
		event_data["source_card_id"] = p_cause_source_card_id
	if p_cause_source_instance_id != -1:
		event_data["source_instance_id"] = p_cause_source_instance_id

	battle_instance.add_event(event_data)
	
func remove_card_from_library() -> CardInZone: # Return type changed
	if not library.is_empty():
		var card_in_zone_obj = library.pop_front() # Returns CardInZone
		if card_in_zone_obj is CardInZone and card_in_zone_obj.card_resource:
			print("Removing CardInZone (instance: %s, card_id: %s) from %s's library top" % [card_in_zone_obj.instance_id, card_in_zone_obj.get_card_id(), combatant_name])
			battle_instance.add_event({
				"event_type": "card_moved",
				"card_id": card_in_zone_obj.get_card_id(),
				"player": combatant_name,
				"from_zone": "library",
				"to_zone": "play", 
				"instance_id": card_in_zone_obj.instance_id # <<< NOW USES THE INSTANCE ID
			})
			return card_in_zone_obj
		else:
			printerr("Combatant.remove_card_from_library: Popped invalid object from library.")
			return null
	return null

# --- Rest of methods (find_first_empty_lane, place_summon_in_lane, remove_summon_from_lane) as before ---
func find_first_empty_lane() -> int:
	return lanes.find(null) # Returns index or -1

func place_summon_in_lane(summon_instance, lane_index: int):
	if lane_index >= 0 and lane_index < Constants.LANE_COUNT and lanes[lane_index] == null:
		lanes[lane_index] = summon_instance
		print("Placed summon in %s's lane %d" % [combatant_name, lane_index])
		# summon_arrives event generated by Battle logic after placement
	else:
		printerr("Failed to place summon in %s's lane %d" % [combatant_name, lane_index])

func remove_summon_from_lane(lane_index: int):
	if lane_index >= 0 and lane_index < Constants.LANE_COUNT and lanes[lane_index] != null:
		print("Removing summon from %s's lane %d" % [combatant_name, lane_index])
		lanes[lane_index] = null
	else:
		printerr("Failed to remove summon from %s's lane %d" % [combatant_name, lane_index])

func lose_mana(amount: int, p_source_card_id: String, p_source_instance_id: int):
	if amount <= 0:
		return
	
	var actual_mana_lost = min(amount, mana) # Can't lose more than you have
	if actual_mana_lost > 0:
		mana -= actual_mana_lost
		print("%s loses %d mana from %s (Instance: %s). Remaining: %d" % [combatant_name, actual_mana_lost, p_source_card_id, str(p_source_instance_id), mana])
		
		var event_data = {
			"event_type": "mana_change",
			"player": combatant_name,
			"amount": -actual_mana_lost, # Negative for loss
			"new_total": mana,
			"source_card_id": p_source_card_id,
			"source_instance_id": p_source_instance_id,
			"instance_id": p_source_instance_id
		}
		
		battle_instance.add_event(event_data)

# Updated signature to accept the ultimate source of the mill
func mill_top_card(p_mill_reason_card_id: String, p_mill_reason_instance_id: int):
	if not library.is_empty():
		# This call to remove_card_from_library() will generate a card_moved event:
		# { from_zone: "library", to_zone: "play", instance_id: ID_of_card_from_lib }
		# This event does NOT yet know about the Vandal as its ultimate source unless remove_card_from_library is also changed.
		# For now, let's accept this event as is for the lib->play step.
		var milled_card_in_zone_obj: CardInZone = remove_card_from_library() 
		
		if milled_card_in_zone_obj != null and milled_card_in_zone_obj.card_resource != null:
			print("%s mills CardInZone (Instance: %s, CardID: %s) via %s (Instance: %s)." % [
				combatant_name, 
				milled_card_in_zone_obj.get_card_instance_id(), 
				milled_card_in_zone_obj.get_card_id(),
				p_mill_reason_card_id,
				str(p_mill_reason_instance_id)
			])

			# Now, add it to graveyard, coming from the conceptual "play" zone.
			# Pass the original mill reason as the source for the event generated by add_card_to_graveyard.
			# Signature: add_card_to_graveyard(p_card_in_zone_for_graveyard, p_from_zone, p_instance_id_from_origin_zone, 
			#                                p_cause_source_card_id, p_cause_source_instance_id)
			add_card_to_graveyard(
				milled_card_in_zone_obj, 
				"play", # Explicitly state it's moving from "play" (where remove_card_from_library put it)
				milled_card_in_zone_obj.get_card_instance_id(), # Its ID as it was in "play"
				p_mill_reason_card_id,      # Source card of the mill action
				p_mill_reason_instance_id   # Source instance of the mill action
			)
		else:
			printerr("%s.mill_top_card: remove_card_from_library returned null or invalid CardInZone." % combatant_name)
	else:
		print("%s library empty, cannot mill (Reason: %s, SourceInstance: %s)." % [combatant_name, p_mill_reason_card_id, str(p_mill_reason_instance_id)])
		battle_instance.add_event({
			"event_type": "log_message",
			"message": "%s tried to mill top card but library was empty." % combatant_name,
			"source_card_id": p_mill_reason_card_id,
			"source_instance_id": p_mill_reason_instance_id,
			"instance_id": -1 # Event about the combatant/library state
		})
