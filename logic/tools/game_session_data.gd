# res://logic/tools/game_session_data.gd
extends Node

var player_deck: Array[CardResource] = []
var opponent_deck: Array[CardResource] = []

func reset_decks():
	player_deck.clear()
	opponent_deck.clear()
