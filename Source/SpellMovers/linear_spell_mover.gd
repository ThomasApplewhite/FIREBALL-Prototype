extends Node

@export
var spell_body : CharacterBody2D

@export
var spell_speed = 10.0

var is_launched = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if is_launched:
		_move_spell_body(delta)

func launch():
	is_launched = true

func _move_spell_body(delta):
	spell_body.velocity = spell_body.global_transform.x * spell_speed
	spell_body.move_and_slide()
