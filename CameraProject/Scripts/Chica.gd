extends StaticBody3D

@onready var move_cd = $MoveCD
@onready var attack_cd = $AttackCD
@onready var move_wait = $MoveWait
@onready var return_wait = $ReturnWait

@onready var cam_monitor = $"../Monitor1"
#@onready var body = $BonnieModel
@onready var body = $Body
@onready var cupcake = $BonnieModel/Armature/Skeleton3D/Cube009/Cube009
@onready var animation_player = $BonnieModel/AnimationPlayer

#@onready var pos_pupil_l = $BonnieModel/Armature/Skeleton3D/Icosphere020/PupilL
#@onready var pos_pupil_r = $BonnieModel/Armature/Skeleton3D/Icosphere032/PupilR
@onready var pupil_l = $PupilL
@onready var pupil_r = $PupilR


@onready var position_names := ["Stage","DiningArea","Bathrooms","Kitchen","EHall","Storage","RDoor1"]
@onready var chica_positions = $"../ChicaPositions"
@onready var positions = chica_positions.get_children()

var PositionCameras = [0,1,5,4,8,9]
var CurrentPosition = 0

var was_seen := false
var ready_to_attack := false

var agression = 0
var insanity_inrease = 0.5

func _physics_process(delta):
	if ready_to_attack:
		if OfficeState.right_door_closed and !attack_cd.paused:
			attack_cd.set_paused(true)
			return_wait.set_paused(false)
		elif !OfficeState.right_door_closed and attack_cd.paused:
			attack_cd.set_paused(false)
			return_wait.set_paused(true)
			
	if CurrentPosition == positions.size() - 1:
		if OfficeState.flashlight_on and OfficeState.looking_right:
			body.visible = true
			if !OfficeState.left_door_closed:
				if !was_seen:
					OfficeState.insanity += insanity_inrease * 10
					was_seen = true
				else:
					OfficeState.insanity += insanity_inrease
		else:
			body.visible = false
			
	#pupil_l.global_position = pos_pupil_l.global_position
	#pupil_r.global_position = pos_pupil_r.global_position

func _on_move_cd_timeout():
	#print("Chica - Movement Opportunity")
	var move_chance = randi_range(1,20)
	if agression >= move_chance:
		if CurrentPosition == positions.size() - 2 and OfficeState.looking_right == true or CurrentPosition == positions.size() - 2 and OfficeState.right_door_occupied == true:
			print("Chica - Blocked")
			print("Chica - Looking at door - ", CurrentPosition == positions.size() - 2 and OfficeState.looking_right == true)
			print("Chica - Door Occupied - ", CurrentPosition == positions.size() - 2 and OfficeState.right_door_occupied == true)
		else:
			var choose_room
			if CurrentPosition == 1 or CurrentPosition == 4:
				choose_room = randi_range(1,2)
			elif CurrentPosition == 2 or CurrentPosition == 5:
				choose_room = randi_range(-1, 1)
				if choose_room == 0:
					choose_room = -1
			else:
				choose_room = 1
			disrupt_camera(choose_room)
			CurrentPosition += choose_room
			move_wait.start()
			print("Chica - ", CurrentPosition, " / ", positions.size() - 1)
		
func _on_move_wait_timeout():
	move()
		
func move():
	print("Chica - Moved")
	if CurrentPosition == positions.size() - 1:
			move_cd.stop()
			ready_to_attack = true
			OfficeState.right_door_occupied = true
			attack_cd.start()
			attack_cd.set_paused(false)
			return_wait.start()
			return_wait.set_paused(true)
	if CurrentPosition != 0 and cupcake.visible:
		cupcake.visible = false
	global_position = positions[CurrentPosition].global_position
	rotation = positions[CurrentPosition].rotation
	#animation_player.play(position_names[CurrentPosition])
	
func disrupt_camera(move):
	if OfficeState.in_cameras:
		if CurrentPosition == PositionCameras.size() - 2 and move == 2 or CurrentPosition == PositionCameras.size() - 1 and move == 1:
			if OfficeState.CurrentCamera == PositionCameras[CurrentPosition]:
				cam_monitor.lose_signal()
		else:
			if OfficeState.CurrentCamera == PositionCameras[CurrentPosition] or OfficeState.CurrentCamera == PositionCameras[CurrentPosition + move]:
				cam_monitor.lose_signal()
	
func jumpscare():
	print("Chica - Dead")

func _on_attack_cd_timeout():
	jumpscare()
	
func _on_return_wait_timeout():
	print("Chica - Reset")
	attack_cd.stop()
	ready_to_attack = false
	OfficeState.right_door_occupied = false
	body.visible = true
	CurrentPosition = 1
	was_seen = false
	move_wait.start()
	disrupt_camera(0)
	move_cd.start()

