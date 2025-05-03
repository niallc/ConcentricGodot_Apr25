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
	print("loaded...")
	if json_data == null:
		printerr("Failed to load or parse JSON data from: ", JSON_PATH)
		return
	print("non-null...")

	if not json_data is Array:
		printerr("JSON data is not an Array.")
		return
	print("array...")

	print("Loaded %d card entries from JSON." % json_data.size())

	var created_count = 0
	var updated_count = 0
	var error_count = 0

	# Ensure target directories exist
	ensure_dir_exists(INSTANCE_DIR)
	ensure_dir_exists(EFFECT_SCRIPT_DIR)

	# 2. Process each card entry
	for card_entry in json_data:
		if not validate_card_entry(card_entry):
			printerr("Skipping invalid card entry: ", card_entry)
			error_count += 1
			continue

		var card_id = card_entry["id"]
		# Ensure consistent naming (e.g., lowercase for filenames)
		var filename_base = card_id.to_lower()
		var resource_path = INSTANCE_DIR + filename_base + ".tres"
		var effect_script_path = EFFECT_SCRIPT_DIR + filename_base + "_effect.gd"

		print("Processing Card ID: ", card_id)

		# 3. Determine Resource Type and Base Script
		var card_type = card_entry["type"].to_lower()
		var BaseResourceType = null
		var BaseEffectScript = null # This will hold the preloaded base script

		if card_type == "spell":
			BaseResourceType = SpellCardResource # The class_name for .new()
			BaseEffectScript = SPELL_BASE_RES   # The preloaded .gd script for checking
		elif card_type == "summon":
			BaseResourceType = SummonCardResource
			BaseEffectScript = SUMMON_BASE_RES
		else:
			printerr("Unknown card type '%s' for ID '%s'. Skipping." % [card_type, card_id])
			error_count += 1
			continue

		# 4. Create or Load Resource Instance
		var resource = null
		var is_new = false
		if ResourceLoader.exists(resource_path):
			resource = ResourceLoader.load(resource_path)
			# --- FIX for Type Check ---
			var loaded_script = resource.get_script()
			if loaded_script == null or not loaded_script.is_valid():
				printerr("Existing resource at '%s' has no valid script attached. Skipping update." % resource_path)
				error_count += 1
				continue
			# Use is_subclass_of() to check runtime inheritance against the preloaded base script
			if not loaded_script.is_subclass_of(BaseEffectScript):
				printerr("Existing resource at '%s' script (%s) does not extend expected base (%s). Skipping update." % [resource_path, loaded_script.resource_path, BaseEffectScript.resource_path])
				error_count += 1
				continue
			# --- END FIX ---
			updated_count += 1
			print("...Updating existing resource: ", resource_path)
		else:
			# Use the Class directly for .new() - this is correct
			resource = BaseResourceType.new()
			is_new = true
			created_count += 1
			print("...Creating new resource: ", resource_path)

		# 5. Populate Resource Properties from JSON
		resource.id = card_id
		resource.card_name = card_entry.get("name", card_id) # Default name to ID
		resource.cost = card_entry.get("cost", 0)
		resource.artwork_path = card_entry.get("art", DEFAULT_ART)
		resource.description_template = card_entry.get("description", "No description.")

		if card_type == "summon":
			# Ensure keys exist before accessing, provide defaults
			resource.base_power = card_entry.get("power", 0)
			resource.base_max_hp = card_entry.get("hp", 1)
			resource.tags = card_entry.get("tags", [])
			resource.is_swift = card_entry.get("swift", false)

		# 6. Ensure Effect Script Exists and Link It
		if not FileAccess.file_exists(effect_script_path):
			print("...Effect script not found, creating placeholder: ", effect_script_path)
			create_placeholder_effect_script(effect_script_path, BaseEffectScript.resource_path)

		# Assign the script path to the resource property
		# We load the script resource itself to assign it
		var script_res = load(effect_script_path)
		if script_res:
			resource.script = script_res
		else:
			printerr("...Failed to load effect script resource at: ", effect_script_path)
			error_count += 1
			# Optionally skip saving if script link fails?
			# continue

		# 7. Save the Resource (.tres file)
		var save_result = ResourceSaver.save(resource, resource_path)
		if save_result != OK:
			printerr("...Failed to save resource '%s'. Error code: %d" % [resource_path, save_result])
			error_count += 1
		else:
			if is_new: print("...New resource saved.")
			else: print("...Existing resource updated.")


	print("\nCard Import Finished.")
	print("Created: %d, Updated: %d, Errors: %d" % [created_count, updated_count, error_count])


# --- Helper Functions ---

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
	# Add more checks as needed (e.g., cost is int)
	if not entry.get("cost", 0) is int:
		printerr("Invalid 'cost' (must be int). ID: ", entry.get("id", "N/A"))
		return false
	if entry["type"].to_lower() == "summon":
		if not entry.get("power", 0) is int:
			printerr("Invalid 'power' (must be int). ID: ", entry.get("id", "N/A"))
			return false
		if not entry.get("hp", 1) is int or entry.get("hp", 1) < 1:
			printerr("Invalid 'hp' (must be int >= 1). ID: ", entry.get("id", "N/A"))
			return false
	return true

func ensure_dir_exists(path: String):
	if not DirAccess.dir_exists_absolute(path):
		var dir_access = DirAccess.open("res://") # Open root
		var result = dir_access.make_dir_recursive(path)
		if result != OK:
			printerr("Failed to create directory: ", path, " Error: ", result)
		else:
			print("Created directory: ", path)


func create_placeholder_effect_script(script_path: String, base_script_path: String):
	# Use the base script path directly in extends for reliability
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
	if file == null:
		printerr("Failed to open file for writing placeholder script: ", script_path)
		return

	file.store_string(content)
	file.close()
	print("...Placeholder script created: ", script_path)
