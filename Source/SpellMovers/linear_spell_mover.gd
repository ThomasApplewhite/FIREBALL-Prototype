extends Node

@export
var spell_node : Node2D

var spell_speed = 10.0

var move_direction

var is_launched = false;
	
func _physics_process(delta):
	if is_launched:
		_move_spell_body(delta)

func launch(initial_move_direction : Vector2):
	is_launched = true
	move_direction = initial_move_direction
	
	# Reverse the spell direction because up is -Y (and all spells go some degree of up)
	get_parent().global_transform.y = -move_direction
	get_parent().global_transform.x = -move_direction.orthogonal()

func _move_spell_body(delta):
	spell_node.global_position += move_direction * spell_speed * delta
