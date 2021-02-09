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
	if body == Player:
		if !Player.is_iframe():
			Player.get_hurt(5)
		Player.velocity.y = rand_range(-300, -200)
		if Player.get_position().x < get_position().x:
			Player.velocity.x = rand_range(-2000, -500)
		else:
			Player.velocity.x = rand_range(500, 2000)
