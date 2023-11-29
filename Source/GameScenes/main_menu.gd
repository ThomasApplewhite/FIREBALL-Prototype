extends Control

@export
var packed_gameplay_scene : PackedScene


func _on_start_button_pressed():
	get_tree().change_scene_to_packed(packed_gameplay_scene)


func _on_quit_button_pressed():
	# Go Back is for Android, Close is for everything else
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().root.propagate_notification(NOTIFICATION_WM_GO_BACK_REQUEST)
	get_tree().quit()
