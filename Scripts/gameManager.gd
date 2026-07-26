extends Node2D

#distance from the origin (0,0)
@export var rangeX:float = 1000
@export var rangeY:float = 1000
#will change to be just outside of camera view

@export var enemy_scenes: Array[PackedScene] = []
#in case we add more enemies

@export var enemyIndex: int = 0
@export var enemyNumber: int = 5
@onready var wave_timer: Timer = $WaveTimer
@onready var round_timer: Timer = $RoundTimer

signal round_started(round_number: int)

var round: int = 0
#for difficulty scaling later
var roundEnded = false

func _ready() -> void:
	wave_timer.timeout.connect(_on_wave_timer_timeout)
	round_timer.timeout.connect(_on_round_timer_timeout)
	

func _on_wave_timer_timeout() -> void:
	if(!roundEnded):
		if enemy_scenes.is_empty():
			print("No enemy scenes assigned.")
			return
		for i in range(enemyNumber):
			spawn(enemy_scenes[enemyIndex])
	else:
		wave_timer.stop()
		

func _on_round_timer_timeout() -> void:
	roundEnded = true
	round+=1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn(enemy_scene:PackedScene) -> void:
	if enemy_scene == null:
		print("No enemy scene assigned.")
		return

	# Create a new copy of the enemy scene.
	var new_enemy = enemy_scene.instantiate()

	# Choose a random position around the spawner.
	var random_position = Vector2(
		randf_range(-rangeX, rangeX),
		randf_range(-rangeY, rangeY)
	)

	new_enemy.global_position = global_position + random_position

	# Add the enemy to the current scene.
	get_tree().current_scene.add_child(new_enemy)
