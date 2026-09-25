extends Node


var totalPoints : int = 0
const POINTS = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signalbus.signal_miss.connect(_on_miss)
	$Song.load_song()


func _add_points() -> void:
	var oldTotal = totalPoints
	totalPoints += POINTS * $Combo.get_combo_multiplyer()
	for i in range(oldTotal, totalPoints+1):
		$Points.text = str(i)
		await get_tree().create_timer(0.01).timeout


func _do_hit(hitStatus: Constants.HitStatus) -> void:
	match hitStatus:
		Constants.HitStatus.Miss:
			$Ghost.play_miss()
			$Combo.clear_combo()
		Constants.HitStatus.Good:
			$Ghost.play_good()
			$Combo.add_combo()
			_add_points()
		Constants.HitStatus.Perfect:
			$Ghost.play_perfect()
			$Combo.add_perfect_combo()
			_add_points()
		Constants.HitStatus.None:
			pass


func _on_miss() -> void:
	_do_hit(Constants.HitStatus.Miss)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var hitStatus = Constants.HitStatus.None
	if Input.is_action_just_pressed("left"):
		hitStatus = $Track.attempt_play_note(0)
		$Ghost.play_hit(Constants.Hit.Left)
	elif Input.is_action_just_pressed("mid-left"):
		hitStatus = $Track.attempt_play_note(1)
		$Ghost.play_hit(Constants.Hit.MidLeft)
	elif Input.is_action_just_pressed("mid-right"):
		hitStatus = $Track.attempt_play_note(2)
		$Ghost.play_hit(Constants.Hit.MidRight)
	elif Input.is_action_just_pressed("right"):
		hitStatus = $Track.attempt_play_note(3)
		$Ghost.play_hit(Constants.Hit.Right)

	_do_hit(hitStatus)
