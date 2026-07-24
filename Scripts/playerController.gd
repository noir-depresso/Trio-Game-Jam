extends CharacterBody2D

#speed i chose for now, maybe speed upgrades later?
@export var speed: float = 250.0


func _physics_process(_delta: float) -> void:
	#get the input and set the velocity, then move.
	var direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	velocity = direction * speed
	move_and_slide()
