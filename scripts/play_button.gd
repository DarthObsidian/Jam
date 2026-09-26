extends Button

func _on_pressed() -> void:
	$click.play()
	await $click.finished
	get_tree().change_scene_to_file("res://scenes/game.tscn")
