extends Node2D

class_name Trigger

var dialog_player = null

func _ready():
	dialog_player = get_node("/root/Dialog_Player")

func trigger():
	pass
