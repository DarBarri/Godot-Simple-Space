extends Node
onready var config: ConfigFile = ConfigFile.new()
var high_score: int = 0
var score_data = {}
onready var best_score = get_parent().find_node("record")

func config_create():
	var file = File.new()
	if !file.file_exists("user://params.cfg"):
		file.open("user://params.cfg", file.WRITE)
		file.close()
	config.set_value("ver1", "score", 0) 
	config.save("user://params.cfg")

func update_score(var new_score: int):
	if(new_score > high_score):
		high_score = new_score
		print(new_score)
		config.set_value("ver1", "score", new_score) 
		config.save("user://params.cfg")
		best_score.bbcode_text  = "[center]Рекорд: " + String(high_score)
	
func load_config():
	var err = config.load("user://params.cfg")

	if err != OK:
		config_create()
	 
	high_score = config.get_value("ver1", "score") 

func _ready():
	load_config()
	# score.text = "[center]Рекорд:  "
	best_score.bbcode_text  = "[center]Рекорд: " + String(high_score)
	# score.bbcode_text  = ProjectSettings.globalize_path("user://")
	pass 
