extends Character

######### Attack Cooldown ###########
var is_attack_ready: bool = false
######################################

######### Movement on spawn ###########
var is_moving: bool = true
@export var speed = 170
@export var target = Vector2(0,0)
@onready var enemy: Character = $"."
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


signal inflict_damage

func _ready() -> void:
	animated_sprite.play("walk")
	attack_cooldown_bar.hide()

func move_on_spawn(delta: float) -> void:
	if not is_moving:
		return
	
	enemy.position = enemy.position.move_toward(target, speed * delta)
	
	
	if enemy.position == target: 
		is_moving = false
		is_arrived()
	

func _process(delta: float) -> void:
	move_on_spawn(delta)
	cooldown()

func is_arrived():
	super._ready()
	
	give_new_prompt()
	
	attack_cooldown_bar.show()
	
	cooldown_timer.start()
	
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
func cooldown():
	#fill the progress bar with time left
	attack_cooldown_bar.value = cooldown_timer.wait_time - cooldown_timer.time_left
	
	if is_attack_ready == true:
		is_attack_ready = false
		attack()
		
		
		

func _on_cooldown_timer_timeout() -> void:
	is_attack_ready = true

#to stop the timer when the player died
func _on_knight_is_dead() -> void:
	cooldown_timer.paused = true
	attack_cooldown_bar.hide()
	prompt.hide()
	hearts_container.hide()


func attack():
	play_attack_animation()
	await super.play_attack_animation()
	cooldown_timer.start()
	inflict_damage.emit()
	
###################################

############ Health system ###################
func on_take_damage():
	cooldown_timer.start() #reset the timer when taking damage

func on_survived():
	give_new_prompt()

func death():
	attack_cooldown_bar.hide()
	await super.death()
	queue_free()
########################################
