# res://scenes/intro_challenge.gd
extends Control

const CardIconVisualScene = preload("res://ui/card_icon_visual.tscn")

@onready var opponent_deck_display: HBoxContainer = $MainVBox/OpponentDeckDisplay
@onready var available_cards_grid: GridContainer = $MainVBox/AvailableCardsGrid
@onready var selected_cards_display: HBoxContainer = $MainVBox/SelectedCardsDisplay
@onready var start_button: Button = $MainVBox/StartChallengeButton

var opponent_deck: Array[CardResource] = []
var available_cards: Array[CardResource] = []
var selected_cards: Array[CardResource] = []

func _ready():
    _load_card_lists()
    _populate_available_cards()
    _update_deck_display(opponent_deck_display, opponent_deck)
    _update_deck_display(selected_cards_display, selected_cards)
    start_button.disabled = true

func _load_card_lists():
    opponent_deck = [
        CardDB.get_card_resource("GoblinWarboss"),
        CardDB.get_card_resource("Unmake")
    ]
    available_cards = [
        CardDB.get_card_resource("Bloodrager"),
        CardDB.get_card_resource("Flamewielder"),
        CardDB.get_card_resource("AscendingProtoplasm"),
        CardDB.get_card_resource("Pikemen"),
        CardDB.get_card_resource("TauntingElf")
    ]

func _populate_available_cards():
    for child in available_cards_grid.get_children():
        child.queue_free()
    for card_res in available_cards:
        var icon_instance = CardIconVisualScene.instantiate()
        icon_instance.custom_minimum_size = Vector2(80, 112)
        icon_instance.gui_input.connect(_on_available_card_clicked.bind(card_res))
        available_cards_grid.add_child(icon_instance)
        icon_instance.call_deferred("update_display", card_res)

func _on_available_card_clicked(event: InputEvent, card_res: CardResource):
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
        if selected_cards.has(card_res):
            selected_cards.erase(card_res)
        elif selected_cards.size() < 2:
            selected_cards.append(card_res)
        _update_deck_display(selected_cards_display, selected_cards)
        start_button.disabled = selected_cards.size() != 2
        get_viewport().set_input_as_handled()

func _update_deck_display(display_container: HBoxContainer, deck_array: Array[CardResource]):
    for child in display_container.get_children():
        child.queue_free()
    for card_res in deck_array:
        var icon_instance = CardIconVisualScene.instantiate()
        icon_instance.custom_minimum_size = Vector2(60, 84)
        display_container.add_child(icon_instance)
        icon_instance.call_deferred("update_display", card_res)

func _on_start_challenge_button_pressed():
    GameSessionData.player_deck = selected_cards.duplicate()
    GameSessionData.opponent_deck = opponent_deck.duplicate()
    get_tree().change_scene_to_file("res://scenes/battle_launcher.tscn")
