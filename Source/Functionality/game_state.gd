extends Node

@export
var player : Node2D
@export
var enemy_spawner : Node2D

@onready
var main_status_text = $RichTextLabel
@onready
var damage_dealer = $DamageDealer

const game_state_group_name = "GameStates"
const enemy_group_name = "Enemies"

static func get_game_state(context_scene_tree : SceneTree) -> Node:
	var game_states = context_scene_tree.get_nodes_in_group(game_state_group_name)
	
	if game_states.size() < 1:
		push_error("SceneTree has no GameState node!")
		return null
	
	if game_states.size() > 1:
		push_warning("There are multiple GameState nodes. Returning the first to be ready")

	return game_states[0]

# Called when the node enters the scene tree for the first time.
func _ready():
	var player_health = player.get_node(^"HealthCounter")
	player_health.health_depleted.connect(_on_player_death)
	
	add_to_group(game_state_group_name)
	
	# bind an event to parent ready to start the enemy spawner and also set its group name
	get_parent().ready.connect(start_enemy_spawning)


func _on_player_death():
	end_game()

func start_enemy_spawning():
	enemy_spawner.enemy_group_name = enemy_group_name
	enemy_spawner.toggle_enemy_spawning(true)

func kill_all_enemies():
	var enemies = get_tree().get_nodes_in_group(enemy_group_name)
	for enemy in enemies:
		damage_dealer.instant_kill_node(enemy)

func win_level():
	main_status_text.text = "[center]YOU WIN[/center]"
	main_status_text.visible = true
	enemy_spawner.toggle_enemy_spawning(false)
	kill_all_enemies()

func end_game():
	player.queue_free()
	main_status_text.text = "[center]YOU LOSE![/center]"
	main_status_text.visible = true
