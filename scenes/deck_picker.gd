extends Control

# UI Node References - Adjust paths precisely to your scene tree
@onready var available_cards_grid: GridContainer = $MainVBox/ContentVBox/AvailableCardsSection/AvailableCardsVBox/AvailableCardsScroll/AvailableCardsGrid
@onready var player_deck_display: HBoxContainer = $MainVBox/ContentVBox/DeckDisplayVBox/PlayerDeckMC/PlayerDeckVBox/PlayerDeckDisplay
@onready var opponent_deck_display: HBoxContainer = $MainVBox/ContentVBox/DeckDisplayVBox/OpponentDeckPanel/OpponentDeckVBox/OpponentDeckDisplay
@onready var adding_to_label: Label = $MainVBox/ContentVBox/DeckDisplayVBox/TargetSelectionHBox/AddingToLabel
@onready var player_target_button: Button = $MainVBox/ContentVBox/DeckDisplayVBox/TargetSelectionHBox/PlayerTargetButton
@onready var opponent_target_button: Button = $MainVBox/ContentVBox/DeckDisplayVBox/TargetSelectionHBox/OpponentTargetButton
@onready var start_battle_button: Button = $MainVBox/BottomHBox/StartBattleButton


# Preload your card icon scene
const CardIconVisualScene = preload("res://ui/card_icon_visual.tscn")

var player_current_deck: Array[CardResource] = []
var opponent_current_deck: Array[CardResource] = []

enum DeckTarget { PLAYER, OPPONENT }
var current_target_deck = DeckTarget.PLAYER

func _ready():
	_populate_available_cards()
	_update_target_label()
	
func _populate_available_cards():
	# Clear existing (if any)
	if not is_instance_valid(available_cards_grid):
		printerr("DeckPicker: AvailableCardsGrid node not found or invalid.")
		return
	for child in available_cards_grid.get_children():
		child.queue_free()

	if CardDB == null: # Assuming CardDB is your autoloaded Card Database
		printerr("DeckPicker: CardDB is not available.")
		return

	for card_res in CardDB.card_resources.values():
		if card_res is CardResource:
			print("DeckPicker: Populating card - ", card_res.card_name)
			var icon_instance = CardIconVisualScene.instantiate()
			icon_instance.custom_minimum_size = Vector2(100, 140)
			
			# Connect its input signal. Pass the card_res as an extra argument.
			icon_instance.gui_input.connect(_on_available_card_clicked.bind(card_res))
			
			available_cards_grid.add_child(icon_instance)
			
			# Defer the call to update_display until after the node is in the tree and ready
			icon_instance.call_deferred("update_display", card_res) # MODIFIED LINE
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
