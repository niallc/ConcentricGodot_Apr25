# In res://scenes/splash_screen.gd
extends Control

const SPLASH_BACKGROUND_LOW_RES_PATH = "res://art/splash_menu_background_med_res.png"
const SPLASH_BACKGROUND_HIGH_RES_PATH = "res://art/splash_background_high_res.jpg"

@onready var background_texture_rect: TextureRect = $Background 

func _on_example_battle_button_pressed():
	print("SplashScreen: Attempting to change scene to battle_launcher.tscn...") # New print
	var scene_load_status = get_tree().change_scene_to_file("res://scenes/battle_launcher.tscn")
	print("SplashScreen: Scene change call completed. Status: ", scene_load_status) # New print, should show 0 for OK

	# Add example decks (from battle_launcher.gd) GameSessionData
	var bl = BattleLauncher.new() 
	bl._load_default_decks_for_testing()
	GameSessionData.player_deck = bl.player_deck_to_load.duplicate() # Duplicate to avoid issues if this scene is revisited
	GameSessionData.opponent_deck = bl.opponent_deck_to_load.duplicate()

	if scene_load_status != OK:
		printerr("Error changing scene to battle_launcher.tscn: ", scene_load_status)

func _on_deck_picker_button_pressed():
	print("SplashScreen: Attempting to change scene to deck_picker.tscn...")
	var scene_load_status = get_tree().change_scene_to_file("res://scenes/deck_picker.tscn") # Corrected path if needed
	print("SplashScreen: Scene change call to deck_picker.tscn completed. Status: ", scene_load_status)

	if scene_load_status != OK:
		printerr("Error changing scene to deck_picker.tscn: ", scene_load_status)

func _ready():
	# Load background: attempt high-res if available
	var bg_texture_to_load_path = SPLASH_BACKGROUND_LOW_RES_PATH

	if ResourceLoader.exists(SPLASH_BACKGROUND_HIGH_RES_PATH):
		var high_res_tex_attempt = load(SPLASH_BACKGROUND_HIGH_RES_PATH)
		if high_res_tex_attempt is Texture2D:
			bg_texture_to_load_path = SPLASH_BACKGROUND_HIGH_RES_PATH
			print("SplashScreen: Using high-resolution background.")
		else:
			printerr("SplashScreen: Found high-res background path '%s', but failed to load as Texture2D. Using low-res." % SPLASH_BACKGROUND_HIGH_RES_PATH)
	
	if is_instance_valid(background_texture_rect):
		var loaded_bg_tex = load(bg_texture_to_load_path)
		if loaded_bg_tex is Texture2D:
			background_texture_rect.texture = loaded_bg_tex
		else:
			printerr("SplashScreen: CRITICAL - Failed to load background texture from: ", bg_texture_to_load_path)
	else:
		printerr("SplashScreen: Background TextureRect node not found at path: ", str(background_texture_rect.get_path()) if background_texture_rect else "INVALID_PATH_OR_NODE")
