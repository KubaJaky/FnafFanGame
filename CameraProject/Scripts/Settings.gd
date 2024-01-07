extends MarginContainer

@onready var save = $"../../../../Save"

@onready var sfx_slider = $Categories/Audio/SFXSlider
@onready var music_slider = $Categories/Audio/MusicSlider
@onready var ambience_slider = $Categories/Audio/AmbienceSlider
@onready var call_slider = $Categories/Audio/CallSlider
@onready var cutscene_slider = $Categories/Audio/CutsceneSlider

@onready var sfx_try = $"../../Hover"
@onready var call_try = $"../../CallTry"
@onready var cutscene_try = $"../../CutsceneTry"

@onready var resolutions = [Vector2(1920,1080),Vector2(1600,900),Vector2(1366,768),Vector2(1280,720),Vector2(854,480),Vector2(640,360)]

@onready var resolution = $Categories/Graphics/Resolution
@onready var v_sync = $Categories/Graphics/VSync

@onready var world_environment = $"../../../../WorldEnvironment"
@onready var brightness_slider = $Categories/Graphics/BrightnessSlider
@onready var brightness_label = $Categories/Graphics/BrightnessLabel

@onready var volumetric_fog = $Categories/Graphics/VolumetricFog
@onready var shadows = $Categories/Graphics/Shadows

@onready var jumpscares = $Categories/Graphics/Jumpscares


func LoadSettings():
				
				
	world_environment.environment.set_adjustment_brightness(save.save.Brightness)
	resolution.selected = save.save.ResolutionId
	v_sync.button_pressed = DisplayServer.window_get_vsync_mode()
	volumetric_fog.button_pressed = save.save.VolFog
	shadows.button_pressed = save.save.Shadows
	brightness_slider.value = save.save.Brightness * 100
	brightness_label.text = str(snappedf(save.save.Brightness, 2.5))
	jumpscares.button_pressed = save.save.JumpscaresOn
	
	sfx_slider.value = save.save.SfxVolume * 10
	music_slider.value = save.save.MusicVolume * 10
	ambience_slider.value = save.save.AmbienceVolume * 10
	call_slider.value = save.save.CallVolume * 10
	cutscene_slider.value = save.save.CutsceneVolume * 10

func _on_resolution_item_selected(index):
	get_viewport().size = resolutions[index]
	DisplayServer.window_set_size(resolutions[index])
	DisplayServer.window_set_position(DisplayServer.screen_get_size()/8)
	
	save.save.ResolutionId = index


func _on_v_sync_toggled(button_pressed):
	if button_pressed:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func _on_brightness_slider_value_changed(value):
	save.save.Brightness = float(value)/100
	brightness_label.text = str(snappedf(float(value)/100, 0.1))
	world_environment.environment.set_adjustment_brightness(float(value)/100)

func _on_volumetric_fog_toggled(button_pressed):
	if button_pressed:
		save.save.VolFog = true
	else:
		save.save.VolFog = false


func _on_shadows_toggled(button_pressed):
	if button_pressed:
		save.save.Shadows = true
	else:
		save.save.Shadows = false
		
	

func _on_jumpscares_toggled(button_pressed):
	if button_pressed:
		save.save.JumpscaresOn = true
	else:
		save.save.JumpscaresOn = false



func _on_sfx_slider_value_changed(value):
	save.save.SfxVolume = float(value)/10
	AudioServer.set_bus_volume_db(1, float(value)/10)
	AudioServer.set_bus_volume_db(2, float(value)/10)
	AudioServer.set_bus_volume_db(3, float(value)/10)
	AudioServer.set_bus_volume_db(4, float(value)/10)
	

func _on_music_slider_value_changed(value):
	save.save.MusicVolume = float(value)/10
	AudioServer.set_bus_volume_db(6, float(value)/10)


func _on_ambience_slider_value_changed(value):
	save.save.AmbienceVolume = float(value)/10
	AudioServer.set_bus_volume_db(5, float(value)/10)
	
func _on_call_slider_value_changed(value):
	save.save.CallVolume = float(value)/10
	AudioServer.set_bus_volume_db(7, float(value)/10)
	
func _on_cutscene_slider_value_changed(value):
	save.save.CutsceneVolume = float(value)/10
	print(AudioServer.get_bus_index("Cutscenes")," - Cutscenes | Volume - ", AudioServer.get_bus_volume_db(8))
	AudioServer.set_bus_volume_db(8, float(value)/10)


func _on_sfx_slider_drag_ended(value_changed):
	sfx_try.play()


func _on_call_slider_drag_ended(value_changed):
	call_try.play()


func _on_cutscene_slider_drag_ended(value_changed):
	cutscene_try.play()

