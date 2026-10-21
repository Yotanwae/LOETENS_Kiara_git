extends Control

@export var game_scene: PackedScene


func _ready() -> void:
	pass



func _on_quit_game_button_pressed() -> void:
	get_tree().quit()


func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)
