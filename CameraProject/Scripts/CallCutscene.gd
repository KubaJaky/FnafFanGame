extends Control
@onready var background = $Background

@onready var transition = $Transition

func fade_in():
	transition.play("Transition")
	
func fade_out():
	transition.play_backwards("Transition")

func _on_background_finished():
	background.play()
	
func end_cutscene():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
