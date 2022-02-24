extends KinematicBody
class_name player

export var move_speed = 15.0
export var DEADZONE = 0.2
export var rotate_speed = 3.0

func _process(_delta):
	process_movement()
	process_turning()
	
func process_movement():	
	var x_movement: float = Input.get_action_strength("moveDown") - Input.get_action_strength("moveUp")
	var z_movement: float = Input.get_action_strength("moveLeft") - Input.get_action_strength("moveRight")
	var motion: Vector3 = Vector3(x_movement , 0.0 , z_movement)
	
	if motion.length_squared() < DEADZONE*DEADZONE:
		motion = Vector3.ZERO
	if motion.length_squared() > 1.0:
		motion = motion.normalized()
	move_and_slide(motion * move_speed)
	
var look := Vector3.FORWARD
func process_turning():
	var x_look: float = Input.get_action_strength("lookDown") - Input.get_action_strength("lookUp")
	var z_look: float = Input.get_action_strength("lookLeft") - Input.get_action_strength("lookRight")
	var tlook: Vector3 = -Vector3(x_look , 0.0 , z_look)
	if look.length_squared() < DEADZONE*DEADZONE:
		look = tlook.normalized()
	
	var xBasis: = transform.basis.y.cross(look)
	
	transform.basis = Basis(xBasis, transform.basis.y, look).orthonormalized()
	
	
