extends Node

@export
var max_health = 100.0

@onready
var health = max_health
@onready
var health_bar = $ProgressBar

@onready
var debug_label = $Label

signal health_depleted()

func _ready():
	set_healthbar_size_to_max_heath()
	debug_label.text = ("%.2f" % health)

func set_max_health(new_max_health : float):
	max_health = new_max_health
	health = new_max_health
	debug_label.text = ("%.2f" % health)
	set_healthbar_size_to_max_heath()

func set_healthbar_size_to_max_heath():
	health_bar.min_value = 0.0
	health_bar.max_value = max_health
	health_bar.value = max_health

func decrease_health(health_delta : float):
	health -= health_delta
	health_bar.value = health
	debug_label.text = ("%.2f" % health)
	_check_for_death()
	
func _check_for_death():
	if(health <= 0):
		health_depleted.emit()
