extends CharacterBody2D

class_name Player

@onready var anim = get_node("AnimationPlayer")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var direction = 0

func _physics_process(delta: float) -> void:
		# Apply gravity if not on the floor
	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.x = direction * SPEED
	if direction == 0 and is_on_floor():
		velocity.x = 0
	# Update direction based on input
	direction = Input.get_axis("ui_left", "ui_right")
	death()
	move(delta)
	animationHandler()
	move_and_slide()

func move(delta):
	# Handle jumping
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif direction != 0 and is_on_floor():
		velocity.x = direction * SPEED
		
func death():
	if Game.playerHP <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://main.tscn")
		return


func animationHandler():
	# Update animation based on state
	if direction != 0:
		get_node("AnimatedSprite2D").flip_h = direction < 0

	if is_on_floor():
		if direction == 0:
			anim.play("Idle")
		else:
			anim.play("Run")
	else:  # In the air
		if velocity.y < 0:
			anim.play("Jump")
		else:
			anim.play("Fall")
