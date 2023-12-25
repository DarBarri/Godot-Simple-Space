extends Node
var pop_sound = []
enum TYPES {DEFAULT, SUN, BLACKHOLE, PLATFORM, STATION}
var planet = load("res://Prefabs/Planet.tscn")
var planet_buffer = []
var buffer_size : int = 10
enum game_state {MENU, PAUSE, GAME, DEATH}
var state = game_state.MENU
onready var timer = get_child(0)
var screen_size
var planet_spawn_number : int = 1
var high_score : int
var player
var sound_volume
#speeds 
var player_move_speed = 600
var player_rotation_speed = 3.7
var planet_speed = 200
var spawn_interval = 3

onready var rng = RandomNumberGenerator.new()

func _ready():
	pop_sound = get_parent().findFilesInFolder("res://sounds/pop/");
	screen_size = get_viewport().get_visible_rect().size
	#print(screen_size)
	pass

func set_difficulty():
	player.change_rotation_speed(player_rotation_speed)
	player.change_move_speed(player_move_speed)
	pass

func change_difficulty_by(var new_dif):
	print("diif")
	if(spawn_interval > 0.5): 
		player_move_speed += new_dif * 5
		player_rotation_speed += 0.05 * new_dif
		planet_speed += new_dif * 8.2
		spawn_interval -= 0.049 * new_dif
		set_difficulty()
	
func game_start(var hscore : int): 
	high_score = hscore
	var first_planet = planet.instance()
	add_child_below_node(get_parent().get_child(2), first_planet)
	first_planet.set_sound_volume(sound_volume)
	first_planet.position = Vector2(370,1600)
	first_planet.radius = 1
	first_planet.init(get_parent(), 1, planet_speed, 0)
	planet_buffer.append(first_planet)
	ChangeState(game_state.GAME)
	
func on_pause():
	pass
 
var prev_diff_planet = 3
func on_game():
	if(planet_spawn_number > prev_diff_planet):
		prev_diff_planet += 3
		change_difficulty_by(1)
	pass
	
func on_death():
	pass

func ChangeState(var new_state): 
	if(new_state != game_state.GAME):
		timer.stop()
	else:
		timer.start(spawn_interval)
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
	var cur_buffer_size = planet_buffer.size()
	var pPlace = (planet_spawn_number % buffer_size)
	pPlace -= 1
	if(buffer_size >= pPlace):
		if(cur_buffer_size <= buffer_size):
			planet_buffer.append(planet.instance())
	
	var new_planet = planet_buffer[pPlace]
	match type:
		TYPES.DEFAULT:
			new_planet.radius = rand_range(0.55, 1.2)
		TYPES.BLACKHOLE:
			new_planet.radius = rand_range(1.0, 1.2)
		TYPES.SUN:
			#new_planet.audio_stream = load("res://sounds/pop/pop1.ogg")		
			new_planet.radius = rand_range(0.6, 1)

	add_child_below_node(get_parent().get_child(2), new_planet)
	if(planet_spawn_number == high_score):
		new_planet.tombstone_enable()
	new_planet.init(get_parent(), planet_spawn_number,planet_speed, type)
	new_planet.set_sound_volume(sound_volume)
	var offset = new_planet.get_pixel_size()/2
	new_planet.position = Vector2(rand_range(offset,screen_size.x - offset),1800)
	planet_buffer[pPlace] = new_planet
	
func _on_Timer_timeout():
	if(state == game_state.GAME):
		spawn_planet(rng.randi_range(0,2))
		pass
	timer.start(spawn_interval)
	pass 
