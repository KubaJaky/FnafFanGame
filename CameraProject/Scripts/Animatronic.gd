extends StaticBody3D

@onready var move_cd = $MoveCD
@onready var attack_cd = $AttackCD
@onready var move_wait = $MoveWait

@onready var cam_monitor = $"../Monitor1"
@onready var body = $BonnieModel
@onready var guitar = $BonnieModel/Armature/Skeleton3D/Cube009/Cube009
@onready var animation_player = $BonnieModel/AnimationPlayer

@onready var pos_pupil_l = $BonnieModel/Armature/Skeleton3D/Icosphere020/PupilL
@onready var pos_pupil_r = $BonnieModel/Armature/Skeleton3D/Icosphere032/PupilR
@onready var pupil_l = $PupilL
@onready var pupil_r = $PupilR


@onready var position_names := ["Stage","DiningArea","Backstage","Arcade","WHall","LDoor1"]
@onready var bonnie_positions = $"../BonniePositions"
@onready var positions = bonnie_positions.get_children()

var PositionCameras = [0,1,2,3,7]
var CurrentPosition = 0

var ready_to_attack := false

var agression = 16

func _physics_process(delta):
	if ready_to_attack:
		if OfficeState.left_door_closed and !attack_cd.paused:
			attack_cd.set_paused(true)
		elif !OfficeState.left_door_closed and attack_cd.paused:
			attack_cd.set_paused(false)
			
	if CurrentPosition == positions.size() - 1:
		if OfficeState.flashlight_on and OfficeState.looking_left:
			body.visible = true
		else:
			body.visible = false
			
	pupil_l.global_position = pos_pupil_l.global_position
	pupil_r.global_position = pos_pupil_r.global_position

func _on_move_cd_timeout():
	print("Movement Opportunity")
	var move_chance = randi_range(1,20)
	if agression >= move_chance:
		if CurrentPosition == positions.size() - 1:
			move_cd.stop()
			ready_to_attack = true
			attack_cd.start()
		elif CurrentPosition == positions.size() - 2 and OfficeState.looking_left == true:
			pass
		else:
			var choose_room
			if CurrentPosition == 1:
				choose_room = randi_range(1,2)
			elif CurrentPosition == 2:
				choose_room = randi_range(-1, 1)
				if choose_room == 0:
					choose_room = -1
			else:
				choose_room = 1
			disrupt_camera(choose_room)
			CurrentPosition += choose_room
			move_wait.start()
			print(CurrentPosition, " / ", positions.size() - 1)
		
func _on_move_wait_timeout():
	move()
		
func move():
	print("Moved")
	if CurrentPosition != 0 and guitar.visible:
		guitar.visible = false
	global_position = positions[CurrentPosition].global_position
	rotation = positions[CurrentPosition].rotation
	animation_player.play(position_names[CurrentPosition])
	
func disrupt_camera(move):
	if OfficeState.in_cameras:
		if OfficeState.CurrentCamera == PositionCameras[CurrentPosition] or OfficeState.CurrentCamera == PositionCameras[CurrentPosition] + move:
			cam_monitor.lose_signal()
	
func jumpscare():
	print("Dead")

func _on_attack_cd_timeout():
	jumpscare()

