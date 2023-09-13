extends CharacterBody2D

@onready
var spell_mover = $LinearSpellMover

func launch():
	spell_mover.launch()
