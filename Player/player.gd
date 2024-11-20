extends CharacterBody2D


@onready var anim = get_node("AnimationPlayer")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var direction

func _physics_process(delta: float) -> void:
	# Apply gravity if not on the floor
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jumping
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get movement direction
	direction = Input.get_axis("ui_left", "ui_right")
	
	if direction == 0:
		velocity.x = 0
	# Move the character
	move(delta)
	move_and_slide()


func move(delta):
	if Game.playerHP <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://main.tscn")
	elif is_on_floor() and velocity.y == 0 and direction == 0:
		anim.play("Idle")
	elif is_on_floor()  and direction != 0:
		velocity.x = direction * SPEED
		get_node("AnimatedSprite2D").flip_h = direction < 0
		anim.play("Run")
	elif velocity.y < 0:
		anim.play("Jump")
	elif velocity.y > 0 and !is_on_floor():
		anim.play("Fall")
	
