extends Node

class_name GameState

@export
var player : Node2D
@export
var enemy_spawner : Node2D
@export
var buff_buttons : Array[Button]
@export
var show_debug_info = true

@onready
var status_control = $PostLevelControl
@onready
var status_text = $PostLevelControl/RichTextLabel
@onready
var status_buff_buttons = $PostLevelControl/BuffSelectorGridContainer
@onready
var damage_dealer = $DamageDealer
@onready
var buff_counter = $PlayerBuffCounter

const game_state_group_name = "GameStates"
const enemy_group_name = "Enemies"

var level_scale = 0

signal level_started(game_state : Node)

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
	connect_startup_signals()
	init_buff_buttons()
	# bind an event to parent ready to start the enemy spawner and also set its group name
	get_parent().ready.connect(begin_level)
	add_to_group(game_state_group_name)
	
	if show_debug_info:
		$DebugControl.visible = true


func connect_startup_signals():
	#var player_health = 
	player.get_node(^"HealthCounter").health_depleted.connect(_on_player_death)
	level_started.connect(player.get_node(^"PlayerFunctionality").apply_player_health_multipliers)
	level_started.connect(player.get_node(^"SpellProvider").init_and_start_cooldown_timer)


func init_buff_buttons():
	for i in buff_buttons.size():
		buff_buttons[i].pressed.connect(_on_progression_button_pressed.bind(i))


func begin_level():
	player.visible = true
	status_control.visible = false
	$DebugControl/RichTextLabel.text = "Level Scale: %d" % level_scale
	#start_enemy_spawning()
	level_started.emit(self)


func kill_all_enemies():
	var enemies = get_tree().get_nodes_in_group(enemy_group_name)
	for enemy in enemies:
		damage_dealer.instant_kill_node(enemy)


func complete_level(won_level : bool):
	if won_level:
		win_level()
	else:
		end_game()


func win_level():
	status_text.text = "[center]YOU WIN[/center]"
	status_buff_buttons.visible = true
	status_control.visible = true
	enemy_spawner.toggle_enemy_spawning(false)
	kill_all_enemies()
	
	level_scale += 1


func end_game():
	player.visible = false
	status_text.text = "[center]YOU LOSE![/center]"
	status_buff_buttons.visible = false
	status_control.visible = true


func _on_player_death():
	complete_level(false)


func _on_progression_button_pressed(buff_selected : int):
	buff_counter.increment_buff(buff_selected)
	begin_level()
