extends CharacterBody2D

@export
var enemy_speed = 10.0
@export
var health_increase = 10.0
@export
var enemy_collision_layer = 0x0002

signal _on_non_enemy_collision(Node2D)

@onready
var health_counter = $HealthCounter

var target_location : Vector2
var initialized = false

func init_enemy(new_target : Node2D, enemy_scale : int):
	target_location = new_target.global_position
	health_counter.set_max_health(health_counter.max_health + (enemy_scale * health_increase))
	initialized = true

func _physics_process(_delta):
	if not initialized:
		return
	
	var move_dir = (target_location - global_position).normalized()
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
