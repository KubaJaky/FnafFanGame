extends Node3D

@onready var play_buttons = $UI/Menu/MarginContainer/VBoxContainer2/PlayButtons
@onready var misc_buttons = $UI/Menu/MarginContainer/VBoxContainer2/MiscButtons
@onready var night_buttons = $UI/Menu/MarginContainer/VBoxContainer2/NightSelect
@onready var skip_progress_bar = $UI/SkipMargin/VBoxContainer/HBoxContainer/SkipProgressBar

@onready var skip_progress = $SkipProgress
@onready var skip_timer = $SkipTimer

@onready var menu_anim = $MenuAnim
@onready var bg_music = $UI/BGMusic
@onready var hover_sound = $UI/Menu/Hover

@onready var menu_freddy = $MenuFreddy
@onready var freddy_anim = menu_freddy.get_node("AnimationPlayer")
@onready var freddy_timer = $FreddyTimer

var intro_playing = false
var show_skip = false
var skip_gone = true
var skip_progress_value :int = 0

func start_intro():
	intro_playing = true

func start_menu():
	intro_playing = false
	freddy_timer.start()
				
func _process(delta):
	if intro_playing:
		if Input.is_action_just_pressed("CalmDown"):
			if !show_skip and skip_gone:
				show_skip = true
				skip_gone = false
				skip_timer.start()
				skip_progress.play("Appear")
		if Input.is_action_pressed("CalmDown"):
			if show_skip:
				skip_progress_value += 1
				
		if !Input.is_action_pressed("CalmDown") and skip_progress_value > 0:
			skip_progress_value -= 4
			
		if skip_progress_value <= 0 and show_skip and skip_gone:
			show_skip = false
			skip_progress.play_backwards("Appear")
			
		if skip_progress_value == 100 and show_skip:
			skip()
		
	skip_progress_value = clamp(skip_progress_value, 0, 100)
	skip_progress_bar.value = skip_progress_value
	
func _on_skip_timer_timeout():
	skip_gone = true
				
				
func skip():
	intro_playing = false
	menu_anim.play("Skip")

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



func _on_night_select_pressed():
	remove_arrow(3)
	menu_anim.play("NightSelect")
	
func _on_back_pressed():
	menu_anim.play("NightSelectBack")

	
# Night Select

func loading_night():
	get_tree().change_scene_to_file("res://Scenes/LoadingScreen.tscn")
	
func _on_night_1_pressed():
	OfficeState.loading_night = 1
	menu_anim.play("LoadNight")
	
func _on_night_2_pressed():
	OfficeState.loading_night = 2
	menu_anim.play("LoadNight")
	
func _on_night_3_pressed():
	OfficeState.loading_night = 3
	menu_anim.play("LoadNight")
	
func _on_night_4_pressed():
	OfficeState.loading_night = 4
	menu_anim.play("LoadNight")
	
func _on_night_5_pressed():
	OfficeState.loading_night = 5
	menu_anim.play("LoadNight")
	
func _on_night_6_pressed():
	OfficeState.loading_night = 5
	menu_anim.play("LoadNight")
	
	

func add_arrow(button_id):
	play_buttons.get_child(button_id).text = ">" + play_buttons.get_child(button_id).text
	hover_sound.play()
	
func remove_arrow(button_id):
	play_buttons.get_child(button_id).text = play_buttons.get_child(button_id).text.replace(">", "")
	
	
func add_arrow_night(button_id):
	night_buttons.get_child(button_id).text = ">" + night_buttons.get_child(button_id).text
	hover_sound.play()
	
func remove_arrow_night(button_id):
	night_buttons.get_child(button_id).text = night_buttons.get_child(button_id).text.replace(">", "")
	
	
func _on_new_game_mouse_entered():
	add_arrow(0)

func _on_new_game_mouse_exited():
	remove_arrow(0)


func _on_continue_mouse_entered():
	add_arrow(1)

func _on_continue_mouse_exited():
	remove_arrow(1)


func _on_night_select_mouse_entered():
	add_arrow(3)

func _on_night_select_mouse_exited():
	remove_arrow(3)


func _on_custom_night_mouse_entered():
	add_arrow(4)

func _on_custom_night_mouse_exited():
	remove_arrow(4)


func _on_settings_mouse_entered():
	misc_buttons.get_child(0).text = ">" + misc_buttons.get_child(0).text
	hover_sound.play()

func _on_settings_mouse_exited():
	misc_buttons.get_child(0).text = misc_buttons.get_child(0).text.replace(">", "")


func _on_exit_mouse_entered():
	misc_buttons.get_child(1).text = ">" + misc_buttons.get_child(1).text
	hover_sound.play()

func _on_exit_mouse_exited():
	misc_buttons.get_child(1).text = misc_buttons.get_child(1).text.replace(">", "")



func _on_night_1_mouse_entered():
	add_arrow_night(0)

func _on_night_1_mouse_exited():
	remove_arrow_night(0)


func _on_night_2_mouse_entered():
	add_arrow_night(1)

func _on_night_2_mouse_exited():
	remove_arrow_night(1)


func _on_night_3_mouse_entered():
	add_arrow_night(2)

func _on_night_3_mouse_exited():
	remove_arrow_night(2)


func _on_night_4_mouse_entered():
	add_arrow_night(3)

func _on_night_4_mouse_exited():
	remove_arrow_night(3)


func _on_night_5_mouse_entered():
	add_arrow_night(4)

func _on_night_5_mouse_exited():
	remove_arrow_night(4)


func _on_night_6_mouse_entered():
	add_arrow_night(5)

func _on_night_6_mouse_exited():
	remove_arrow_night(5)


func _on_back_mouse_entered():
	add_arrow_night(7)

func _on_back_mouse_exited():
	remove_arrow_night(7)

