extends AudioStreamPlayer


func _on_first_loop_done() -> void:
	stream = load("res://assets/music/music_menu_loop.wav")
	play()
