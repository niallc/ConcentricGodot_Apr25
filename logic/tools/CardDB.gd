# CardDB.gd (Autoload Singleton)
extends Node

var card_resources: Dictionary = {}

func _ready():
	var dir = DirAccess.open("res://data/cards/instances")
	if dir == null:
		printerr("Failed to open instances directory!")
		return
	
	# Get all files in the directory
	var files = []
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir():
			files.append(file_name)
		file_name = dir.get_next()
	dir.list_dir_end()
	
	print("Files found in instances directory: ", files)
	
	# Process each file
	for file in files:
		var resource_path = ""
		
		# Handle both .remap files (exported) and original .tres files (development)
		if file.ends_with(".tres.remap"):
			# In exported builds, strip the .remap suffix to get the original path
			resource_path = "res://data/cards/instances/" + file.trim_suffix(".remap")
		elif file.ends_with(".tres"):
			# In development builds, use the file directly
			resource_path = "res://data/cards/instances/" + file
		else:
			# Skip non-resource files
			continue
		
		print("Loading resource: ", resource_path)
		
		# Use ResourceLoader.load() which handles remapping automatically
		var card_res = ResourceLoader.load(resource_path) as CardResource
		if card_res and card_res.id != "UNKNOWN_CARD":
			card_resources[card_res.id] = card_res
			print("Successfully loaded card: ", card_res.id)
		else:
			printerr("Failed to load or invalid CardResource: ", resource_path)
	
	print("CardDB loaded %d card resources." % card_resources.size())

func get_card_resource(card_id: String) -> CardResource:
	return card_resources.get(card_id, null)
