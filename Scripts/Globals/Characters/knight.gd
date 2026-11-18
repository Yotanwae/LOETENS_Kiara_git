extends Character

#@onready var main_scene: Node2D = $".."


func _on_enemy_inflict_damage() -> void:
	take_damage()


func _on_typing_succesfully_typed_word() -> void:
	play_attack_animation()
