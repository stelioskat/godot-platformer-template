extends CharacterBody2D

signal dbg_change_direction
var marker_scene = load("res://util/marker.tscn")

## TODO
@export var can_double_jump : bool = true
## TODO
@export var can_wall_jump : bool = true
## TODO
@export var speed : float = 600.0
## TODO
@export var jump_velocity : float = -800.0
## TODO
@export var double_jump_velocity : float = -600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jumped : bool = false
var has_wall_jumped : bool = false
var direction : float = 0

# used to improve feeling of responsiveness of jumping
var time_since_just_pressed_jump : float = 1000.0
var time_since_is_on_floor : float = 1000.0

func _physics_process(delta : float):
	var dbg_prev_vel = velocity
		
	update_jump(delta)
	
	if not is_on_floor():
		# Add the gravity.
		velocity.y += gravity * delta
	
	direction = Input.get_axis("left", "right")
	if has_wall_jumped:
		has_wall_jumped = false
	elif direction:
		velocity.x = move_toward(velocity.x, direction * speed, speed)
	else:
		velocity.x = move_toward(velocity.x, 0, speed/10)

	move_and_slide()
	update_sprite_direction()
	
	# DEBUG stuff
	if velocity != dbg_prev_vel:
		add_marker()

func add_marker():
	var m = preload("res://util/marker.tscn").instantiate()
	m.init(position)
	add_sibling(m)
	
## The jump behavior is inspired by Hollow Knight
func update_jump(delta : float):
	time_since_just_pressed_jump += delta
	if Input.is_action_just_pressed("jump"):
		time_since_just_pressed_jump = 0.0
		
	time_since_is_on_floor += delta
	if is_on_floor():
		time_since_is_on_floor =  0.0
		has_double_jumped = false
		
	if time_since_is_on_floor < 0.1 and time_since_just_pressed_jump < 0.01:
		velocity.y = jump_velocity
	elif not has_double_jumped and not is_on_wall() and time_since_just_pressed_jump < 0.01:
		double_jump()
	elif is_on_wall() and time_since_just_pressed_jump < 0.01:
		has_double_jumped = false
		wall_jump()
	elif Input.is_action_just_released("jump") and (velocity.y < 0):
		velocity.y = 0.0

func double_jump():
	if can_double_jump:
		has_double_jumped = true
		velocity.y = double_jump_velocity

func wall_jump():
	if can_wall_jump:
		has_wall_jumped = true 
		velocity.x = get_wall_normal().x * abs(double_jump_velocity)
		print(velocity.x)
		velocity.y = jump_velocity
	
func update_sprite_direction():
	if direction < 0:
		scale.x = -1
	elif direction > 0:
		scale.x = 1
