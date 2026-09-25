extends HSlider

@onready var master = AudioServer.get_bus_index("Master")
@onready var icon = $"../volIcon"

func _ready() -> void:
	value = AudioServer.get_bus_volume_linear(master)
	_on_value_changed(value)


func _on_value_changed(newValue: float) -> void:
	var vol = linear_to_db(newValue)
	AudioServer.set_bus_volume_db(master, vol)
	if newValue == 0.0:
		icon.frame = 0
	elif newValue >= 0.0 and newValue <= 0.25:
		icon.frame = 1
	elif newValue > 0.25 and newValue <= 0.75:
		icon.frame = 2
	elif newValue > 0.75:
		icon.frame = 3
