extends Button

@export var diffculty : Constants.Difficulty

func _on_pressed() -> void:
	$click.play()
	await $click.finished
	GameState.difficulty = diffculty
	get_tree().change_scene_to_file("res://scenes/game.tscn")
