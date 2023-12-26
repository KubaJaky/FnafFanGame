extends Control

@onready var transition = $Transition
@onready var subtitles_anim = $SubtitlesAnim


func credits():
	transition.play("Credits")
	
func subtitles():
	subtitles_anim.play("Subtitles")
	
func end_cutscene():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
