extends CharacterBody2D

@onready var player = $AnimatedSprite2D
#@onready var player = $AnimationPlayer
var num = 0
var isAttacking = false


func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input_vector.y = Input.get_action_strength("Down") - Input.get_action_strength("Forward")
	
	if Input.is_action_just_pressed("Attack"):
		isAttacking = true
		if num % 2:
			if Input.is_action_pressed("Left"):
				player.play("attackOneLeft")
			else: 
				player.play("attackOneRight")
		else:
			if Input.is_action_pressed("Left"):
				player.play("attackTwoLeft")
			else: 
				player.play("attackTwoRight")
		
		#await get_tree().create_timer(player.sprite_frames.get_frame_duration(player.animation, 0)).timeout
		isAttacking = false
		num += 1

	if not isAttacking:
		if Input.is_action_pressed("Right"):
			player.play("walkRight")
		elif Input.is_action_pressed("Left"):
			player.play("walkLeft")
		elif Input.is_action_pressed("Down"):
			player.play("walkDown")
		elif Input.is_action_pressed("Forward"):
			player.play("walkUp")
		else: 
			player.play(("Idle"))
		
		if input_vector != Vector2.ZERO:
			velocity = input_vector
		else: 
			velocity = Vector2.ZERO

	move_and_collide(velocity)
