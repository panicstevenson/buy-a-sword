extends KinematicBody2D


export var speed = 250
export var gravity = 2500

var flipped = 1

var velocity = Vector2.ZERO

var Player = null

class_name Goblin

func _ready():
	$HurtBox.connect("body_entered", self, "_on_HurtBox_body_entered")
	Player = get_tree().get_current_scene().find_node("Player")

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
		
func _on_HurtBox_body_entered(body):
	print("owieee")
	if body == Player:
		print("OWIE PLAYER")
		Player.velocity.y = -400
		Player.velocity.x = rand_range(-2000, 2000)
