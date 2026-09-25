@tool
class_name Lane
extends Node2D

@export var lane_size  := Vector2(100.0, 500.0)
var spawn_offset: float
var target_offset: float

func setup(top_offset: float, bottom_offset: float) -> void:
	spawn_offset = top_offset
	target_offset = bottom_offset
	$CenterLine.points = PackedVector2Array([
		Vector2(lane_size.x  / 2.0, 0),
		Vector2(lane_size.x / 2.0, lane_size.y)
	])

	$CenterLine.width = 1.0
	$CenterLine.default_color = Color.WHITE
	
func get_spawn_position() -> Vector2:
	return Vector2(
		lane_size .x / 2.0,
		spawn_offset
	)


func get_target_position() -> Vector2:
	return Vector2(
		lane_size .x / 2.0,
		lane_size .y - target_offset
	)
