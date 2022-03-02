extends RigidBody

export var FORCE = 25

func fire():
	apply_impulse(-transform.basis.y, transform.basis.y * FORCE)

func _on_Timer_timeout():
	queue_free()
