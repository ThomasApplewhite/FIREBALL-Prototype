extends Node

@export
var spell_body : CharacterBody2D

@export
var spell_speed = 10.0

var is_launched = false;
	
func _physics_process(delta):
	if is_launched:
		_move_spell_body(delta)

func launch():
	is_launched = true

func _move_spell_body(delta):
	spell_body.velocity = spell_body.global_transform.x * spell_speed
	spell_body.move_and_slide()
