extends RigidBody2D

func _on_area_body_entered(body):
	if body.name == "floor":
		get_parent().game_over = true
		get_tree().paused = true
