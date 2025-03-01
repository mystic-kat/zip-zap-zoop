extends TouchScreenButton

@onready var knob = get_node("../Joystick_Knob")
@onready var player = get_node("/root/Main/Player")

var joystick_vector = Vector2.ZERO

func _process(delta):
	if joystick_vector.length() > 0:
		player.direction = joystick_vector.normalized()

func _on_Joystick_Button_gui_input(event):
	if event is InputEventScreenDrag:
		joystick_vector = (event.position - knob.position).normalized()
