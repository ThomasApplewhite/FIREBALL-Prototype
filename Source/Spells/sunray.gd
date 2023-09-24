# I am having a lot of trouble getting this spell to work.
# I do not know how to handle the collision. The intention of this spell is to
# flash an area for damage. A shape trace is sufficient for that mechanically,
# but I don't know how to scale the beam sprite so it covers that area (which
# is defined by a rect size, not by a transform.

extends Node2D

@export
var beam_range = 1000.0
@export
var beam_width = 32.0
@export_flags_2d_physics
var beam_collision_mask

@onready
var sprite_node = $Sprite2D

var beam_location

func launch():
	sweep_for_damage()
	
# the current desire is to sweep cast from spawn to some point beyond the screen
# Check these docs for how to set up the sweep query and how to interpret the 
# sweep results. Remeber: The raycast should sweep only the layer enemies are on
#
# https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
# https://docs.godotengine.org/en/stable/classes/class_physicsdirectspacestate2d.html#class-physicsdirectspacestate2d-method-intersect-shape
func sweep_for_damage():
	# move projectile to good spot
	global_position += (global_transform.x * (beam_range/2))
	# modify sprite scale so sprite stretches correctly
	# desired scale * sprite rect = desired size
	# mmmm... matrix division...
	# this isn't working. Hmm...
	
	sprite_node.transform.scale =Vector2(beam_range, beam_width) / sprite_node.get_rect().size
	
	var space_state = get_world_2d().direct_space_state
	var query = make_sweep_query()
	var result = space_state.intersect_shape(query)

func make_sweep_query() -> PhysicsShapeQueryParameters2D:
	var query = PhysicsShapeQueryParameters2D.new()
	var query_shape = RectangleShape2D
	
	query_shape.size = Vector2(beam_range, beam_width)
	
	query.shape = query_shape
	query.collision_mask = beam_collision_mask
	query.transform = global_transform
	
	return query
