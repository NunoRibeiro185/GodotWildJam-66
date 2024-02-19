extends Node

@export_file("*.tscn") var mainMenuScenePath
@export_file("*.tscn") var mainGameScenePath
@export_file("*.tscn") var gameOverScenePath
@export_file("*.tscn") var wildcardScenePath
@export_file("*.tscn") var tutorialScenePath

var current_active_scene
var loaded_scene_path

func _ready():
	main_menu()
	GameManager.game_over_signal.connect(game_over)

func start_game():
	GameManager.restart()
	var current_scene = current_active_scene
	loaded_scene_path = mainMenuScenePath
	var main_game_scene = load(mainGameScenePath).instantiate()
	current_active_scene = main_game_scene
	if current_scene:
		current_scene.queue_free()
	call_deferred("add_child",main_game_scene)
	
func main_menu():
	var current_scene = current_active_scene
	loaded_scene_path = mainMenuScenePath
	var main_menu_scene = load(mainMenuScenePath).instantiate()
	current_active_scene = main_menu_scene
	if current_scene:
		current_scene.queue_free()
	call_deferred("add_child",main_menu_scene)

func game_over():
	var current_scene = current_active_scene
	loaded_scene_path = gameOverScenePath
	var game_over_scene = load(gameOverScenePath).instantiate()
	current_active_scene = game_over_scene
	if current_scene:
		current_scene.queue_free()
	call_deferred("add_child",game_over_scene)
	
func wildcard():
	var current_scene = current_active_scene
	loaded_scene_path = wildcardScenePath
	var wildcard_scene = load(wildcardScenePath).instantiate()
	current_active_scene = wildcard_scene
	if current_scene:
		current_scene.queue_free()
	call_deferred("add_child",wildcard_scene)
	
func tutorial():
	var current_scene = current_active_scene
	loaded_scene_path = tutorialScenePath
	var tutorial_scene = load(tutorialScenePath).instantiate()
	current_active_scene = tutorial_scene
	if current_scene:
		current_scene.queue_free()
	call_deferred("add_child",tutorial_scene)
	
	
