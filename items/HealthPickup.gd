extends Area2D

class_name HealthPickup

export var health = 1

var Player = null
var _Game_State_Controller

func _init():
	var _body_entered = connect("body_entered", self, "_on_HealthPickup_body_entered")


func _ready():
	Player = get_parent().find_node("Player")
	_Game_State_Controller = get_node("/root/GameStateController")
	

func _on_HealthPickup_body_entered(body: Node2D):
	if (body == Player):
		_Game_State_Controller.change_health(health)
		get_parent().remove_child(self)
