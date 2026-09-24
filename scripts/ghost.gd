extends Node2D


@onready var eyes = $body/eyes
@onready var body = $body


func _ready():
	eyes.animation_finished.connect(_on_eye_anim_done)
	body.animation_finished.connect(_on_body_anim_done)


func _on_eye_anim_done():
	eyes.play("idle")


func _on_body_anim_done():
	body.play("idle")


func play_miss() -> void:
	eyes.play("miss")


func play_perfect() -> void:
	eyes.play("perfect")


func play_idle() -> void:
	body.play("idle")
	eyes.play("idle")


func play_hit(hit: Constants.Hit):
	match hit:
		Constants.Hit.Left:
			body.play("hitLeft")
		Constants.Hit.MidLeft:
			body.play("hitMidLeft")
		Constants.Hit.MidRight:
			body.play("hitMidRight")
		Constants.Hit.Right: 
			body.play("hitRight")
		_: 
			play_idle()
