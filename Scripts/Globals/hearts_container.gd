extends HBoxContainer

@onready var heart_scene = preload("res://Scenes/UI/heart_ui.tscn")


func set_max_hearts(max: int):
	for i in range(max):
		var heart = heart_scene.instantiate()
		add_child(heart)

func remove_hearts():
	var hearts = get_child(0)
	
	hearts.queue_free()
	
