extends Button

func _on_pressed():
	print("Pressed")
	print(get_parent().get_parent().name)
	get_parent().get_parent().start_game()
