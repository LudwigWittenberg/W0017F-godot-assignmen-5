extends Node2D
class_name Game

@onready var waveManager = $WaveManager
@onready var extractZone = $World/ExtractionZone
@onready var soundEffectClose = $ExtractionSoundClose
@onready var soundEffectOpen = $ExtractionSoundOpen


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	waveManager.start_next_wave()
	waveManager.extract_open.connect(_on_extract_open)
	waveManager.extract_closed.connect(_on_extract_closed)
	extractZone.extracted.connect(_on_extract)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_extract_open():
	extractZone.visible = true
	soundEffectOpen.play()
	
func _on_extract_closed():
	extractZone.visible = false
	soundEffectClose.play()
	

func _on_extract():
	get_tree().change_scene_to_file("res://scenes/winner_scene.tscn")
