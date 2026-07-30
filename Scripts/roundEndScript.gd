extends Control

@onready var leave_button: Button = $VBoxContainer/LeaveButton
@onready var stay_button: Button = $VBoxContainer/StayButton
@onready var round_timer: Timer = $"../../GameManager/RoundTimer"

func _ready() -> void:
	hide()

	leave_button.pressed.connect(_on_leave_button_pressed)
	stay_button.pressed.connect(_on_stay_button_pressed)


func open_menu() -> void:
	show()
	get_tree().paused = true


func close_menu() -> void:
	get_tree().paused = false
	hide()


func _on_leave_button_pressed() -> void:
	close_menu()
	print("Player chose to leave")
	hide()
	# Later:
	# Save the player's ghost.
	# End the current run.
	# Return to the menu.



func _on_stay_button_pressed() -> void:
	close_menu()
	print("Player stayed")
	round_timer.start_round()

	# Later:
	# Increase the round difficulty.
	# Start another 40-second round.
