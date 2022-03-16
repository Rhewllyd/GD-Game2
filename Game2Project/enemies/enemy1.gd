extends KinematicBody

var path = []
var path_node = 0

var speed = 10

onready var nav = get_parent()
onready var player = $"../../Player"

func _ready():
	pass

# warning-ignore:unused_argument
func _physics_process(delta):
	if path_node < path.size():
		var direction = (path[path_node] - global_transform.origin)
		if direction.length() < 1:
			path_node += 1
		else:
# warning-ignore:return_value_discarded
			move_and_slide(direction.normalized() * speed, Vector3.UP, false, 4, 0.785, true)
			#move_and_slide(direction.normalized() * speed, Vector3.UP)
			
			for index in get_slide_count():
				var collision = get_slide_collision(index)
				if collision.collider.is_in_group("player"):
					print("enemy collided with player ", collision.collider.name)
				if collision.collider.is_in_group("bullet"):
					print("enemy collided with bullet ", collision.collider.name)

func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node = 0

func _on_Timer_timeout():
	move_to(player.global_transform.origin)


