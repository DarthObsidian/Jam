class_name MeasureBar
extends Node2D

var spawn_position: Vector2
var target_position: Vector2
var elapsed_beats: float = 0.0
var travel_beats: float = 2.0
var track: NoteTrack
var song_controller: SongController
var spawn_beat : float

func _process(delta: float) -> void:
	elapsed_beats = song_controller.get_song_beat() - spawn_beat

	var progress := elapsed_beats / travel_beats
	position = lerp(spawn_position, target_position, progress)

	if (position - spawn_position).length() >= track.get_track_size().y:
		queue_free()
		
func setup( song_controller_in: SongController, track_in: NoteTrack, spawn_position_in: Vector2, target_position_in: Vector2, travel_beats_in: float) -> void:
	song_controller = song_controller_in
	track = track_in
	spawn_position = spawn_position_in 
	target_position = target_position_in
	travel_beats = travel_beats_in
	spawn_beat = song_controller.get_song_beat()
	position = spawn_position
