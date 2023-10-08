extends Node

var damage = 10.0

var health_node_path = ^"HealthCounter"

# damage < 0 = instant kill
func damage_node_by_amount(node_to_damage : Node2D, incoming_damage : float):
	if !node_to_damage.has_method("get_node"):
		push_warning("Tried to damage something that isn't a Node")
		return

	var health = node_to_damage.get_node(health_node_path)
	
	if health:
		if incoming_damage < 0:
			incoming_damage = health.max_health * 10
			
		health.decrease_health(damage)
	else:
		push_warning("Tried to damage %s, but it has no HealthCounter" % node_to_damage.to_string())
		
func damage_node(node_to_damage : Node2D):
	damage_node_by_amount(node_to_damage, damage)

func instant_kill_node(node_to_kill):
	damage_node_by_amount(node_to_kill, -1)

func _on_damage_triggered(node_to_damage : Node2D):
	damage_node(node_to_damage)
	
func _on_instant_kill_triggered(node_to_kill : Node2D):
	instant_kill_node(node_to_kill)
