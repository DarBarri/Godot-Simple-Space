extends Control

func _ready():
	get_child(0).connect("pressed", self, "_on_pressed");

func _on_pressed():
	get_tree().change_scene("res://Scenes/menu.tscn")
