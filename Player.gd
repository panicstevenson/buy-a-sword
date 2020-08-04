extends KinematicBody2D

export var speed = 400  # How fast the player will move (pixels/sec).
export var jump = -700
export var gravity = 2500
var screen_size  # Size of the game window.

var max_health = 100
var health = 100

var touching = null

var jumping = false
var velocity = Vector2.ZERO

var is_occupied = false
signal PLAYER_OCCUPIED(is_occupied)

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


func _on_Interactable_entered(interactable: Interactable):
	print("entered: " + interactable.name)
	touching = interactable


func _on_Interactable_exited(interactable: Interactable):
	print("exited: " + interactable.name)
	interactable.set_visible(false)
	touching = null
	_set_occupied(false)


func _process(_delta):
	if not touching:
		return
	touching.set_visible(true)


func get_input():
	velocity.x = 0
	jumping = false
	if Input.is_action_pressed("ui_right"):
		if not is_occupied:
			velocity.x += speed
	if Input.is_action_pressed("ui_left"):
		if not is_occupied:
			velocity.x -= speed
	if Input.is_action_just_pressed("ui_up"):
		if not touching:
			return
		if is_occupied:
			if not touching.interact():
				_set_occupied(false)
		else:
			_set_occupied(true)
			touching.interact()


func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "HazardTileMap":
			var _reload = get_tree().reload_current_scene()

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
		
func _set_occupied(occupied):
	is_occupied = occupied
	emit_signal("PLAYER_OCCUPIED", is_occupied)
