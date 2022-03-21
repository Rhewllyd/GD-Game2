extends Node

const GameOverScreen = preload("res://UI/GameOverScreen.tscn")
const PauseScreen = preload("res://UI/PauseScreen.tscn")

func handle_player_win():
	var game_over = GameOverScreen.instance()
	add_child(game_over)
	game_over.set_title(true)
	get_tree().paused = true

func handle_player_lost():
	var game_over = GameOverScreen.instance()
	add_child(game_over)
	game_over.set_title(false)
	get_tree().paused = true

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		var pause_menu = PauseScreen.instance()
		add_child(pause_menu)


func _on_Player_gamewin():
	handle_player_win()
	
func _on_Player_gamelose():
	handle_player_lost()
