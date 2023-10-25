extends Node

const spell_data_type = preload("res://Source/Utils/spell_data.gd")

var spell_data : SpellData
var spell_mover : Node
var spell_damage : Node
var caster : Node2D

@export
var spell_mover_override : Node
@export
var spell_damage_override : Node

signal spell_launched

func _ready():
	init_spell_functionality()


func init_spell_functionality():
	if !spell_data:
		push_error("SpellFunctionality initialized without Spell Data! Set it first!")
	
	spell_mover = $LinearSpellMover if !spell_mover_override else spell_mover_override
	spell_damage = $DamageDealer if !spell_damage_override else spell_damage_override
	
	spell_mover.init_spell_mover(get_parent(), spell_data.speed)
	
	spell_damage.damage = spell_data.damage


func launch(initial_move_direction : Vector2):
	spell_mover.launch(initial_move_direction)
	damage_spell_caster()
	spell_launched.emit()
	

func damage_spell_caster():
	spell_damage.damage_node_by_amount(caster, spell_data.health_cost)

	
func _handle_spell_collision(other_body):
	spell_damage.damage_node(other_body)

#func set_speed(new_speed : float):
#	spell_mover.spell_speed = new_speed


#func set_damage(new_damage : float):
#	spell_damage.damage = new_damage
