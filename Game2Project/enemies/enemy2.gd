extends RigidBody

var path = []
var path_node = 0

var speed = 10

onready var nav = get_parent()
onready var player = $"../../Player"

func _ready():
	pass

func _physics_process(delta):
	if path_node < path.size():
		var direction = (path[path_node] - global_transform.origin)
		if direction.length() < 1:
			path_node += 1
		else:
			apply_central_impulse(direction.normalized() * speed)

func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node = 0

func _on_Timer_timeout():
	move_to(player.global_transform.origin)


func _on_enemy2_body_entered(body):
	print(body.to_string())
	queue_free()
