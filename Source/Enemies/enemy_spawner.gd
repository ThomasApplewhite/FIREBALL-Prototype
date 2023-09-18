extends Area2D

@export
var packed_enemy : PackedScene
@export
var player : Node2D

@onready
var collision_shape = $CollisionShape2D

func _on_timer_timeout():
	spawn_enemy()

func spawn_enemy():
	var enemy_instance = packed_enemy.instantiate()
	get_parent().add_child(enemy_instance)
	enemy_instance.global_position = get_random_point_in_area()
	enemy_instance.init_enemy(player)
	
func get_random_point_in_area() -> Vector2:
	var area_size = collision_shape.shape.get_rect().size
	var pos_x = randf_range(0.0, area_size.x)
	var pos_y = randf_range(0.0, area_size.y)
	return Vector2(pos_x, pos_y)
	
