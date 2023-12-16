extends Control

var planetsIcon = [] 
onready var Player = find_node("PlayerShip")
onready var game_logic = find_node("GameLogic")
onready var save_system = find_node("SaveSystem")
onready var score = find_node("score")

func _ready(): 
	Player.GM = self
	planetsIcon = findPNGImagesInFolder("res://Textures/Planets/");
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

func findPNGImagesInFolder(path: String) -> Array:
	var png_images = []
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "": 
			file_name = dir.get_next()
			if file_name.get_extension().to_lower() == "png":
				var texture : Texture = load(path + "/" + file_name)
				png_images.append(texture)
	return png_images

func _on_Start_Button_gui_input():
	find_node("menu").visible = false
	Player.start()
	game_logic.game_start(save_system.high_score)
	pass
