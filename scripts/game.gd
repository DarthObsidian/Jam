extends Node


var totalPoints : int = 0
var high_score : int = 0
const POINTS = 5
const WAIT = 2
var gameOver = false
var gameOverDelay = 0
@onready var finalScore = $CanvasLayer/Panel/VBoxContainer/ScoreBox/FinalScore
@onready var highScoreText = $CanvasLayer/Panel/VBoxContainer/HighScoreBox/HighScore
@onready var scoreBox = $CanvasLayer/Panel/VBoxContainer/ScoreBox
@onready var highScoreBox = $CanvasLayer/Panel/VBoxContainer/HighScoreBox
@onready var highScoreLabel = $CanvasLayer/Panel/VBoxContainer/HighScoreBox/HighScoreLabel
@onready var gameOverPanel = $CanvasLayer/Panel
@onready var points = $CanvasLayer/Points

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signalbus.signal_miss.connect(_on_miss)
	_on_restart_click()


func _add_points() -> void:
	var oldTotal = totalPoints
	totalPoints += POINTS * $Combo.get_combo_multiplyer()
	for i in range(oldTotal, totalPoints+1):
		points.text = str(i)
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


func _on_game_over() -> void:
	gameOver = true
	if(totalPoints > high_score):
		high_score = totalPoints
		scoreBox.visible = false;
		highScoreLabel.text = "New High Score:"
	else:
		highScoreLabel.text = "Session High Score:"
		scoreBox.visible = true;
	highScoreText.text = str(high_score)	
	finalScore.text = str(totalPoints)
	gameOverPanel.visible = true


func _on_restart_click() -> void:
	$Song.load_song()
	gameOver = false
	gameOverPanel.visible = false
	gameOverPanel.position.y = 1000
	totalPoints = 0
	points.text = str(0)
	$Combo.clear_combo()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !gameOver:
		var hitStatus = Constants.HitStatus.None
		if Input.is_action_just_pressed("left"):
			hitStatus = $Song.judge_note(0)
			$Ghost.play_hit(Constants.Hit.Left)
		elif Input.is_action_just_pressed("mid-left"):
			hitStatus = $Song.judge_note(1)
			$Ghost.play_hit(Constants.Hit.MidLeft)
		elif Input.is_action_just_pressed("mid-right"):
			hitStatus = $Song.judge_note(2)
			$Ghost.play_hit(Constants.Hit.MidRight)
		elif Input.is_action_just_pressed("right"):
			hitStatus = $Song.judge_note(3)
			$Ghost.play_hit(Constants.Hit.Right)

		_do_hit(hitStatus)
	else:
		gameOverDelay += delta
		if gameOverDelay >= WAIT and gameOverPanel.position.y > 141.0:
			gameOverPanel.position.y = lerp(gameOverPanel.position.y, 140.0, delta * 5)
