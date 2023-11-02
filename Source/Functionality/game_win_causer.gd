extends Node


signal win_triggered()


# Called when the node enters the scene tree for the first time.
func _ready():
	var game_state = GameState.get_game_state(get_tree())
	win_triggered.connect(game_state.complete_level.bind(true))
