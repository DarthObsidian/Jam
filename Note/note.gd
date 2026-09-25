@tool
class_name Note
extends Node2D

var start_y: float
var target_y: float
var travel_time: float
var elapsed_time: float = 0.0
var lane: Lane

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsed_time += delta

	var progress := elapsed_time / travel_time
	progress = clamp(progress, 0.0, 1.0)

	position = lerp(lane.get_spawn_position(), lane.get_target_position(), progress)

	if progress >= 1.0:
		queue_free()
	
	
func setup(assigned_lane: Lane, color: Color, duration: float) -> void:
	lane = assigned_lane
	travel_time = duration
	
	$Sprite2D.modulate = color
	
	position = lane.get_spawn_position()
