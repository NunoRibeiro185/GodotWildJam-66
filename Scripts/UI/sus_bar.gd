extends Node2D
class_name SusBar

@onready var dead_indicator = $"Dead Indicator"
@onready var alive_indicator = $"Alive Indicator"

const SUS_INCREMENT = 1

func update_suspition(direction):
	if direction > 0:
		alive_indicator.move(SUS_INCREMENT * direction)
	else:
		dead_indicator.move(SUS_INCREMENT * direction)
