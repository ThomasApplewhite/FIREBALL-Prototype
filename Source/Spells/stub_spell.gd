extends Area2D

@onready
var spell_mover = $LinearSpellMover

func launch():
	spell_mover.launch()


func _on_body_entered(body):
	queue_free()
