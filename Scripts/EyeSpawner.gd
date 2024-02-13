extends Node

const EYES = preload("res://Scenes/Entities/eyes.tscn")
@onready var eyes = $"../Eyes"
@onready var platforms = $"../Platforms"
@onready var player = $"../Player"

const LEFT_WALL = 207
const RIGHT_WALL = 860
const CEILLING = 48
const FLOOR = 682

var spawns = [LEFT_WALL,RIGHT_WALL,CEILLING,FLOOR]

func spawn_eye():
	var new_eye = EYES.instantiate() as Eye
	eyes.call_deferred("add_child", new_eye)
	
	var random_spawn = spawns[randi() % spawns.size()]
	
	if random_spawn == LEFT_WALL:
		new_eye.position = Vector2(LEFT_WALL,randf_range(CEILLING, FLOOR))
	if random_spawn == RIGHT_WALL:
		new_eye.position = Vector2(RIGHT_WALL,randf_range(CEILLING, FLOOR))
	if random_spawn == CEILLING:
		new_eye.position = Vector2(randf_range(LEFT_WALL,RIGHT_WALL),CEILLING)
	if random_spawn == FLOOR:
		new_eye.position = Vector2(randf_range(LEFT_WALL,RIGHT_WALL),FLOOR)
		
	new_eye.platforms = platforms
	new_eye.player = player 
	pass

func _on_timer_timeout():
	spawn_eye()
