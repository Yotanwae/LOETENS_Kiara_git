extends CanvasLayer

@export var menu_scene: PackedScene


func reload_scene():
	get_tree().reload_current_scene()

func _on_restart_pressed() -> void:
	await get_tree().create_timer(0.3).timeout
	reload_scene()


func _on_back_to_menue_pressed() -> void:
	get_tree().change_scene_to_packed(menu_scene)
