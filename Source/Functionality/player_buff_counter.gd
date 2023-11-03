extends Node

class_name PlayerBuffCounter

const buff_data_type = preload("res://Source/Utils/buff_data.gd")
const buff_counter_group_name = "BuffCounter"

enum BuffMultiplierType {
	DAMAGE,
	COOLDOWN,
	HEALTH_CAP,
	HEALTH_REGEN
}

@export
var buff_data : BuffData
@export
var add_startup_buffs : bool
@export
var startup_damage : int
@export
var startup_cooldown : int
@export
var startup_health_cap : int
@export
var startup_health_regen : int

var buff_counts = {
	BuffMultiplierType.DAMAGE : 0,
	BuffMultiplierType.COOLDOWN : 0,
	BuffMultiplierType.HEALTH_CAP : 0,
	BuffMultiplierType.HEALTH_REGEN : 0
}

#static func get_buff_counter(context_scene_tree : SceneTree) -> PlayerBuffCounter:
#	var buff_counters = context_scene_tree.get_nodes_in_group(buff_counter_group_name)
#	
#	if buff_counters.size() < 1:
#		push_error("SceneTree has no PlayerBuffCounter node!")
#		return null
#	
#	if buff_counters.size() > 1:
#		push_warning("There are multiple PlayerBuffCounter nodes. Returning the first to be ready")
#
#	return buff_counters[0]


#static func get_buff_multiplier(buff_type : BuffMultiplierType, context_scene_tree : SceneTree) -> float:
#	var buff_counter = PlayerBuffCounter.get_buff_counter(context_scene_tree)
#	
#	if not buff_counter:
#		return 1.0
#		
#	return buff_counter.get_buff_multiplier_internal(buff_type)


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group(buff_counter_group_name)
	
	if add_startup_buffs:
		buff_counts = {
			BuffMultiplierType.DAMAGE : startup_damage,
			BuffMultiplierType.COOLDOWN : startup_cooldown,
			BuffMultiplierType.HEALTH_CAP : startup_health_cap,
			BuffMultiplierType.HEALTH_REGEN : startup_health_regen
		}


func increment_buff(buff_type : BuffMultiplierType):
	buff_counts[buff_type] += 1


func get_buff_multiplier(buff_type : BuffMultiplierType) -> float:
	return _get_buff_multiplier_internal(buff_type)


func _get_buff_multiplier_internal(buff_type : BuffMultiplierType) -> float:
	var buff_mult_inc
	var buff_mult_cap
	
	# this is gonna suck
	# but it's better than caching everything ahead of time
	# it would be cool if I could access this more cleanly without caching
	# well I guess I could put it in a cache friendly format in the resource but whatever who cares
	match buff_type:
		BuffMultiplierType.DAMAGE:
			buff_mult_inc = buff_data.damage_mult_inc
			buff_mult_cap = buff_data.damage_mult_cap
		BuffMultiplierType.COOLDOWN:
			buff_mult_inc = buff_data.cooldown_mult_inc
			buff_mult_cap = buff_data.cooldown_mult_capc
		BuffMultiplierType.HEALTH_CAP:
			buff_mult_inc = buff_data.healthcap_mult_inc
			buff_mult_cap = buff_data.healthcap_mult_cap
		BuffMultiplierType.HEALTH_REGEN:
			buff_mult_inc = buff_data.healthregen_mult_inc
			buff_mult_cap = buff_data.healthregen_mult_cap
		_:
			push_error("Invalid Buff Type given for PlayerBuffCounter.get_buff_multiplier")
			buff_mult_inc = 1.0
			buff_mult_cap = 1.0
	
	var final_buff_mult = buff_mult_inc * buff_counts[buff_type]
	return final_buff_mult if final_buff_mult <= buff_mult_cap else buff_mult_cap
