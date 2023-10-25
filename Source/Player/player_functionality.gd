extends Node

@export
var spell_spawn_point : Node2D

@export
var spell_func_path = ^"SpellFuncationality"

# This will be some other type once I make the thing that picks the spells
@export
var spell_provider : Node


# If this stops working, make sure all created Controls in play scenes are
# set to ignore mouse
# The only exception is GameState's post-level screen. By blocking the mouse there,
# spells aren't cast between levels
func _unhandled_input(event):
	# Any other screen touch not consumed by a UI feature is a spell cast
	if event is InputEventScreenTouch and event.is_pressed():
		cast_spell(event.position)

func cast_spell(screen_touch_position : Vector2):
	var spell_instance = spell_provider.cast_selected_spell()
	if not spell_instance:
		return
	
	var spell_direction = screen_touch_position - spell_spawn_point.global_position
	spell_direction = spell_direction.normalized()
	
	spell_spawn_point.add_child(spell_instance)
	spell_instance.global_position = spell_spawn_point.global_position
	
	var spell_func = spell_instance.get_node(spell_func_path)
	spell_func.caster = get_parent()
	spell_func.launch(spell_direction)
	
	
