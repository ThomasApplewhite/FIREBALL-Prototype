extends Node

@export
var spell_mover : Node

signal spell_launched

func launch(initial_move_direction : Vector2):
	spell_mover.launch(initial_move_direction)
	spell_launched.emit()
