extends Node2D


@onready var eyes = $body/eyes
@onready var arms = $arms
@onready var body = $body
@onready var drum_right = $drum_right
@onready var drum_left = $drum_left
@onready var cymbol_right = $cymbol_right
@onready var cymbol_left = $cymbol_left


func _ready() -> void:
	eyes.animation_finished.connect(_on_eye_anim_done)
	arms.animation_finished.connect(_on_arms_anim_done)
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


func _on_arms_anim_done() -> void:
	arms.play("idle")


func play_miss() -> void:
	eyes.play("miss")


func play_perfect() -> void:
	eyes.play("perfect")


func play_good() -> void:
	eyes.play("good")


func play_idle() -> void:
	body.play("idle")
	eyes.play("idle")
	arms.play("idle")
	drum_left.play("idle")
	drum_right.play("idle")
	cymbol_right.play("idle")
	cymbol_left.play("idle")


func play_hit(hit: Constants.Hit) -> void:
	match hit:
		Constants.Hit.Left:
			arms.play("hitLeft")
			cymbol_left.play("hit")
		Constants.Hit.MidLeft:
			arms.play("hitMidLeft")
			drum_left.play("hit")
		Constants.Hit.MidRight:
			arms.play("hitMidRight")
			drum_right.play("hit")
		Constants.Hit.Right: 
			arms.play("hitRight")
			cymbol_right.play("hit")
