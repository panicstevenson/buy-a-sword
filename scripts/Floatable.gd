extends Area2D

class_name Floatable

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var count = 0
var reverse = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	count = int(round(self.get_position()[0])) % 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	count += 1
	if count > 99:
		count = 0
		reverse *= -1
	self.translate(Vector2(0, -0.15 * reverse))
