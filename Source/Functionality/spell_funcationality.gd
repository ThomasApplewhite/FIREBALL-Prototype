extends Node

@export
var spell_mover : Node
@export
var spell_damage : Node

signal spell_launched

func launch(initial_move_direction : Vector2):
	spell_mover.launch(initial_move_direction)
	spell_launched.emit()


func set_speed(new_speed : float):
	spell_mover.spell_speed = new_speed


func set_damage(new_damage : float):
	spell_damage.damage = new_damage
