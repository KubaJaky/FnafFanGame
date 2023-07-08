extends Area3D

@onready var CamMonitor = $"../Monitor1"
@onready var AnimPlayer = $AnimationPlayer

var Power := false

func _physics_process(delta):
	if CamMonitor.Power and !Power:
		AnimPlayer.play("On-Off")
		Power = true
	elif !CamMonitor.Power and Power:
		AnimPlayer.play_backwards("On-Off")
		Power = false
