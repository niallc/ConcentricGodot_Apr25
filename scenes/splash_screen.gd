extends Control

func _on_example_battle_button_pressed():
	print("SplashScreen: Attempting to change scene to placeholder_root_node_2d.tscn...") # New print
	var scene_load_status = get_tree().change_scene_to_file("res://scenes/battle_launcher.tscn")
	print("SplashScreen: Scene change call completed. Status: ", scene_load_status) # New print, should show 0 for OK

	if scene_load_status != OK:
		printerr("Error changing scene to battle_launcher.tscn: ", scene_load_status)

# You can add more button handler functions here later, like:
# func _on_deck_picker_button_pressed():
#     get_tree().change_scene_to_file("res://scenes/deck_picker_scene.tscn") # Assuming you create this
