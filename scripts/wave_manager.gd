extends Node2D


var bot_scene := preload("res://scenes/bot.tscn")
var heart_pickup_scene := preload("res://scenes/heart_pickup.tscn")


@onready var wave_label = $CanvasLayer/WaveLable
@onready var wave_text_timer = $WaveTextTimer
@onready var wave_delay_timer = $WaveDelay
@onready var new_wave_timer = $newWAveTimer
@onready var extractLable = $Extract/Extract
@onready var extractionTimer = $Extract/ExtractionTimer
@onready var lableTimer = $Extract/LableTimer
@onready var roundOver = $RoundOver

signal extract_open
signal extract_closed

var current_wave: int = 0
var enemies: Array = []
var enemy_count: int = 0
var roundStarted = false


func start_next_wave():
	current_wave += 1
	show_wave_text(current_wave)


func show_wave_text(wave: int) -> void:
	wave_label.text = "Wave %d" % wave
	wave_label.visible = true
	wave_text_timer.start(3)


func spawn_wave(wave: int) -> void:
	enemy_count = 3 + wave  # increase per wave
	enemies.clear()

	for i in range(enemy_count):
		var bot = bot_scene.instantiate()
		bot.z_index = 30
		bot.visible = true

		bot.global_position = getRandomSpawnPoint()
		get_tree().current_scene.add_child(bot)
		enemies.append(bot)
		roundStarted = true

func _on_wave_text_timer_timeout() -> void:
	wave_label.visible = false
	wave_text_timer.stop()
	spawn_wave(current_wave)
	
	
func _process(_delta):
	# Remove dead ones
	enemies = enemies.filter(func(e): return is_instance_valid(e))

	# All gone?
	if enemies.is_empty() and roundStarted:
		roundStarted = false
		roundOver.play()
		spawn_hearts(clamp(current_wave / 5, 1, 3))  # 1–3 hearts every 5 waves
		Global.waves_completed = current_wave
		if (current_wave % 5 == 0):
			extractOption()
			new_wave_timer.start(20)
		else: 
			new_wave_timer.start(10)


func _on_new_w_ave_timer_timeout() -> void:
	new_wave_timer.stop()
	start_next_wave()

func spawn_hearts(count: int = 1):
	for i in range(count):
		var heart = heart_pickup_scene.instantiate()
		# Spawn at random position (or a set spot)
		heart.global_position = getRandomSpawnPoint()
		get_tree().current_scene.add_child(heart)


func extractOption():
	extractLable.text = "Extraction is now open"
	extractLable.visible = true
	emit_signal("extract_open")
	lableTimer.start(3)
	extractionTimer.start(20)

func _on_extraction_timer_timeout() -> void:
	extractionTimer.stop()
	extractLable.text = "Extraction is now Closed"
	emit_signal("extract_closed")
	extractLable.visible = true
	lableTimer.start(3)


func _on_lable_timer_timeout() -> void:
		lableTimer.stop()
		extractLable.visible = false
		
func getRandomSpawnPoint() -> Vector2:
	var validSpawnPoint = false
	var tileMap = get_parent().get_node("World/Bush_stone")
	var validCoords
	
	while (!validSpawnPoint):
		var coords = Vector2(randf_range(-100, 470), randf_range(-160, 250))
		var cell = tileMap.local_to_map(coords)
		var tile_data = tileMap.get_cell_tile_data(cell)
		
		if tile_data == null:
			validSpawnPoint = true
			validCoords = coords
		else:
			print("CAN NOT SPAWN HERE, ", coords)
			
	#print("Valid Coords: ", validCoords)
	
	return validCoords
