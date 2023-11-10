extends Area2D

@export
var explode_anim_name = "explode"
@export
var explosion_shape : Shape2D

@onready
var spell_anim = $AnimatedSprite2D
@onready
var spell_func = $SpellFuncationality


func explode(explosion_origin : Vector2):
	spell_anim.play(explode_anim_name)
	
	var hit_enemies = get_world_2d().direct_space_state.intersect_shape(CreateShape2DQueryParams(explosion_origin))
	for hit_enemy in hit_enemies:
		spell_func.spell_damage.damage_node(hit_enemy.collider)


func CreateShape2DQueryParams(query_position : Vector2) -> PhysicsShapeQueryParameters2D:
	var params = PhysicsShapeQueryParameters2D.new()
	params.collision_mask = collision_mask
	params.shape = explosion_shape
	params.transform = Transform2D(0.0, query_position)
	return params


func _on_body_entered(body):
	spell_func.spell_mover.spell_speed = 0.0
	explode(body.position)


func _on_animated_sprite_2d_animation_finished():
	queue_free()


func _on_animated_sprite_2d_animation_looped():
	queue_free()
