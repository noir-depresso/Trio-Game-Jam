extends CharacterBody2D

# This was a small AI pathfinding script I wrote. Feel free to change parts as this is just showing it works.
# Even though the navigation is displayed on a 2D flat tilemap, it works for orthographic art as well.
# the reason for this script to make little guys wander around the map while avoiding trees or buildings or whatever we come up with

var speed = 100.0
var has_reached_target_pos = false
var target_pos : Vector2

@onready var navigation = $NavigationAgent2D


func _physics_process(delta: float) -> void:
	if !has_reached_target_pos: #Checks if target has not been reached, allowing movement
		movement()

	if navigation.target_position != target_pos: #Checks if the nav target position has been changed, and a new path must be created
		has_reached_target_pos = false

	update_path()

	if Input.is_action_just_pressed("Left_Click"): #Temporary to show how the AI will go towards the mouse clicked position
		print("Mouse Clicked")
		target_pos = get_global_mouse_position()


func movement():
	var dir = to_local(navigation.get_next_path_position()).normalized()
	velocity = dir * speed
	move_and_slide()


func update_path():
	if target_pos != null:
		navigation.target_position = target_pos


func _on_navigation_agent_2d_navigation_finished() -> void: #Checks when the AI has reached the end of its path
	has_reached_target_pos = true
	print("Target Reached")
	
