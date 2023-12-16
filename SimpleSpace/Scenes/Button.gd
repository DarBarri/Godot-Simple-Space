extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("pressed", self, "_on_pressed");
	pass # Replace with function body.

func _on_pressed():
	var node = find_parent("settings"); 
	node.visible = !node.visible;
	pass
