extends Node2D


var active_word = null
var current_letter_index := -1
var is_error_cooldown: bool = false

@onready var enemy = $Enemy


func new_active_word(typed_character : String):
	var current_prompt = enemy.get_prompt()
	if current_prompt.substr(0, 1) == typed_character: #check if the letter typed is the same as the first letter in the current_prompt
		active_word = enemy
		current_letter_index = 1
		active_word.set_next_character(current_letter_index) # color with bbcode





func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey && event.is_pressed() && ! event.is_echo() && is_error_cooldown == false:
		var typed_event = event as InputEventKey
		
		#ignore every key that have no caracters, such as( Maj, Ctrl, ....)
		if typed_event.unicode == 0:
			return
		
		
		var key_typed = PackedByteArray([typed_event.keycode]).get_string_from_utf8() 
		
		
		
		# ignore every key like (space, tab, ....)
		if key_typed.strip_edges().is_empty():
			return
		
		print(key_typed)
		
		
		if active_word == null:
			new_active_word(key_typed.to_upper()) # using to_upper to make no difference between typing with or without Maj
		else :
			var prompt = active_word.get_prompt()
			var next_character = prompt.substr(current_letter_index, 1)
			
			if key_typed == next_character:
				print("success")
				current_letter_index += 1
				active_word.set_next_character(current_letter_index) # color with bbcode
				
				if current_letter_index == prompt.length(): # check if we are at the end of the word
					current_letter_index = -1 #reset to the beginning
					active_word.take_damage() #erase the current enemy ###### temporary as it will just cause damage later on
					active_word = null
			
			
			if key_typed != next_character:
				print("miss typed")
				active_word.miss_input_shake()
				is_error_cooldown = true
				await get_tree().create_timer(0.15).timeout
				is_error_cooldown = false
				active_word.set_next_character(current_letter_index)
				
				
	
	
	
	
	
	
