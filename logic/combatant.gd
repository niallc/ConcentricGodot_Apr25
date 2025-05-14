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
func take_damage(amount: int, _source = null) -> bool: # Returns true if defeated
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
		"instance_id": combatant_name
		# TODO: Add source info?
	})

	if defeated:
		print("%s defeated!" % combatant_name)
		# Check game over state in Battle after this returns
	return defeated

func heal(amount: int):
	var heal_increment = max(0, amount)
	var hp_before = current_hp
	current_hp = min(current_hp + heal_increment, max_hp)

	if current_hp > hp_before: # Only generate event if HP changed
		print("%s heals %d HP. Now %d/%d" % [combatant_name, heal_increment, current_hp, max_hp])
		# Generate hp_change event
		battle_instance.add_event({
			"event_type": "hp_change",
			"player": combatant_name,
			"amount": current_hp - hp_before, # Positive for heal
			"new_total": current_hp,
			"instance_id": "None, player heal"
		})

func gain_mana(amount: int, source_card_id_for_event: String, p_source_instance_id_for_event: int):
	var mana_add = max(0, amount)
	var old_mana = mana
	mana = min(mana + mana_add, Constants.MAX_MANA)
	if mana > old_mana:
		print("%s gains %d mana. Total: %d. Source: %s, SourceInstance: %s" % [combatant_name, mana - old_mana, mana, source_card_id_for_event, str(p_source_instance_id_for_event)])
		var event_data = {
			"event_type": "mana_change",
			"player": combatant_name,
			"amount": mana - old_mana,
			"new_total": mana,
			"source": source_card_id_for_event # Card ID of the effect, or "turn_start"
			# instance_id here refers to the combatant (player) whose mana changed, which is implicitly "player" field.
			# No, for mana_change, the "instance_id" field as per spec was unclear.
			# Let's assume "instance_id" is NOT for the player, but for a card instance if relevant.
			# For a direct player mana change not tied to a card instance acting, it can be omitted or null.
		}
		if p_source_instance_id_for_event != -1:
			event_data["source_instance_id"] = p_source_instance_id_for_event
			# If mana gain is from a card effect, the primary "instance_id" of this mana_change
			# event could also be this source_instance_id, as it's the card causing the direct effect.
			# This is a point of convention.
			# Let's try setting instance_id if a source_instance_id is provided.
			event_data["instance_id"] = p_source_instance_id_for_event
		else:
			# If it's just turn_start mana, no specific card instance is the subject.
			# Perhaps use a convention like player's name or a special value if needed.
			# For now, let's assume it might be null if not tied to a specific card instance acting.
			# Your spec has "instance_id": combatant_name for turn_start mana_change, which works for that case.
			event_data["instance_id"] = combatant_name # For turn start / non-specific card source

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

# Option A: Change signature to accept CardInZone
func add_card_to_graveyard(card_in_zone_obj: CardInZone, from_zone: String, p_instance_id_if_relevant = -1): # p_instance_id_if_relevant is the ID of the card AS IT WAS in the from_zone
	if not card_in_zone_obj is CardInZone or not card_in_zone_obj.card_resource:
		printerr("Attempted to add null or invalid CardInZone to graveyard.")
		return
	
	print("Adding CardInZone (instance: %s, card_id: %s) to %s's graveyard from %s" % [card_in_zone_obj.instance_id, card_in_zone_obj.get_card_id(), combatant_name, from_zone])
	graveyard.push_back(card_in_zone_obj)

	var event_instance_id = card_in_zone_obj.instance_id
	if p_instance_id_if_relevant != -1: # If an ID from the "from_zone" was provided (e.g. a summon's ID)
		event_instance_id = p_instance_id_if_relevant


	battle_instance.add_event({
		"event_type": "card_moved",
		"card_id": card_in_zone_obj.get_card_id(), # Get card_id from the CardInZone
		"player": combatant_name,
		"from_zone": from_zone,
		"to_zone": "graveyard",
		"instance_id": event_instance_id # Use the instance_id of the object that MOVED
										 # If it was a summon, p_instance_id_if_relevant should be that summon's ID.
										 # The card_in_zone_obj itself will have a NEW id for its state in the graveyard.
										 # For the event, we log the ID of the item as it was known in the "from_zone".
	})

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

func lose_mana(amount: int, source_id: String = "unknown"):
	if amount <= 0: return
	var mana_lost = min(amount, mana) # Can't lose more than you have
	if mana_lost > 0:
		mana -= mana_lost
		print("%s loses %d mana from %s. Remaining: %d" % [combatant_name, mana_lost, source_id, mana])
		# Generate mana_change event
		battle_instance.add_event({
			"event_type": "mana_change",
			"player": combatant_name,
			"amount": -mana_lost, # Negative for loss
			"new_total": mana,
			"source": source_id # Optional source tracking
		})

func mill_top_card(reason: String = "unknown"):
	if not library.is_empty():
		var milled_card_in_zone_obj = remove_card_from_library() # Returns CardInZone
		if milled_card_in_zone_obj is CardInZone and milled_card_in_zone_obj.card_resource: # Check if valid
			print("%s mills CardInZone (instance: %s, card_id: %s) from top of library." % [combatant_name, milled_card_in_zone_obj.instance_id, milled_card_in_zone_obj.get_card_id()])
			# Pass the CardInZone object to add_card_to_graveyard
			# The instance_id for the 'card_moved' event within add_card_to_graveyard will be milled_card_in_zone_obj.instance_id
			add_card_to_graveyard(milled_card_in_zone_obj, "library_top_" + reason, milled_card_in_zone_obj.instance_id) 
		else:
			printerr("Combatant.mill_top_card: remove_card_from_library returned invalid object.")
	else:
		print("%s library empty, cannot mill." % combatant_name)
		battle_instance.add_event({
			"event_type": "log_message",
			"message": "%s tried to mill top card but library was empty." % combatant_name
		})
