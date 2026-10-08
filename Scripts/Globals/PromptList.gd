extends Node

var difficulty_word: int = 1
var min_length: int = 1
var max_length: int = 20 

var words : Array = [
	"dungeon",
	"cemetary",
	"skeleton",
	"goblin",
	"slime",
	"chop",
	"cut",
	"slash",
	"break",
	"rat",
	"bone",
	"skull",
	"orc",
	"bow",
	"blood",
	"ghost",
	"key",
	"dark",
	"light",
	"demon",
	"spear",
	"shield",
	"sword",
	"axe",
	"torch",
	"gold",
	"trap",
	"knight",
	"curse",
	"thunder",
	"dagger",
	"weapon",
	"treasure",
	"apocalypse",
	"necromancer",
	"flesh",
	"sorcerer",
	"archer",
	"ghoul",
	"ancient",
	"mystery",
	"monster",
	"vampire",
	"poison",
	"hammer",
	"helmet",
	"crossbow",
	"nightmare",
	"venomous",
	"abomination",
	"ominous",
	"catacombs",
	"enchantment",
	"sacrifice",
	"decaying",
	"stronghold",
	"bloodthirsty",
	"destruction",
	"malicious",
	"corrupted",
	"annihilation",
	"invocation",
	"damnation",
	"malevolent",
	"resurrection",
	"transfiguration",
	"monstrosity",
	"invulnerability",
	"necromancy",
	"desolation",
	"dragon",
	"wyrd",
	"hollow",
	"crypt",
	"tomb",
	"sepulchre",
	"blade",
	"glaive",
	"mace",
	"flail",
	"buckler",
	"witch",
	"haunt",
	"dread",
	"wrath",
	"ash",
	"fate",
	"relic",
	"oath",
	"hand",
	"heart",
	"muscle",
	"brain",
	"ground",
	"coin",
	"chest",
	
]


func is_in_range(word:String)-> bool:
	return word.length() >= min_length && word.length() <= max_length

func give_prompt()-> String:
	####################
	if difficulty_word == 1:
		min_length = 1
		max_length = 5
	if difficulty_word == 2:
		min_length = 5
		max_length = 7
	if difficulty_word == 3:
		min_length = 6
		max_length = 20
	####################
	var possible_words = words.filter(is_in_range)
	
	
	return possible_words.pick_random().to_upper()
