extends Control
 
var planetsIcon = [] 
var pop_sound = []
onready var Player = find_node("PlayerShip")
onready var game_logic = find_node("GameLogic")
onready var save_system = find_node("SaveSystem")
onready var score = find_node("score")
onready var main_music = find_node("mainMusic")
onready var version_info = find_node("version_info")

func _ready():  
	version_info.text = "версия: " + ProjectSettings.get_setting("version/string") 
	Player.GM = self
	planetsIcon = findFilesInFolder("res://Textures/Planets/");
	main_music.play()
	game_logic.player = Player
	pass

func BackgroundWasTapped():
	Player.Release()
	pass 

func PlanetWasTapped(var Planet):
	pass

func score_up(var new_score : int):
	score.bbcode_text = "счёт: " + String(new_score)
	pass

func _process(delta):
	pass

func PlayerDead():
	save_system.update_score(Player.score)
	get_tree().reload_current_scene()
	pass

func remove_file_extension(file_path: String) -> String:
	var file_name = file_path.get_file()
	var dot_index = file_name.find_last(".")
	if dot_index > -1:
			file_name = file_name.substr(0, dot_index)
	return file_name

func findFilesInFolder(path: String) -> Array:
	var png_images = []
	var dir = Directory.new() 
	if dir.open(path) == OK: 
		dir.list_dir_begin()
		var file_name = dir.get_next()  
		while file_name != "": 
			file_name = dir.get_next()
			if file_name.get_extension() == "import":
				file_name  = remove_file_extension(file_name)
				var texture = load(path + file_name) 

				png_images.append(texture)
	return png_images

func _on_Start_Button_gui_input():
	find_node("menu").visible = false
	main_music.stop()
	Player.start()
	game_logic.game_start(save_system.high_score)
	pass
