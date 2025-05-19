extends CharacterBody2D
class_name Viking


@export var max_hp := 5

@onready var player = $AnimationPlayer
@onready var timer = $Timer
@onready var attackCooldown = $AttackCoolDown
@onready var heart_container = $CanvasLayer/HBoxContainer
@onready var swordEffect = $sword
@onready var takeDamage = $Damage
@onready var heartSound = $Heart
var num = 0
var isAttacking = false
var hp = 5
var attackers: Array = []
var cooldown = false

func _ready():
		timer.timeout.connect(_on_damage_timer_timeout)


func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input_vector.y = Input.get_action_strength("Down") - Input.get_action_strength("Forward")
	
	if Input.is_action_just_pressed("Attack") and not cooldown:
		isAttacking = true
		cooldown = true
		
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
		
		if Input.is_action_pressed("Forward"):
			player.play("attackUp")
		elif Input.is_action_pressed("Down"):
			player.play("attackDown")
			
		swordEffect.play()
		
		await player.animation_finished

		attackCooldown.start(0.2)
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
			
	is_dead()

	move_and_collide(velocity)

func is_dead() -> void:
	if hp <= 0:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.name == "BotKillZone":
		attackers.append(area)
		timer.start(0.4)

func _on_damage_timer_timeout() -> void:
	for enemy in attackers:
		hp -= 0.5 
		update_hearts()
		takeDamage.play()


func _on_hurt_box_area_exited(area: Area2D) -> void:
	attackers.erase(area)
	if attackers.size() == 0:
		timer.stop()


func _on_attack_cool_down_timeout() -> void:
	attackCooldown.stop()
	cooldown = false

func update_hearts() -> void:
	for i in range(heart_container.get_child_count()):
		var heart = heart_container.get_child(i) as TextureRect
		if i  + 1  <= hp:
			heart.texture = preload("res://assets/Heart.png")
		elif i + 0.5 <= hp:
			heart.texture = preload("res://assets/halfHeart.png")
		else: 
			heart.texture = preload("res://assets/EmptyHeart.png")

func add_heart():
	hp += 1
	if hp > 5:
		hp = 5
	update_hearts()
	heartSound.play()
	
