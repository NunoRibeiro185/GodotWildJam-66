extends Label

func _ready():
	text = GameManager.formatTime(GameManager.time)
