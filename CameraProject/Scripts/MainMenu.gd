extends Node3D

@onready var save = $Save

@onready var play_buttons = $UI/Menu/MarginContainer/VBoxContainer2/PlayButtons
@onready var misc_buttons = $UI/Menu/MarginContainer/VBoxContainer2/MiscButtons
@onready var night_buttons = $UI/Menu/MarginContainer/VBoxContainer2/NightSelect
@onready var reset_save_button = $UI/Menu/MarginContainer/Reset/ResetSave
@onready var skip_progress_bar = $UI/SkipMargin/VBoxContainer/HBoxContainer/SkipProgressBar

@onready var skip_progress = $SkipProgress
@onready var skip_timer = $SkipTimer

@onready var menu_anim = $MenuAnim
@onready var bg_music = $UI/BGMusic
@onready var hover_sound = $UI/Menu/Hover

@onready var menu_freddy = $MenuFreddy
@onready var freddy_anim = menu_freddy.get_node("AnimationPlayer")
@onready var freddy_timer = $FreddyTimer

@onready var bonnie_label = $UI/Menu/MarginContainer/CustomNight/AgressionSettings/TopRow/Bonnie/Value/Label
@onready var chica_label = $UI/Menu/MarginContainer/CustomNight/AgressionSettings/TopRow/Chica/Value/Label
@onready var freddy_label = $UI/Menu/MarginContainer/CustomNight/AgressionSettings/TopRow/Freddy/Value/Label
@onready var foxy_label = $UI/Menu/MarginContainer/CustomNight/AgressionSettings/TopRow/Foxy/Value/Label
@onready var endo_label = $UI/Menu/MarginContainer/CustomNight/AgressionSettings/BottomRow/Endo/Value/Label

var change_value := 0.2

var bonnie_change := 0.0
var chica_change := 0.0
var freddy_change := 0.0
var foxy_change := 0.0
var endo_change := 0.0

var bonnie_value := 0.0
var chica_value := 0.0
var freddy_value := 0.0
var foxy_value := 0.0
var endo_value := 0.0

var intro_playing = false
var show_skip = false
var skip_gone = true
var skip_progress_value :int = 0

func start_intro():
	intro_playing = true

func start_menu():
	save.UnlockNights()
	intro_playing = false
	freddy_timer.start()
				
func _process(delta):
	if Input.is_action_just_pressed("FullScreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
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
			
	bonnie_value += bonnie_change
	chica_value += chica_change
	freddy_value += freddy_change
	foxy_value += foxy_change
	endo_value += endo_change


		
	skip_progress_value = clamp(skip_progress_value, 0, 100)
	skip_progress_bar.value = skip_progress_value
	
	bonnie_value = clamp(bonnie_value, 0, 20)
	chica_value = clamp(chica_value, 0, 20)
	freddy_value = clamp(freddy_value, 0, 20)
	foxy_value = clamp(foxy_value, 0, 20)
	endo_value = clamp(endo_value, 0, 20)
	
	bonnie_label.text = str(int(bonnie_value))
	chica_label.text = str(int(chica_value))
	freddy_label.text = str(int(freddy_value))
	foxy_label.text = str(int(foxy_value))
	endo_label.text = str(int(endo_value))
	
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
	
func start_custom_night():
	pass



func _on_intro_finished():
	menu_anim.play("StartMenu")

func _on_bg_music_finished():
	bg_music.play()

func _on_new_game_pressed():
	remove_arrow(0)
	OfficeState.loading_night = 1
	menu_anim.play("LoadNight")
	
func _on_continue_pressed():
	remove_arrow(1)
	OfficeState.loading_night = save.get_night_continue()
	menu_anim.play("LoadNight")

func _on_night_select_pressed():
	remove_arrow(3)
	menu_anim.play("NightSelect")
	
func _on_custom_night_pressed():
	remove_arrow(4)
	menu_anim.play("CustomNight")
	
func _on_custom_night_back_pressed():
	menu_anim.play("CustomNightBack")
	
func _on_custom_night_start_pressed():
	save.load_custom_night(int(bonnie_value), int(chica_value), int(freddy_value), int(foxy_value), int(endo_value))
	OfficeState.loading_night = 7
	menu_anim.play("LoadNight")
	
func _on_back_pressed():
	menu_anim.play("NightSelectBack")
	
func _on_exit_pressed():
	get_tree().quit()

	
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
	OfficeState.loading_night = 6
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


func _on_reset_save_mouse_entered():
	reset_save_button.text = "• " + reset_save_button.text
	reset_save_button.add_theme_color_override("font_outline_color", "840000")
	hover_sound.play()

func _on_reset_save_mouse_exited():
	reset_save_button.text = reset_save_button.text.replace("• ", "")
	reset_save_button.add_theme_color_override("font_outline_color", "858585")

func _on_night_1_mouse_entered():
	if !night_buttons.get_child(0).disabled:
		add_arrow_night(0)

func _on_night_1_mouse_exited():
	if !night_buttons.get_child(0).disabled:
		remove_arrow_night(0)


func _on_night_2_mouse_entered():
	if !night_buttons.get_child(1).disabled:
		add_arrow_night(1)

func _on_night_2_mouse_exited():
	if !night_buttons.get_child(1).disabled:
		remove_arrow_night(1)


func _on_night_3_mouse_entered():
	if !night_buttons.get_child(2).disabled:
		add_arrow_night(2)

func _on_night_3_mouse_exited():
	if !night_buttons.get_child(2).disabled:
		remove_arrow_night(2)


func _on_night_4_mouse_entered():
	if !night_buttons.get_child(3).disabled:
		add_arrow_night(3)

func _on_night_4_mouse_exited():
	if !night_buttons.get_child(3).disabled:
		remove_arrow_night(3)


func _on_night_5_mouse_entered():
	if !night_buttons.get_child(4).disabled:
		add_arrow_night(4)

func _on_night_5_mouse_exited():
	if !night_buttons.get_child(4).disabled:
		remove_arrow_night(4)


func _on_night_6_mouse_entered():
	add_arrow_night(5)

func _on_night_6_mouse_exited():
	remove_arrow_night(5)


func _on_back_mouse_entered():
	add_arrow_night(7)

func _on_back_mouse_exited():
	remove_arrow_night(7)
	




func release_change():
	if bonnie_change != 0:
		bonnie_change = 0
	if chica_change != 0:
		chica_change = 0
	if freddy_change != 0:
		freddy_change = 0
	if foxy_change != 0:
		foxy_change = 0
	if endo_change != 0:
		endo_change = 0

func _on_lower_bonnie_button_down():
	if bonnie_value > 0:
		bonnie_change = -change_value

func _on_higher_bonnie_button_down():
	if bonnie_value < 20:
		bonnie_change = change_value
	
func _on_lower_chica_button_down():
	if chica_value > 0:
		chica_change = -change_value

func _on_higher_chica_button_down():
	if chica_value < 20:
		chica_change = change_value
	
	
func _on_lower_freddy_button_down():
	if freddy_value > 0:
		freddy_change = -change_value

func _on_higher_freddy_button_down():
	if freddy_value < 20:
		freddy_change = change_value
	

func _on_lower_foxy_button_down():
	if foxy_value > 0:
		foxy_change = -change_value

func _on_higher_foxy_button_down():
	if foxy_value < 20:
		foxy_change = change_value
	
	
func _on_lower_endo_button_down():
	if endo_value > 0:
		endo_change = -change_value

func _on_higher_endo_button_down():
	if endo_value < 20:
		endo_change = change_value


func _on_lower_bonnie_button_up():
	release_change()
	
func _on_higher_bonnie_button_up():
	release_change()
	
func _on_lower_chica_button_up():
	release_change()
	
func _on_higher_chica_button_up():
	release_change()
	
func _on_lower_freddy_button_up():
	release_change()
	
func _on_higher_freddy_button_up():
	release_change()
	
func _on_lower_foxy_button_up():
	release_change()
	
func _on_higher_foxy_button_up():
	release_change()
	
func _on_lower_endo_button_up():
	release_change()
	
func _on_higher_endo_button_up():
	release_change()
	
	
