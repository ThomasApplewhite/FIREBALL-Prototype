extends Area2D


# You've heard of kill box, now get ready for Life Box (TM)
func _on_body_exited(body):
	body.queue_free()
