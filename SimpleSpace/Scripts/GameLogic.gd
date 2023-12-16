extends Node

enum TYPES {DEFAULT, SUN, BLACKHOLE, PLATFORM, STATION}
var planet = load("res://Prefabs/Planet.tscn")
enum game_state {MENU, PAUSE, GAME, DEATH}
var state = game_state.MENU
var Difficulty = 0
onready var timer = get_child(0)
var screen_size
var planet_spawn_number : int = 1
var high_score : int

func _ready():
	screen_size = get_viewport().get_visible_rect().size
	print(screen_size)
	pass

func game_start(var high_score : int):
	self.high_score = high_score
	var first_planet = planet.instance()
	add_child_below_node(get_parent().get_child(2), first_planet)
	first_planet.position = Vector2(370,1600)
	first_planet.radius = rand_range(0.55, 1.2)
	first_planet.init(get_parent(), 0)
	ChangeState(game_state.GAME)
	
func on_pause():
	pass

func on_game():
	
	pass
	
func on_death():
	pass

func ChangeState(var new_state): 
	if(new_state != game_state.GAME):
		timer.stop()
	else:
		timer.start(3)
	state = new_state

func _process(delta):
	if(state == game_state.GAME):
		on_game()
	elif(state == game_state.PAUSE):
		on_pause()
	elif(state == game_state.DEATH):
		on_death()
	pass

func spawn_planet(var type):	
	planet_spawn_number += 1
	var new_planet = planet.instance()
	match type:
		TYPES.DEFAULT:
			new_planet.radius = rand_range(0.55, 1.2)
		TYPES.BLACKHOLE:
			new_planet.radius = rand_range(0.7, 1.2)
		TYPES.SUN:
			new_planet.radius = rand_range(0.5, 0.6)
			
	add_child_below_node(get_parent().get_child(2), new_planet)
	if(planet_spawn_number == high_score):
		new_planet.tombstone_enable()
	new_planet.init(get_parent(), planet_spawn_number, type)
		
	var offset = new_planet.get_pixel_size()/2
	new_planet.position = Vector2(rand_range(offset,screen_size.x - offset),1800)
	
	pass

func _on_Timer_timeout():
	if(state == game_state.GAME):
		spawn_planet(rand_range(0,3))
		pass
	pass 
