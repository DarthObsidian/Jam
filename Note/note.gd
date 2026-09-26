@tool
class_name Note
extends Node2D

var travel_time: float
var hit_time: float
var elapsed_time: float = 0.0
var spawn_time : float
var duration: float
var lane: Lane
var song_controller: SongController


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsed_time = song_controller.get_song_time_unscaled() - spawn_time

	var progress := elapsed_time / travel_time
	position = lerp(lane.get_spawn_position(), lane.get_target_position(), progress)

	if (position - lane.get_spawn_position()).length() >= lane.lane_size.y:
		queue_free()
		Signalbus.signal_miss.emit()


func setup(assigned_lane: Lane, song_controller_in: SongController, color: Color, hit_time_in: float, travel_time_in: float, duration_in: float) -> void:
	lane = assigned_lane
	song_controller = song_controller_in
	hit_time = hit_time_in 
	travel_time = travel_time_in
	duration = duration_in
	
	$Sprite2D.modulate = color
	
	spawn_time = song_controller.get_song_time_unscaled()
	position = lane.get_spawn_position()
	
