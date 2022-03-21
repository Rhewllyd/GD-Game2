extends CanvasLayer

onready var health_bar = $MarginContainer/Rows/TopRow/CenterContainer/HealthBar

func _on_Player_health_updated(health):
	health_bar.value -= 1

func _on_Player_playerhealed():
	health_bar.value = 6
