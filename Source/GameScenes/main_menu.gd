extends Control

@export
var packed_gameplay_scene : PackedScene


func _on_button_pressed():
	get_tree().change_scene_to_packed(packed_gameplay_scene)
