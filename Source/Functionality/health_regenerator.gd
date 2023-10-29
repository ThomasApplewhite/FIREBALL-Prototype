extends Node

const minimum_regen_time = 0.4

@export
var health : Node
@export
var regen_amount = 5.0
@export
var regen_time = 1:
	# This set is called before ready because this is an export
	# So, we can't update the regen timer if this node isn't ready
	set(new_regen_time):
		regen_time = new_regen_time
		if(is_node_ready()):
			update_regen_timer()

# Not an onready to control when Timer gets set
@onready
var timer = $Timer
var regen_on_tick = false 

# Called when the node enters the scene tree for the first time.
func _ready():
	update_regen_timer()


func _process(_delta):
	if(regen_on_tick):
		apply_regen()


func apply_regen():
	health.increase_health(regen_amount)


func update_regen_timer():
	# switch to process to avoid tiny timer times
	regen_on_tick = regen_time <= minimum_regen_time
	if regen_on_tick:
		timer.stop()
	else:
		timer.start(regen_time)


func _on_timer_timeout():
	apply_regen()
