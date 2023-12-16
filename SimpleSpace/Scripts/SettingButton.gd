extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	get_child(0).connect("pressed", self, "_on_pressed");
	pass # Replace with function body.

func _on_pressed():
	var node = get_parent().find_node("settings"); 
	node.visible = !node.visible;
	pass
