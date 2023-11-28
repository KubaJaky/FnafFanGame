extends StaticBody3D

@onready var move_cd = $MoveCD
@onready var attack_cd = $AttackCD
@onready var move_wait = $MoveWait
@onready var return_wait = $ReturnWait

@onready var player = $"../UI"
@onready var player_cam_anim = $"../Player/Camera3D/PlayerCamAnim"
@onready var fusebox_anim = $"../FuseBox/OpenClose"

@onready var cam_monitor = $"../Monitor1"
@onready var body = $FoxyModel
#@onready var body = $Body
@onready var animation_player = $FoxyModel/AnimationPlayer
@onready var state_anim = $StateAnim

@onready var pupil_l = $PupilL
@onready var pupil_r = $PupilR

@onready var start_position_names := ["Backstage","DiningArea"]
@onready var left_position_names := ["Arcade","WHall","LDoor1"]
@onready var right_position_names := ["Kitchen","EHall","LDoor1"]

@onready var foxy_choose_names = [left_position_names, right_position_names]
var position_names = []

@onready var foxy_positions_start = $"../FoxyPositions/FoxyPositionsStart".get_children()
@onready var foxy_positions_left = $"../FoxyPositions/FoxyPositionsLeft".get_children()
@onready var foxy_positions_right = $"../FoxyPositions/FoxyPositionsRight".get_children()

@onready var save = $"../Save"

@onready var foxy_choose_position = [foxy_positions_left, foxy_positions_right]
var chosen_position = 0

var positions = []

var StartPositionCameras = [2,1]
var LeftPositionCameras = [3,7]
var RightPositionCameras = [4,8]

var foxy_choose_cameras = [LeftPositionCameras, RightPositionCameras]

var PositionCameras = []
var CurrentPosition = 0

var was_seen := false
var ready_to_attack := false
var blinded := false

# Agression Chart
# 0 - night 1
# 0 - night 2
# 11 - night 3
# 13 - night 4
# 15 - night 5
# 17 - night 6

@export var agression :int
var base_agression :int

var insanity_inrease = 2

func _ready():
	if OfficeState.night_number == 7:
		agression = save.CustomFoxy
	base_agression = agression
	choose_route()
	global_position = positions[CurrentPosition].global_position
	rotation = positions[CurrentPosition].rotation
	animation_player.play(position_names[CurrentPosition])

func _physics_process(delta):
	if !OfficeState.in_jumpscare and !OfficeState.dead and !OfficeState.hour >= 6:
		if OfficeState.hour < 3:
			agression = base_agression - (8 + OfficeState.night_number)
		elif agression != base_agression:
			agression = base_agression
			
		if ready_to_attack:
			if chosen_position == 0:
				if OfficeState.looking_left and OfficeState.flashlight_on and !blinded and !attack_cd.paused:
					attack_cd.set_paused(true)
					blinded = true
					animation_player.play("Blinded")
					state_anim.play("BlindedState")
				elif OfficeState.left_door_closed and !blinded:
					OfficeState.left_door_closed = false
					jumpscare()
					
				if OfficeState.left_door_closed and blinded and !attack_cd.paused:
					attack_cd.set_paused(true)
					return_wait.set_paused(false)
				elif !OfficeState.left_door_closed  and blinded and attack_cd.paused:
					attack_cd.set_paused(false)
					return_wait.set_paused(true)
					
			elif chosen_position == 1:
				if OfficeState.looking_right and OfficeState.flashlight_on and !blinded and !attack_cd.paused:
					attack_cd.set_paused(true)
					blinded = true
					animation_player.play("Blinded")
					state_anim.play("BlindedState")
				elif OfficeState.right_door_closed and !blinded:
					OfficeState.right_door_closed = false
					jumpscare()
					
				if OfficeState.right_door_closed and blinded and !attack_cd.paused:
					attack_cd.set_paused(true)
					return_wait.set_paused(false)
				elif !OfficeState.left_door_closed  and blinded and attack_cd.paused:
					attack_cd.set_paused(false)
					return_wait.set_paused(true)
				
		if CurrentPosition == positions.size() - 1 and attack_cd.time_left > 0 and !OfficeState.in_jumpscare:
			if OfficeState.flashlight_on:
				if chosen_position == 0 and OfficeState.looking_left or chosen_position == 1 and OfficeState.looking_right:
					body.visible = true
					if chosen_position == 0 and !OfficeState.left_door_closed or chosen_position == 1 and !OfficeState.right_door_closed:
						if !was_seen:
							OfficeState.insanity += insanity_inrease * 10
							was_seen = true
							player.jumpscare_short.play()
							player.stinger_sound.play()
						else:
							OfficeState.insanity += insanity_inrease
			else:
				body.visible = false
			

func _on_move_cd_timeout():
	if !OfficeState.in_jumpscare and !OfficeState.dead and !OfficeState.hour >= 6:
		#print("Foxy - Movement Opportunity")
		var move_chance = randi_range(1,20)
		if agression >= move_chance:
			if CurrentPosition == positions.size() - 2 and chosen_position == 0 and OfficeState.looking_left == true or CurrentPosition == positions.size() - 2 and chosen_position == 0 and OfficeState.left_door_occupied == true or CurrentPosition == positions.size() - 2 and chosen_position == 0 and OfficeState.left_door_closed == true:
				if OfficeState.looking_left:
					print("Foxy - Blocked - Looking at door - ", CurrentPosition == positions.size() - 2 and OfficeState.looking_left == true)
				if OfficeState.left_door_occupied: 
					print("Foxy - Blocked - Door Occupied - ", CurrentPosition == positions.size() - 2 and OfficeState.left_door_occupied == true)
				if OfficeState.left_door_closed:
					print("Foxy - Blocked - Door Closed - ", CurrentPosition == positions.size() - 2 and OfficeState.left_door_closed == true)
					
			elif CurrentPosition == positions.size() - 2 and chosen_position == 1 and OfficeState.looking_right == true or CurrentPosition == positions.size() - 2 and chosen_position == 1 and OfficeState.right_door_occupied == true or CurrentPosition == positions.size() - 2 and chosen_position == 1 and OfficeState.right_door_closed == true:
				if OfficeState.looking_right:
					print("Foxy - Blocked - Looking at door - ", CurrentPosition == positions.size() - 2 and OfficeState.looking_right == true)
				if OfficeState.right_door_occupied: 
					print("Foxy - Blocked - Door Occupied - ", CurrentPosition == positions.size() - 2 and OfficeState.right_door_occupied == true)
				if OfficeState.right_door_closed:
					print("Foxy - Blocked - Door Closed - ", CurrentPosition == positions.size() - 2 and OfficeState.right_door_closed == true)
					
			else:
				var choose_room
				if CurrentPosition == 2:
					choose_room = randi_range(0,1)
					if choose_room == 0:
						choose_room = -1
						choose_route()
				else:
					choose_room = 1
				disrupt_camera(choose_room)
				CurrentPosition += choose_room
				move_wait.start()
				print("Foxy - ", CurrentPosition, " / ", positions.size() - 1)
		
func _on_move_wait_timeout():
	if !OfficeState.in_jumpscare and !OfficeState.dead and !OfficeState.hour >= 6:
		move()
		
func move():
	print("Foxy - Moved")
	if CurrentPosition == positions.size() - 1:
		move_cd.stop()
		ready_to_attack = true
		attack_cd.start()
		attack_cd.set_paused(false)
		if chosen_position == 0:
			OfficeState.left_door_occupied = true
		elif chosen_position == 1:
			OfficeState.right_door_occupied = true
		return_wait.start()
		return_wait.set_paused(true)
	global_position = positions[CurrentPosition].global_position
	rotation = positions[CurrentPosition].rotation
	animation_player.play(position_names[CurrentPosition])
	
func choose_route():
	chosen_position = randi_range(0,1)
	var new_positions = foxy_choose_position[chosen_position]
	var new_cameras = foxy_choose_cameras[chosen_position]
	var new_names = foxy_choose_names[chosen_position]
	positions.clear()
	positions.append_array(foxy_positions_start)
	positions.append_array(new_positions)
	PositionCameras.clear()
	PositionCameras.append_array(StartPositionCameras)
	PositionCameras.append_array(new_cameras)
	position_names.clear()
	position_names.append_array(start_position_names)
	position_names.append_array(new_names)
	
func blind_end():
	if chosen_position == 0:
		if OfficeState.left_door_closed:
			attack_cd.set_paused(false)
		else:
			jumpscare()
	elif chosen_position == 1:
		if OfficeState.right_door_closed:
			attack_cd.set_paused(false)
		else:
			jumpscare()
	
func disrupt_camera(move):
	if OfficeState.in_cameras:
		if CurrentPosition == PositionCameras.size() - 1 and move == 1:
			if OfficeState.CurrentCamera == PositionCameras[CurrentPosition]:
				cam_monitor.lose_signal()
		else:
			#print("Cameras Blocked: Cam", PositionCameras[CurrentPosition], ", Cam", PositionCameras[CurrentPosition + move])
			if OfficeState.CurrentCamera == PositionCameras[CurrentPosition] or OfficeState.CurrentCamera == PositionCameras[CurrentPosition + move]:
				cam_monitor.lose_signal()
	
func jumpscare():
	if !OfficeState.in_jumpscare and !OfficeState.dead and !OfficeState.hour >= 6:
		if OfficeState.in_cameras:
			OfficeState.in_cameras = false
			player_cam_anim.speed_scale = 2
			player_cam_anim.play_backwards("Zoom")
		if OfficeState.in_fusebox:
			OfficeState.in_fusebox = false
			fusebox_anim.speed_scale = 2
			fusebox_anim.play_backwards("OpenClose")
		if OfficeState.eyes_closed:
			player.eyes_anim.play_backwards("CloseEyes")
		if chosen_position == 0:
			player.CameraRotation = 90.1
		elif chosen_position == 1:
			player.CameraRotation = -90.1
		print("Foxy - Dead")
		OfficeState.in_jumpscare = true
		body.visible = true
		animation_player.speed_scale = 2
		state_anim.speed_scale = 2
		animation_player.play("Jumpscare")
		state_anim.play("JumpscareState")
		
func jumpscare_sound():
	player.jumpscare_sound.play()
				
func end_jumpscare():
	if !OfficeState.hour >= 6:
		player.load_static()

func _on_attack_cd_timeout():
	jumpscare()
	
func _on_return_wait_timeout():
	print("Foxy - Reset")
	attack_cd.stop()
	ready_to_attack = false
	if chosen_position == 0:
		OfficeState.left_door_occupied = false
	elif chosen_position == 1:
		OfficeState.right_door_occupied = false
	body.visible = true
	choose_route()
	CurrentPosition = 1
	was_seen = false
	blinded = false
	move_wait.start()
	disrupt_camera(0)
	move_cd.start()

