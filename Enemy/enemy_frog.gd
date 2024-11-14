extends CharacterBody2D




@onready var player = get_node("../../Player/Player")
@onready var anim = get_node("AnimatedSprite2D")
var chase = false
var SPEED = 50

func _physics_process(delta: float) -> void:
	#Gravity frog
	velocity += get_gravity() * delta
	if chase == true:
		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			get_node("AnimatedSprite2D").flip_h = true
			anim.play("Jump")
		else:
			get_node("AnimatedSprite2D").flip_h = false
			anim.play("Jump")
		velocity.x = direction.x * SPEED	
	else:
		anim.play("Idle")
		velocity.x = 0
		
	move_and_slide()	


func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		chase = true


func _on_player_detection_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		chase = false
