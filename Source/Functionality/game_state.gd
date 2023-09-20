extends Node

@export
var player : Node2D

@onready
var main_status_text = $RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	var player_health = player.get_node(^"HealthCounter")
	player_health.health_depleted.connect(_on_player_death)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_death():
	end_game()

func end_game():
	player.queue_free()
	main_status_text.text = "[center]YOU LOSE![/center]"
	main_status_text.visible = true
