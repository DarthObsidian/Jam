@tool
class_name Note
extends Node2D

var travel_beats: float
var hit_beat: float
var elapsed_beats: float = 0.0
var spawn_beat : float
var duration: float
var lane: Lane
var song_controller: SongController

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_beat = song_controller.get_song_beat()

	var progress : float = (current_beat - spawn_beat) / travel_beats
	clamp(progress, 0.0, 1.5)
	position = lerp(lane.get_spawn_position(), lane.get_target_position(), progress)

	if (position - lane.get_spawn_position()).length() >= lane.lane_size.y:
		queue_free()
		Signalbus.signal_miss.emit()


func setup(assigned_lane: Lane, song_controller_in: SongController, color: Color, hit_beat_in: float, travel_beat_in: float, duration_in: float) -> void:
	lane = assigned_lane
	song_controller = song_controller_in
	hit_beat = hit_beat_in 
	travel_beats = travel_beat_in
	duration = duration_in
	
	$Sprite2D.modulate = color
	
	spawn_beat = hit_beat - travel_beats
	print("Spawn: ", spawn_beat, " Hit: ", hit_beat, " Travel: ", travel_beats)
	position = lane.get_spawn_position()
	
