extends Node

var time_running = false
var time = 0
signal game_over_signal
	
func _process(delta):
	if time_running:
		time += (int(delta*1000) + 1)

func game_over():
	emit_signal("game_over_signal")
	
func formatTime(ms: int) -> String:
	var minutes = int(ms / 60000)
	var seconds = int((ms % 60000) / 1000)
	var milliseconds = int(ms % 1000)

	# Format the time components
	var formattedMinutes = str(minutes).pad_zeros(2)
	var formattedSeconds = str(seconds).pad_zeros(2)
	var formattedMilliseconds = str(milliseconds).pad_zeros(2)

	# Construct the time string
	var formattedTime = formattedMinutes + ":" + formattedSeconds + ":" + formattedMilliseconds

	return formattedTime

