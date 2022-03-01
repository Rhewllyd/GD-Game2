extends KinematicBody
class_name player

export var move_speed = 15.0
export var DEADZONE = 0.2
export var rotate_speed = 0.2

func _process(_delta):
	process_movement()
	process_turning()
	process_fire()
	
func process_movement():	
	var z_movement := Input.get_action_strength("moveRight") - Input.get_action_strength("moveLeft")
	var x_movement := Input.get_action_strength("moveDown") - Input.get_action_strength("moveUp")
	var motion := Vector3(z_movement , 0.0 , x_movement)
	if motion.length_squared() <= DEADZONE*DEADZONE:
		motion = Vector3.ZERO
	elif motion.length_squared() > 1.0:
		motion = motion.normalized()
	move_and_slide(motion * move_speed)
	
var look := Vector3.FORWARD
func process_turning():
	var z_look: float = Input.get_action_strength("lookRight") - Input.get_action_strength("lookLeft")
	var x_look: float = Input.get_action_strength("lookDown") - Input.get_action_strength("lookUp")
	var tlook := -Vector3(z_look , 0.0 , x_look)
	if tlook.length_squared() > DEADZONE*DEADZONE:
		look = tlook.normalized()
	
	if is_equal_approx(transform.basis.z.dot(look), -1.0):
		look = transform.basis.x * sign(randf() - 0.5)
	
	var zBasis := look
	if not transform.basis.z.cross(look).is_equal_approx(Vector3.ZERO):
		zBasis = transform.basis.z.slerp(look, rotate_speed)
	var xBasis := transform.basis.y.cross(zBasis)
	
	transform.basis = Basis(xBasis, transform.basis.y, zBasis).orthonormalized()
	
func process_fire():
	if Input.is_action_just_pressed("fire"):
		print("fired")
	
	
