extends Node2D 
var startPos :=  Vector2(340,0)
var endPos :=  Vector2(340,-3360)
var drop_value = 50
var pos = 0
var speed = 0.07
func _process(delta):
	pos += delta * speed 
	self.position = startPos.linear_interpolate(endPos, pos)
	if self.position.y < endPos.y:
		self.position.y = startPos.y
		pos = 0
