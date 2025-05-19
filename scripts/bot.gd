extends CharacterBody2D	
class_name Bot

var player = null
var is_player_in_zone = false
var move_speed = 40
@onready var animation = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	if is_player_in_zone and player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * move_speed
		
		if direction.x < 0:
			animation.flip_h = true
		elif direction.x > 0:
			animation.flip_h = false
		move_and_slide()


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.name == "SwordHitBox":
		get_parent().get_node("DeadSound").play()
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Viking:
		is_player_in_zone = true
		player = body
