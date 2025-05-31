extends Control

func _on_example_battle_button_pressed():
	# This path should point to the scene that currently sets up and runs your battle replay
	var scene_load_status = get_tree().change_scene_to_file("res://scenes/placeholder_root_node_2d.tscn")
	if scene_load_status != OK:
		printerr("Error changing scene to placeholder_root_node_2d.tscn: ", scene_load_status)

# You can add more button handler functions here later, like:
# func _on_deck_picker_button_pressed():
#     get_tree().change_scene_to_file("res://scenes/deck_picker_scene.tscn") # Assuming you create this
