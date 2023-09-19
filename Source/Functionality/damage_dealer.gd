extends Node

func _on_damage_triggered(node_to_damage : Node2D):
	# just remove it for now
	node_to_damage.queue_free()
