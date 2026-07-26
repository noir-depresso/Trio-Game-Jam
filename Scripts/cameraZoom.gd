extends Camera2D

@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.1
@export var max_zoom: float = 100


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		change_zoom(zoom_speed)

	if event.is_action_pressed("zoom_out"):
		change_zoom(-zoom_speed)


func change_zoom(amount: float) -> void:
	var new_zoom: float = clamp(
		zoom.x + amount,
		min_zoom,
		max_zoom
	)

	zoom = Vector2(new_zoom, new_zoom)
