extends CharacterBody2D

signal knocked_ceil

# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var viewport_width = ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var animated_sprite = $AnimatedSprite

# var viewport_size = get_viewport().size

@export_group("Motion")
@export var speed = 350.0
@export var acceleration = 1.5
# @export var jump_height = 50.0
@export var jump_speed = -550.0
@export_group("")



func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		animated_sprite.play("jump")
		if is_on_ceiling_only():
			knocked_ceil.emit(position)

	# Handle jump.
	if (Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("ui_up")) && is_on_floor():
		velocity.y = jump_speed
		animated_sprite.play("jump")
	
	if (Input.is_action_just_released("jump") || Input.is_action_just_released("jump")) && velocity.y < 0:
		velocity.y *= delta # variable jump
		animated_sprite.play("jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")

	if direction:
		velocity.x = lerpf(velocity.x, direction * speed, acceleration * delta) # Dario sliding
		#print(position.x, " ", position.y)
		if direction > 0:
			animated_sprite.flip_h = true
			if is_on_floor(): animated_sprite.play("run")
		if direction < 0:
			animated_sprite.flip_h = false
			if is_on_floor(): animated_sprite.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta * acceleration)
		if is_on_floor(): animated_sprite.play("stand")
	
	# no areas needed with global_position
	if global_position.x < 0: 
		global_position.x = viewport_width
	if global_position.x > viewport_width:
		global_position.x = 0

	move_and_slide()

