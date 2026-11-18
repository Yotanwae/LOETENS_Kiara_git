class_name Character
extends Node

signal is_dead

##################################
@export var max_health : int
var current_health: int
##################################
@onready var animated_sprite = $AnimatedSprite2D
@onready var hearts_container = $HeartsContainer

func _ready() -> void:
	current_health = max_health
	
	animated_sprite.play("idle")
	
	hearts_container.set_max_hearts(max_health)

func take_damage():
	if current_health > 0:
		current_health -= 1
		animated_sprite.play("hurt")
		hearts_container.remove_hearts()
		on_take_damage()
		await animated_sprite.animation_finished
		if current_health > 0:
			animated_sprite.play("idle")
			on_survived()
		if current_health == 0:
			death()

func death():
	animated_sprite.play("death")
	await get_tree().create_timer(1.0).timeout
	is_dead.emit()

func play_attack_animation() -> void:
	animated_sprite.play("attack")
	await animated_sprite.animation_finished
	animated_sprite.play("idle")
	

######## for the enemy #############
func on_take_damage():
	pass

func on_survived():
	pass
