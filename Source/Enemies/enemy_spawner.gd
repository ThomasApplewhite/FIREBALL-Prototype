extends Area2D

@export
var time_between_spawns = 1.0
@export
var packed_enemy : PackedScene
@export
var player : Node2D

var enemy_group_name

@onready
var collision_shape = $CollisionShape2D
@onready
var timer = $Timer

func _on_timer_timeout():
	spawn_enemy()
	
	
func toggle_enemy_spawning(toggle : bool):
	if toggle:
		spawn_enemy()
		timer.start(time_between_spawns)
	else:
		timer.stop()
		

func spawn_enemy():
	if not player:
		return
	var enemy_instance = packed_enemy.instantiate()
	get_parent().add_child(enemy_instance)
	enemy_instance.global_position = get_random_point_in_area()
	enemy_instance.add_to_group(enemy_group_name)
	enemy_instance.init_enemy(player)
	
func get_random_point_in_area() -> Vector2:
	var area_size = collision_shape.shape.get_rect().size
	var pos_x = randf_range(0.0, area_size.x)
	var pos_y = randf_range(0.0, area_size.y)
	return Vector2(pos_x, pos_y)
	
