extends Node

@export
var spell_datas : Array[SpellData]
@export
var starting_spell_index : int
@export
var debug_enable_cooldowns_display = false

@onready
var grid_container = $GridContainer
@onready
var cooldown_timer = $Timer

const cooldown_timer_max = 1000
const reduced_cooldown_min = 5

var selected_spell_index : int
var spell_cooldowns : Array[float]

# Called when the node enters the scene tree for the first time.
func _ready():
	selected_spell_index = starting_spell_index
	# timer starts before buttons are made so that timer.time_left is not 0
	cooldown_timer.start(cooldown_timer_max)
	init_buttons()
	
	if debug_enable_cooldowns_display:
		$SpellProviderCooldownDisplay.enable_debug_display(self)

func init_buttons():
	grid_container.columns = spell_datas.size()
	spell_cooldowns.resize(spell_datas.size())
	# the fact that this loop naturally goes from 0 to bound-1 is WILD to me
	for i in spell_datas.size():
		var new_button = Button.new()
		new_button.set_custom_minimum_size(new_button.size)
		new_button.icon = spell_datas[i].spell_icon
		new_button.mouse_filter = Button.MOUSE_FILTER_STOP
		# this is how you capture variables for signal arguments outside
		# of defining the args for the signal itself
		new_button.pressed.connect(spell_button_pressed.bind(i))
		grid_container.add_child(new_button)
		
		spell_cooldowns[i] = get_initial_spell_cooldown_time(spell_datas[i].spell_cooldown)

func spell_button_pressed(index : int):
	selected_spell_index = index
	print("Spell Select Button %d pressed" % index)
	
func get_initial_spell_cooldown_time(base_cooldown : float) -> float:
	return cooldown_timer.get_time_left() - base_cooldown
	
func get_spell_cooldown_time(base_cooldown : float, current_cooldown : float) -> float:
	return current_cooldown - base_cooldown
	
func get_spell_stacks(spell_index : int) -> int:
	var cooldown = spell_cooldowns[spell_index]
	var time_left = cooldown_timer.get_time_left()
	var base_cooldown = spell_datas[spell_index].spell_cooldown
	return floor((cooldown - time_left) / base_cooldown)
	
func reduce_all_spell_cooldowns(cooldown_reduction : float):
	var new_time = cooldown_timer.get_time_left() - cooldown_reduction
	
	if new_time > reduced_cooldown_min:
		cooldown_timer.start(new_time)
	else:
		# force a timer loop
		# this avoids restarting timers with a low wait time, which
		# could cause strange behavior
		loop_spell_timer(new_time)
	
func loop_spell_timer(timer_carryover : float):
	for i in spell_cooldowns.size():
		spell_cooldowns[i]  += cooldown_timer_max + timer_carryover
		
	cooldown_timer.start(cooldown_timer_max - timer_carryover)

func cast_selected_spell() -> PackedScene:
	if cooldown_timer.get_time_left() < spell_cooldowns[selected_spell_index]:
		var base_cool = spell_datas[selected_spell_index].spell_cooldown
		var cur_cool = spell_cooldowns[selected_spell_index]
		var new_cooldown = get_spell_cooldown_time(base_cool, cur_cool)
		var global_cool = spell_datas[selected_spell_index].global_cooldown_reduction
	
		spell_cooldowns[selected_spell_index] = new_cooldown - global_cool
		reduce_all_spell_cooldowns(global_cool)
		
		return spell_datas[selected_spell_index].packed_spell
	
	return null
	
func print_spell_stack_math(spell_index):
	var overflow = spell_cooldowns[spell_index] - cooldown_timer.get_time_left()
	var base = spell_datas[spell_index].spell_cooldown
	print("Stacks: %d, overflow: %.2f, base_cooldown: %.2f" % [get_spell_stacks(spell_index), overflow, base])

func _on_timer_timeout():
	loop_spell_timer(0.0)
