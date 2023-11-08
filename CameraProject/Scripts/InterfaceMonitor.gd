extends Area3D

@onready var CamMonitor = $"../Monitor1"
@onready var AnimPlayer = $AnimationPlayer
@onready var hour_label = $SubViewport/TVScreen/Hour
@onready var date_label = $SubViewport/TVScreen/Date
@onready var cpu_label = $SubViewport/TVScreen/CPUTemp
@onready var usage_bar = $SubViewport/TVScreen/UsageProgress
@onready var power_left = $SubViewport/TVScreen/PowerLeft

var dates = [
	"28 Jun
	Mon",
	
	"29 Jun
	Tue",
	
	"30 Jun
	Wed",
	
	"31 Jun
	Thu",
	
	"1 Jul
	Fri",
	
	"12 Apr
	Sat",
	
	"7 Aug
	Wed",
]

var Power := false
var bluescreen := false

func _ready():
	update_hour()
	update_cpu()
	

func _physics_process(delta):
	if !CamMonitor.bluescreen:
		if CamMonitor.Power and !Power:
			AnimPlayer.play("On-Off")
			Power = true
		elif !CamMonitor.Power and Power:
			AnimPlayer.play_backwards("On-Off")
			Power = false
	else:
		if !bluescreen:
			bluescreen = true
			AnimPlayer.play("Bluescreen")
	
	usage_bar.value = OfficeState.power_usage
	power_left.text = "Power: " + str(int(OfficeState.power_left)) + "%"

func update_hour():
	if OfficeState.hour == 0:
		hour_label.text = "12AM"
	else:
		hour_label.text = str(OfficeState.hour) + "AM"
		
func update_cpu():
	cpu_label.text = "CPU: " + str(int(OfficeState.cpu_temp)) + "°F"
	if int(OfficeState.cpu_temp) >= 180:
		cpu_label.self_modulate = "ff0000"
	elif int(OfficeState.cpu_temp) >= 160:
		cpu_label.self_modulate = "ffe100"
	elif int(OfficeState.cpu_temp) < 160:
		cpu_label.self_modulate = "ffffff"

func _on_cpu_update_timeout():
	update_cpu()
	
func end_bluescreen():
	bluescreen = false

func _on_date_timer_timeout():
	date_label.text = dates[OfficeState.night_number-1]
