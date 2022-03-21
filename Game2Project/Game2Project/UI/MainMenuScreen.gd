extends CanvasLayer

func _on_PlayButton_pressed():
	get_tree().change_scene("res://world/Level1.tscn")

func _on_QuitButton_pressed() -> void:
	get_tree().quit()
