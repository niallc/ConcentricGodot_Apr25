# res://logic/tools/card_importer_tool.gd
@tool # IMPORTANT! Makes the script run in the editor
extends EditorScript # Use EditorScript for batch processing

# --- Configuration ---
const JSON_PATH = "res://data/cards/card_data.json"
const INSTANCE_DIR = "res://data/cards/instances/"
const EFFECT_SCRIPT_DIR = "res://logic/card_effects/"
const DEFAULT_ART = "res://art/default_card.png" # Fallback art

# Base resource paths (adjust if needed)
# Preload the base scripts to check inheritance against
const SPELL_BASE_RES = preload("res://logic/cards/spell_card.gd")
const SUMMON_BASE_RES = preload("res://logic/cards/summon_card.gd")


# --- Main Execution Logic ---
func _run():
	print("Starting Card Import Tool...")

	# 1. Load JSON data
	var json_data = load_json_data(JSON_PATH)
	if json_data == null:
		printerr("Halting: Failed to load or parse JSON data from: ", JSON_PATH)
		return # Halt on JSON load/parse error
	if not json_data is Array:
		printerr("Halting: JSON data is not an Array.")
		return # Halt if not array

	print("Loaded %d card entries from JSON." % json_data.size())

	var created_count = 0
	var updated_count = 0
	var error_count = 0 # Count validation/save errors

	# Ensure target directories exist
	ensure_dir_exists(INSTANCE_DIR)
	ensure_dir_exists(EFFECT_SCRIPT_DIR)

	# 2. Process each card entry
	for card_entry in json_data:
		# Call validation first
		if not validate_card_entry(card_entry):
			printerr("Halting import due to invalid card entry: ", card_entry)
			# error_count += 1 # Increment error count
			return # Halt execution on first validation error

		var card_id = card_entry["id"]
		# --- FIX: Use snake_case for filenames ---
		var filename_base = card_id.to_snake_case() # e.g., GoblinScout -> goblin_scout
		var resource_path = INSTANCE_DIR + filename_base + ".tres"
		var effect_script_path = EFFECT_SCRIPT_DIR + filename_base + "_effect.gd"

		print("Processing Card ID: %s (Files: %s, %s)" % [card_id, resource_path.get_file(), effect_script_path.get_file()])

		# 3. Determine Resource Type and Base Script
		var card_type = card_entry["type"].to_lower()
		var BaseResourceType = null
		var BaseEffectScript = null
		if card_type == "spell":
			BaseResourceType = SpellCardResource
			BaseEffectScript = SPELL_BASE_RES
		elif card_type == "summon":
			BaseResourceType = SummonCardResource
			BaseEffectScript = SUMMON_BASE_RES
		else:
			# This case should be caught by validation, but check defensively
			printerr("Critical Error: Unknown card type '%s' for ID '%s' after validation. Halting." % [card_type, card_id])
			return

		# 4. Create or Load Resource Instance
		var resource = null
		var is_new = false
		if ResourceLoader.exists(resource_path):
			resource = ResourceLoader.load(resource_path)
			var loaded_script = resource.get_script()
			if loaded_script == null:
				printerr("Halting: Existing resource at '%s' has no valid script attached." % resource_path)
				return
			if not loaded_script.is_subclass_of(BaseEffectScript):
				printerr("Halting: Existing resource at '%s' script (%s) does not extend expected base (%s)." % [resource_path, loaded_script.resource_path, BaseEffectScript.resource_path])
				return
			updated_count += 1
			print("...Updating existing resource: ", resource_path)
		else:
			resource = BaseResourceType.new()
			is_new = true
			created_count += 1
			print("...Creating new resource: ", resource_path)

		# 5. Populate Resource Properties from JSON
		resource.id = card_id
		resource.card_name = card_entry.get("name", card_id)
		resource.cost = int(card_entry.get("cost", 0)) # Cast to int
		resource.artwork_path = card_entry.get("art", DEFAULT_ART)
		resource.description_template = card_entry.get("description", "No description.")

		if card_type == "summon":
			resource.base_power = int(card_entry.get("power", 0)) # Cast to int
			resource.base_max_hp = int(card_entry.get("hp", 1)) # Cast to int

			# --- FIX: Assign tags with correct type ---
			var json_tags = card_entry.get("tags", [])
			if json_tags is Array:
				var typed_tags: Array[String] = []
				for tag in json_tags:
					if tag is String:
						typed_tags.append(tag)
					else:
						printerr("Warning: Non-string value found in tags for card '%s': %s. Skipping tag." % [card_id, str(tag)])
				resource.tags = typed_tags # Assign the correctly typed array
			else:
				printerr("Warning: Invalid 'tags' format for card '%s'. Expected Array. Setting to empty." % card_id)
				resource.tags = [] # Assign empty typed array
			# --- END FIX ---

			resource.is_swift = card_entry.get("swift", false)

		# 6. Ensure Effect Script Exists and Link It
		if not FileAccess.file_exists(effect_script_path):
			print("...Effect script not found, creating placeholder: ", effect_script_path)
			create_placeholder_effect_script(effect_script_path, BaseEffectScript.resource_path)

		var script_res = load(effect_script_path)
		if script_res:
			resource.script = script_res
		else:
			printerr("Halting: Failed to load effect script resource at: ", effect_script_path)
			return # Halt if script cannot be loaded/linked

		# 7. Save the Resource (.tres file)
		print("...Attempting to save resource...") # Added print before save
		var save_result = ResourceSaver.save(resource, resource_path)
		if save_result != OK:
			printerr("...Failed to save resource '%s'. Error code: %d. Halting." % [resource_path, save_result])
			# error_count += 1 # Not needed if halting
			return # Halt on save error
		else:
			# --- FIX: Correct if/else formatting ---
			if is_new:
				print("...New resource saved successfully.")
			else:
				print("...Existing resource updated successfully.")


	print("\nCard Import Finished Successfully.")
	print("Created: %d, Updated: %d" % [created_count, updated_count]) # Removed error count as we halt


# --- Helper Functions ---
# (load_json_data, validate_card_entry, ensure_dir_exists, create_placeholder_effect_script)
# ... (Include the helper functions from the previous version with the updated validate_card_entry) ...

func load_json_data(path: String):
	if not FileAccess.file_exists(path):
		printerr("JSON file not found at: ", path)
		return null
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		printerr("Failed to open JSON file. Error: ", FileAccess.get_open_error())
		return null
	var content = file.get_as_text()
	file.close()
	var json = JSON.new()
	var error = json.parse(content)
	if error != OK:
		printerr("JSON Parse Error: %s (Line %d)" % [json.get_error_message(), json.get_error_line()])
		return null
	return json.get_data()

func validate_card_entry(entry: Dictionary) -> bool:
	if not entry.has("id") or not entry["id"] is String or entry["id"].is_empty():
		printerr("Missing or invalid 'id'. Entry: ", entry)
		return false
	if not entry.has("type") or not entry["type"] is String or not entry["type"].to_lower() in ["spell", "summon"]:
		printerr("Missing or invalid 'type' (must be 'Spell' or 'Summon'). ID: ", entry.get("id", "N/A"))
		return false
	var cost_val = entry.get("cost", 0)
	if not (cost_val is int or cost_val is float):
		printerr("Invalid 'cost' (must be number). ID: ", entry.get("id", "N/A"))
		return false
	if cost_val < 0:
		printerr("Invalid 'cost' (must be non-negative). ID: ", entry.get("id", "N/A"))
		return false
	if entry["type"].to_lower() == "summon":
		var power_val = entry.get("power", 0)
		if not (power_val is int or power_val is float):
			printerr("Invalid 'power' (must be number). ID: ", entry.get("id", "N/A"))
			return false
		var hp_val = entry.get("hp", 1)
		if not (hp_val is int or hp_val is float):
			printerr("Invalid 'hp' (must be number). ID: ", entry.get("id", "N/A"))
			return false
		if hp_val < 1:
			printerr("Invalid 'hp' (must be >= 1). ID: ", entry.get("id", "N/A"))
			return false
		if entry.has("tags") and not entry["tags"] is Array:
			printerr("Invalid 'tags' (must be array). ID: ", entry.get("id", "N/A"))
			return false
		if entry.has("swift") and not entry["swift"] is bool:
			printerr("Invalid 'swift' (must be boolean). ID: ", entry.get("id", "N/A"))
			return false
	return true

func ensure_dir_exists(path: String):
	if not DirAccess.dir_exists_absolute(path):
		var dir_access = DirAccess.open("res://")
		var result = dir_access.make_dir_recursive(path)
		if result != OK: printerr("Failed to create directory: ", path, " Error: ", result)
		else: print("Created directory: ", path)

func create_placeholder_effect_script(script_path: String, base_script_path: String):
	var content = """# %s (Auto-generated placeholder)
extends "%s"

# Add card-specific logic by overriding methods like:
# func apply_effect(source_card_res, active_combatant, _opponent_combatant, battle_instance): pass
# func can_play(active_combatant, opponent_combatant, _turn_count, _battle_instance) -> bool: return true
# func _on_arrival(summon_instance, active_combatant, _opponent_combatant, battle_instance): pass
# func _on_death(summon_instance, active_combatant, opponent_combatant, battle_instance): pass
# func perform_turn_activity_override(summon_instance, active_combatant, opponent_combatant, battle_instance) -> bool: return false

pass
""" % [script_path.get_file(), base_script_path]
	var file = FileAccess.open(script_path, FileAccess.WRITE)
	if file == null: printerr("Failed to open file for writing placeholder script: ", script_path); return
	file.store_string(content)
	file.close()
	print("...Placeholder script created: ", script_path)
