extends MarginContainer

@onready var save = $"../../../../Save"

@onready var sfx_slider = $Categories/Audio/SFXSlider
@onready var music_slider = $Categories/Audio/MusicSlider
@onready var ambience_slider = $Categories/Audio/AmbienceSlider
@onready var call_slider = $Categories/Audio/CallSlider
@onready var cutscene_slider = $Categories/Audio/CutsceneSlider


@onready var resolutions = [Vector2(1920,1080),Vector2(1600,900),Vector2(1366,768),Vector2(1280,720),Vector2(854,480),Vector2(640,360)]

@onready var resolution = $Categories/Graphics/Resolution
@onready var v_sync = $Categories/Graphics/VSync

@onready var world_environment = $"../../../../WorldEnvironment"
@onready var brightness_slider = $Categories/Graphics/BrightnessSlider
@onready var brightness_label = $Categories/Graphics/BrightnessLabel

@onready var volumetric_fog = $Categories/Graphics/VolumetricFog
@onready var shadows = $Categories/Graphics/Shadows


func LoadSettings():
	DisplayServer.window_set_size(resolutions[save.save.ResolutionId])
	
	
	if save.save.Fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	
	if DisplayServer.window_get_vsync_mode() == 1:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		
	AudioServer.set_bus_volume_db(1, save.save.SfxVolume)
	AudioServer.set_bus_volume_db(2, save.save.SfxVolume)
	AudioServer.set_bus_volume_db(3, save.save.SfxVolume)
	AudioServer.set_bus_volume_db(4, save.save.SfxVolume)
	AudioServer.set_bus_volume_db(5, save.save.AmbienceVolume)
	AudioServer.set_bus_volume_db(6, save.save.MusicVolume)
	AudioServer.set_bus_volume_db(7, save.save.CallVolume)
	AudioServer.set_bus_volume_db(8, save.save.CutsceneVolume)
				
				
	resolution.selected = save.save.ResolutionId
	v_sync.button_pressed = DisplayServer.window_get_vsync_mode()
	volumetric_fog.button_pressed = save.save.VolFog
	shadows.button_pressed = save.save.Shadows
	brightness_slider.value = save.save.Brightness * 100
	brightness_label.text = str(snappedf(save.save.Brightness, 2.5))
	
	sfx_slider.value = save.save.SfxVolume * 10
	music_slider.value = save.save.MusicVolume * 10
	ambience_slider.value = save.save.AmbienceVolume * 10
	call_slider.value = save.save.CallVolume * 10
	cutscene_slider.value = save.save.CutsceneVolume * 10

func _on_resolution_item_selected(index):
	get_viewport().size = resolutions[index]
	DisplayServer.window_set_size(resolutions[index])
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



func _on_sfx_slider_drag_ended(value_changed):
	save.save.SfxVolume = float(value_changed)/10
	AudioServer.set_bus_volume_db(1, float(value_changed)/10)
	AudioServer.set_bus_volume_db(2, float(value_changed)/10)
	AudioServer.set_bus_volume_db(3, float(value_changed)/10)
	AudioServer.set_bus_volume_db(4, float(value_changed)/10)
	
func _on_music_slider_drag_ended(value_changed):
	save.save.MusicVolume = float(value_changed)/10
	AudioServer.set_bus_volume_db(6, float(value_changed)/10)

func _on_ambience_slider_drag_ended(value_changed):
	save.save.AmbienceVolume = float(value_changed)/10
	AudioServer.set_bus_volume_db(6, float(value_changed)/10)
	
func _on_call_slider_drag_ended(value_changed):
	save.save.CallVolume = float(value_changed)/10
	AudioServer.set_bus_volume_db(7, float(value_changed)/10)
	
func _on_cutscene_slider_drag_ended(value_changed):
	save.save.CutsceneVolume = float(value_changed)/10
	AudioServer.set_bus_volume_db(8, float(value_changed)/10)

