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
	
	pass

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
		
		spell_cooldowns[i] = get_spell_cooldown_time(spell_datas[i].spell_cooldown)

func spell_button_pressed(index : int):
	selected_spell_index = index
	print("Spell Select Button %d pressed" % index)
	
func get_spell_cooldown_time(base_cooldown : float) -> float:
	return cooldown_timer.get_time_left() - base_cooldown
	
# do this laters
#func reduce_all_spell_cooldowns(cooldown_reduction : float):
#	pass
	
func loop_spell_timer(timer_underflow : float):
	# the only times that wouldn't have expired before the underflow occurs
	# are negative ones. So, we can assume all times are negative during a loop
	for i in spell_cooldowns.size():
		spell_cooldowns[i]  += cooldown_timer_max - timer_underflow
		
	cooldown_timer.start(cooldown_timer_max - timer_underflow)

func cast_selected_spell() -> PackedScene:
	if cooldown_timer.get_time_left() < spell_cooldowns[selected_spell_index]:
		var new_cooldown = get_spell_cooldown_time(spell_datas[selected_spell_index].spell_cooldown)
		spell_cooldowns[selected_spell_index] = new_cooldown
		return spell_datas[selected_spell_index].packed_spell
	
	return null

func _on_timer_timeout():
	loop_spell_timer(0.0)
