extends Area2D


var inZone = false
var isActive = false

signal extracted


func _on_body_entered(body: Node2D) -> void:
	if body is Viking:
		inZone = true


func _process(delta: float) -> void:
	if (Global.waves_completed % 5 == 0) and not Global.waves_completed == 0:
		isActive = true
	else: 
		isActive = false
		
	if isActive and inZone and Input.is_action_pressed("Enter"):
		get_tree().paused = true
		emit_signal("extracted")

func _on_body_exited(body: Node2D) -> void:
	if body is Viking:
		inZone = false
