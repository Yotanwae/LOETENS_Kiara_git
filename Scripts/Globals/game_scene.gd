extends Node2D

# script to handle changing scenes

@onready var main_scene: Node2D = $"."

var gameover_scene = preload("res://Scenes/UI/game_over_screen.tscn")



func load_gameover_scene():
	var gameover_instance = gameover_scene.instantiate()
	main_scene.add_child(gameover_instance)
	gameover_instance.back_to_menu.connect(_on_game_over_screen_back_to_menu)

func _on_knight_is_dead() -> void:
	load_gameover_scene()


func _on_game_over_screen_back_to_menu() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main Scene/main_menu.tscn") # had to do it like that to avoid circular dependencies
																			  # not a problem since it will always send back to this scene
