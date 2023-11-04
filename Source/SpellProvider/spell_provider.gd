extends Node

@export
var spell_datas : Array[SpellData]
@export
var starting_spell_index : int
@export
var debug_enable_cooldowns_display = false

@onready
var grid_container = $SpellButtonGridContainer
@onready
var cooldown_timer = $SpellCooldownTimer
@onready
var spell_factory = $SpellFactory



var spell_index : int
var cooldowns : Array[float]:
	get = get_cooldowns


func _ready():
	spell_index = starting_spell_index
	grid_container.init_buttons(spell_datas, spell_button_pressed)
	spell_factory.init_factory_data(spell_datas)

		

func init_and_start_cooldown_timer(_game_state : Node):
	init_cooldown_timer()
	cooldown_timer.start_cooldown_timer()
	
	if debug_enable_cooldowns_display:
		$SpellProviderCooldownDisplay.enable_debug_display(self)

func init_cooldown_timer():
	var base : Array[float] = []
	var reduce : Array[float] = []
	var size = spell_datas.size()
	var player_buffs = GameState.get_game_state(get_tree()).buff_counter
	var base_multiplier = player_buffs.get_buff_multiplier(PlayerBuffCounter.BuffMultiplierType.COOLDOWN)
	base.resize(size)
	reduce.resize(size)
	for i in size:
		base[i] = spell_datas[i].cooldown * base_multiplier
		reduce[i] = spell_datas[i].global_cooldown_change
	cooldown_timer.init_cooldowns(size, base, reduce, false)

func get_cooldowns() -> Array[float]:
	return cooldown_timer.cooldowns


func cast_selected_spell() -> Node2D:
	if cooldown_timer.get_time_left() >= cooldowns[spell_index]:
		return null
	
	cooldown_timer.adjust_cooldowns_from_spell_cast(spell_index)
	return spell_factory.create_spell_instance(spell_index)


func spell_button_pressed(index : int):
	spell_index = index
	print("Spell Select Button %d pressed" % index)
