extends Node

const game_state_type = preload("res://Source/Functionality/game_state.gd")

signal win_triggered()

# Called when the node enters the scene tree for the first time.
func _ready():
	var game_state = game_state_type.get_game_state(get_tree())
	win_triggered.connect(game_state.win_level)
