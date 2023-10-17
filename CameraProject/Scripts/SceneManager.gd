extends AnimationPlayer

@onready var cutscene_head = $"../CutsceneHead"

func scene2():
	cutscene_head.stop()
	play("Scene2")
	
func scene3():
	play("Scene3")
