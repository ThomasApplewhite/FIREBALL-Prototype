extends Node

@export
var spell_datas : Array[SpellData]
@export
var starting_spell_index : int

@onready
var grid_container = $GridContainer

var selected_spell : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	selected_spell = spell_datas[starting_spell_index].packed_spell
	init_buttons()

func init_buttons():
	grid_container.columns = spell_datas.size()
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

func spell_button_pressed(index : int):
	selected_spell = spell_datas[index].packed_spell
	print("Spell Select Button %d pressed" % index)

func cast_selected_spell() -> PackedScene:
	return selected_spell
