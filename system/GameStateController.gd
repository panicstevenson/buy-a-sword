extends Node2D


var VARIABLES = {}

signal variables_updated(assignments)


func _ready():
	print("Life begins. :(")
	VARIABLES["talked"] = "0"
	pass

func update_variable(story_var, value):
	update_variables({story_var: value})

func update_variables(assignments):
	for key in assignments.keys():
		# TODO: Check the value's type (Number, String, Boolean, Counter)
		VARIABLES[key] = assignments[key]
	emit_signal("variables_updated", assignments)

func get(key : String, default_value = null):
	return VARIABLES.get(key, default_value)
