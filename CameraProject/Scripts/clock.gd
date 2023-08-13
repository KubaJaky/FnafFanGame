extends StaticBody3D

@onready var hour_label = $SubViewport/ClockScreen/Hour

func _ready():
	update_hour()

func update_hour():
	if OfficeState.hour == 0:
		hour_label.text = "12:00"
	else:
		hour_label.text = str(OfficeState.hour)+":00"
