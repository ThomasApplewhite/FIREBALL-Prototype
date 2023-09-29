extends Control

@onready
var grid_container = $GridContainer

var spell_provider
var display_texts : Array[Label]

var display_enabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not display_enabled:
		return
		
	var time_remaining
	var time_left = spell_provider.cooldown_timer.get_time_left()
	var time_max = spell_provider.cooldown_timer_max	
		
	for i in spell_provider.spell_cooldowns.size():
		var cooldown = spell_provider.spell_cooldowns[i]
		
		if(cooldown < 0):
			# account for loop scenario
			time_remaining = (time_max + time_left) - (time_max + cooldown)
		else:
			time_remaining = time_left - cooldown
		
		time_remaining = 0 if time_remaining <= 0 else time_remaining
		display_texts[i].text = "%.2f" % time_remaining
		

func enable_debug_display(new_spell_provider):
	spell_provider = new_spell_provider
	generate_display_text()
	
	display_enabled = true
	
func generate_display_text():
	var spell_count = spell_provider.spell_cooldowns.size()
	display_texts.resize(spell_count)
	grid_container.columns = spell_count
	for i in spell_count:
		display_texts[i] = Label.new()
		display_texts[i].mouse_filter = MOUSE_FILTER_IGNORE
		grid_container.add_child(display_texts[i])
		
