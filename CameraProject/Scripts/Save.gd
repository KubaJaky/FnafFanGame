extends Node2D

var save = {
	"BestNight":0,
	"FiveTwenty":false,
	"SfxVolume":0.0,
	"MusicVolume":0.0,
	"AmbienceVolume":0.0,
	"CallVolume":0.0,
	"CutsceneVolume":0.0,
	"ResolutionId":0,
	"VSync":false,
	"Fullscreen":false,
	"Brightness":1.0,
	"VolFog":true,
	"Shadows":true,
	"CustomBonnie":0,
	"CustomChica":0,
	"CustomFreddy":0,
	"CustomFoxy":0,
	"CustomEndo":0,
	"ResetSave":false
}

var in_menu := false
var in_game := true

# do not try to save in _ready, it doesn't work
func _ready():
	if save.ResetSave == true:
		save_data()
	print("1")
	print(save)
	load_data()
	print("2")
	print(save)
	

# saves everyhing in the "save" variable
func save_data():
	var file = FileAccess.open("user://save.dat", FileAccess.WRITE)
	if file == null:
		print(FileAccess.get_open_error())
		return
	var data = save
	var json_string = JSON.stringify(data, "\t")
	file.store_var(save)
	file.close()
	
# and load
func load_data():
	if FileAccess.file_exists("user://save.dat"):
		var file = FileAccess.open("user://save.dat", FileAccess.READ)
		if file == null:
			print(FileAccess.get_open_error())
			return
			
		save = file.get_var()
		print(save)
		file.close()
	
func UnlockNights():
	var night_select = $"../UI/Menu/MarginContainer/VBoxContainer2/NightSelect"
	var id = 0
	for night in night_select.get_children():
		if id < 6:
			if id <= save.BestNight:
				print("Unlocked Night ", id + 1)
				night.visible = true
				night.disabled = false
			id += 1
	var custom_night = $"../UI/Menu/MarginContainer/VBoxContainer2/PlayButtons/CustomNight"
	if 6 <= save.BestNight:
		print("Unlocked Custom Night")
		custom_night.visible = true
		custom_night.disabled = false
		
func UnlockAchievements():
	var badges = $"../UI/Menu/MarginContainer/Achievements"
	if 5 <= save.BestNight:
		badges.get_child(0).visible = true
	if 6 <= save.BestNight:
		badges.get_child(1).visible = true
	if 7 <= save.BestNight:
		badges.get_child(2).visible = true
	if save.FiveTwenty == true:
		badges.get_child(3).visible = true
		
func get_night_continue():
	if save.BestNight < 6:
		return save.BestNight + 1
	else:
		return 6
	
func CheckNight():
	if OfficeState.night_number > save.BestNight:
		save.BestNight = OfficeState.night_number
		print(save.BestNight)
		save_data()
		
func load_custom_night(bonnie, chica, freddy, foxy, endo):
	save.CustomBonnie = bonnie
	save.CustomChica = chica
	save.CustomFreddy = freddy
	save.CustomFoxy = foxy
	save.CustomEndo = endo
	save_data()
		
func FiveTwentyBeaten():
	if OfficeState.max_agression:
		save.FiveTwenty = true
		save_data()
		

