extends Node2D

######### Enemy Statistics ###########
@export var max_health := 3
var current_health = max_health

@export var attack_cooldown : float = 1.0



@onready var prompt = $RichTextLabel



func get_prompt() -> String:
	return prompt.get_parsed_text()  # to get the text without the BBcode




func take_damage() -> void:
	if current_health > 0:
		current_health -= 1
		print("-1hp / current health is " + str(current_health))
	
	
	if current_health == 0:
		queue_free()
