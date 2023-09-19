extends CharacterBody2D

@export
var enemy_speed = 10.0
@export
var enemy_collision_layer = 0x0002

signal _on_non_enemy_collision(Node2D)

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
	var collided = move_and_slide()
	if collided:
		_handle_collision()

func _handle_collision():
	for i in get_slide_collision_count():
		var collision_obj = get_slide_collision(i).get_collider()
		if not collision_obj.collision_layer & int(pow(2, enemy_collision_layer-1)):
			_attack_target(collision_obj)
			return
			

func _attack_target(target):
	_on_non_enemy_collision.emit(target)
	queue_free()

func _on_health_counter_health_depleted():
	queue_free()
