extends KinematicBody2D

export (int) var speed = 600
var cur_speed = 0
var velocity = Vector2()
var isfly = false
var planet = null
var rotation_speed = 3.7
var rotation_dir = 1
var angle = 0
var score = 0
var GM
var offset_modifier : float = 0

func _ready():
	var bitmap = BitMap.new()
	var image = get_child(0).texture.get_data() 
	bitmap.create_from_image_alpha(image) 
	var polys_detailed = bitmap.opaque_to_polygons(Rect2(Vector2(0, 0), bitmap.get_size()))
	for polygon in polys_detailed:
		var collider = CollisionPolygon2D.new()
		collider.polygon = polygon
		add_child(collider)
		collider.position -= (get_child(0).texture.get_size() / 2) * get_child(0).transform.get_scale()
		# collider.scale = get_child(0).scale
	# print(get_child(2).polygon.size())
	# print(get_child_count())

func change_rotation_speed(var rotation_speed):
	self.rotation_speed = rotation_speed

func change_move_speed(var speed):
	self.speed = speed

var offset
func catched(var pl):
	var type = pl.type
	if(!pl.touched):
		score = pl.spawn_number
		GM.score_up(score)
		pl.touched = true
	isfly = false 
		
	match type:
		pl.TYPES.DEFAULT:
			offset_modifier = 0
			pass
		pl.TYPES.SUN:
			offset_modifier = 0.3
			pass
		pl.TYPES.BLACKHOLE:
			offset_modifier = -0.3
			pass
		
			
	if(self.transform.get_origin().x - pl.transform.get_origin().x > 0):
		rotation_dir = 1
		get_child(0).flip_v = false
		get_child(2).transform.rotated(0)
	else: 
		rotation_dir = -1
		get_child(0).flip_v = true
		get_child(2).transform.rotated(180)
	offset = Vector2((pl.get_pixel_size() - get_pixel_size()/2.5)/2, 0)
	angle = (self.transform.get_origin().angle_to_point(pl.transform.get_origin()))
	
	# print(pl.name)
	planet = pl 

func _physics_process(delta):
	if(isfly): 
		velocity = Vector2(transform.get_rotation(), cur_speed * rotation_dir).rotated(angle)
		move_and_slide(velocity)  
	elif(planet):
		offset += Vector2(offset_modifier,0)
		angle += (rotation_speed - planet.radius) * delta * rotation_dir 
		transform = planet.transform * Transform2D().rotated(angle).translated(offset)
		# transform = transform.scaled(Vector2(0.25,0.25))

func Release(): 
	if(planet):
		if(!get_child(1).is_on_screen()):
			Dead()
		planet.RelesePlayer()
		planet = null;
		isfly = true
	cur_speed = speed

func Dead():
	GM.PlayerDead()

func start():
	get_child(0).transform = get_child(0).transform.scaled(Vector2(0.4,0.4))
	get_child(1).transform = get_child(1).transform.scaled(Vector2(0.4,0.4))
	get_child(2).transform = get_child(2).transform.scaled(Vector2(0.3,0.3))
	var scene = get_parent().get_parent();
	get_parent().remove_child(self)
	scene.add_child(self)
	isfly = true
	cur_speed = speed

func get_pixel_size() -> float:
	var ship_size = get_child(0).texture.get_size() 
	return (ship_size * get_child(0).scale.x).x;


func _on_VisibilityNotifier2D_screen_exited():
	if(isfly):
		if(find_parent("Planet") == null):
			Dead() 
