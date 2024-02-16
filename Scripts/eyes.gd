extends StaticBody2D
class_name Eye

var platforms = null
var raycasts = []
var fov = 0.10
var step = 0.05
@onready var light = $PointLight2D
var wanted_state = null
var time_limit = 0.0
var player = null
var sus_bar = null

# Called when the node enters the scene tree for the first time.
func _ready():
	#var children = platforms.get_children()
	#var random_child = children[randi() % children.size()]
	#var target = random_child.position
	var target = player.global_position
	var it = -fov
	while it <= fov:
		var new_raycast = RayCast2D.new()
		add_child(new_raycast)
		new_raycast.target_position = Vector2((new_raycast.global_position - target).length() + 350,0)
		new_raycast.rotate(it)
		new_raycast.set_collision_mask_value(2,true)
		new_raycast.set_collision_mask_value(1,true)
		raycasts.append(new_raycast)
		it += step
		
	look_at(target)
	if randf() > 0.5:
		wanted_state = "DEAD"
		light.set_color(Color(1,0,0))
	else:
		wanted_state = "ALIVE"
		light.set_color(Color(0,1,0))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for ray in raycasts:
		if ray.is_colliding():
			if(ray.get_collider() == get_tree().get_first_node_in_group("Player")):
				var player = ray.get_collider() as Player
				time_limit += delta
				if time_limit >= 0.5:
					if wanted_state == "DEAD":
						time_limit = 0.0
						sus_bar.update_suspition(-1)
						player.detected(wanted_state)
					elif wanted_state == "ALIVE":
						time_limit = 0.0
						sus_bar.update_suspition(1)
						player.detected(wanted_state)
	
func _on_life_span_timeout():
	queue_free()