extends KinematicBody2D

export var speed = 400  # How fast the player will move (pixels/sec).
export var jump = -700
export var gravity = 2500
export var is_touching = false
var screen_size  # Size of the game window.

var touching = []

var jumping = false
var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


func get_input():
	velocity.x = 0
	jumping = false
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed


func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

	var buttonVisible = false
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "HazardTileMap":
			var _reload = get_tree().reload_current_scene()

	$Sprite.visible = buttonVisible or touching.size()

	if Input.is_action_just_pressed('ui_select'):
		if is_on_floor():
			velocity.y = jump

	if velocity.x != 0:
		$SpriteFlip/AnimatedSprite.animation = "walk"
		$SpriteFlip/AnimatedSprite.play()
		if velocity.x < 0:
			$SpriteFlip.scale.x = -1
		else:
			$SpriteFlip.scale.x = 1
	else:
		$SpriteFlip/AnimatedSprite.stop()
