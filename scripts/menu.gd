extends Node2D


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		get_tree().paused = true
	elif what == NOTIFICATION_APPLICATION_FOCUS_IN:
		get_tree().paused = false
