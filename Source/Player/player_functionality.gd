extends Node

@export
var spell_spawn_point : Node2D

# This will be some other type once I make the thing that picks the spells
@export
var spell_provider : Node


# If this stops working, make sure all created Controls in play scenes are
# set to ignore mouse
func _unhandled_input(event):
	# Any other screen touch not consumed by a UI feature is a spell cast
	if event is InputEventScreenTouch and event.is_pressed():
		cast_spell(event.position)

func cast_spell(screen_touch_position : Vector2):
	var packed_spell = spell_provider.cast_selected_spell()
	if not packed_spell:
		return
	
	var spell_instance = packed_spell.instantiate()
	var spell_direction = screen_touch_position - spell_spawn_point.global_position
	spell_direction = spell_direction.normalized()
	
	spell_spawn_point.add_child(spell_instance)
	spell_instance.global_position = spell_spawn_point.global_position
	spell_instance.global_transform.x = spell_direction
	spell_instance.global_transform.y = spell_direction.orthogonal()
	# correcting transform skew. Why does that happen?
	# spell_instance.global_transform.skew = 0.0
	
	spell_instance.launch()
	
	
