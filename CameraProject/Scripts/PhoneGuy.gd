extends Node

@onready var phone_call_6_1 = $"../UI/PhoneCall6_1"
@onready var phone_call_5_end = $"../UI/PhoneCall5End"
@onready var phone_call_skip = $"../UI/PhoneCallSkip"

@onready var phone_guy = get_tree().get_root().get_node("World/UI/PhoneGuy")

func next_call_6():
	phone_guy.play("PhoneCall_6_2")

func stop_audio():
	$"../PhoneCall".stop()
	$"../PhoneCall2".stop()
	$"../PhoneCall3".stop()
	$"../PhoneCall4".stop()
	$"../PhoneCall5".stop()
	$"../PhoneCall6_1".stop()
	$"../PhoneCall6_2".stop()
	$"../PhoneCall7".stop()
	
func hide_subtitle():
	$"../CallSubtitles".visible = false
	$"../CallSubtitles2".visible = false
	$"../CallSubtitles3".visible = false
	$"../CallSubtitles4".visible = false
	$"../CallSubtitles5".visible = false
	$"../CallSubtitles6".visible = false
	$"../CallSubtitles6_2".visible = false
	$"../CallSubtitles7".visible = false
	
func use():
	if phone_guy.is_playing():
		if phone_call_6_1.playing:
			phone_guy.play("Skip_PhoneCall_Night6")
		elif phone_call_5_end.playing or phone_call_skip.playing:
			return
		else:
			phone_guy.play("Skip_PhoneCall")
