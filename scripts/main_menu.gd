extends Node

@onready var play = $Control/CanvasLayer/Play
@onready var tutorial = $Control/CanvasLayer/Tutorial
@onready var exit = $Control/CanvasLayer/Exit

func _ready():
	# Connect buttons to their functions
	play.pressed.connect(_on_play_pressed)
	tutorial.pressed.connect(_on_instructions_pressed)
	exit.pressed.connect(_on_exit_pressed)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")  # Your game scene

func _on_instructions_pressed():
	show_instructions_popup()

func _on_exit_pressed():
	get_tree().quit()

func show_instructions_popup():
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")
