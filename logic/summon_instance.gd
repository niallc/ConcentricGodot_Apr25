# res://logic/summon_instance.gd
extends Object
class_name SummonInstance

# --- Properties (as defined before) ---
var card_resource: SummonCardResource
var owner_combatant: Combatant
var opponent_combatant: Combatant
var battle_instance: Battle
var lane_index: int = -1
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
func setup(card_res: SummonCardResource, owner, opp, lane_idx: int, battle):
	self.card_resource = card_res
	self.owner_combatant = owner
	self.opponent_combatant = opp
	self.battle_instance = battle
	self.lane_index = lane_idx
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


# --- Damage & Death (with Event Generation) ---
func take_damage(amount: int, _source = null):
	var hp_decrement = max(0, amount) # Use max(0,...) based on our previous discussion
	current_hp -= hp_decrement
	print("%s takes %d damage. Now %d/%d HP" % [card_resource.card_name, hp_decrement, current_hp, get_current_max_hp()])

	# Generate creature_hp_change event
	battle_instance.add_event({
		"event_type": "creature_hp_change",
		"player": owner_combatant.combatant_name,
		"lane": lane_index + 1,
		"amount": -hp_decrement, # Use the actual decrement
		"new_hp": current_hp,
		"new_max_hp": get_current_max_hp()
	})

	if current_hp <= 0:
		die()

func heal(amount: int):
	var heal_increment = max(0, amount) # Use max(0,...)

	var max_hp = get_current_max_hp()
	var hp_before = current_hp
	current_hp = min(current_hp + heal_increment, max_hp)

	if current_hp > hp_before:
		print("... Actual heal: %d HP. Now %d/%d HP" % [current_hp - hp_before, current_hp, get_current_max_hp()])
		print("%s heals %d HP. Now %d/%d" % [card_resource.card_name, current_hp - hp_before, current_hp, max_hp])
		battle_instance.add_event({
			"event_type": "creature_hp_change",
			"player": owner_combatant.combatant_name,
			"lane": lane_index + 1,
			"amount": current_hp - hp_before, # Actual amount healed
			"new_hp": current_hp,
			"new_max_hp": max_hp
		})

func die():
	print("%s dies!" % card_resource.card_name)
	battle_instance.add_event({})

	battle_instance.add_event({
		"event_type": "creature_defeated",
		"player": owner_combatant.combatant_name,
		"lane": lane_index + 1 # 1-based for events
		# Optional: Add card_id if needed by replay?
		# "card_id": card_resource.id
	})

	var prevent_graveyard = false # Flag to check
	var replaced_in_lane = false # Introduced for CursedSamurai

	if custom_state.has("prevent_graveyard"):
		prevent_graveyard = custom_state["prevent_graveyard"]
		custom_state.erase("prevent_graveyard") # Clear the flag

	# Call _on_death effect script *before* graveyard/removal
	if card_resource != null and card_resource.has_method("_on_death"):
		card_resource._on_death(self, owner_combatant, opponent_combatant, battle_instance)
		# Re-check flag in case _on_death changed it (unlikely but possible)
		if custom_state.has("prevent_graveyard"):
			prevent_graveyard = custom_state["prevent_graveyard"]
			custom_state.erase("prevent_graveyard")

	# Cursed Samurai handles its own lane update, so don't do anything else here.
	if custom_state.has("replaced_in_lane"):
		replaced_in_lane = custom_state["replaced_in_lane"]
	if not replaced_in_lane:
		owner_combatant.remove_summon_from_lane(lane_index)

	# Add the card *resource* to graveyard ONLY if not prevented
	if not prevent_graveyard:
		owner_combatant.add_card_to_graveyard(card_resource, "lane")

# --- Turn Activity Logic ---
func perform_turn_activity():
	# ... (uses get_current_power() indirectly via helpers) ...
	var activity_type = "none"
	var opposing_instance = opponent_combatant.lanes[lane_index]
	if script_instance != null and script_instance.has_method("perform_turn_activity_override"):
		if script_instance.perform_turn_activity_override(self, owner_combatant, opponent_combatant, battle_instance):
			return
	if is_relentless or opposing_instance == null:
		activity_type = "direct_attack"
		_perform_direct_attack()
	else:
		activity_type = "attack"
		_perform_combat(opposing_instance)
	if activity_type != "none":
		battle_instance.add_event({
			"event_type": "summon_turn_activity",
			"player": owner_combatant.combatant_name,
			"lane": lane_index + 1,
			"activity_type": activity_type
		})

func _perform_direct_attack():
	var bonus_damage = 0
	if card_resource != null and card_resource.has_method("_get_direct_attack_bonus_damage"):
		bonus_damage = card_resource._get_direct_attack_bonus_damage(self)
	var damage = max(0, get_current_power() + bonus_damage)
	print("%s attacks opponent directly for %d damage" % [card_resource.card_name, damage])

	var _target_player_hp_before = opponent_combatant.current_hp
	# take_damage generates hp_change event for the combatant
	var _defeated = opponent_combatant.take_damage(damage, self)
	# Generate direct_damage event (provides context for the hp_change)
	battle_instance.add_event({
		"event_type": "direct_damage",
		"attacking_player": owner_combatant.combatant_name,
		"attacking_lane": lane_index + 1,
		"target_player": opponent_combatant.combatant_name,
		"amount": damage,
		"target_player_remaining_hp": opponent_combatant.current_hp
	}) # direct_damage event

	var sacrificed_by_effect = false
	if card_resource != null and card_resource.has_method("_on_deal_direct_damage"):
		# This method might sacrifice the creature (e.g., Sarcophagus)
		# It should return true if it sacrificed the instance
		sacrificed_by_effect = card_resource._on_deal_direct_damage(self, opponent_combatant, battle_instance)

	# --- Check for Glassgraft sacrifice ---
	if not sacrificed_by_effect and custom_state.get("glassgrafted", false):
		print("...Glassgrafted creature dealt damage, sacrificing!")
		custom_state.erase("glassgrafted") # Remove flag
		die() # Sacrifice self
		sacrificed_by_effect = true # Mark as sacrificed

	# Only check game over if not sacrificed by an effect this turn
	if not sacrificed_by_effect:
		battle_instance.check_game_over()

func _perform_combat(target_instance):
	var damage = max(0, get_current_power()) # Use calculated power
	print("%s attacks %s for %d damage" % [card_resource.card_name, target_instance.card_resource.card_name, damage])
	var target_hp_before = target_instance.current_hp
	target_instance.take_damage(damage, self)
	battle_instance.add_event({
		"event_type": "combat_damage",
		"attacking_player": owner_combatant.combatant_name,
		"attacking_lane": lane_index + 1,
		"defending_player": target_instance.owner_combatant.combatant_name,
		"defending_lane": target_instance.lane_index + 1,
		"amount": damage,
		"defender_remaining_hp": target_instance.current_hp
	})
	# --- NEW: Check if target died and trigger kill effect ---
	if target_instance.current_hp <= 0 and target_hp_before > 0: # Check if this attack caused death
		print("...%s killed %s!" % [self.card_resource.card_name, target_instance.card_resource.card_name])
		# Call the killer's _on_kill_target method if it exists
		if self.card_resource != null and self.card_resource.has_method("_on_kill_target"):
			self.card_resource._on_kill_target(self, target_instance, battle_instance)
	# --- END NEW ---

	# Note: 'take_damage' on the target handles calling 'die' if HP <= 0


# --- Modifier Methods (Implemented) ---
func add_power(amount: int, source_id: String = "unknown", duration: int = -1):
	# Add the modifier to the list
	var modifier = {"source": source_id, "value": amount, "duration": duration}
	power_modifiers.append(modifier)
	print("%s gets %d power from %s. Now %d/%d HP, %d Power (Modifier added: %s)" % [card_resource.card_name, amount, source_id, current_hp, get_current_max_hp(), get_current_power(), modifier])

	# Generate stat_change event with the *new* calculated power
	battle_instance.add_event({
		"event_type": "stat_change",
		"player": owner_combatant.combatant_name,
		"lane": lane_index + 1,
		"stat": "power",
		"amount": amount, # The change amount
		"new_value": get_current_power() # The resulting value after change
	})

func add_hp(amount: int, source_id: String = "unknown", duration: int = -1):
	# Add the modifier to the list
	var modifier = {"source": source_id, "value": amount, "duration": duration}
	max_hp_modifiers.append(modifier)
	print("%s gets %d max HP from %s. Now %d/%d HP, %d Power (Modifier added: %s)" % [card_resource.card_name, amount, source_id, current_hp, get_current_max_hp(), get_current_power(), modifier])

	# Generate stat_change event for max_hp
	var new_max_hp = get_current_max_hp()
	battle_instance.add_event({
		"event_type": "stat_change",
		"player": owner_combatant.combatant_name,
		"lane": lane_index + 1,
		"stat": "max_hp",
		"amount": amount, # The change amount
		"new_value": new_max_hp # The resulting value
	})

	# Also increase current HP by the same amount (heal effect)
	# Call heal, which handles clamping and generating the creature_hp_change event
	heal(amount)


func add_counter(amount: int, source_id: String = "unknown", duration: int = -1):
	# Call add_power and add_hp which now handle adding modifiers and events
	add_power(amount, source_id, duration)
	add_hp(amount, source_id, duration)

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
				"stat": "power",
				"amount": final_power - power_before_upkeep, # Net change
				"new_value": final_power,
				"source": "expiration" # Indicate cause
			})
		if final_max_hp != max_hp_before_upkeep:
			battle_instance.add_event({
				"event_type": "stat_change",
				"player": owner_combatant.combatant_name,
				"lane": lane_index + 1,
				"stat": "max_hp",
				"amount": final_max_hp - max_hp_before_upkeep, # Net change
				"new_value": final_max_hp,
				"source": "expiration"
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
				"source": "expiration_clamp" # Indicate cause
			})
