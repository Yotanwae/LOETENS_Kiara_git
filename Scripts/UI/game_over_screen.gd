extends CanvasLayer

signal back_to_menu


func reload_scene():
	get_tree().reload_current_scene()

func _on_restart_pressed() -> void:
	await get_tree().create_timer(0.3).timeout
	reload_scene()



func _on_back_to_menu_pressed() -> void:
	back_to_menu.emit()
