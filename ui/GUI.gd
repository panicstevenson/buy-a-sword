extends MarginContainer


onready var number_label = $CanvasLayer/HBoxContainer/Bars/Bar/Count/Background/Number
onready var bar = $CanvasLayer/HBoxContainer/Bars/Bar/Gauge
onready var tween = $Tween


func _ready():
	var player_max_health = $"../Player".max_health
	var player_health = $"../Player".health
	bar.max_value = player_max_health
	bar.value = player_health
	number_label.text = str(player_health)

func update_health(new_value):
	bar.value = new_value
	number_label.text = str(new_value)
