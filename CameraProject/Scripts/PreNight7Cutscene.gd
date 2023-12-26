extends Control

@onready var transition = $Transition


func _on_background_finished():
	end_cutscene()
	
func end_cutscene():
	get_tree().change_scene_to_file("res://Scenes/CallCutsceneNight7.tscn")
