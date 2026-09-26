class_name MeasureBar
extends Node2D

var spawn_position: Vector2
var target_position: Vector2
var elapsed_time: float = 0.0
var travel_time: float = 2.0
var track: NoteTrack

func _process(delta: float) -> void:
	elapsed_time += delta

	var progress := elapsed_time / travel_time
	position = lerp(spawn_position, target_position, progress)

	if (position - spawn_position).length() >= track.get_track_size().y:
		queue_free()
		
func setup(track_in: NoteTrack, spawn_position_in: Vector2, target_position_in: Vector2, travel_time_in: float) -> void:
	track = track_in
	spawn_position = spawn_position_in 
	target_position = target_position_in
	travel_time = travel_time_in
	
	position = spawn_position
