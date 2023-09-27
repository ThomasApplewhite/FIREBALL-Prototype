extends Node

@export
var player : Node2D

@onready
var main_status_text = $RichTextLabel

const game_state_group_name = "GameStates"

static func get_game_state(context_scene_tree : SceneTree) -> Node2D:
	# how should we access the game state if it's not on scene root?
	return context_scene_tree.get_nodes_in_group(game_state_group_name)[0]
	return null
	var root = context_scene_tree.get_root()
	var game_state = root.get_node_or_null(^"./GameState")
	
	if game_state:
		return game_state
		
	# GameState not the root? Try one step lower!
	game_state = root.get_node_or_null(^"././GameState")
	
	if game_state:
		return game_state
	else:
		push_error("GameState node is not a Root Chlld or Grandchild!")
		return null

# Called when the node enters the scene tree for the first time.
func _ready():
	var player_health = player.get_node(^"HealthCounter")
	player_health.health_depleted.connect(_on_player_death)
	
	add_to_group(game_state_group_name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_death():
	end_game()

func win_level():
	main_status_text.text = "[center]YOU WIN[/center]"
	main_status_text.visible = true

func end_game():
	player.queue_free()
	main_status_text.text = "[center]YOU LOSE![/center]"
	main_status_text.visible = true
