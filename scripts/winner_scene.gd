extends Control

@onready var title = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	title.text = "You completed %d Waves" % Global.waves_completed
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	await get_tree().create_timer(8.0).timeout
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
