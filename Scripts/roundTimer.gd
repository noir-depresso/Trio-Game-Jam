extends Timer

var previous_second = -1
var roundEnd = false

func _ready() -> void:
	#wait time is set to 5s for now
	timeout.connect(_on_round_timer_timeout) #when the timer ends, it calls the function
	print("Timer is starting!")
	start_round()


func start_round() -> void:
	#call stuff here like mob spawn
	start()


func _process(_delta: float) -> void:
	#only outputs seconds when they change
	var current_second = ceil(time_left)

	if current_second != previous_second:
		print(current_second)
		previous_second = current_second

#press C to restart the timer
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset_timer"):
		print("Timer has been reset")
		start_round()


func _on_round_timer_timeout() -> void:
	print("Round finished!")
	
