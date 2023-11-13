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
var debug_show_buff_count : bool
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
	$DebugShowBuffsControl.visible = debug_show_buff_count
	
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
	
	if debug_show_buff_count:
		var text = "[right]%d %d %d %d[/right]" % [buff_counts[0], buff_counts[1], buff_counts[2], buff_counts[3]]
		$DebugShowBuffsControl/RichTextLabel.text = text


func get_buff_multiplier(buff_type : BuffMultiplierType) -> float:
	return _get_buff_multiplier_internal(buff_type)


func _get_buff_multiplier_internal(buff_type : BuffMultiplierType) -> float:
	var buff_formula
	
	match buff_type:
		BuffMultiplierType.DAMAGE:
			buff_formula = buff_data.damage_multiplier_formula
		BuffMultiplierType.COOLDOWN:
			buff_formula = buff_data.cooldown_multiplier_formula
		BuffMultiplierType.HEALTH_CAP:
			buff_formula = buff_data.healthcap_multiplier_formula
		BuffMultiplierType.HEALTH_REGEN:
			buff_formula = buff_data.healthregen_multiplier_formula
		_:
			push_error("Invalid Buff Type given for PlayerBuffCounter.get_buff_multiplier")
			buff_formula = "1.0"
			
	var buff_expression = Expression.new()
	buff_expression.parse(buff_formula, [buff_data.scale_variable])
	return buff_expression.execute([buff_counts[buff_type]], self)


#func _get_buff_multiplier_internal(buff_type : BuffMultiplierType) -> float:
#	var buff_mult_inc
#	var buff_mult_cap
#	var buff_mult_base
#	var buff_config
#	
#	match buff_type:
#		BuffMultiplierType.DAMAGE:
#			buff_config = buff_data.damage_multiplier
#		BuffMultiplierType.COOLDOWN:
#			buff_config = buff_data.cooldown_multiplier
#		BuffMultiplierType.HEALTH_CAP:
#			buff_config = buff_data.healthcap_multiplier
#		BuffMultiplierType.HEALTH_REGEN:
#			buff_config = buff_data.healthregen_multiplier
#		_:
#			pass
#
#	if(buff_config):
#		buff_mult_inc = buff_config.increment
#		buff_mult_cap = buff_config.cap
#		buff_mult_base = buff_config.base
#	else:
#		push_error("Invalid Buff Type given for PlayerBuffCounter.get_buff_multiplier")
#		buff_mult_inc = 1.0
#		buff_mult_cap = 1.0
#		buff_mult_base = 1.0
#	
#	var buff_coef = (buff_mult_inc * buff_counts[buff_type])
#	buff_coef *= -1 if buff_config.buff_subtracts_from_base else 1
#	var final_buff_mult = buff_mult_base + buff_coef
#	# buff-larger-than-cap XOR is-buff-subtractive
#	# If the buff is subtract, it's highest magnitude will be smaller than the base
#	# So, we should use the cap if the buff is too small
#	var should_use_cap = (final_buff_mult > buff_mult_cap) != buff_config.buff_subtracts_from_base
#	
#	return buff_mult_cap if should_use_cap else final_buff_mult
