extends CharacterBody2D



signal dbg_change_direction
var marker_scene = load("res://util/marker.tscn")


@export var speed : float = 500.0
@export var jump_velocity : float = -700.0
@export var double_jump_velocity : float = -500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jumped : bool = false
var direction : float = 0
var anim_locked : bool = false
var is_jumping : bool = false

func _physics_process(delta):
	var dbg_prev_vel = velocity
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		has_double_jumped = false
		
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			jump()
		elif not has_double_jumped:
			double_jump()
		
	direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	update_sprite_direction()
	
	# DEBUG stuff
	if velocity != dbg_prev_vel:
		add_marker()

func add_marker():
	var m = preload("res://util/marker.tscn").instantiate()
	m.init(position)
	add_sibling(m)
	
func jump():
	velocity.y = jump_velocity

func double_jump():
	has_double_jumped = true
	velocity.y = double_jump_velocity

func update_sprite_direction():
	if direction < 0:
		scale.x = -1
	elif direction > 0:
		scale.x = 1
