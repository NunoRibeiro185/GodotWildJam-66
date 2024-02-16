extends RichTextLabel


func _ready():
	text = GameManager.formatTime(GameManager.time)
