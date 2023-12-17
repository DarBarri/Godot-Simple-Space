extends Node2D

enum TYPES {DEFAULT, SUN, BLACKHOLE, PLATFORM, STATION}
var hasTarget = false
var TargetTexture
var radius = 1
var rotation_speed = 100
var type
var move_speed = 200
var player
var touched = false
var game_manager
var spawn_number : int = 1
onready var tombstone = get_child(0).get_child(2)
onready var orbit = get_child(0).get_child(1).get_child(0);
onready var planet = get_child(0).get_child(0).get_child(0);
onready var sphered_cube = get_child(0).get_child(0).get_child(1);
onready var audio_stream = get_child(0).get_child(3)

func _ready():  
	

	pass # Replace with function body.

func get_pixel_size():
	var orbit_size = orbit.texture.get_size() 
	return (orbit_size * radius * get_child(0).get_child(1).scale.x).x;

func generate_random_sun_color() -> Color: 
	return Color(1, rand_range(0.8, 1), rand_range(0.4, 1), rand_range(0.6, 1))

func generateRandomPastelColor() -> Color:
	# Randomly generate numbers
	var red: float = rand_range(0, 1)
	var green: float = rand_range(0, 1)
	var blue: float = rand_range(0, 1)

	# Mix with light-blue
	var mixRed: float = 1 + 0xad / 256
	var mixGreen: float = 1 + 0xd8 / 256
	var mixBlue: float = 1 + 0xe6 / 256
	red = (red + mixRed) / 3
	green = (green + mixGreen) / 3
	blue = (blue + mixBlue) / 3
	return Color(red, green, blue, 1)

func init(var GM, var s_number : int, var n_type : int = 0):
	spawn_number = s_number
	game_manager = GM
	type = n_type
	#print("hi, I am at ", position, " my parent is ", get_parent().name)
	if(type == TYPES.DEFAULT):
		sphered_cube.visible = true;
		planet.modulate = generateRandomPastelColor()
		if(radius > 0.69):
			sphered_cube.texture = game_manager.planetsIcon[rand_range(0, game_manager.planetsIcon.size()-1)]
	elif(type == TYPES.SUN):
		planet.modulate = generate_random_sun_color()
		get_child(0).get_child(0).get_child(2).visible = true;
		get_child(0).get_child(0).get_child(2).modulate = planet.modulate
	elif(type == TYPES.BLACKHOLE):
		planet.modulate = Color(0.1,0.1,0.1,1)
		get_child(0).get_child(0).get_child(3).visible = true;
		get_child(0).get_child(0).get_child(3).modulate = Color(0.6,0.6,0.6,1)
			
	get_child(0).scale = Vector2(radius,radius)

func tombstone_enable(): 
	tombstone.visible = true
	pass

func _physics_process(delta):
	position += Vector2(0, -delta * move_speed);

func killPlayer(): 
	game_manager.PlayerDead()

func catchPlayer():
	audio_stream.play()
	print("play")
	player.catched(self)

func RelesePlayer():
	player = null

func _on_VisibilityNotifier2D_viewport_exited(viewport): 
	if(player != null):
		killPlayer()
	
func _on_TouchScreenButton_pressed():
	if hasTarget:
		pass

func _on_TouchScreenButton_released():
	#get_child(0).visible = false
	game_manager.PlanetWasTapped(self) 

func _on_OrbitArea_body_entered(body): 
	if(body.name == "PlayerShip" && player == null):
		player = body
		catchPlayer()

func _on_Planet_body_entered(body):
	if(body == player):
		killPlayer()
