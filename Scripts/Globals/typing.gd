extends Node2D

#####################################
var active_word = null
var current_letter_index := -1
var is_error_cooldown: bool = false
var can_type: bool = true
######################################
var kill_count : int = 0

var difficulty_level : int = 1
#######################################
@onready var enemy_container: Node2D = $EnemyContainer
@onready var spawner: Marker2D = $Spawner

@export var difficulty_text : Label
@export var kill_count_text : Label

@export var knight : Node2D
###################################
var orc_scene = preload("res://Scenes/Characters/orc.tscn")
var demon_scene = preload("res://Scenes/Characters/demon.tscn")
###################################
signal succesfully_typed_word
signal increase_difficulty
##################################

func _ready() -> void:
	increase_difficulty.connect(PromptList._on_increase_difficulty)


func new_active_word(typed_character : String):
	for enemy in enemy_container.get_children():
		var current_prompt = enemy.get_prompt()
		if current_prompt.substr(0, 1) == typed_character: #check if the letter typed is the same as the first letter in the current_prompt
			active_word = enemy
			current_letter_index = 1
			active_word.set_next_character(current_letter_index) # color with bbcode





func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey && event.is_pressed() && ! event.is_echo() && is_error_cooldown == false && can_type == true:
		var typed_event = event as InputEventKey
		
		#ignore every key that have no caracters, such as( Maj, Ctrl, ....)
		if typed_event.unicode == 0:
			return
		
		
		var key_typed = PackedByteArray([typed_event.keycode]).get_string_from_utf8() 
		
		
		
		# ignore every key like (space, tab, ....)
		if key_typed.strip_edges().is_empty():
			return
		
		#print(key_typed)
		
		
		if active_word == null:
			new_active_word(key_typed.to_upper()) # using to_upper to make no difference between typing with or without Maj
		else :
			var prompt = active_word.get_prompt()
			var next_character = prompt.substr(current_letter_index, 1)
			
			if key_typed == next_character:
				#print("success")
				current_letter_index += 1
				active_word.set_next_character(current_letter_index) # color with bbcode
				
				
				###### when the word is fully typed#####
				if current_letter_index == prompt.length(): # check if we are at the end of the word
					current_letter_index = -1 #reset to the beginning
					succesfully_typed_word.emit() #signals to emit for playing animation
					
					
					await get_tree().create_timer(0.4).timeout
					active_word.take_damage() #erase the current enemy ###### temporary as it will just cause damage later on
					active_word = null 
			
			
			##### when miss input #####
			if key_typed != next_character:
				#print("miss typed")
				active_word.miss_input_shake()
				is_error_cooldown = true
				await get_tree().create_timer(0.15).timeout
				is_error_cooldown = false
				active_word.set_next_character(current_letter_index)
				
				

# to prevent the player from typing during his death
func _on_knight_is_dead() -> void:
	can_type = false


func _on_enemy_death() -> void:
	
	add_to_kill_count_enemy()
	
	var randomized = randi_range(0,1)
	var enemy_scene = orc_scene
	
	if randomized == 0:
		enemy_scene = orc_scene
	if randomized == 1:
		enemy_scene = demon_scene
	
	var enemy_instance = enemy_scene.instantiate()
	enemy_instance.death.connect(_on_enemy_death)
	enemy_instance.inflict_damage.connect(knight._on_enemy_inflict_damage)
	knight.is_dead.connect(enemy_instance._on_knight_is_dead)
	enemy_container.add_child(enemy_instance)
	enemy_instance.global_position = spawner.global_position


func add_to_kill_count_enemy():
	kill_count += 1
	
	if kill_count % 5 == 0:
		increase_difficulty.emit()

func update_difficulty_text():
	difficulty_text.set_text("DIFFICULTY : " + str(difficulty_level))

func update_kill_count_text():
	kill_count_text.set_text("NUMBER OF ENEMY DEFEATED : " + str(kill_count))

func _process(delta: float) -> void:
	difficulty_level = PromptList.give_difficulty()
	update_difficulty_text()
	update_kill_count_text()
