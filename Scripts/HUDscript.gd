extends Control

@onready var health_bar: ProgressBar = $VBoxContainer/HealthBar
@onready var cooldown_bar: ProgressBar = $VBoxContainer/SkillCD
@onready var exp_bar: ProgressBar = $VBoxContainer/ExpBar


func _ready() -> void:
	print("Health bar: ", health_bar)
	print("Cooldown bar: ", cooldown_bar)
	print("EXP bar: ", exp_bar)


func update_health(current_health: float, max_health: float) -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health


func update_exp(current_exp: float, required_exp: float) -> void:
	exp_bar.max_value = required_exp
	exp_bar.value = current_exp


func update_cooldown(time_left: float, cooldown_duration: float) -> void:
	cooldown_bar.max_value = cooldown_duration
	cooldown_bar.value = cooldown_duration - time_left
