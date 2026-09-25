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
		Vector2(lane_size.x  / 2.0, 0 + spawn_offset),
		Vector2(lane_size.x / 2.0, lane_size.y - target_offset)
	])

	$CenterLine.width = 1.0
	$CenterLine.default_color = Color.WHITE
	
	$HitIndicator.position = get_target_position()
	
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

func play_hit_visuals(hit_status: Constants.HitStatus) -> void:
	$HitIndicator.play("play")
	#spawn FX
	match hit_status:
		Constants.HitStatus.Perfect:
			#Perfect FX
			pass
		Constants.HitStatus.Good:
			#Good FX
			pass
		Constants.HitStatus.Miss:
			#Good FX
			pass

	
