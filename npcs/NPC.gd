extends Interactable

var _letter = "NPC"

func _process(_delta):
	$SpriteFlip/AnimatedSprite.play()
