extends Node2D
class_name Indicator

const THRESHOLD = 47

func move(amount):
	if((abs(position.y + amount)) <= THRESHOLD) and ((abs(position.y + amount)) > 0):
		position.y += amount

func _process(delta):
	if abs(position.y) >= THRESHOLD:
		GameManager.game_over()
