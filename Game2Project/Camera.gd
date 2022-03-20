extends Camera

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var move_speed = 15.0
export var DEADZONE = 0.2

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	process_movement() # Replace with function body.

func process_movement():	
	var z_movement := Input.get_action_strength("moveRight") - Input.get_action_strength("moveLeft")
	var x_movement := Input.get_action_strength("moveDown") - Input.get_action_strength("moveUp")
	var motion := Vector3(z_movement , 0.0 , x_movement)
	if motion.length_squared() <= DEADZONE*DEADZONE:
		motion = Vector3.ZERO
	elif motion.length_squared() > 1.0:
		motion = motion.normalized()
	move_and_slide(motion * move_speed)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
