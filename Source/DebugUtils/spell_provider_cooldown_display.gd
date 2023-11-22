extends Control

@onready
var grid_container = $GridContainer

var spell_provider
var cool_labels : Array[Label]
var stack_labels : Array[Label]

var display_enabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not display_enabled:
		return
		
	for i in spell_provider.get_cooldowns().size():
		cool_labels[i].text = "%.2f" % spell_provider.cooldown_timer.get_spell_time_remaining(i)
		stack_labels[i].text = "%d" % spell_provider.cooldown_timer.get_spell_stacks(i)
		

func enable_debug_display(new_spell_provider):
	spell_provider = new_spell_provider
	generate_display_text()
	
	display_enabled = true
	
func generate_display_text():
	if display_enabled:
		return
	
	var spell_count = spell_provider.cooldowns.size()
	cool_labels.resize(spell_count)
	stack_labels.resize(spell_count)
	grid_container.columns = spell_count
	
	for i in spell_count:
		cool_labels[i] = Label.new()
		cool_labels[i].mouse_filter = MOUSE_FILTER_IGNORE
		grid_container.add_child(cool_labels[i])
		
	for i in spell_count:
		stack_labels[i] = Label.new()
		stack_labels[i].mouse_filter = MOUSE_FILTER_IGNORE
		grid_container.add_child(stack_labels[i])
		
