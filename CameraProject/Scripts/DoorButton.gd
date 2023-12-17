extends StaticBody3D

@onready var PlayerCamera = $"../Player/Camera3D"
@onready var right_door_anim = $"../SecurityDoorRight/DoorAnim"
@onready var right_close_sound = $"../SecurityDoorRight/DoorClose"
@onready var right_pre_close_sound = $"../SecurityDoorRight/DoorPreClose"
@onready var right_open_sound = $"../SecurityDoorRight/DoorOpen"
@onready var left_door_anim = $"../SecurityDoorLeft/DoorAnim"
@onready var left_pre_close_sound = $"../SecurityDoorLeft/DoorPreClose"
@onready var left_close_sound = $"../SecurityDoorLeft/DoorClose"
@onready var left_open_sound = $"../SecurityDoorLeft/DoorOpen"
@onready var button_anim = $ButtonAnim
@onready var button_sound = $ButtonSound
@onready var omni_light_3d = $OmniLight3D

@onready var close_delay_left = Timer.new()
@onready var close_delay_right = Timer.new()

@export var left = false

func _ready():
	close_delay_left.connect("timeout", Callable(self, "left_close_door_sound"))
	close_delay_right.connect("timeout", Callable(self, "right_close_door_sound"))
	close_delay_left.one_shot = true
	close_delay_right.one_shot = true
	close_delay_left.wait_time = 0.2
	close_delay_right.wait_time = 0.2
	add_child(close_delay_left)
	add_child(close_delay_right)

func _physics_process(delta):
	if !OfficeState.power_on:
		if OfficeState.left_door_closed and left:
			OfficeState.left_door_closed = false
			button_anim.play_backwards("PushButton")
			button_sound.pitch_scale = 0.9
			button_sound.play()
			left_door_anim.play_backwards("Close")
			left_open_sound.play()
			OfficeState.power_usage -= 1
		elif OfficeState.right_door_closed and !left:
			button_anim.play_backwards("PushButton")
			button_sound.pitch_scale = 0.9
			button_sound.play()
			right_door_anim.play_backwards("Close")
			right_open_sound.play()
			OfficeState.right_door_closed = false
			OfficeState.power_usage -= 1
			
func use():
	if left:
		if int(PlayerCamera.rotation_degrees.y) == 90:
			if !left_door_anim.is_playing() and OfficeState.power_on:
				if OfficeState.left_door_closed == false:
					button_anim.play("PushButton")
					button_sound.pitch_scale = 1
					button_sound.play()
					left_door_anim.play("Close")
					left_pre_close_sound.play()
					close_delay_left.start()
					OfficeState.left_door_closed = true
					OfficeState.power_usage += 1
				else:
					button_anim.play_backwards("PushButton")
					button_sound.pitch_scale = 0.9
					button_sound.play()
					left_door_anim.play_backwards("Close")
					left_open_sound.play()
					OfficeState.left_door_closed = false
					OfficeState.power_usage -= 1
	else:
		if int(PlayerCamera.rotation_degrees.y) == -90:
			if !right_door_anim.is_playing() and OfficeState.power_on:
				if OfficeState.right_door_closed == false:
					button_anim.play("PushButton")
					button_sound.pitch_scale = 1
					button_sound.play()
					right_door_anim.play("Close")
					right_pre_close_sound.play()
					close_delay_right.start()
					OfficeState.right_door_closed = true
					OfficeState.power_usage += 1
				else:
					button_anim.play_backwards("PushButton")
					button_sound.pitch_scale = 0.9
					button_sound.play()
					right_door_anim.play_backwards("Close")
					right_open_sound.play()
					OfficeState.right_door_closed = false
					OfficeState.power_usage -= 1
					
func left_close_door_sound():
	left_close_sound.play()
	
func right_close_door_sound():
	right_close_sound.play()
	
func turn_off_shadow():
	omni_light_3d.shadow_enabled = false
