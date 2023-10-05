extends Timer

var base_cooldowns :Array [float]
var cooldowns : Array[float]
var cooldown_reductions : Array[float]

# Timer max will be the starting point for timer loops
# Timers will automatically loop if reduced below cooldown_min to avoid
# undefined behavior with small timer wait times
const cooldown_timer_max = 1000
const reduced_cooldown_min = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	timeout.connect(_on_timer_timeout)


func start_cooldown_timer():
	start(cooldown_timer_max)


func init_cooldowns(array_size : int, new_base : Array[float], new_reductions : Array[float]):
	base_cooldowns = new_base
	cooldown_reductions = new_reductions
	cooldowns.resize(array_size)
	for i in array_size:
		cooldowns[i] = cooldown_timer_max - base_cooldowns[i]


func get_spell_stacks(index : int) -> int:
	return floor((cooldowns[index] - get_time_left()) / base_cooldowns[index])


func reduce_all_spell_cooldowns(cooldown_reduction : float):
	var new_time = get_time_left() - cooldown_reduction
	if new_time > reduced_cooldown_min:
		start(new_time)
	else:
		loop_spell_timer(new_time)


func loop_spell_timer(timer_carryover : float):
	var loop_time = cooldown_timer_max + timer_carryover
	for i in cooldowns.size():
		cooldowns[i] += loop_time
	start(loop_time)


func adjust_cooldowns_from_spell_cast(index : int):
	# Subtracting the global reduction prevents from making themselves cooldown faster
	cooldowns[index] -= base_cooldowns[index] - cooldown_reductions[index]
	reduce_all_spell_cooldowns(cooldown_reductions[index])


func _on_timer_timeout():
	loop_spell_timer(0.0)
