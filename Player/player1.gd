extends CharacterBody2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var viewport_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var player1
# var viewport_size = get_viewport().size

@export_group("Motion")
@export var speed = 350.0
@export var acceleration = 1.5
@export var jump_height = 50.0
@export var jump_speed = -550.0
@export_group("")


func _ready():
	player1 = $Player1Sprite

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		player1.play("jump")

	# Handle jump.
	if (Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("ui_up")) && is_on_floor():
		velocity.y = jump_speed
		player1.play("jump")
	
	if (Input.is_action_just_released("ui_accept") || Input.is_action_just_released("ui_up")) && velocity.y < 0:
		velocity.y *= delta # variable jump
		player1.play("jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	# print(viewport_size)
	if direction:
		velocity.x = lerpf(velocity.x, direction * speed, acceleration * delta) # dario sliding
		#print(position.x, " ", position.y)
		if direction > 0:
			player1.flip_h = true
			if is_on_floor(): player1.play("run")
		if direction < 0:
			player1.flip_h = false
			if is_on_floor(): player1.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta * acceleration)
		if is_on_floor(): player1.play("stand")
		
	if global_position.x < 0: # nop areas needed with global_position
		global_position.x = viewport_width
	if global_position.x > viewport_width:
		global_position.x = 0

	move_and_slide()

