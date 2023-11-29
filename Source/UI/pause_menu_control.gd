extends Control

@export
var pause_icon : Texture2D
@export
var play_icon : Texture2D

@onready
var pause_menu = $PauseOnlyMenu
@onready
var pause_button = $TextureButton
@onready
var scene_tree = get_tree()

func toggle_pause():
	var pause_state = scene_tree.paused
	
	pause_button.texture_normal = pause_icon if pause_state else play_icon
	pause_menu.visible = !pause_state
	scene_tree.paused = !pause_state

func _on_pause_button_pressed():
	toggle_pause()


func _on_quit_button_pressed():
	# Go Back is for Android, Close is for everything else
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().root.propagate_notification(NOTIFICATION_WM_GO_BACK_REQUEST)
	get_tree().quit()
