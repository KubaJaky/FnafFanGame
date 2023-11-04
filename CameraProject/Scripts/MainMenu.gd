extends Node3D

@onready var menu_anim = $MenuAnim
@onready var bg_music = $UI/BGMusic

@onready var menu_freddy = $MenuFreddy
@onready var freddy_anim = menu_freddy.get_node("AnimationPlayer")
@onready var freddy_timer = $FreddyTimer

func start_menu():
	freddy_timer.start()

func _on_freddy_timer_timeout():
	var anim_id = randi_range(0,4)
	freddy_anim.play("MenuAction" + str(anim_id))
	
	var time = randi_range(2,5)
	freddy_timer.wait_time = time
	freddy_timer.start()


func _on_intro_finished():
	menu_anim.play("StartMenu")


func _on_bg_music_finished():
	bg_music.play()
