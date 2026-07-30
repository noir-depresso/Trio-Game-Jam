extends Node2D

#range distance of enemy spawning from the player
@export var range_min:float = 900
@export var range_max:float = 1000

@export var enemy_scenes: Array[PackedScene] = []
#in case we add more enemies

@export var enemyIndex: int = 0
@export var enemyNumber: int = 5
@onready var wave_timer: Timer = $WaveTimer
@onready var round_timer: Timer = $RoundTimer
@onready var player: CharacterBody2D = $"../Player"


signal round_started(round_number: int)

var round: int = 0

#for difficulty scaling later
var roundEnded = false

func _ready() -> void:
	wave_timer.timeout.connect(_on_wave_timer_timeout)
	round_timer.timeout.connect(_on_round_timer_timeout)
	prepareSpawn()
	

func _on_wave_timer_timeout() -> void:
	if(!roundEnded):
		prepareSpawn()
	else:
		wave_timer.stop()
		

func prepareSpawn() -> void:
	if enemy_scenes.is_empty():
		print("No enemy scenes assigned.")
		return
	for i in range(enemyNumber+2*round):
		spawn(enemy_scenes[enemyIndex])
	return

func _on_round_timer_timeout() -> void:
	roundEnded = true
	nextRound()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn(enemy_scene:PackedScene) -> void:
	if enemy_scene == null:
		print("No enemy scene assigned.")
		return

	var new_enemy = enemy_scene.instantiate()

	# get a random direction
	var direction = Vector2.RIGHT.rotated(randf_range(0, 360))
	# and a random distance within range
	var distance = randf_range(range_min, range_max)

	#change the enemy location with the randomized direction and distance. so it gives like a circular ring of possible spawns
	new_enemy.global_position = (
		player.global_position
		+ direction * distance
	)

	# add the enemy to the current scene
	get_tree().current_scene.add_child.call_deferred(new_enemy)

func nextRound():
	round+=1
	print("current round: ", round)
