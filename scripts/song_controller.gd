@tool
class_name SongController
extends Node

@export_file("*.json") var song_data_file: String
@export var track: NoteTrack
@export var music_player: AudioStreamPlayer

var difficulty := Constants.Difficulty.Normal
var perfect_window: float = 0.1
var good_window: float = 0.35

@export var note_travel_time: float = 2.0

@export_tool_button("Play Selected Song")
var play_song_button: Callable:
	get:
		return Callable(self, "load_song")

var chart_data: Dictionary
var notes: Array = []
var next_note_index: int = 0

var bpm: float = 120.0
var initial_delay: float = 0.0


var song_time_temp: float = 0.0


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	var song_time := get_song_time()
	spawn_notes(song_time)


func load_song() -> void:
	if song_data_file.is_empty():
		push_error("SongController: No chart file assigned.")
		return
		
	var file := FileAccess.open(song_data_file, FileAccess.READ)

	if file == null:
		push_error("SongController: Could not open song: " + song_data_file)
		return

	var json_text := file.get_as_text()
	var json := JSON.new()
	var error := json.parse(json_text)

	if error != OK:
		push_error("Could not parse chart: " + json.get_error_message())
		return

	if not json.data is Dictionary:
		push_error("SongController: Chart root must be a JSON object.")
		return

	chart_data = json.data

	bpm = chart_data.get("bpm", 120.0)
	initial_delay = chart_data.get("initial_delay", 0.0)
	notes = chart_data.get("notes", [])

	next_note_index = 0

	print("Loaded song: ", chart_data.get("song", "Unknown"))
	print("BPM: ", bpm)
	print("Delay: ", initial_delay)
	print("Notes: ", notes.size())
	
	music_player.play()


func get_song_time() -> float:
	return music_player.get_playback_position() * (bpm/60)


func spawn_notes(song_time: float) -> void:
	while next_note_index < notes.size():
		var note_data: Dictionary = notes[next_note_index]

		var hit_time: float = note_data.get("beat", 0.0) + initial_delay
		var spawn_time := hit_time - note_travel_time

		if song_time < spawn_time:
			break

		spawn_note(note_data)

		next_note_index += 1


func spawn_note(note_data: Dictionary) -> void:
	if track == null:
		push_error("SongController: No Track assigned.")
		return

	var lane: int = note_data.get("lane", 0)
	var hit_time: float = note_data.get("beat", 0.0) + initial_delay + note_travel_time
	var duration: float = note_data.get("duration", 0.0)

	track.spawn_note(
		lane,
		hit_time,
		note_travel_time,
		duration
	)


func judge_note(lane_index: int) -> Constants.HitStatus:	
	var player_time : float = get_song_time()

	var note := get_best_note_for_lane(lane_index)
	var lane := track.lanes.get_child(lane_index) as Lane

	if lane == null:
		print("ERROR: SongController: no lane matching index")
		return Constants.HitStatus.Miss

	if note == null:
		lane.play_hit_visuals(Constants.HitStatus.Miss)
		return Constants.HitStatus.Miss

	var difference : float = abs(player_time - note.hit_time)
	
	print("Note hit time: ", note.hit_time, " player time: ", player_time, " Difference: ", difference)
	
	if difference <= perfect_window:
		lane.play_hit_visuals(Constants.HitStatus.Perfect)
		note.queue_free()
		return Constants.HitStatus.Perfect

	if difference <= good_window:
		lane.play_hit_visuals(Constants.HitStatus.Good)
		note.queue_free()
		return Constants.HitStatus.Good
	
	lane.play_hit_visuals(Constants.HitStatus.Miss)	
	return Constants.HitStatus.Miss
	
	
	
func get_best_note_for_lane(lane_index: int) -> Note:
	if track == null:
		return null

	var lane := track.lanes.get_child(lane_index) as Lane

	if lane == null:
		return null

	var best_note:Note = null
	var best_difference := INF
	var player_time := get_song_time()

	for child in lane.get_children():
		if child is Note:
			var note := child as Note
			var difference : float = abs(player_time - note.hit_time)

			if difference < best_difference:
				best_difference = difference
				best_note = child

	return best_note
