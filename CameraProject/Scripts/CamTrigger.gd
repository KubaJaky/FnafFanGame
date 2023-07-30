extends StaticBody3D

@export var CamNum = 0
@onready var UIMonitor = get_parent()

func use():
	if UIMonitor.Power and !UIMonitor.bluescreen:
		UIMonitor.CamMonitor.change_cam(CamNum)
