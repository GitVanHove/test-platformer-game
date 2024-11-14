extends CharacterBody2D

var health = 10
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var anim = get_node("AnimationPlayer")

func _physics_process(delta: float) -> void:
	# Apply gravity if not on the floor
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jumping
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get movement direction
	var direction := Input.get_axis("ui_left", "ui_right")

	# Check if on the ground and not moving horizontally or vertically
	if is_on_floor():
		if velocity.y == 0:
			if direction == 0:
				anim.play("Idle")  # Idle when no movement is detected
			else:
				# Run animation when there's movement input on the ground
				velocity.x = direction * SPEED
				get_node("AnimatedSprite2D").flip_h = direction < 0
				anim.play("Run")
	# Handle falling
	elif velocity.y < 0:  # Jumping up
		anim.play("Jump")
	elif velocity.y > 0 and !is_on_floor(): # Falling down
		anim.play("Fall")

	# Update velocity for stopping motion when no input
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Move the character
	move_and_slide()
