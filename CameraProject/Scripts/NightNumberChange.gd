extends Node3D

@export var night_number :int

func _ready():
	OfficeState.night_number = night_number
