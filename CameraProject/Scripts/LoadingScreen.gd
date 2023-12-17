extends Control

@onready var transition = $Transition
@onready var progress_bar = $ProgressBar

var progress = []
var sceneName
var scene_load_status = 0

var loading_scene := false

func _ready():
	OfficeState.reset()
	sceneName = "res://Scenes/Night" + str(OfficeState.loading_night) + ".tscn"
	ResourceLoader.load_threaded_request(sceneName)
	transition.play_backwards("Fade")
	get_node("BGNoise" + str(randi_range(1,3))).play()
	
func _process(delta):
	scene_load_status = ResourceLoader.load_threaded_get_status(sceneName, progress)
	progress_bar.value = floor(progress[0]*100)
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED and !loading_scene:
		loading_scene = true
		transition.play("Fade")
		
	if Input.is_action_just_pressed("FullScreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func load_scene():
	if loading_scene:
		var newScene = ResourceLoader.load_threaded_get(sceneName)
		get_tree().change_scene_to_packed(newScene)

func play_new_noise( played :int):
	var noise_id = randi_range(1,3)
	while noise_id == played:
		noise_id = randi_range(1,3)
	get_node("BGNoise" + str(noise_id)).play()
	
func _on_bg_noise_1_finished():
	play_new_noise(1)
func _on_bg_noise_2_finished():
	play_new_noise(2)
func _on_bg_noise_3_finished():
	play_new_noise(3)
