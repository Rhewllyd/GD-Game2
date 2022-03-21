extends KinematicBody

var path = []
var path_node = 0

var speed = 10

onready var nav = get_parent()
onready var player = $"../../Player"
export (float) var max_health = 3
onready var health = max_health setget _set_health
onready var invuln_timer = $InvulnTimer

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
			move_and_slide(direction.normalized() * speed, Vector3.UP, false, 4, 0.785, false)
			#move_and_slide(direction.normalized() * speed, Vector3.UP)
			
			#DETECT COLLISION
			for index in get_slide_count():
				var collision = get_slide_collision(index)
				if collision.collider.is_in_group("bullet"):
					#print("enemy collided with bullet ", collision.collider.name)
					damage_enemy(1)
					

func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node = 0

func _on_Timer_timeout():
	move_to(player.global_transform.origin)

func damage_enemy(amount):
	if invuln_timer.is_stopped():
		invuln_timer.start()
		_set_health(health - amount)
		print("Enemy DAMAGED")

func kill_enemy():
	print("Enemy KILLED")
	queue_free()

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("enemy_health_updated", health)
		if health == 0:
			kill_enemy()
			emit_signal("enemy_killed")
