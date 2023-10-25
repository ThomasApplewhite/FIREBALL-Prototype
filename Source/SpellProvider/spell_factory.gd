extends Node

@export
var spell_func_path = ^"SpellFuncationality"

var spell_datas


func init_factory_data(new_spell_datas):
	spell_datas = new_spell_datas


func create_spell_instance(spell_index : int) -> Node2D:
	var data = spell_datas[spell_index]
	var spell = data.packed_spell.instantiate()
	var spell_func = spell.get_node(spell_func_path)
	
	spell.name = data.name
	spell_func.spell_data = data
	#spell_func.set_damage(data.damage)
	#spell_func.set_speed(data.speed)
	
	return spell
