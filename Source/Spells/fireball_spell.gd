extends Node2D

@export
var explosion_position_offset : Vector2
@export_flags_2d_physics
var fireball_collision_mask

@onready
var spell_mover = $LinearSpellMover
@onready
var damage_dealer = $DamageDealer
@onready
var win_causer = $GameWinCauser

var screen_center : Vector2
var screen_size : Vector2
var explosion_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	var viewport_rect = get_viewport().get_visible_rect()
	screen_size = viewport_rect.size
	screen_center = viewport_rect.position + (screen_size / 2)
	explosion_position = screen_center + explosion_position_offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var dir_to_center = get_dir_to_explosion_position()
	
	# checking vector dots is slightly more expensive than checking position,
	# but it will work even if the spell overshoots the exact position because
	# of subpixel movement or whatever else.
	if global_transform.y.dot(dir_to_center) > 0:
		win_causer.win_triggered.emit()
		queue_free()

func get_dir_to_explosion_position() -> Vector2:
	return (explosion_position - global_position).normalized()
	
func kill_all_enemies():
	#var space_state = get_world_2d().direct_space_state
	#var query = PhysicsShapeQueryParameters2D.new()
	#query.shape = RectangleShape2D.new()
	#query.shape.set_size(screen_size)
	#query.collision_mask = fireball_collision_mask
	#query.transform = Transform2D(0.0, screen_center)
	
	#for result in space_state.intersect_shape(query):
	#	if result.collider:
	#		damage_dealer.instant_kill_node(result.collider)
	
	# GameState will cover all effects of a win. FIREBALL does nothing eles.
	pass


func _on_spell_funcationality_spell_launched():
	# rotate towards screen center
	var dir_to_center = get_dir_to_explosion_position()
	spell_mover.move_direction = dir_to_center
	global_transform.y = -dir_to_center
	global_transform.x = -(dir_to_center.orthogonal())
