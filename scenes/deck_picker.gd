extends Control

# UI Node References - Adjust paths precisely to your scene tree
@onready var available_cards_grid: GridContainer = $MainVBox/ContentVBox/AvailableCardsSection/AvailableCardsVBox/AvailableCardsScroll/AvailableCardsGrid
@onready var player_deck_display: HBoxContainer = $MainVBox/ContentVBox/DeckDisplayVBox/PlayerDeckMC/PlayerDeckVBox/PlayerDeckDisplay
@onready var opponent_deck_display: HBoxContainer = $MainVBox/ContentVBox/DeckDisplayVBox/OpponentDeckPanel/OpponentDeckVBox/OpponentDeckDisplay
@onready var adding_to_label: Label = $MainVBox/ContentVBox/DeckDisplayVBox/TargetSelectionHBox/AddingToLabel
@onready var player_target_button: Button = $MainVBox/ContentVBox/DeckDisplayVBox/TargetSelectionHBox/PlayerTargetButton
@onready var opponent_target_button: Button = $MainVBox/ContentVBox/DeckDisplayVBox/TargetSelectionHBox/OpponentTargetButton
@onready var start_battle_button: Button = $MainVBox/BottomHBox/StartBattleButton
@onready var background_texture_rect: TextureRect = $Background 

const DECK_PICKER_BACKGROUND_LOW_RES_PATH = "res://art/deck_picker_background_low_res.png"
const DECK_PICKER_BACKGROUND_HIGH_RES_PATH = "res://art/deck_picker_background_high_res.png"

# Preload your card icon scene
const CardIconVisualScene = preload("res://ui/card_icon_visual.tscn")
const CARD_COLUMN_COUNT = 6

var player_current_deck: Array[CardResource] = []
var opponent_current_deck: Array[CardResource] = []

enum DeckTarget { PLAYER, OPPONENT }
var current_target_deck = DeckTarget.PLAYER

# In res://scenes/deck_picker.gd

# ... (const CardIconVisualScene, CARD_COLUMN_COUNT, etc.) ...

func _populate_available_cards():
	if not is_instance_valid(available_cards_grid):
		printerr("DeckPicker: AvailableCardsGrid node not found or invalid.")
		return
	for child in available_cards_grid.get_children():
		child.queue_free()

	if CardDB == null:
		printerr("DeckPicker: CardDB is not available.")
		return

	# The ratio is width / height for AspectRatioContainer.
	var card_aspect_ratio: float = 80.0 / 80.0 

	print("DeckPicker: Populating cards. Target aspect ratio: ", card_aspect_ratio)

	for card_res in CardDB.card_resources.values():
		if card_res is CardResource:
			# 1. Create the AspectRatioContainer
			var aspect_container = AspectRatioContainer.new()
			aspect_container.ratio = card_aspect_ratio
			# Make the AspectRatioContainer itself expand to fill the grid cell's width
			aspect_container.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL
			# Allow it to also take vertical space given by the grid row
			aspect_container.size_flags_vertical = Control.SIZE_EXPAND | Control.SIZE_FILL 
			# Stretch child to fill the AspectRatioContainer
			aspect_container.stretch_mode = AspectRatioContainer.STRETCH_WIDTH_CONTROLS_HEIGHT # Or STRETCH_HEIGHT_CONTROLS_WIDTH depending on control

			# 2. Create the CardIconVisual instance
			var icon_instance = CardIconVisualScene.instantiate()
			# The CardIconVisual should fill the AspectRatioContainer
			icon_instance.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL
			icon_instance.size_flags_vertical = Control.SIZE_EXPAND | Control.SIZE_FILL
			# Its custom_minimum_size will now act as a minimum *within* the AspectRatioContainer.
			# If the AspectRatioContainer becomes very small, this will prevent the icon from vanishing.
			icon_instance.custom_minimum_size = Vector2(100, 140) # Keep this or your desired minimum display size

			icon_instance.gui_input.connect(_on_available_card_clicked.bind(card_res))
			
			# 3. Add CardIconVisual as a child of AspectRatioContainer
			aspect_container.add_child(icon_instance)
			
			# 4. Add AspectRatioContainer to the grid
			available_cards_grid.add_child(aspect_container)
			
			# 5. Defer update_display for the icon_instance
			icon_instance.call_deferred("update_display", card_res)
			# Optional: Defer the debug print for the icon instance
			icon_instance.call_deferred("print_layout_info_debug")
			
			
func _on_available_card_clicked(event: InputEvent, card_resource: CardResource):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		# No deck limits as per your request for testing
		if current_target_deck == DeckTarget.PLAYER:
			player_current_deck.append(card_resource)
			_update_deck_display(player_deck_display, player_current_deck)
		elif current_target_deck == DeckTarget.OPPONENT:
			opponent_current_deck.append(card_resource)
			_update_deck_display(opponent_deck_display, opponent_current_deck)
		
		get_viewport().set_input_as_handled() # Consume the click

func _update_deck_display(display_container: HBoxContainer, deck_array: Array[CardResource]):
	if not is_instance_valid(display_container):
		printerr("DeckPicker: Display container for deck is invalid.")
		return
		
	# Clear existing display
	for child in display_container.get_children():
		child.queue_free()
	
	for card_res in deck_array:
		var icon_instance = CardIconVisualScene.instantiate()
		icon_instance.custom_minimum_size = Vector2(60, 84) # Smaller for deck list
		
		# Optional: Add ability to click to remove from here too
		# icon_instance.gui_input.connect(_on_selected_card_clicked.bind(card_res, display_container, deck_array))
		
		display_container.add_child(icon_instance)
		
		# Defer the call to update_display until after the node is in the tree and ready
		icon_instance.call_deferred("update_display", card_res)
		
func _on_player_target_button_pressed():
	current_target_deck = DeckTarget.PLAYER
	_update_target_label()

func _on_opponent_target_button_pressed():
	current_target_deck = DeckTarget.OPPONENT
	_update_target_label()

func _update_target_label():
	if not is_instance_valid(adding_to_label):
		return
	if current_target_deck == DeckTarget.PLAYER:
		adding_to_label.text = "Adding to: Player"
	else:
		adding_to_label.text = "Adding to: Opponent"

func _on_start_battle_button_pressed():
	# For testing, allow empty decks if you prefer, or add checks:
	# if player_current_deck.is_empty() or opponent_current_deck.is_empty():
	#	printerr("DeckPicker: Both decks must have at least one card.")
	#	# Maybe show a popup or label to the user
	#	return

	# Assuming GameSessionData is your autoload
	if GameSessionData == null:
		printerr("DeckPicker: GameSessionData autoload not found.")
		return
		
	GameSessionData.player_deck = player_current_deck.duplicate() # Duplicate to avoid issues if this scene is revisited
	GameSessionData.opponent_deck = opponent_current_deck.duplicate()
	
	# Transition to the battle launcher scene
	var status = get_tree().change_scene_to_file("res://scenes/battle_launcher.tscn")
	if status != OK:
		printerr("DeckPicker: Failed to change scene to battle_launcher. Error: ", status)

func _load_background_texture():
	var bg_texture_to_load_path = DECK_PICKER_BACKGROUND_LOW_RES_PATH
	if ResourceLoader.exists(DECK_PICKER_BACKGROUND_HIGH_RES_PATH):
		var high_res_tex_attempt = load(DECK_PICKER_BACKGROUND_HIGH_RES_PATH)
		if high_res_tex_attempt is Texture2D:
			bg_texture_to_load_path = DECK_PICKER_BACKGROUND_HIGH_RES_PATH
			print("DeckPicker: Using high-resolution background.")
		else:
			printerr("DeckPicker: Found high-res background path '%s', but failed to load as Texture2D. Using low-res." % DECK_PICKER_BACKGROUND_HIGH_RES_PATH)

	if is_instance_valid(background_texture_rect):
		var loaded_bg_tex = load(bg_texture_to_load_path)
		if loaded_bg_tex is Texture2D:
			background_texture_rect.texture = loaded_bg_tex
		else:
			printerr("DeckPicker: CRITICAL - Failed to load background texture from: ", bg_texture_to_load_path)
	else:
		var bgpath = "INVALID_PATH_OR_NODE"
		if background_texture_rect.get_path():
			bgpath = background_texture_rect
		printerr("DeckPicker: Background TextureRect node not found at path: ", bgpath)


func _ready():
	_load_background_texture() # Call new function
	_populate_available_cards()
	_update_target_label()
	if is_instance_valid(available_cards_grid):
		available_cards_grid.columns = CARD_COLUMN_COUNT
