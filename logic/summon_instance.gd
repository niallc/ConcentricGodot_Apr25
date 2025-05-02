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
	self.is_relentless = false # Default, can be set by effects/tags
	self.is_newly_arrived = true

	if card_res.script != null:
		self.script_instance = card_res.script.new() # Instantiate the effect script

	print("Setup SummonInstance for %s in lane %d" % [card_res.card_name, lane_index])


# --- Damage & Death (with Event Generation) ---
func take_damage(amount: int, _source = null):
	var hp_decrement = max(0, amount) # Use max(0,...) based on our previous discussion
	current_hp -= hp_decrement
	print("%s takes %d damage. Now %d/%d" % [card_resource.card_name, hp_decrement, current_hp, get_current_max_hp()])

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
	battle_instance.add_event({
		"event_type": "creature_defeated",
		"player": owner_combatant.combatant_name,
		"lane": lane_index + 1
	})
	if script_instance != null and script_instance.has_method("_on_death"):
		script_instance._on_death(self, owner_combatant, opponent_combatant, battle_instance)
	owner_combatant.remove_summon_from_lane(lane_index)
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
	var damage = max(0, get_current_power()) # Use calculated power
	# ... (rest of direct attack logic as before) ...
	print("%s attacks opponent directly for %d damage" % [card_resource.card_name, damage])
	var _defeated = opponent_combatant.take_damage(damage, self)
	battle_instance.add_event({
		"event_type": "direct_damage",
		"attacking_player": owner_combatant.combatant_name,
		"attacking_lane": lane_index + 1,
		"target_player": opponent_combatant.combatant_name,
		"amount": damage,
		"target_player_remaining_hp": opponent_combatant.current_hp
	})
	battle_instance.check_game_over()


func _perform_combat(target_instance):
	var damage = max(0, get_current_power()) # Use calculated power
	print("%s attacks %s for %d damage" % [card_resource.card_name, target_instance.card_resource.card_name, damage])
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

	# Note: 'take_damage' on the target handles calling 'die' if HP <= 0


# --- Modifier Methods (Implemented) ---
func add_power(amount: int, source_id: String = "unknown", duration: int = -1):
	# Add the modifier to the list
	var modifier = {"source": source_id, "value": amount, "duration": duration}
	power_modifiers.append(modifier)
	print("%s gets %d power from %s (Modifier added: %s)" % [card_resource.card_name, amount, source_id, modifier])

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
	print("%s gets %d max HP from %s (Modifier added: %s)" % [card_resource.card_name, amount, source_id, modifier])

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
