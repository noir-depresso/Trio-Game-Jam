extends CharacterBody2D

@export var speed: float = 100.0
@export var player: CharacterBody2D

func _physics_process(_delta: float) -> void:
	if player == null:
		return

	var direction = global_position.direction_to(player.global_position)

	velocity = direction * speed
	move_and_slide()
