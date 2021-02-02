extends KinematicBody2D


export var speed = 250
export var gravity = 2500

var flipped = 1

var velocity = Vector2.ZERO

class_name Goblin

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func move():
	if flipped == 1:
		velocity.x = speed
	else:
		velocity.x = -1 * speed


func _physics_process(delta):
	move()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if velocity.x != 0:
		$SpriteFlip/AnimatedSprite.animation = "walk"
		$SpriteFlip/AnimatedSprite.play()
		if velocity.x < 0:
			$SpriteFlip.scale.x = -1
		else:
			$SpriteFlip.scale.x = 1
	else:
		$SpriteFlip/AnimatedSprite.stop()
