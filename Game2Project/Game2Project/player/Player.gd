extends KinematicBody
class_name player

signal health_updated(health)
signal player_killed()

export var move_speed = 15.0
export var DEADZONE = 0.2
export var rotate_speed = 0.2


export (float) var max_health = 6

onready var health = max_health setget _set_health
onready var invuln_timer = $InvulnTimer

export(Resource) var bullet_resource
onready var bullet_scn : PackedScene = load(bullet_resource.resource_path)

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
# warning-ignore:return_value_discarded
	move_and_slide(motion * move_speed, Vector3.UP, false, 4, 0.785, true)
	
	#DETECT COLLISION
	for index in get_slide_count():
				var collision = get_slide_collision(index)
				if collision.collider.is_in_group("enemy"):
					#print("player collided with enemy(player)", collision.collider.name)
					damage_player(1)
					
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
		var b = bullet_scn.instance()
		b.transform = $MeshInstance/bulletSpawn.global_transform
		get_tree().root.add_child(b)
		b.fire()

func damage_player(amount):
	if invuln_timer.is_stopped():
		invuln_timer.start()
		_set_health(health - amount)
		print("PLAYER DAMAGED")

func kill_player():
	print("PLAYER KILLED")
	get_tree().change_scene("res://UI/GameOverScreen.tscn")

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			kill_player()
			emit_signal("player_killed")

