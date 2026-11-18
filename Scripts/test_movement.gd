extends Node2D

@export var speed = 200
@export var target = Vector2()

func _process(delta: float) -> void:
	position = position.move_toward(target, speed * delta)
