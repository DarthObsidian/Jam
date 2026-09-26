extends Node2D

@export var step : int = 4
@onready var pumpkins : Array[Sprite2D] = [
	$pumpkin,
	$pumpkin2,
	$pumpkin3,
	$pumpkin4,
]
var currentIndex = 0
var currentStep = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_glow_strength()
	for pumpkin in pumpkins:
		pumpkin.visible = false
		pumpkin.frame = 0


func add_combo() -> void:
	if currentIndex >= pumpkins.size() - 1 and currentStep == step:
		return

	if currentStep >= step:
		currentStep = 0
		currentIndex += 1

	if currentStep == 0:
		pumpkins[currentIndex].visible = true
	else:
		pumpkins[currentIndex].frame += 1
	currentStep += 1
	set_glow_strength()
	if currentIndex >= pumpkins.size() - 1 and currentStep == step:
		$audio.play()


func add_perfect_combo() -> void:
	add_combo()
	add_combo()


func clear_combo() -> void:
	for pumpkin in pumpkins:
		pumpkin.visible = false
		pumpkin.frame = 0
		currentStep = 0
		currentIndex = 0
		set_glow_strength()


func get_combo_multiplyer() -> int:
	return currentIndex + 2 if currentStep == 4 else currentIndex + 1


func set_glow_strength() -> void:
	if(currentStep >= pumpkins.size()):
		return
	var strength : float = 0.0
	
	#too lazy to figure out how to do a curve, thus silly switches
	match currentIndex:
		0:
			strength = 0.0
		1: 
			strength = 0.0
		2:
			match currentStep:
				0:
					strength = 0.25
				1: 
					strength = 0.5
				2:
					strength = .75
				3:
					strength = 1.0
		3:
			match currentStep:
				0:
					strength = 1.25
				1: 
					strength = 1.5
				2:
					strength = 1.75
				3:
					strength = 2.0
	$Glow.material.set_shader_parameter("glow_strength", strength)
