extends Control

 
func _ready():
	get_child(0).connect("pressed", self, "_on_pressed");
	pass 

func _on_pressed():
	#get_tree().change_scene("res://Scenes/main.tscn")
	get_parent().get_parent()._on_Start_Button_gui_input()  
	pass
