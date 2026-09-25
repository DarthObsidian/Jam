@tool
class_name Note
extends Node2D

var start_y: float
var target_y: float
var travel_time: float
var hit_time: float
var elapsed_time: float = 0.0
var duration: float
var lane: Lane

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsed_time += delta

	var progress := elapsed_time / travel_time
	position = lerp(lane.get_spawn_position(), lane.get_target_position(), progress)

	if (position - lane.get_spawn_position()).length() >= lane.lane_size.y:
		queue_free()
		Signalbus.signal_miss.emit()


func setup(assigned_lane: Lane, color: Color, hit_time_in: float, travel_time_in: float, duration_in: float) -> void:
	lane = assigned_lane
	hit_time = hit_time_in 
	travel_time = travel_time_in
	duration = duration_in
	
	$Sprite2D.modulate = color
	
	position = lane.get_spawn_position()
	
