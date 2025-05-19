extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Viking:
		body.add_heart()
		queue_free()
