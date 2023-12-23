extends Control
var save_system
var main_music
var sound_slider
var music_slider

func set_sliders(ss):
	save_system = ss 
	main_music = get_parent().find_node("mainMusic")
	sound_slider = find_node("sound_slider")
	music_slider = find_node("music_slider")
	music_slider.value = save_system.music_volume
	sound_slider.value = save_system.sound_volume 
	pass

func _on_music_slider_value_changed(value):
	save_system.music_volume = value 
	main_music.volume_db = music_slider.value
	pass 

func _on_sound_value_changed(value):
	save_system.sound_volume = value 
	pass 

func _on_drag_ended(value_changed): 
	save_system.update_score() 
	pass
