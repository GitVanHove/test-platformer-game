extends CharacterBody2D

class_name FrogEnemy

@onready var player = get_node("../../Player/Player")
@onready var anim = get_node("AnimatedSprite2D")
@onready var direction_timer = $DirectionTimer 
var is_frog_chase: bool = false

var SPEED = 50
var health = 10
var health_max = 10
var health_min = 0 

var dead: bool = false
var taking_damage: bool = false
var damage_to_deal = 5
var is_dealing_damage: bool = false

var dir: Vector2 = Vector2.RIGHT  # Initialized
const gravity = 900
var knockback_force = 200
var is_roaming: bool = true
	
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
			velocity.x = dir.x * SPEED  # Consistent with movement direction
	else:
		velocity.x = 0
		
func handle_animation():
	if !dead and !taking_damage and !is_dealing_damage:
		anim.flip_h = dir.x > 0
		anim.play("Jump")
	elif dead and is_roaming:
		is_roaming = false
		death()

func _on_direction_timer_timeout() -> void:
	direction_timer.wait_time = choose([1.5, 2.0, 2.5])
	if !is_frog_chase:
		dir = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0  # Reset velocity momentarily when changing direction

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
