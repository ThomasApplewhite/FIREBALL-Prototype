extends GridContainer

var spell_buttons : Array[Button]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# spell_datas is an array of spell data resources
# spell_button_bind is a callable method handle.
# That's the method that will be called when a spell button is pressed
func init_buttons(spell_datas, spell_button_bind):
	var spell_count = spell_datas.size()
	columns = spell_count
	# spell_cooldowns.resize(spell_datas.size())
	# the fact that this loop naturally goes from 0 to bound-1 is WILD to me
	for i in spell_count:
		var new_button = Button.new()
		new_button.set_custom_minimum_size(new_button.size)
		new_button.icon = spell_datas[i].icon
		new_button.mouse_filter = Button.MOUSE_FILTER_STOP
		# this is how you capture variables for signal arguments outside
		# of defining the args for the signal itself
		new_button.pressed.connect(spell_button_bind.bind(i))
		add_child(new_button)
