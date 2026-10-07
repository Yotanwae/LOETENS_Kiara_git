extends Node2D

######### Enemy Statistics ###########
@export var max_health := 3
var current_health = max_health

@export var attack_cooldown : float = 5.0
######################################

######### Colors for Ui #########
@export var green : Color = Color("#89fe6d")
@export var red : Color = Color("#ff3e23")
@export var yellow : Color = Color("#d6d642")
#################################

########### Text ##############
@onready var prompt = $RichTextLabel
@onready var prompt_text = prompt.get_parsed_text() # to get the text without the BBcode
###############################

@export var animated_sprite : AnimatedSprite2D


func _ready() -> void:
	give_new_prompt()


#give a new prompt at the beginning
func give_new_prompt():
	prompt_text = PromptList.give_prompt()
	prompt.parse_bbcode(set_bbcode_basics_tags(prompt_text))




func get_prompt() -> String: # function to be call in another script
	return prompt_text 




func set_next_character(next_character_index: int):
	var green_text = get_bbcode_color_tag(green) + prompt_text.substr(0, next_character_index) + get_bbcode_color_tag_end()
	var yellow_text = get_bbcode_color_tag(yellow) + "[font_size=37]" + prompt_text.substr(next_character_index, 1) + "[/font_size]" + get_bbcode_color_tag_end()
	
	var red_text = " "
	if next_character_index != prompt_text.length():
		red_text = get_bbcode_color_tag(red) + prompt_text.substr(next_character_index +1, prompt_text.length() - next_character_index+1) + get_bbcode_color_tag_end()
	
	prompt.parse_bbcode(set_bbcode_basics_tags(green_text + yellow_text + red_text))


func miss_input_shake():
	prompt.parse_bbcode("[center][font gl=7][shake rate=40 level=70]" + get_bbcode_color_tag(red) + prompt_text + get_bbcode_color_tag_end() +  "[/shake][/font][/center]")
	




####### function to setup bbcode in the richTextLabel #######
func get_bbcode_color_tag(color: Color)-> String:
	return "[color=#" + color.to_html(false) + "]" # return the hexa color code without the "#" and without the alpha 
func get_bbcode_color_tag_end() -> String:
	return "[/color]"


func set_bbcode_basics_tags(base_string: String):
	return "[center][wave amp=30][font gl=7]" + base_string + "[/font][/wave][/center]" #help to quickly setup the basic tag in the richtextlabel

#############################################################




func take_damage() -> void:
	if current_health > 0:
		current_health -= 1
		animated_sprite.play("hurt")
		await animated_sprite.animation_finished
		animated_sprite.play("idle")
		print("-1hp / current health is " + str(current_health))
		if current_health >= 1: 
			give_new_prompt()
	
	
	
	
	
	if current_health == 0:
		animated_sprite.play("death")
		await get_tree().create_timer(1.0).timeout
		queue_free()
