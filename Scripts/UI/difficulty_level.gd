extends Label


var difficulty_level : int


func _process(delta: float) -> void:
	difficulty_level = PromptList.give_difficulty()
	update_text()
	

func update_text():
	set_text("DIFFICULTY : " + str(difficulty_level))
	
