extends StaticBody3D

@onready var move_cd = $MoveCD
@onready var attack_cd = $AttackCD
@onready var move_wait = $MoveWait
@onready var return_wait = $ReturnWait

@onready var cam_monitor = $"../Monitor1"
#@onready var body = $BonnieModel
@onready var body = $Body
@onready var animation_player = $BonnieModel/AnimationPlayer
@onready var door_anim = $"../Endo/DoorAnim"

#@onready var pos_pupil_l = $BonnieModel/Armature/Skeleton3D/Icosphere020/PupilL
#@onready var pos_pupil_r = $BonnieModel/Armature/Skeleton3D/Icosphere032/PupilR
@onready var pupil_l = $PupilL
@onready var pupil_r = $PupilR

@onready var position_names := ["Stage","DiningArea","Backstage","Arcade","WHall","LDoor1"]
@onready var endo_positions = $"../EndoPositions"
@onready var positions = endo_positions.get_children()

var CurrentPosition = 0

var was_seen := false
var ready_to_attack := false

var agression = 20
var insanity_inrease = 1

func _physics_process(delta):
	if ready_to_attack:
		if OfficeState.left_door_closed and !attack_cd.paused:
			attack_cd.set_paused(true)
			return_wait.set_paused(false)
			print(return_wait.paused, " - ", return_wait.time_left)
		elif !OfficeState.left_door_closed and attack_cd.paused:
			attack_cd.set_paused(false)
			return_wait.set_paused(true)
			print(return_wait.paused, " - ", return_wait.time_left)
			
	if CurrentPosition == positions.size() - 1:
		if OfficeState.flashlight_on and OfficeState.looking_left and !OfficeState.left_door_closed:
			body.visible = true
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
	#print("Endo - Movement Opportunity")
	var move_chance = randi_range(1,20)
	if agression >= move_chance:
		if CurrentPosition == positions.size() - 2 and OfficeState.looking_left == true or CurrentPosition == positions.size() - 2 and OfficeState.left_door_occupied == true:
			print("Endo - Blocked")
			print("Endo - Looking at door - ", CurrentPosition == positions.size() - 2 and OfficeState.looking_left == true)
			print("Endo - Door Occupied - ", CurrentPosition == positions.size() - 2 and OfficeState.left_door_occupied == true)
		else:
			CurrentPosition += 1
			move_wait.start()
			print("Endo - ",CurrentPosition, " / ", positions.size() - 1)
		
func _on_move_wait_timeout():
	move()
		
func move():
	print("Endo - Moved")
	if CurrentPosition == positions.size() - 1:
			move_cd.stop()
			ready_to_attack = true
			OfficeState.left_door_occupied = true
			attack_cd.start()
			return_wait.start()
			return_wait.set_paused(true)
	global_position = positions[CurrentPosition].global_position
	rotation = positions[CurrentPosition].rotation
	animation_player.play(position_names[CurrentPosition])
	if CurrentPosition == 1:
		door_anim.play("DoorOpen")
	
func jumpscare():
	print("Endo - Dead")

func _on_attack_cd_timeout():
	jumpscare()

func _on_return_wait_timeout():
	print("Endo - Reset")
	attack_cd.stop()
	ready_to_attack = false
	OfficeState.left_door_occupied = false
	CurrentPosition = 0
	was_seen = false
	move_wait.start()
	door_anim.play("RESET")
	move_cd.start()
