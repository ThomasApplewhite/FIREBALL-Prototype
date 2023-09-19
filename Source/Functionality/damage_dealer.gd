extends Node

@export
var damage = 10.0

var health_node_path = ^"HealthCounter"

func _on_damage_triggered(node_to_damage : Node2D):
	var health = node_to_damage.get_node(health_node_path)
	
	if health:
		health.decrease_health(damage)
