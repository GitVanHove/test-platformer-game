extends Area2D




func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Game.Gold += 1
		var tween = get_tree().create_tween()
		var tweenVis = get_tree().create_tween()
		tween.tween_property(self,"position",position - Vector2(0,25), 0.2)
		tweenVis.tween_property(self, "modulate:a" , 0 , 0.2)
		tween.tween_callback(queue_free)
		
