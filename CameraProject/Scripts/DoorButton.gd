extends StaticBody3D

@onready var PlayerCamera = $"../Player/Camera3D"
@onready var right_door_anim = $"../SecurityDoorRight/DoorAnim"
@onready var left_door_anim = $"../SecurityDoorLeft/DoorAnim"
@onready var button_anim = $ButtonAnim

@export var left = false

func _physics_process(delta):
	if !OfficeState.power_on:
		if OfficeState.left_door_closed and left:
			OfficeState.left_door_closed = false
			button_anim.play_backwards("PushButton")
			left_door_anim.play_backwards("Close")
		elif OfficeState.right_door_closed and !left:
			button_anim.play_backwards("PushButton")
			right_door_anim.play_backwards("Close")
			OfficeState.right_door_closed = false
			
func use():
	if left:
		if int(PlayerCamera.rotation_degrees.y) == 90:
			if !left_door_anim.is_playing() and OfficeState.power_on:
				if OfficeState.left_door_closed == false:
					button_anim.play("PushButton")
					left_door_anim.play("Close")
					OfficeState.left_door_closed = true
				else:
					button_anim.play_backwards("PushButton")
					left_door_anim.play_backwards("Close")
					OfficeState.left_door_closed = false
	else:
		if int(PlayerCamera.rotation_degrees.y) == -90:
			if !right_door_anim.is_playing() and OfficeState.power_on:
				if OfficeState.right_door_closed == false:
					button_anim.play("PushButton")
					right_door_anim.play("Close")
					OfficeState.right_door_closed = true
				else:
					button_anim.play_backwards("PushButton")
					right_door_anim.play_backwards("Close")
					OfficeState.right_door_closed = false
					
