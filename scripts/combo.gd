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


func clear_combo() -> void:
	for pumpkin in pumpkins:
		pumpkin.visible = false
		pumpkin.frame = 0
		currentStep = 0
		currentIndex = 0


func get_combo_multiplyer() -> int:
	return currentIndex + 2 if currentStep == 4 else currentIndex + 1
