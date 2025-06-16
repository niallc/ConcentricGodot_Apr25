# CardDB.gd (Autoload Singleton)
extends Node

var card_resources: Dictionary = {}

func _ready():
	var dir = DirAccess.open("res://data/cards/instances")
	if dir == null:
		printerr("Failed to open instances directory!")
	else:
		var contents = []
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			contents.append(file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
		print("Files found in instances directory: ", contents)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			print("*", file_name)
			if dir.current_is_dir():
				pass # Skip directories
			#elif file_name.ends_with(".tres") or file_name.ends_with(".tres.remap"):
			elif file_name.ends_with(".tres"):
				var card_res_path = "res://data/cards/instances/" + file_name
				var card_res = load(card_res_path) as CardResource
				if card_res and card_res.id != "UNKNOWN_CARD": # Ensure it's a valid card resource with an ID
					card_resources[card_res.id] = card_res
				else:
					printerr("Failed to load or invalid CardResource: ", card_res_path)
			file_name = dir.get_next()
	else:
		printerr("Could not open card instances directory!")
	print("CardDB loaded %d card resources." % card_resources.size())

func get_card_resource(card_id: String) -> CardResource:
	return card_resources.get(card_id, null)
