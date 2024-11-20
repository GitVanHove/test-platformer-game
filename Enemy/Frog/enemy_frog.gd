extends CharacterBody2D

class_name FrogEnemy

@onready var player = get_node("../../Player/Player")
@onready var anim = get_node("AnimatedSprite2D")
@onready var direction_timer = $DirectionTimer 
var is_frog_chase: bool = false

var SPEED = 50
var roaming_speed = 20
var health = 10
var health_max = 10
var health_min = 0 

var dead: bool = false
var taking_damage: bool = false
var damage_to_deal = 5
var is_dealing_damage: bool = false

var dir: Vector2 
const gravity = 900
var knockback_force = 200
var is_roaming: bool = true
var idle_duration = 1.0  
var idle_timer: float = 0.0  
	
func _ready() -> void:
	direction_timer.start()  # Start the timer

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	move(delta)
	handle_animation()
	move_and_slide()  
	

func move(delta):
	if !dead:
		if is_roaming and !is_frog_chase:
			velocity.x = dir.x * roaming_speed  # Consistent with movement direction
		elif is_frog_chase:
			dir = (player.position - self.position).normalized()
			velocity.x = dir.x * SPEED
	else:
		velocity.x = 0
		
func handle_animation():
	if !dead and is_roaming and velocity.x != 0:
		flip_sprite(dir.x)
		anim.play("Jump")
	elif !dead and is_frog_chase and velocity.x != 0:
		flip_sprite(dir.x)
		anim.play("Jump")
	elif !dead and velocity.x == 0:
		anim.play("Idle")
	elif dead:
		is_roaming = false
		death()

func _on_direction_timer_timeout() -> void:
	direction_timer.wait_time = choose([1.5, 2.0, 2.5])
	if !is_frog_chase:
		dir = choose([Vector2.RIGHT, Vector2.LEFT, Vector2.ZERO])
		velocity.x = 0  # Reset velocity momentarily when changing direction

func flip_sprite(direction_x):
	anim.flip_h = direction_x > 0 

func choose(array):
	var shuffled = array.duplicate()
	shuffled.shuffle()
	return shuffled[0]

func death():
	Game.Gold += 5
	Utils.saveGame()
	anim.play("Death")
	await anim.animation_finished
	self.queue_free()


func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_frog_chase = true
		is_roaming = false

func _on_player_detection_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_frog_chase = false
		is_roaming = true
