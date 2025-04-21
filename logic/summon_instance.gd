# res://logic/summon_instance.gd
extends Object
class_name SummonInstance

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
var script_instance = null # Reference to card effect script
var custom_state: Dictionary = {}

func get_current_power() -> int:
	var calculated_power = base_power
	# TODO: Apply power_modifiers
	return max(0, calculated_power)

func get_current_max_hp() -> int:
	var calculated_max_hp = base_max_hp
	# TODO: Apply max_hp_modifiers
	return max(1, calculated_max_hp)

func setup(card_res: SummonCardResource, owner: Combatant, opp: Combatant, lane_idx: int, battle: Battle):
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
	self.is_relentless = false # Default, can be set by effects/tags
	self.is_newly_arrived = true

	if card_res.script != null:
		self.script_instance = card_res.script.new() # Instantiate the effect script

	print("Setup SummonInstance for %s in lane %d" % [card_res.card_name, lane_index])

func take_damage(amount: int, source = null):
	print("%s takes %d damage" % [card_resource.card_name, amount])
	current_hp -= amount
	# TODO: Generate creature_hp_change event
	if current_hp <= 0:
		die()

func heal(amount: int):
	var max_hp = get_current_max_hp()
	current_hp = min(current_hp + amount, max_hp)
	print("%s heals %d HP. Now %d/%d" % [card_resource.card_name, amount, current_hp, max_hp])
	# TODO: Generate creature_hp_change event

func add_power(amount: int, source_id: String = "unknown", duration: int = -1):
	print("%s gets %d power from %s" % [card_resource.card_name, amount, source_id])
	power_modifiers.append({"source": source_id, "value": amount, "duration": duration})
	# TODO: Generate stat_change event (with NEW calculated power)

func add_hp(amount: int, source_id: String = "unknown", duration: int = -1):
	print("%s gets %d max HP from %s" % [card_resource.card_name, amount, source_id])
	max_hp_modifiers.append({"source": source_id, "value": amount, "duration": duration})
	var old_hp = current_hp
	current_hp += amount # Also heal current HP
	current_hp = min(current_hp, get_current_max_hp()) # Clamp to new max
	# TODO: Generate stat_change (max_hp) event
	# TODO: Generate creature_hp_change event if old_hp != current_hp

func add_counter(amount: int, source_id: String = "unknown", duration: int = -1):
	add_power(amount, source_id, duration)
	add_hp(amount, source_id, duration)

func perform_turn_activity():
	print("%s performs turn activity..." % card_resource.card_name)
	# TODO: Generate summon_turn_activity event
	# TODO: Check card script override: if script_instance and script_instance.perform_turn_activity_override(...): return
	# TODO: Check is_relentless or if opponent lane is empty
	# TODO: Call _perform_direct_attack() or _perform_combat()

func _perform_direct_attack():
	print("...attacks opponent directly for %d damage" % get_current_power())
	var defeated = opponent_combatant.take_damage(get_current_power(), self)
	# TODO: Generate direct_damage event
	# TODO: Check if opponent defeated, potentially end game via battle_instance state

func _perform_combat():
	var target_instance = opponent_combatant.lanes[lane_index]
	if target_instance != null:
		print("...attacks %s for %d damage" % [target_instance.card_resource.card_name, get_current_power()])
		target_instance.take_damage(get_current_power(), self)
		# TODO: Generate combat_damage event
	else:
		print("...finds no target in opposing lane.")


func die():
	print("%s dies!" % card_resource.card_name)
	# TODO: Generate creature_defeated event
	# TODO: Call script_instance._on_death(...) if script_instance exists
	owner_combatant.remove_summon_from_lane(lane_index)
	owner_combatant.add_card_to_graveyard(card_resource, "lane") # Add card *resource* to grave

func _end_of_turn_upkeep():
	print("Upkeep for %s" % card_resource.card_name)
	is_newly_arrived = false # Reset flag
	# TODO: Process modifiers (decrement duration, remove expired)
	# TODO: Generate events if stats change due to expiration
