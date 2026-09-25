@tool
class_name NoteTrack
extends Node2D

@export var background : TextureRect
@export var lanes: Node2D
@export var note_scene: PackedScene
@export var lane_scene: PackedScene

@export_tool_button("Spawn Test Note")
var spawn_test_note_button: Callable:
	get:
		return Callable(self, "spawn_test_note")

@export var lane_count: int = 4: 
	set(value): 
		lane_count = max(1, value)
		if Engine.is_editor_hint():
			generate_lanes()
			
@export var lane_colors: Array[Color] = [
	Color.RED,
	Color.GREEN,
	Color.YELLOW,
	Color.BLUE
]

@export var lane_vis_width := 10
@export var spawn_height_mod := 0.0
@export var target_height_mod := 0.0
@export var note_visible_time := 3.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_lanes() # Replace with function body.
	spawn_note(0)
	spawn_note(1)
	spawn_note(2)
	spawn_note(3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func generate_lanes():
	# Make sure everything we need exists. 
	if not background: 
		print("ERROR: No background object")
		return 
	
	print("Background: ", background)
	print("Texture: ", background.get_texture())
		
	if not background.texture:
		print("ERROR: no background texture") 
		return 
		
	if not lanes: 
		print ("ERROR: no Lanes object")
		return
		
	# Remove existing generated lanes.
	for child in lanes.get_children():
		child.free()	
		
	print("Generating ", lane_count, " lanes")	
	
	var track_rect = background.get_rect()
	var track_size = track_rect.size
	var track_origin = track_rect.position
	var lane_width = track_size.x / lane_count
	
	print("Track size: ", track_size)
	print("Lane width: ", lane_width)
	
	# Generate the lanes
	
	if not lane_scene:
		print("ERROR: No lane scene assigned")
		return

	for i in range(lane_count):
		var lane := lane_scene.instantiate() as Lane

		lane.name = "Lane_%d" % i
		lane.lane_size = Vector2(lane_width, track_size.y)

		lane.position = Vector2(
			i * lane_width - track_size.x / 2.0,
			-track_size.y / 2.0
		)
		lane.setup(spawn_height_mod, target_height_mod)
		lanes.add_child(lane)
		if Engine.is_editor_hint():
			lane.owner = get_tree().edited_scene_root
	

func spawn_note(lane_index: int) -> void:
	if not note_scene:
		print("ERROR: No note scene assigned")
		return

	if lane_index < 0 or lane_index >= lane_count:
		print("ERROR: Invalid lane index: ", lane_index)
		return

	var note := note_scene.instantiate() as Note

	var lane := lanes.get_child(lane_index)
	lane.add_child(note)

	var track_size := background.texture.get_size()
	var lane_width := track_size.x / lane_count

	var lane_center_x := lane_width / 2.0

	var color := lane_colors[lane_index % lane_colors.size()]

	note.setup(
		lane,
		color,
		note_visible_time
	) 


func spawn_test_note() -> void:
	if not Engine.is_editor_hint():
		return
		
	var random_lane = randi() % lane_count
	spawn_note(random_lane)
