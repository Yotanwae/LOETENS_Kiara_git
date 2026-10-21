extends CanvasLayer


@onready var pause_menu_scene := $"."
var is_paused : bool = false


func _ready() -> void:
	pause_menu_scene.hide()
	is_paused = false # double verification

func pause_menu():
	if Input.is_action_just_pressed("escape"):
		# PAUSE
		if is_paused == false:
			pause_menu_scene.show()
			is_paused = true
			get_tree().paused = true
		# UNPAUSE
		elif is_paused == true:
			pause_menu_scene.hide()
			is_paused = false
			get_tree().paused = false
	

func _process(delta: float) -> void:
	pause_menu()


func _on_back_to_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Main Scene/main_menu.tscn")
