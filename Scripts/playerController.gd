extends CharacterBody2D

@export var speed: float = 250.0
@export var dash_speed: float = 900.0
@export var dash_duration: float = 0.15
@export var dash_cooldown: float = 0.2 #for testing purposes
@export var dash_iframe: float = 0.35
@export var targeting_range: float = 500.0
@export var max_health: float = 100
@export var damage_iframe: float = 0.5 #iframe after getting damaged
@export var recoil_speed: float = 300.0
@export var recoil_duration: float = 0.1
@export var dash_damage: float = 15.0
@onready var hurtbox: Area2D = $Hurtbox

var direction = Vector2.ZERO
var dash_direction = Vector2.ZERO
var dash_time_left = 0.0
var dash_cooldown_left = 0.0
var targeting_mode = false
var iframe = 0
var playerHealth = max_health
var recoil_direction =Vector2.ZERO
var recoil_time_left = 0.0

func _physics_process(delta: float) -> void:
	direction = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	dash_time_left = max(dash_time_left - delta, 0.0)
	dash_cooldown_left = max(dash_cooldown_left - delta, 0.0)
	recoil_time_left = max(recoil_time_left - delta, 0.0)
	iframe = max(iframe-delta,0)

	if Input.is_action_just_pressed("target_mode"):
		targeting_mode = !targeting_mode
		print("Targeting mode: ", targeting_mode)

	if Input.is_action_just_pressed("dash"):
		start_dash()

#during the dash, you get extra velocity. but the dash_direction is actually locked when you first press the key
#sprint can be added by having less velocity than the dash but a controllable direction
#this is the part that actualy executes the dash
	if recoil_time_left > 0.0:
		velocity = recoil_direction * recoil_speed

	elif dash_time_left > 0.0:
		velocity = dash_direction * dash_speed

	else:
		velocity = direction * speed

	move_and_slide()

func recoil_from(enemy: Node2D) -> void:
	recoil_direction = enemy.global_position.direction_to(global_position)

	if recoil_direction == Vector2.ZERO:
		recoil_direction = Vector2.RIGHT

	recoil_time_left = recoil_duration
	
	
#checks all the variables and sets the direction so the dash can be executed in _physics_process
func start_dash() -> void:
	print("dashing!")
	if dash_cooldown_left > 0.0:
		return
	if targeting_mode:
		var nearest_enemy = find_nearest_enemy()

		if nearest_enemy != null:
			dash_direction = global_position.direction_to(
				nearest_enemy.global_position
			)
			#gets directional vector to the enemy
		else:
			dash_direction = get_normal_dash_direction()
	else:
		dash_direction = get_normal_dash_direction()

	dash_time_left = dash_duration
	dash_cooldown_left = dash_cooldown
	iframe += dash_iframe
	#reset timers and cooldowns


#direction always points to mouse position unless overrode by the keypad input
func get_normal_dash_direction() -> Vector2:
	if direction != Vector2.ZERO:
		return direction.normalized()

	return global_position.direction_to(get_global_mouse_position())


#tracks enemy by tag "enemies" and returns position if inside the given range
func find_nearest_enemy() -> Node2D:
	var nearest_enemy: Node2D = null
	var nearest_distance = targeting_range
	#set the limit for targeting. any enemies beyond this distance will not be counted

	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy is not Node2D:
			continue

		var distance = global_position.distance_to(
			enemy.global_position
		)

		if distance < nearest_distance:
			nearest_distance = distance
			nearest_enemy = enemy

	return nearest_enemy


func loseHealth(receivedDMG: float) -> void:
	playerHealth-=receivedDMG
	playerHealth = clamp(playerHealth, 0.0, max_health)
	iframe = damage_iframe
	print("Got Hit!")
	print(playerHealth)
	
	if playerHealth<=0 :
		#GAME OVER
		print("YOU DIED!")
		get_tree().paused = true


#called when an enemy enters the Area2D hurtbox
func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		hit_enemy(body, dash_time_left > 0)


func hit_enemy(enemy: Node, in_dash: bool) -> void:
	if in_dash:
		enemy.loseHealth(dash_damage)

		print("Hit enemy!")

	elif iframe <= 0:
		loseHealth(10)
		recoil_from(enemy)
