extends Node2D


@export var max_health := 3
var current_health := max_health

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

signal is_dead

func _ready() -> void:
	animated_sprite.play("idle")
	

func _on_enemy_inflict_damage() -> void:
	take_damage()


func take_damage():
	if current_health > 0:
		current_health -= 1
		animated_sprite.play("hurt")
		await animated_sprite.animation_finished
		if current_health > 0:
			animated_sprite.play("idle")
		if current_health == 0:
			death()

func death():
	is_dead.emit()
	animated_sprite.play("death")
	await animated_sprite.animation_finished
	await get_tree().create_timer(3.0).timeout
	get_tree().reload_current_scene()

func attack_animation():
	animated_sprite.play("attack")
	await animated_sprite.animation_finished
	animated_sprite.play("idle")


func _on_typing_succesfully_typed_word() -> void:
	attack_animation()
