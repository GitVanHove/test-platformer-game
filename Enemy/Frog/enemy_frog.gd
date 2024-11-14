extends CharacterBody2D




@onready var player = get_node("../../Player/Player")
@onready var anim = get_node("AnimatedSprite2D")
var chase = false
var SPEED = 50

func _physics_process(delta: float) -> void:
	#Gravity frog
	velocity += get_gravity() * delta
	if chase == true && anim.animation != "Death":
		anim.play("Jump")
		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			get_node("AnimatedSprite2D").flip_h = true
		else:
			get_node("AnimatedSprite2D").flip_h = false
		velocity.x = direction.x * SPEED	
	else:
		if anim.animation != "Death":
			anim.play("Idle")
		velocity.x = 0
		
	move_and_slide()	


func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		chase = true


func _on_player_detection_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		chase = false


func _on_player_death_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		death()


func _on_player_collision_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.health -= 3
		

func death():
	chase =  false
	anim.play("Death")
	await anim.animation_finished
	self.queue_free()
