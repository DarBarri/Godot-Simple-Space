extends Node
onready var config: ConfigFile = ConfigFile.new()
onready var settings = get_parent().find_node("settings")
var high_score: int = 0
var sound_volume = 0
var music_volume = 0
var score_data = {}
onready var best_score = get_parent().find_node("record")

func config_create():
	var file = File.new()
	if !file.file_exists("user://params.cfg"):
		file.open("user://params.cfg", file.WRITE)
		file.close()
	config.set_value("ver1", "score", 0) 
	config.set_value("ver2", "sound_volume", 0) 
	config.set_value("ver2", "music_volume", 0) 
	config.save("user://params.cfg")

func update_score(var new_score: int = 0):
	if(new_score > high_score):
		high_score = new_score 
		config.set_value("ver1", "score", new_score) 
		best_score.bbcode_text  = "[center]Рекорд: " + String(high_score)
	config.set_value("ver2", "sound_volume", sound_volume) 
	config.set_value("ver2", "music_volume", music_volume) 
	config.save("user://params.cfg")

func load_config():
	var err = config.load("user://params.cfg")

	if err != OK:
		config_create()
	 
	high_score = config.get_value("ver1", "score") 
	sound_volume = config.get_value("ver2", "sound_volume", 0) 
	music_volume = config.get_value("ver2", "music_volume", 0) 
	
	settings.set_sliders(self)
	
func set_params():
	pass

func _ready():
	load_config() 
	best_score.bbcode_text  = "[center]Рекорд: " + String(high_score) 
	pass 
