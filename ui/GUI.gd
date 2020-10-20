extends MarginContainer

var _Game_State_Controller = null

onready var health_number_label = $CanvasLayer/HBoxContainer/Bars/Bar/Count/Background/Number
onready var bar = $CanvasLayer/HBoxContainer/Bars/Bar/Gauge
onready var tween = $Tween

var health_story_var = "health"

func _ready():
	_Game_State_Controller = get_node("/root/GameStateController")
	var _player_occupied = _Game_State_Controller.connect("variables_updated", self, "check_my_vars")

	var player_max_health = _Game_State_Controller.MAX_HEALTH
	var player_health = _Game_State_Controller.get_health()
	bar.max_value = player_max_health
	bar.value = player_health
	health_number_label.text = str(player_health)

func update_health(new_value):
	bar.value = new_value
	health_number_label.text = str(new_value)

func check_my_vars(assignments):
	if health_story_var in assignments.keys():
		update_health(assignments.get(health_story_var))
