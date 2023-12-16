extends Control 
var startPos :=  Vector2(340,0)
var endPos :=  Vector2(340,-3360)
var drop_value = 50
var pos = 0
var speed = 0.07
func _process(delta):
	pos += delta * speed 
	self.rect_position = startPos.linear_interpolate(endPos, pos)
	if self.rect_position.y < endPos.y:
		self.rect_position.y = startPos.y
		pos = 0


func _on_TouchScreenButton_released():
	get_parent().BackgroundWasTapped()
