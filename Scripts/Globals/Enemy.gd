extends Node2D

######### Enemy Statistics ###########
@export var max_health : int
var current_health: int

var is_attack_ready: bool = false
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

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var attack_cooldown_bar: ProgressBar = $AttackCooldownBar
@onready var animated_sprite = $AnimatedSprite2D



signal inflict_damage
signal death


func _ready() -> void:
	current_health = max_health
	cooldown_timer.start()
	give_new_prompt()
	
	# setup for the progress bar 
	attack_cooldown_bar.min_value = 0.00
	attack_cooldown_bar.max_value = cooldown_timer.wait_time
	attack_cooldown_bar.value = cooldown_timer.wait_time




#give a new prompt at the beginning
func give_new_prompt():
	prompt_text = PromptList.give_prompt()
	prompt.parse_bbcode(set_bbcode_basics_tags(prompt_text))




func get_prompt() -> String: # function to be call in another script
	return prompt_text 



# add feedback depending on the current letter, the next letters or the already typed letters
func set_next_character(next_character_index: int):
	var green_text = get_bbcode_color_tag(green) + prompt_text.substr(0, next_character_index) + get_bbcode_color_tag_end()
	var yellow_text = get_bbcode_color_tag(yellow) + "[font_size=37]" + prompt_text.substr(next_character_index, 1) + "[/font_size]" + get_bbcode_color_tag_end()
	
	var red_text = " "
	if next_character_index != prompt_text.length():
		red_text = get_bbcode_color_tag(red) + prompt_text.substr(next_character_index +1, prompt_text.length() - next_character_index+1) + get_bbcode_color_tag_end()
	
	prompt.parse_bbcode(set_bbcode_basics_tags(green_text + yellow_text + red_text))

# add effect when there's a wrong input
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

######## Attack system ###################
func _process(delta: float) -> void:
	#fill the progress bar with time left
	attack_cooldown_bar.value = cooldown_timer.wait_time - cooldown_timer.time_left
	
	if is_attack_ready == true:
		is_attack_ready = false
		attack()
		print("attacked")
		
		

func _on_cooldown_timer_timeout() -> void:
	is_attack_ready = true

#to stop the timer when the player died
func _on_knight_is_dead() -> void:
	cooldown_timer.paused = true


func attack():
	animated_sprite.play("attack")
	await animated_sprite.animation_finished
	cooldown_timer.start()
	inflict_damage.emit()
	animated_sprite.play("idle")
###################################

############ Health system ###################
func take_damage() -> void:
	if current_health > 0:
		current_health -= 1
		animated_sprite.play("hurt")
		cooldown_timer.start() #reset the timer when taking damage
		await animated_sprite.animation_finished
		animated_sprite.play("idle")
		if current_health > 0: 
			give_new_prompt()


	if current_health == 0:
		attack_cooldown_bar.hide()
		animated_sprite.play("death")
		await get_tree().create_timer(1.0).timeout
		death.emit()
		queue_free()
