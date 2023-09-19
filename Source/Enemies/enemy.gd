extends CharacterBody2D

@export
var enemy_speed = 10.0

var target_node : Node2D
var initialized = false

func init_enemy(new_target : Node2D):
	target_node = new_target
	initialized = true

func _physics_process(delta):
	if not initialized:
		return
	
	var move_dir = (target_node.global_position - global_position).normalized()
	velocity = move_dir * enemy_speed
	move_and_slide()


func _on_health_counter_health_depleted():
	queue_free()
