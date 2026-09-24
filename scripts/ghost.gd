extends Node2D


@onready var eyes = $body/eyes
@onready var body = $body
@onready var drum_right = $body/drum_right
@onready var drum_left = $body/drum_left
@onready var cymbol_right = $body/cymbol_right
@onready var cymbol_left = $body/cymbol_left


func _ready() -> void:
	eyes.animation_finished.connect(_on_eye_anim_done)
	body.animation_finished.connect(_on_body_anim_done)
	drum_right.animation_finished.connect(_on_drum_right_done)
	drum_left.animation_finished.connect(_on_drum_left_done)
	cymbol_left.animation_finished.connect(_on_cymbol_left_done)
	cymbol_right.animation_finished.connect(_on_cymbol_right_done)


func _on_cymbol_left_done() -> void:
	cymbol_left.play("idle")


func _on_cymbol_right_done() -> void:
	cymbol_right.play("idle")


func _on_drum_left_done() -> void:
	drum_left.play("idle")


func _on_drum_right_done() -> void:
	drum_right.play("idle")


func _on_eye_anim_done() -> void:
	eyes.play("idle")


func _on_body_anim_done() -> void:
	body.play("idle")


func play_miss() -> void:
	eyes.play("miss")


func play_perfect() -> void:
	eyes.play("perfect")


func play_idle() -> void:
	body.play("idle")
	eyes.play("idle")
	drum_left.play("idle")
	drum_right.play("idle")
	cymbol_right.play("idle")
	cymbol_left.play("idle")


func play_hit(hit: Constants.Hit) -> void:
	match hit:
		Constants.Hit.Left:
			body.play("hitLeft")
			cymbol_left.play("hit")
		Constants.Hit.MidLeft:
			body.play("hitMidLeft")
			drum_left.play("hit")
		Constants.Hit.MidRight:
			body.play("hitMidRight")
			drum_right.play("hit")
		Constants.Hit.Right: 
			body.play("hitRight")
			cymbol_right.play("hit")
