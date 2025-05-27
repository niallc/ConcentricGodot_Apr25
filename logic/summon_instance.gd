# res://logic/summon_instance.gd
extends Object
class_name SummonInstance

# --- Properties (as defined before) ---
var card_resource: SummonCardResource
var owner_combatant: Combatant
var opponent_combatant: Combatant
var battle_instance: Battle
var lane_index: int = -1
var instance_id: int = -1 # Unique ID for this instance
var base_power: int = 0
var base_max_hp: int = 1
var current_hp: int = 1
var power_modifiers: Array[Dictionary] = []
var max_hp_modifiers: Array[Dictionary] = []
var tags: Array[String] = []
var is_newly_arrived: bool = true
var is_swift: bool = false
var is_relentless: bool = false
var script_instance = null
var custom_state: Dictionary = {}

func get_current_power() -> int:
	var calculated_power = base_power
	for mod in power_modifiers:
		# Check duration only if it's not permanent (-1)
		if mod["duration"] != 0: # 0 means expired this turn but not yet removed
			calculated_power += mod["value"]
	return max(0, calculated_power)

func get_current_max_hp() -> int:
	var calculated_max_hp = base_max_hp
	for mod in max_hp_modifiers:
		if mod["duration"] != 0:
			calculated_max_hp += mod["value"]
	return max(1, calculated_max_hp)


# --- Setup (as before) ---
func setup(card_res: SummonCardResource, owner, opp, lane_idx: int, battle, new_instance_id: int):
	self.card_resource = card_res
	self.owner_combatant = owner
	self.opponent_combatant = opp
	self.battle_instance = battle
	self.lane_index = lane_idx
	self.instance_id = new_instance_id # 
	self.base_power = card_res.base_power
	self.base_max_hp = card_res.base_max_hp
	self.current_hp = self.base_max_hp
	self.tags = card_res.tags.duplicate()
	self.is_swift = card_res.is_swift
	# TODO: Implement relentless handling once we have a design, e.g., with tags:
	#   self.is_relentless = card_res.tags.has("Relentless")  
	self.is_relentless = self.tags.has("Relentless")
	self.is_newly_arrived = true
	if self.tags.has("Relentless"):
		print("Card has the relentless tag.")
	if card_res.script != null:
		self.script_instance = card_res.script.new() # Instantiate the effect script

	print("Setup SummonInstance for %s in lane %d" % [card_res.card_name, lane_index])


# --- Damage & Death (with Event Generation) for SUMMONS ---
func take_damage(amount: int, p_source_card_id: String, p_source_instance_id: int):
	var hp_decrement = max(0, amount) 
	var old_hp = current_hp # Store old_hp for accurate change amount if clamped
	current_hp -= hp_decrement
	# current_hp = max(0, current_hp) # Ensure HP doesn't go below 0 before die() is called

	print("%s (Instance: %s) takes %d damage from %s (Instance: %s). Now %d/%d HP" % [card_resource.card_name, instance_id, hp_decrement, p_source_card_id, str(p_source_instance_id), current_hp, get_current_max_hp()])

	var event_data = {
		"event_type": "creature_hp_change",
		"player": owner_combatant.combatant_name,
		"lane": lane_index + 1,
		"instance_id": instance_id, # The SummonInstance whose HP is changing
		"card_id": card_resource.id, # The card type of the instance being damaged
		"amount": -hp_decrement, # The actual damage dealt
		"new_hp": current_hp, # HP after damage (can be <=0)
		"new_max_hp": get_current_max_hp(),
		"source_card_id": p_source_card_id # Card ID of the source of damage
	}
	if p_source_instance_id != -1:
		event_data["source_instance_id"] = p_source_instance_id
	
	battle_instance.add_event(event_data)

	if current_hp <= 0 and old_hp > 0: # Only call die if it wasn't already "dead"
		die(p_source_card_id, p_source_instance_id) # Pass the source of damage as cause of death
	elif old_hp < 0:
		printerr("Unexpected Case where creature's HP was already <= 0, intended?")

func heal(amount: int, p_source_card_id: String, p_source_instance_id: int):
	var heal_increment = max(0, amount)
	var max_hp = get_current_max_hp()
	var hp_before = current_hp
	current_hp = min(current_hp + heal_increment, max_hp)

	if current_hp > hp_before:
		print("%s (Instance: %s) heals %d HP from %s (Instance: %s). Now %d/%d" % [card_resource.card_name, instance_id, current_hp - hp_before, p_source_card_id, str(p_source_instance_id), current_hp, max_hp])
		var event_data = {
			"event_type": "creature_hp_change",
			"player": owner_combatant.combatant_name,
			"lane": lane_index + 1,
			"instance_id": instance_id, # The creature being healed
			"card_id": card_resource.id,
			"amount": current_hp - hp_before,
			"new_hp": current_hp,
			"new_max_hp": max_hp,
			"source_card_id": p_source_card_id
		}
		if p_source_instance_id != -1:
			event_data["source_instance_id"] = p_source_instance_id
		battle_instance.add_event(event_data)


# Updated signature to include the cause of death
func die(p_cause_source_card_id: String = "unknown_cause", p_cause_source_instance_id: int = -1):
	print("%s (Instance: %s) dies. Caused by: %s (Instance: %s)" % [card_resource.card_name, instance_id, p_cause_source_card_id, str(p_cause_source_instance_id)])

	var event_data_defeated = {
		"event_type": "creature_defeated",
		"player": owner_combatant.combatant_name,
		"lane": lane_index + 1,
		"card_id": card_resource.id,    # Card type of the defeated summon
		"instance_id": instance_id,     # Instance ID of the defeated summon
	}
	# Add source of death if known (and not just "unknown_cause" from a direct test call perhaps)
	if p_cause_source_card_id != "unknown_cause": # Or a more robust check if needed
		event_data_defeated["source_card_id"] = p_cause_source_card_id
	if p_cause_source_instance_id != -1:
		event_data_defeated["source_instance_id"] = p_cause_source_instance_id
	
	battle_instance.add_event(event_data_defeated)

	var prevent_graveyard = false 
	var replaced_in_lane = false 

	if custom_state.has("prevent_graveyard"):
		prevent_graveyard = custom_state.get("prevent_graveyard", false) # Add default for safety
		custom_state.erase("prevent_graveyard") 

	# Call _on_death effect script (e.g., Recurring Skeleton, Reassembling Legion)
	if card_resource != null and card_resource.has_method("_on_death"):
		# _on_death itself doesn't currently take the cause of death, but it could if needed.
		card_resource._on_death(self, owner_combatant, opponent_combatant, battle_instance)
		if custom_state.has("prevent_graveyard"): # Re-check after _on_death
			prevent_graveyard = custom_state.get("prevent_graveyard", false)
			custom_state.erase("prevent_graveyard")

	if custom_state.has("replaced_in_lane"):
		replaced_in_lane = custom_state.get("replaced_in_lane", false)
	
	if not replaced_in_lane:
		owner_combatant.remove_summon_from_lane(lane_index)
	
	if not prevent_graveyard:
		if card_resource != null:
			var new_graveyard_instance_id = battle_instance._generate_new_card_instance_id()
			var card_for_graveyard = CardInZone.new(card_resource, new_graveyard_instance_id)

			# Pass the cause of death to add_card_to_graveyard so the card_moved event
			# can be sourced to what *caused* the creature to go to the graveyard (i.e., its death cause).
			# Signature: add_card_to_graveyard(ciz, from_zone, origin_id, reason_card_id, reason_instance_id)
			owner_combatant.add_card_to_graveyard(
				card_for_graveyard, 
				"lane",                             # p_from_zone
				self.instance_id,                   # p_instance_id_from_origin_zone (the summon that was in lane)
				p_cause_source_card_id,             # p_reason_card_id (what caused the death)
				p_cause_source_instance_id          # p_reason_instance_id (specific instance that caused death)
			)
		else:
			printerr("SummonInstance (Instance: %s) .die(): card_resource is null. Cannot add to graveyard." % instance_id)
# --- Turn Activity Logic ---
func perform_turn_activity():
	var activity_type = "none" # Determine this first
	var opposing_instance = opponent_combatant.lanes[lane_index]

	# Determine activity_type based on script_override, relentless, or opposing_instance
	var handled_by_override = false
	if script_instance != null and script_instance.has_method("perform_turn_activity_override"):
		# The override itself should generate the summon_turn_activity event if it takes over
		handled_by_override = script_instance.perform_turn_activity_override(self, owner_combatant, opponent_combatant, battle_instance)
		if handled_by_override:
			# Assuming the override added its own 'summon_turn_activity' or similar event.
			return 

	if is_relentless or opposing_instance == null:
		activity_type = "direct_attack"
	else:
		activity_type = "attack"

	# ADD THE EVENT *BEFORE* THE ACTION THAT CAUSES DAMAGE/DEATH
	if activity_type != "none":
		battle_instance.add_event({
			"event_type": "summon_turn_activity",
			"player": owner_combatant.combatant_name,
			"lane": lane_index + 1,
			"instance_id": instance_id,
			"card_id": card_resource.id, # Good to have for the replay
			"activity_type": activity_type
		})

	# NOW PERFORM THE ACTION
	if activity_type == "direct_attack":
		_perform_direct_attack()
	elif activity_type == "attack":
		# We already got opposing_instance
		_perform_combat(opposing_instance)

func _perform_direct_attack():
	var bonus_damage = 0
	if card_resource != null and card_resource.has_method("_get_direct_attack_bonus_damage"):
		bonus_damage = card_resource._get_direct_attack_bonus_damage(self)
	var damage = max(0, get_current_power() + bonus_damage)
	
	print("%s (Instance: %s) attacks opponent %s directly for %d damage" % [card_resource.card_name, instance_id, opponent_combatant.combatant_name, damage])

	# The source of the damage is this SummonInstance itself.
	var source_card_id = self.card_resource.id
	var source_instance_id = self.instance_id
	var _defeated = opponent_combatant.take_damage(damage, source_card_id, source_instance_id)
	
	# Generate direct_damage event
	var event_data = {
		"event_type": "direct_damage",
		"attacking_player": owner_combatant.combatant_name,
		"attacking_lane": lane_index + 1,
		"attacking_card_id": self.card_resource.id, # Good to add attacker's card type
		"attacking_instance_id": self.instance_id, # Good to add attacker's card type
		"instance_id": self.instance_id, # This is the "instance_id" for this event, the attacker.
		"target_player": opponent_combatant.combatant_name,
		"amount": damage,
		"target_player_remaining_hp": opponent_combatant.current_hp,
		# "source_instance_id": self.instance_id # Redundant if attacking_instance_id serves this role
	}
	# The main "instance_id" of a direct_damage event should be the attacker.
	# If we add "source_instance_id", it would be the same as "attacking_instance_id".
	# Let's ensure the spec for direct_damage is clear that `attacking_instance_id` is the key instance here.
	# Your spec already has "attacking_instance_id", which is good.
	# We can add "source_card_id" to it if that was missing from the spec.
	
	battle_instance.add_event(event_data)

	var sacrificed_by_effect = false
	if card_resource != null and card_resource.has_method("_on_deal_direct_damage"):
		sacrificed_by_effect = card_resource._on_deal_direct_damage(self, opponent_combatant, battle_instance)

	if not sacrificed_by_effect and card_resource != null and card_resource.has_method("_on_attack_resolved"):
		card_resource._on_attack_resolved(self, battle_instance)

	if not sacrificed_by_effect and custom_state.get("glassgrafted", false):
		print("...Glassgrafted creature dealt damage, sacrificing!")
		custom_state.erase("glassgrafted") 
		die() 
		# sacrificed_by_effect = true # Not strictly needed if die() is the last thing

	battle_instance.check_game_over()

func _perform_combat(target_instance: SummonInstance):
	var bonus_damage = 0
	if card_resource != null and card_resource.has_method("_get_bonus_combat_damage"):
		bonus_damage = card_resource._get_bonus_combat_damage(self, target_instance)
	var damage = max(0, get_current_power() + bonus_damage)

	print("%s (Instance: %s) attacks %s (Instance: %s) for %d damage (%d base + %d bonus)" % [card_resource.card_name, instance_id, target_instance.card_resource.card_name, target_instance.instance_id, damage, get_current_power(), bonus_damage])
	
	var target_hp_before = target_instance.current_hp
	
	# The source of the damage is this SummonInstance (self).
	var attacking_source_card_id = self.card_resource.id
	var attacking_source_instance_id = self.instance_id
	target_instance.take_damage(damage, attacking_source_card_id, attacking_source_instance_id)

	# The combat_damage event already has attacking_instance_id and defending_instance_id
	# The "source" of the creature_hp_change event (generated within target_instance.take_damage)
	# will correctly be this attacker.
	battle_instance.add_event({
		"event_type": "combat_damage",
		"attacking_player": owner_combatant.combatant_name,
		"attacking_lane": lane_index + 1,
		"attacking_card_id": self.card_resource.id,
		"attacking_instance_id": self.instance_id,
		"instance_id": self.instance_id,
		"defending_player": target_instance.owner_combatant.combatant_name,
		"defending_lane": target_instance.lane_index + 1,
		"defending_card_id": target_instance.card_resource.id, # Good to add
		"defending_instance_id": target_instance.instance_id,
		"amount": damage,
		"defender_remaining_hp": target_instance.current_hp
		# "instance_id" field for combat_damage: This is ambiguous. Having attacking/defending is clearer.
		# If one must be chosen, perhaps the attacker. But spec doesn't demand it if others present.
	})

	if target_instance.current_hp <= 0 and target_hp_before > 0: 
		print("...%s killed %s!" % [self.card_resource.card_name, target_instance.card_resource.card_name])
		if self.card_resource != null and self.card_resource.has_method("_on_kill_target"):
			self.card_resource._on_kill_target(self, target_instance, battle_instance)

	if self.card_resource != null and self.card_resource.has_method("_on_attack_resolved"):
		self.card_resource._on_attack_resolved(self, battle_instance)


func add_power(amount: int, p_source_card_id: String, p_source_instance_id: int, duration: int = -1):
	var modifier = {"source_card_id": p_source_card_id, "value": amount, "duration": duration} # Source here is the Card ID for the modifier dictionary
	power_modifiers.append(modifier)
	print("%s (Instance: %s) gets %d power from %s (Instance: %s). Duration: %s. New Calculated Power: %d" % [card_resource.card_name, instance_id, amount, p_source_card_id, str(p_source_instance_id), str(duration), get_current_power()])

	var event_data = {
		"event_type": "stat_change",
		"player": owner_combatant.combatant_name,
		"lane": lane_index + 1,
		"instance_id": instance_id, # The creature whose stat is changing
		"card_id": card_resource.id, # The type of creature
		"stat": "power",
		"amount": amount, # The modifier value
		"new_value": get_current_power(), # The resulting total value
		"source_card_id": p_source_card_id # Card ID of what granted the modifier
	}
	if p_source_instance_id != -1:
		event_data["source_instance_id"] = p_source_instance_id

	battle_instance.add_event(event_data)

func add_hp(amount: int, p_source_card_id: String, p_source_instance_id: int, duration: int = -1):
	var modifier = {"source_card_id": p_source_card_id, "value": amount, "duration": duration}
	max_hp_modifiers.append(modifier)
	print("%s (Instance: %s) gets %d max HP from %s (Instance: %s). Duration: %s. New Calculated MaxHP: %d" % [card_resource.card_name, instance_id, amount, p_source_card_id, str(p_source_instance_id), str(duration), get_current_max_hp()])

	var new_max_hp = get_current_max_hp()
	var event_data = {
		"event_type": "stat_change",
		"player": owner_combatant.combatant_name,
		"lane": lane_index + 1,
		"instance_id": instance_id, # The creature whose stat is changing
		"card_id": card_resource.id, # The type of creature
		"stat": "max_hp",
		"amount": amount,
		"new_value": new_max_hp,
		"source_card_id": p_source_card_id
	}
	if p_source_instance_id != -1:
		event_data["source_instance_id"] = p_source_instance_id

	battle_instance.add_event(event_data)

	if amount > 0 : # Only heal if max HP increased (or a direct heal effect called add_hp with positive value)
		heal(amount, p_source_card_id, p_source_instance_id) # Pass source info to heal too

	# Also increase current HP by the same amount (heal effect)
	# Call heal, which handles clamping and generating the creature_hp_change event
	heal(amount, p_source_card_id, p_source_instance_id)


func add_counter(amount: int, p_source_card_id: String = "unknown_counter", p_source_instance_id: int = -1, duration: int = -1):
	add_power(amount, p_source_card_id, p_source_instance_id, duration)
	add_hp(amount, p_source_card_id, p_source_instance_id, duration)

func _end_of_turn_upkeep():
	is_newly_arrived = false # Reset flag

	var stats_changed = false
	# Store stats *before* processing expirations
	var power_before_upkeep = get_current_power()
	var max_hp_before_upkeep = get_current_max_hp()

	# --- Process modifier durations ---
	# Iterate backwards because we might remove elements
	# Power Modifiers
	for i in range(power_modifiers.size() - 1, -1, -1):
		var mod = power_modifiers[i]
		if mod["duration"] > 0: # Only decrement timed effects
			mod["duration"] -= 1
			if mod["duration"] == 0:
				print("%s: Power modifier from %s expired." % [card_resource.card_name, mod["source"]])
				power_modifiers.remove_at(i)
				stats_changed = true

	# Max HP Modifiers
	for i in range(max_hp_modifiers.size() - 1, -1, -1):
		var mod = max_hp_modifiers[i]
		if mod["duration"] > 0: # Only decrement timed effects
			mod["duration"] -= 1
			if mod["duration"] == 0:
				print("%s: Max HP modifier from %s expired." % [card_resource.card_name, mod["source"]])
				max_hp_modifiers.remove_at(i)
				stats_changed = true

	# e.g. troll heals at EOT
	card_resource._end_of_turn_upkeep_effect(self, battle_instance)

	# --- Generate events and adjust HP if stats changed ---
	if stats_changed:
		var final_power = get_current_power() # Recalculate after removals
		var final_max_hp = get_current_max_hp() # Recalculate after removals

		print("%s upkeep finished. New Power: %d, New MaxHP: %d" % [card_resource.card_name, final_power, final_max_hp])

		# Generate stat_change events for the *net change* caused by expiration
		if final_power != power_before_upkeep:
			battle_instance.add_event({
				"event_type": "stat_change",
				"player": owner_combatant.combatant_name,
				"lane": lane_index + 1,
				"instance_id": instance_id,
				"stat": "power",
				"amount": final_power - power_before_upkeep, # Net change
				"new_value": final_power,
				"source_card_id": "expiration" # Indicate cause
			})
		if final_max_hp != max_hp_before_upkeep:
			battle_instance.add_event({
				"event_type": "stat_change",
				"player": owner_combatant.combatant_name,
				"lane": lane_index + 1,
				"instance_id": instance_id,
				"stat": "max_hp",
				"amount": final_max_hp - max_hp_before_upkeep, # Net change
				"new_value": final_max_hp,
				"source_card_id": "expiration"
			})

		# Clamp current HP to the potentially new (lower) max HP
		var hp_after_clamp = min(current_hp, final_max_hp)
		if hp_after_clamp < current_hp: # Check if clamping *reduced* HP
			var change_amount = hp_after_clamp - current_hp # Will be negative
			current_hp = hp_after_clamp
			print("...HP clamped to new max HP. Now %d/%d" % [current_hp, final_max_hp])
			# Generate hp change if clamping reduced HP
			battle_instance.add_event({
				"event_type": "creature_hp_change",
				"player": owner_combatant.combatant_name,
				"lane": lane_index + 1,
				"amount": change_amount,
				"new_hp": current_hp,
				"new_max_hp": final_max_hp,
				"source_card_id": "expiration_clamp" # Indicate cause
			})
