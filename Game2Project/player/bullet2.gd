extends KinematicBody

export var speed = 25

func fire():
	#apply_impulse(-transform.basis.y, transform.basis.y * FORCE)
	move_and_slide(-transform.basis.y, transform.basis.y * speed)
	
func _on_Timer_timeout():
	queue_free()
