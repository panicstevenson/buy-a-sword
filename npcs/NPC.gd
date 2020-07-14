extends Interactable

var _letter = "NPC"

func _ready():
	._ready()
	$SpriteFlip/AnimatedSprite.play()
	$Interactable/Bubble.visible = false
