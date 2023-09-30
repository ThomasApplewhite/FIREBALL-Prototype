extends Control

@onready
var grid_container = $GridContainer

var spell_provider
var cool_labels : Array[Label]
var stack_labels : Array[Label]

var display_enabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not display_enabled:
		return
		
	var time_remaining
	var stacks
	var time_left = spell_provider.cooldown_timer.get_time_left()
	var time_max = spell_provider.cooldown_timer_max	
		
	for i in spell_provider.spell_cooldowns.size():
		var cooldown = spell_provider.spell_cooldowns[i]
		var base_cooldown = spell_provider.spell_datas[i].spell_cooldown
		
		if(cooldown < 0):
			# account for loop scenario
			time_remaining = (time_max + time_left) - (time_max + cooldown)
		else:
			time_remaining = time_left - cooldown
		
		# math for stacks  might not be accurate for loops. I didn't check
		time_remaining = 0 if time_remaining <= 0 else time_remaining
		
		cool_labels[i].text = "%.2f" % time_remaining
		stack_labels[i].text = "%d" % spell_provider.get_spell_stacks(i)
		

func enable_debug_display(new_spell_provider):
	spell_provider = new_spell_provider
	generate_display_text()
	
	display_enabled = true
	
func generate_display_text():
	var spell_count = spell_provider.spell_cooldowns.size()
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
		
