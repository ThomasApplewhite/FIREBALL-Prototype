extends Node

@export
var max_health = 100.0

@onready
var health = max_health
@onready
var health_bar = $ProgressBar

signal health_depleted()

func _ready():
	health_bar.min_value = 0.0
	health_bar.max_value = max_health
	health_bar.value = max_health

func decrease_health(health_delta : float):
	health -= health_delta
	health_bar.value = health
	_check_for_death()
	
func _check_for_death():
	if(health <= 0):
		health_depleted.emit()
