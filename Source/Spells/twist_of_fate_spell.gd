extends Node2D

@export 
var spell_range : float
@export_flags_2d_physics
var enemy_collision_layer : int
@export
var anim_name = "twist"
@export
var enemy_speed_name = "enemy_speed"

@onready
var spell_func = $SpellFuncationality
@onready
var spell_anim = $AnimatedSprite2D

var hit_enemy_collider


func create_raycast_params():
	return PhysicsRayQueryParameters2D.create(
		global_position, 
		global_position + (-global_transform.y * spell_range),
		enemy_collision_layer
	)


func raycast_for_damage():
	var hit_enemy = get_world_2d().direct_space_state.intersect_ray(create_raycast_params())

	#print("Raycast: %v -> %v" % [global_position, global_position + (global_transform.y * spell_range)])
	
	if hit_enemy:
		global_transform.y = Vector2.DOWN
		global_transform.x = Vector2.RIGHT
		global_position = hit_enemy.position
		hit_enemy_collider = hit_enemy.collider
		if enemy_speed_name in hit_enemy_collider:
			hit_enemy_collider.set(enemy_speed_name, 0.0)
		
		spell_anim.play(anim_name)
	else:
		queue_free()
		

func damage_enemy_and_free_self():
	spell_func.spell_damage.damage_node(hit_enemy_collider)
	queue_free()


func _on_spell_funcationality_spell_launched():
	raycast_for_damage()


func _on_animated_sprite_2d_animation_finished():
	damage_enemy_and_free_self()


func _on_animated_sprite_2d_animation_looped():
	damage_enemy_and_free_self()
