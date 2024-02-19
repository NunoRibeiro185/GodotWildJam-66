extends TextureButton



func _on_pressed():
	GameManager.restart()
	get_parent().get_parent().main_menu()
