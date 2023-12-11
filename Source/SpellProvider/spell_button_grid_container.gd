extends GridContainer

const progress_undertexture = preload("res://Assets/Icons/BlackIcon.png")
const normal_button_style_name = "Normal"
const hover_button_style_name = "Hover"
const debug_selection_keys = {
	KEY_1 : 0,
	KEY_2 : 1,
	KEY_3 : 2,
	KEY_4 : 3,
	KEY_5 : 4
}

@onready
var empty_stylebox = StyleBoxEmpty.new()

@export
var debug_keyboard_spell_selection = false
@export
var spell_percentage_provider : Node
@export 
var button_size = Vector2(64, 64)

var spell_buttons : Array[Button]


func _process(_delta):
	for i in get_child_count():
		# These buttons always have the texture progress as their only child
		var remaining_percentage = spell_percentage_provider.get_spell_time_percentage(i)
		get_child(i).get_child(0).value = remaining_percentage * 100.0


func _unhandled_key_input(event):
	if debug_keyboard_spell_selection and event.pressed and debug_selection_keys.has(event.keycode):
		var button = get_child(debug_selection_keys[event.keycode])
		button.grab_focus()
		button.pressed.emit()


# spell_datas is an array of spell data resources
# spell_button_bind is a callable method handle.
# That's the method that will be called when a spell button is pressed
func init_buttons(spell_datas, spell_button_bind):
	var spell_count = spell_datas.size()
	columns = spell_count
	# the fact that this loop naturally goes from 0 to bound-1 is WILD to me
	for i in spell_count:
		var new_button = Button.new()
		var progress_texture = TextureProgressBar.new()
		
		new_button.set_custom_minimum_size(button_size)
		new_button.mouse_filter = Button.MOUSE_FILTER_STOP
		new_button.add_theme_stylebox_override(normal_button_style_name, empty_stylebox)
		new_button.add_theme_stylebox_override(hover_button_style_name, empty_stylebox)
		
		progress_texture.fill_mode = TextureProgressBar.FILL_BOTTOM_TO_TOP
		progress_texture.texture_under = progress_undertexture
		progress_texture.texture_progress = spell_datas[i].icon
		progress_texture.min_value = 0.0
		progress_texture.max_value = 100.0
		progress_texture.value = 0.0
		# this is how you capture variables for signal arguments outside
		# of defining the args for the signal itself
		new_button.pressed.connect(spell_button_bind.bind(i))
		new_button.add_child(progress_texture)
		add_child(new_button)
