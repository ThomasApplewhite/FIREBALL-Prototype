extends Node

const instant_kill_damage = 999999999
const health_node_path = ^"HealthCounter"

var damage = 10.0



# damage < 0 = instant kill
func damage_node_by_amount(node_to_damage : Node2D, incoming_damage : float):
	if !node_to_damage.has_method("get_node"):
		push_warning("Tried to damage something that isn't a Node")
		return

	var health = node_to_damage.get_node(health_node_path)
	
	if health:
		health.decrease_health(incoming_damage)
	else:
		push_warning("Tried to damage %s, but it has no HealthCounter" % node_to_damage.to_string())
		
func damage_node(node_to_damage : Node2D):
	damage_node_by_amount(node_to_damage, damage)

func instant_kill_node(node_to_kill):
	damage_node_by_amount(node_to_kill, instant_kill_damage)

func _on_damage_triggered(node_to_damage : Node2D):
	damage_node(node_to_damage)
	
func _on_instant_kill_triggered(node_to_kill : Node2D):
	instant_kill_node(node_to_kill)
