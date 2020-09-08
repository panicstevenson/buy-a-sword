extends Node2D


var VARIABLES = {}

func _ready():
	print("Life begins.")
	pass


func update_variables(assignments):
	for key in assignments.keys():
		# TODO: Check the value's type (Number, String, Boolean, Counter)
		VARIABLES[key] = assignments[key]

func get(key : String, default_value = null):
	return VARIABLES.get(key, default_value)
