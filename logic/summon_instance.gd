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

# --- Calculation Methods (Implement modifier logic here later) ---
func get_current_power() -> int:
	var calculated_power = base_power
	# TODO: Apply power_modifiers
	# for mod in power_modifiers: calculated_power += mod["value"]
	return max(0, calculated_power)

func get_current_max_hp() -> int:
	var calculated_max_hp = base_max_hp
	# TODO: Apply max_hp_modifiers
	# for mod in max_hp_modifiers: calculated_max_hp += mod["value"]
	return max(0, calculated_max_hp)

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
func take_damage(amount: int, source = null):
	if amount <= 0: return # Taking 0 or negative damage does nothing
	var hp_decrement = max(0, amount)
	var hp_before = current_hp
	current_hp -= hp_decrement
	print("%s takes %d damage. Now %d/%d" % [card_resource.card_name, hp_decrement, current_hp, get_current_max_hp()])

	# Generate creature_hp_change event
	battle_instance.add_event({
		"event_type": "creature_hp_change",
		"player": owner_combatant.combatant_name,
		"lane": lane_index + 1, # 1-based for events
		"amount": -hp_decrement, # Negative for damage
		"new_hp": current_hp,
		"new_max_hp": get_current_max_hp()
		# TODO: Add source info if available/needed
	})

	if current_hp <= 0:
		die()

func heal(amount: int):
	# if amount <= 0: return
	var heal_increase = max(0, amount)
	var max_hp = get_current_max_hp()
	var hp_before = current_hp
	current_hp = min(current_hp + heal_increase, max_hp)

	if current_hp > hp_before: # Only generate event if HP actually changed
		print("%s heals %d HP. Now %d/%d" % [card_resource.card_name, heal_increase, current_hp, max_hp])
		# Generate creature_hp_change event
		battle_instance.add_event({
			"event_type": "creature_hp_change",
			"player": owner_combatant.combatant_name,
			"lane": lane_index + 1, # 1-based for events
			"amount": current_hp - hp_before, # Positive for heal
			"new_hp": current_hp,
			"new_max_hp": max_hp
		})


func die():
	print("%s dies!" % card_resource.card_name)
	# Generate creature_defeated event *before* removing from lane
	battle_instance.add_event({
		"event_type": "creature_defeated",
		"player": owner_combatant.combatant_name,
		"lane": lane_index + 1 # 1-based for events
	})

	# Call _on_death effect script *before* graveyard/removal if it exists
	if script_instance != null and script_instance.has_method("_on_death"):
		script_instance._on_death(self, owner_combatant, opponent_combatant, battle_instance)

	# Remove instance from lane (owner's perspective)
	owner_combatant.remove_summon_from_lane(lane_index)
	# Add the card *resource* to graveyard
	owner_combatant.add_card_to_graveyard(card_resource, "lane") # "lane" indicates where it died from

# --- Turn Activity Logic (Implemented) ---
func perform_turn_activity():
	var activity_type = "none" # Default if no action taken
	var opposing_instance = opponent_combatant.lanes[lane_index]

	# Check if card effect script overrides the default activity
	if script_instance != null and script_instance.has_method("perform_turn_activity_override"):
		if script_instance.perform_turn_activity_override(self, owner_combatant, opponent_combatant, battle_instance):
			# If override returns true, it handled everything (including event generation)
			return

	# Determine target: Opponent directly or opposing creature?
	if is_relentless or opposing_instance == null:
		activity_type = "direct_attack"
		_perform_direct_attack()
	else:
		activity_type = "attack"
		_perform_combat(opposing_instance)

	# Generate the base activity event (specific damage events generated by helpers)
	if activity_type != "none":
		battle_instance.add_event({
			"event_type": "summon_turn_activity",
			"player": owner_combatant.combatant_name,
			"lane": lane_index + 1, # 1-based
			"activity_type": activity_type
		})

func _perform_direct_attack():
	var damage = max(0, get_current_power())
	#if damage <= 0:
		#print("%s attempts direct attack but has 0 power." % card_resource.card_name)
		#return

	print("%s attacks opponent directly for %d damage" % [card_resource.card_name, damage])
	var target_player_hp_before = opponent_combatant.current_hp
	var defeated = opponent_combatant.take_damage(damage, self) # take_damage generates hp_change

	# Generate direct_damage event (provides context for the hp_change)
	battle_instance.add_event({
		"event_type": "direct_damage",
		"attacking_player": owner_combatant.combatant_name,
		"attacking_lane": lane_index + 1,
		"target_player": opponent_combatant.combatant_name,
		"amount": damage,
		"target_player_remaining_hp": opponent_combatant.current_hp
	})

	# Check if game ended immediately after damage
	battle_instance.check_game_over()

func _perform_combat(target_instance):
	var damage = max(0, get_current_power())

	print("%s attacks %s for %d damage" % [card_resource.card_name, target_instance.card_resource.card_name, damage])
	var target_hp_before = target_instance.current_hp
	target_instance.take_damage(damage, self) # take_damage generates creature_hp_change

	# Generate combat_damage event (provides context)
	battle_instance.add_event({
		"event_type": "combat_damage",
		"attacking_player": owner_combatant.combatant_name,
		"attacking_lane": lane_index + 1,
		"defending_player": target_instance.owner_combatant.combatant_name,
		"defending_lane": target_instance.lane_index + 1,
		"amount": damage,
		"defender_remaining_hp": target_instance.current_hp # HP after damage
	})

	# Note: 'take_damage' on the target handles calling 'die' if HP <= 0


# --- Upkeep (as before, TODO needed for modifiers) ---
func _end_of_turn_upkeep():
	is_newly_arrived = false # Reset flag
	# TODO: Process modifiers (decrement duration, remove expired)
	# TODO: Generate events if stats change due to expiration
	# Make sure to recalculate/clamp current_hp if max_hp changes
	pass

# --- Modifier Methods (Placeholders - Implement later) ---
func add_power(amount: int, source_id: String = "unknown", duration: int = -1):
	print("%s gets %d power from %s" % [card_resource.card_name, amount, source_id])
	# TODO: Add to power_modifiers array
	# TODO: Generate stat_change event with NEW calculated power
	pass

func add_hp(amount: int, source_id: String = "unknown", duration: int = -1):
	print("%s gets %d max HP from %s" % [card_resource.card_name, amount, source_id])
	# TODO: Add to max_hp_modifiers array
	# TODO: heal(amount) # Increase current HP too
	# TODO: Generate stat_change (max_hp) event
	# TODO: Generate creature_hp_change event (already done by heal if HP increased)
	pass

func add_counter(amount: int, source_id: String = "unknown", duration: int = -1):
	add_power(amount, source_id, duration)
	add_hp(amount, source_id, duration)
