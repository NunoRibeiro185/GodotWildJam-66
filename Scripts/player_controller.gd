extends CharacterBody2D
class_name Player

#Stats
var max_hspeed = 400
var max_vspeed = 1000
var jump_velocity = -850
@export_range(0.0, 1.0) var friction = 0.7
@export_range(0.0 , 1.0) var acceleration = 0.3

#Timers
@onready var coyote_time = $CoyoteTime
@onready var jump_buffer_time = $JumpBuffer
@onready var alive_timer = $"Alive Timer"
@onready var dead_timer = $"Dead Timer"

#Sprite
@onready var animation = $AnimationTree["parameters/playback"]
@onready var sprite = $Sprite2D

#Jump vars
var cut_speed = false
var jump_cut = 0.2
var jumping = false
var gravity := 2500
var peak_gravity := 1250
var peak_gravity_threshold = 150


# Get the gravity from the project settings to be synced with RigidBody nodes.
var coyote = false
var jump_buffer = false
var last_floor = false

var hspeed_threshold = 1.0
var state = "ALIVE"

@onready var sus_bar = $"../CanvasLayer/SusBar"
@onready var audio = $AudioStreamPlayer
@export var jump_audio : AudioStreamMP3
@export var dissipate_audio : AudioStreamMP3

func _physics_process(delta):
	if state != "DISSIPATE":
		if Input.is_action_pressed("play_dead"):
			state = "DEAD"
			animation.travel("Play_Dead")
		if velocity.y >= 0:
			jumping = false
			
		if not is_on_floor():
			velocity.y += current_gravity() * delta
			
		if velocity.x != 0:
			sprite.scale.x = sign(velocity.x)
			
		# Handle jump.
		jump(delta)
		#Update Velocity
		update_velocity(delta)
		#Move and Slide
		move_and_slide()
		
		if not is_on_floor() and last_floor and !jumping:
			coyote = true
			coyote_time.start()
		
		last_floor = is_on_floor()

func jump(_delta):
	if Input.is_action_just_pressed("jump"):
		state = "ALIVE"
		jump_buffer_time.start()
		jump_buffer = true
	if (is_on_floor() or coyote) and jump_buffer:
		audio.pitch_scale = randf_range(0.85, 1.15)
		audio.stream = jump_audio
		audio.play()
		jump_buffer = false
		velocity.y = jump_velocity
		coyote = false
		jumping = true
		if(abs(velocity.x) <= hspeed_threshold):
			animation.travel("Jumping_Idle")
		else:
			animation.travel("Jumping")
		
	if Input.is_action_just_released("jump") and jumping:
		cut_speed = true
	if cut_speed:
		if velocity.y < 0:
			velocity.y *= jump_cut
			cut_speed = false

func update_velocity(_delta):
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		state = "ALIVE"
		velocity.x = lerp(velocity.x, direction * max_hspeed, acceleration) 
		if not jumping:
			animation.travel("Running")
		
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
		if abs(velocity.x) < hspeed_threshold:
			velocity.x = 0
			if not jumping and state == "ALIVE":
				animation.travel("Idle")
				
	#Dash stuff goes here
	velocity.y = clamp(velocity.y, -current_max_vspeed(), current_max_vspeed())

func current_gravity():
	if jumping == true and Input.is_action_pressed("jump") and velocity.y < 0 and abs(velocity.y) < peak_gravity_threshold:
		return peak_gravity
	else:
		return gravity

func detected(state):
	if state == "ALIVE":
		alive_timer.start()
	elif state == "DEAD":
		dead_timer.start()

func current_max_vspeed():
	return max_vspeed
	
func dissipate():
	state = "DISSIPATE"
	animation.travel("Death")
	audio.pitch_scale = 1
	audio.stream = dissipate_audio
	audio.play()
	
func _on_coyote_time_timeout():
	coyote = false

func _on_jump_buffer_timeout():
	jump_buffer = false

func _on_alive_timer_timeout():
	sus_bar.alive_indicator.move(-1)

func _on_dead_timer_timeout():
	sus_bar.dead_indicator.move(1)


