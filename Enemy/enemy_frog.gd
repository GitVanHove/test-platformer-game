extends CharacterBody2D




@onready var player = get_node("../../Player/Player")
var chase = false
var SPEED = 50

func _physics_process(delta: float) -> void:
	#Gravity frog
	velocity += get_gravity() * delta
	var direction = (player.position - self.position).normalized()
	if direction.x > 0:
		if chase == true:
			velocity.x = direction.x * SPEED
			print("right")
	else:
		if chase == true:
			print("left")
	
	move_and_slide()	


func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		chase = true


func _on_player_detection_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		chase = false
